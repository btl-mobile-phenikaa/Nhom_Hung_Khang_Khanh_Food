import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../core/storage/cart_storage.dart';
import '../models/cart_item.dart';
import '../models/food.dart';

/// Quản lý trạng thái giỏ hàng:
/// - Cập nhật tức thời trên RAM (ChangeNotifier) để giao diện mượt mà.
/// - Lưu đồng thời vào `localStorage` (trình duyệt Web) và Cloud Firestore (`carts/active_cart`),
///   đảm bảo khi bấm F5 / tải lại trang giỏ hàng luôn được giữ nguyên 100%.
class CartController extends ChangeNotifier {
  static const String _localStorageKey = 'foodgo_active_cart_v1';
  static const String _addressStorageKey = 'foodgo_delivery_address_v1';
  static final CartController _instance = CartController._internal();

  factory CartController() => _instance;

  CartController._internal() : _enablePersistence = true {
    _loadFromLocalStorage();
    _loadFromFirestore();
  }

  @visibleForTesting
  CartController.createInstance() : _enablePersistence = false;

  final bool _enablePersistence;
  final List<CartItem> _items = [];
  String _deliveryAddress = '144 Xuân Thủy, Cầu Giấy, Hà Nội';

  String get deliveryAddress => _deliveryAddress;

  void updateDeliveryAddress(String newAddress) {
    final trimmed = newAddress.trim();
    if (trimmed.isEmpty) return;
    _deliveryAddress = trimmed;
    notifyListeners();
    if (_enablePersistence) {
      try {
        writeLocalCartJson(_addressStorageKey, _deliveryAddress);
      } catch (_) {}
      _persistCart();
    }
  }

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

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
        final quantity = (map['quantity'] as num?)?.toInt() ?? 1;
        final rawFood = map['food'];
        if (rawFood is Map) {
          final foodMap = Map<String, dynamic>.from(rawFood);
          final food = Food.fromMap(
            foodMap,
            id: foodMap['id'] as String? ?? map['foodId'] as String? ?? '',
          );
          if (food.id.isNotEmpty && quantity >= 1) {
            loaded.add(CartItem(food: food, quantity: quantity));
          }
        }
      }
    }
    return loaded;
  }

  List<Map<String, dynamic>> _serializeItems() {
    return _items
        .map(
          (item) => {
            'foodId': item.food.id,
            'quantity': item.quantity,
            'subtotal': item.subtotal,
            'food': {
              'id': item.food.id,
              ...item.food.toMap(),
            },
          },
        )
        .toList();
  }

  /// Khôi phục tức thời từ Browser localStorage khi F5 trên Web
  void _loadFromLocalStorage() {
    if (!_enablePersistence) return;
    try {
      final savedAddress = readLocalCartJson(_addressStorageKey);
      if (savedAddress != null && savedAddress.trim().isNotEmpty) {
        _deliveryAddress = savedAddress.trim();
      }
      final rawJson = readLocalCartJson(_localStorageKey);
      if (rawJson == null || rawJson.isEmpty) return;
      final decoded = jsonDecode(rawJson);
      if (decoded is List) {
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

  /// Tải lại giỏ hàng đã lưu trên Firestore khi mở / F5 ứng dụng
  Future<void> _loadFromFirestore() async {
    if (!_canSyncFirestore) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('carts')
          .doc('active_cart')
          .get();
      if (!doc.exists || doc.data() == null) return;

      final data = doc.data()!;
      final savedAddr = data['deliveryAddress'] as String?;
      if (savedAddr != null && savedAddr.trim().isNotEmpty) {
        _deliveryAddress = savedAddr.trim();
        writeLocalCartJson(_addressStorageKey, _deliveryAddress);
      }

      final rawItems = data['items'];
      if (rawItems is! List) return;

      final loaded = _parseSerializedItems(rawItems);
      if (loaded.isNotEmpty && _items.isEmpty) {
        _items.addAll(loaded);
        writeLocalCartJson(_localStorageKey, jsonEncode(_serializeItems()));
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CartController Firestore load skipped: $e');
      }
    }
  }

  /// Lưu giỏ hàng hiện tại vào cả localStorage và Firestore
  void _persistCart() {
    if (!_enablePersistence) return;
    final serialized = _serializeItems();

    // 1. Lưu đồng bộ ngay lập tức vào localStorage trình duyệt
    try {
      writeLocalCartJson(_localStorageKey, jsonEncode(serialized));
      writeLocalCartJson(_addressStorageKey, _deliveryAddress);
    } catch (_) {}

    // 2. Lưu bất đồng bộ lên Cloud Firestore
    if (!_canSyncFirestore) return;
    unawaited(
      Future(() async {
        try {
          await FirebaseFirestore.instance
              .collection('carts')
              .doc('active_cart')
              .set({
            'items': serialized,
            'deliveryAddress': _deliveryAddress,
            'totalItemCount': totalItemCount,
            'subtotal': subtotal,
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

  /// Thêm món vào giỏ hàng với số lượng chỉ định (mặc định 1)
  void addItem(Food food, {int quantity = 1}) {
    if (quantity <= 0) return;

    final existingIndex = _items.indexWhere((item) => item.food.id == food.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(food: food, quantity: quantity));
    }
    notifyListeners();
    _persistCart();
  }

  /// Tăng số lượng món
  void increaseQuantity(String foodId) {
    final index = _items.indexWhere((item) => item.food.id == foodId);
    if (index >= 0) {
      _items[index].increase();
      notifyListeners();
      _persistCart();
    }
  }

  /// Giảm số lượng món; nếu còn 1 mà giảm tiếp thì xóa khỏi giỏ
  void decreaseQuantity(String foodId) {
    final index = _items.indexWhere((item) => item.food.id == foodId);
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

  /// Xóa hẳn một món khỏi giỏ hàng
  CartItem? removeItem(String foodId) {
    final index = _items.indexWhere((item) => item.food.id == foodId);
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
    return _items.any((item) => item.food.id == foodId);
  }

  /// Lấy số lượng hiện tại của một món
  int getQuantity(String foodId) {
    final item =
        _items.where((element) => element.food.id == foodId).firstOrNull;
    return item?.quantity ?? 0;
  }

  /// Reset dùng cho test
  void reset() {
    _items.clear();
    notifyListeners();
  }
}
