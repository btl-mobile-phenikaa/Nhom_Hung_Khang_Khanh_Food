import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../core/storage/cart_storage.dart';
import '../models/cart_item.dart';
import '../models/food.dart';

/// Quản lý trạng thái giỏ hàng FoodHub:
/// - Cập nhật tức thời trên RAM (ChangeNotifier) để giao diện mượt mà.
/// - Lưu đồng bộ cấu trúc dữ liệu thống nhất giữa `localStorage` (`foodhub_active_cart_v1`)
///   và Cloud Firestore theo UID người dùng (`carts/{uid}`), đảm bảo phân tách giỏ hàng
///   cá nhân và khôi phục 100% khi tải lại trang (F5).
class CartController extends ChangeNotifier {
  static const String localStorageKey = 'foodhub_active_cart_v1';
  static const String _legacyLocalStorageKey = 'foodgo_active_cart_v1';
  static const String addressStorageKey = 'foodhub_delivery_address_v1';
  static final CartController _instance = CartController._internal();

  factory CartController() => _instance;

  CartController._internal() : _enablePersistence = true {
    _loadFromLocalStorage();
    _initAuthSync();
    _loadFromFirestore();
  }

  @visibleForTesting
  CartController.createInstance({String? userId})
      : _enablePersistence = false,
        _userIdOverride = userId;

  final bool _enablePersistence;
  String? _userIdOverride;
  final List<CartItem> _items = [];
  String _deliveryAddress = '144 Xuân Thủy, Cầu Giấy, Hà Nội';

  String get deliveryAddress => _deliveryAddress;

