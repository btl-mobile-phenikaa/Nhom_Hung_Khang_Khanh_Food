import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  const OrderItem({
    required this.foodId,
    required this.foodName,
    required this.unitPrice,
    required this.quantity,
    this.size = 'Size S',
    this.toppings = const [],
    this.note = '',
    this.imageUrl = '',
  });

  final String foodId;
  final String foodName;

  /// Giá snapshot tại thời điểm đặt hàng (đã bao gồm phụ phí size và topping).
  /// Không phụ thuộc vào giá hiện tại của món trong collection `foods`.
  final double unitPrice;
  final int quantity;
  final String size;
  final List<String> toppings;
  final String note;
  final String imageUrl;

  double get subtotal => unitPrice * quantity;

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    final rawToppings = map['toppings'];
    final parsedToppings = rawToppings is List
        ? rawToppings
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList()
        : const <String>[];

    return OrderItem(
      foodId: map['foodId'] as String? ?? '',
      foodName: map['foodName'] as String? ?? '',
      unitPrice: _asDouble(map['unitPrice']),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      size: (map['size'] as String?)?.trim().isNotEmpty == true
          ? (map['size'] as String).trim()
          : 'Size S',
      toppings: parsedToppings,
      note: map['note'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'foodId': foodId,
        'foodName': foodName,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'size': size,
        'toppings': toppings,
        'note': note,
        'imageUrl': imageUrl,
        'subtotal': subtotal,
      };

  static double _asDouble(dynamic value) => value is num
      ? value.toDouble()
      : (value is String ? double.tryParse(value) ?? 0 : 0);
}

class Order {
  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    DateTime? createdAt,
    DateTime? orderDate,
    required this.status,
    required this.deliveryAddress,
    this.paymentMethod = 'cash',
    this.note = '',
  }) : createdAt =
            createdAt ?? orderDate ?? DateTime.fromMillisecondsSinceEpoch(0);

  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalPrice;

  /// Tên trường thời gian tạo đơn thống nhất trên toàn bộ Model và Cloud Firestore.
  final DateTime createdAt;

  /// Getter tương thích ngược cho các đoạn mã cũ còn đọc `orderDate`.
  DateTime get orderDate => createdAt;

  final String status;
  final String deliveryAddress;
  final String paymentMethod;
  final String note;

  factory Order.fromMap(Map<String, dynamic> map, {String? id}) {
    final rawDate = map['createdAt'] ?? map['orderDate'];
    DateTime date;
    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    } else if (rawDate is DateTime) {
      date = rawDate;
    } else if (rawDate is String) {
      date =
          DateTime.tryParse(rawDate) ?? DateTime.fromMillisecondsSinceEpoch(0);
    } else {
      date = DateTime.fromMillisecondsSinceEpoch(0);
    }

    final rawItems = map['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((item) => OrderItem.fromMap(Map<String, dynamic>.from(item)))
            .toList()
        : <OrderItem>[];

    return Order(
      id: id ?? (map['id'] as String? ?? ''),
      userId: map['userId'] as String? ?? '',
      items: items,
      totalPrice: _asDouble(map['totalPrice']),
      createdAt: date,
      status: map['status'] as String? ?? 'pending',
      deliveryAddress: map['deliveryAddress'] as String? ?? '',
      paymentMethod: map['paymentMethod'] as String? ?? 'cash',
      note: map['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'items': items.map((item) => item.toMap()).toList(),
        'totalPrice': totalPrice,
        'createdAt': Timestamp.fromDate(createdAt),
        'status': status,
        'deliveryAddress': deliveryAddress,
        'paymentMethod': paymentMethod,
        'note': note,
      };

  Order copyWith({String? status}) => Order(
        id: id,
        userId: userId,
        items: items,
        totalPrice: totalPrice,
        createdAt: createdAt,
        status: status ?? this.status,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        note: note,
      );

  static double _asDouble(dynamic value) => value is num
      ? value.toDouble()
      : (value is String ? double.tryParse(value) ?? 0 : 0);
}