  /// UID của người dùng hiện tại dùng để định danh tài liệu `carts/{uid}` trên Firestore.
  String? get currentUserId {
    if (_userIdOverride != null && _userIdOverride!.trim().isNotEmpty) {
      return _userIdOverride!.trim();
    }
    if (!_canSyncFirestore) return null;
    try {
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (_) {
      return null;
    }
  }

  /// Đường dẫn tài liệu Firestore của giỏ hàng người dùng hiện tại (`carts/{uid}`).
  String? get firestoreCartPath {
    final uid = currentUserId;
    if (uid == null || uid.isEmpty) return null;
    return 'carts/$uid';
  }

  @visibleForTesting
  void setUserIdForTesting(String? uid) {
    _userIdOverride = uid;
  }

  void _initAuthSync() {
    if (!_canSyncFirestore) return;
    try {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          _loadFromFirestore();
        }
      });
    } catch (_) {}
  }

  void updateDeliveryAddress(String newAddress) {
    final trimmed = newAddress.trim();
    if (trimmed.isEmpty) return;
    _deliveryAddress = trimmed;
    notifyListeners();
    if (_enablePersistence) {
      try {
        writeLocalCartJson(addressStorageKey, _deliveryAddress);
      } catch (_) {}
      _persistCart();
    }
  }

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  int get totalQuantity => totalItemCount;

  int get totalItemCount =>
      _items.fold<int>(0, (total, item) => total + item.quantity);

  double get subtotal =>
      _items.fold<double>(0.0, (total, item) => total + item.subtotal);

  /// Phí giao hàng mẫu: miễn phí nếu đơn >= 150.000 VNĐ, ngược lại 15.000 VNĐ
  double get deliveryFee => (isEmpty || subtotal >= 150000) ? 0.0 : 15000.0;

  double get totalPrice => subtotal + deliveryFee;

  bool get _canSyncFirestore => _enablePersistence && Firebase.apps.isNotEmpty;

  List<CartItem> _parseSerializedItems(List<dynamic> rawItems) {
    final loaded = <CartItem>[];
    for (final raw in rawItems) {
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        final item = CartItem.fromMap(map);
        if (item.food.id.isNotEmpty && item.quantity >= 1) {
          loaded.add(item);
        }
      }
    }
    return loaded;
  }

  List<Map<String, dynamic>> _serializeItems() {
    return _items.map((item) => item.toMap()).toList();
  }

  /// Tạo payload giỏ hàng có cấu trúc đồng nhất giữa LocalStorage và Cloud Firestore (`carts/{uid}`).
  Map<String, dynamic> toCartPayload({String? userId}) => {
        'userId': userId ?? currentUserId ?? '',
        'deliveryAddress': _deliveryAddress,
        'totalItemCount': totalItemCount,
        'subtotal': subtotal,
        'updatedAt': DateTime.now().toIso8601String(),
        'items': _serializeItems(),
      };

  /// Khôi phục giỏ hàng từ payload đồng nhất (dùng chung cho LocalStorage và Firestore).
  void restoreFromPayload(Map<String, dynamic> data, {bool overwriteItems = true}) {
    final savedAddr = data['deliveryAddress'] as String?;
    if (savedAddr != null && savedAddr.trim().isNotEmpty) {
      _deliveryAddress = savedAddr.trim();
    }
    final rawItems = data['items'];
    if (rawItems is List) {
      final loaded = _parseSerializedItems(rawItems);
      if (overwriteItems || _items.isEmpty) {
        _items
          ..clear()
          ..addAll(loaded);
      }
    }
    notifyListeners();
  }

  /// Khôi phục tức thời từ Browser localStorage khi F5 trên Web
  void _loadFromLocalStorage() {
    if (!_enablePersistence) return;
    try {
      final savedAddress = readLocalCartJson(addressStorageKey);
      if (savedAddress != null && savedAddress.trim().isNotEmpty) {
        _deliveryAddress = savedAddress.trim();
      }
      final rawJson = readLocalCartJson(localStorageKey) ??
          readLocalCartJson(_legacyLocalStorageKey);
      if (rawJson == null || rawJson.isEmpty) return;
      final decoded = jsonDecode(rawJson);
      if (decoded is Map) {
        restoreFromPayload(Map<String, dynamic>.from(decoded));
      } else if (decoded is List) {
        final loaded = _parseSerializedItems(decoded);
        if (loaded.isNotEmpty) {
          _items
            ..clear()
            ..addAll(loaded);
          notifyListeners();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CartController localStorage load skipped: $e');
      }
    }
  }

  /// Tải lại giỏ hàng cá nhân đã lưu trên Firestore (`carts/{uid}`) khi mở / F5 ứng dụng
  Future<void> _loadFromFirestore() async {
    if (!_canSyncFirestore) return;
    final uid = currentUserId;
    if (uid == null || uid.isEmpty) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('carts')
          .doc(uid)
          .get();
      if (!doc.exists || doc.data() == null) return;

      final data = doc.data()!;
      restoreFromPayload(data, overwriteItems: _items.isEmpty);
      writeLocalCartJson(addressStorageKey, _deliveryAddress);
      writeLocalCartJson(localStorageKey, jsonEncode(toCartPayload(userId: uid)));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CartController Firestore load skipped: $e');
      }
    }
  }

  /// Lưu giỏ hàng hiện tại với cùng một cấu trúc vào cả localStorage và Firestore (`carts/{uid}`)
  void _persistCart() {
    if (!_enablePersistence) return;
    final uid = currentUserId;
    final payload = toCartPayload(userId: uid);

    // 1. Lưu đồng bộ ngay lập tức vào localStorage trình duyệt
    try {
      writeLocalCartJson(localStorageKey, jsonEncode(payload));
      writeLocalCartJson(addressStorageKey, _deliveryAddress);
    } catch (_) {}

    // 2. Lưu bất đồng bộ lên Cloud Firestore theo UID (`carts/{uid}`) nếu người dùng đã đăng nhập
    if (!_canSyncFirestore || uid == null || uid.isEmpty) return;
    unawaited(
      Future(() async {
        try {
          await FirebaseFirestore.instance
              .collection('carts')
              .doc(uid)
              .set({
            ...payload,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          if (kDebugMode) {
            debugPrint('CartController Firestore save skipped: $e');
          }
        }
      }),
    );
  }

  /// Thêm món vào giỏ hàng với số lượng, size, danh sách topping và giá snapshot chỉ định
  void addItem(
    Food food, {
    int quantity = 1,
    String size = 'Size S',
    List<String> toppings = const [],
    double? unitPrice,
    String note = '',
  }) {
    if (quantity <= 0) return;

    final candidate = CartItem(
      food: food,
      quantity: quantity,
      size: size,
      toppings: toppings,
      unitPrice: unitPrice ?? food.price,
      note: note,
    );

    final existingIndex =
        _items.indexWhere((item) => item.itemKey == candidate.itemKey);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(candidate);
    }
    notifyListeners();
    _persistCart();
  }

  /// Tăng số lượng món (hỗ trợ truyền itemKey hoặc foodId)
  void increaseQuantity(String idOrKey) {
    final index = _items.indexWhere(
      (item) => item.itemKey == idOrKey || item.food.id == idOrKey,
    );
    if (index >= 0) {
      _items[index].increase();
      notifyListeners();
      _persistCart();
    }
  }

  /// Giảm số lượng món; nếu còn 1 mà giảm tiếp thì xóa khỏi giỏ (hỗ trợ truyền itemKey hoặc foodId)
  void decreaseQuantity(String idOrKey) {
    final index = _items.indexWhere(
      (item) => item.itemKey == idOrKey || item.food.id == idOrKey,
    );
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].decrease();
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
      _persistCart();
    }
  }

  /// Xóa hẳn một món khỏi giỏ hàng (hỗ trợ truyền itemKey hoặc foodId)
  CartItem? removeItem(String idOrKey) {
    final index = _items.indexWhere(
      (item) => item.itemKey == idOrKey || item.food.id == idOrKey,
    );
    if (index >= 0) {
      final removed = _items.removeAt(index);
      notifyListeners();
      _persistCart();
      return removed;
    }
    return null;
  }

  /// Xóa toàn bộ giỏ hàng
  void clear() {
    if (_items.isNotEmpty) {
      _items.clear();
      notifyListeners();
      _persistCart();
    }
  }

  /// Kiểm tra món đã có trong giỏ chưa
  bool hasItem(String foodId) {
    return _items.any((item) => item.food.id == foodId || item.itemKey == foodId);
  }

  /// Lấy tổng số lượng hiện tại của một món trong giỏ
  int getQuantity(String foodId) {
    return _items
        .where((element) => element.food.id == foodId || element.itemKey == foodId)
        .fold<int>(0, (total, item) => total + item.quantity);
  }

  /// Reset dùng cho test
  void reset() {
    _items.clear();
    notifyListeners();
  }
}
