import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  const OrderItem({
    required this.foodId,
    required this.foodName,
    required this.unitPrice,
    required this.quantity,
    this.imageUrl = '',
  });

  final String foodId;
  final String foodName;
  final double unitPrice;
  final int quantity;
  final String imageUrl;

  double get subtotal => unitPrice * quantity;

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
        foodId: map['foodId'] as String? ?? '',
        foodName: map['foodName'] as String? ?? '',
        unitPrice: _asDouble(map['unitPrice']),
        quantity: (map['quantity'] as num?)?.toInt() ?? 1,
        imageUrl: map['imageUrl'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'foodId': foodId,
        'foodName': foodName,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'imageUrl': imageUrl,
        'subtotal': subtotal,
      };

  static double _asDouble(dynamic value) => value is num
      ? value.toDouble()
      : (value is String ? double.tryParse(value) ?? 0 : 0);
}

class Order {
  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
    required this.deliveryAddress,
    this.paymentMethod = 'cash',
    this.note = '',
  });

  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalPrice;
  final DateTime orderDate;
  final String status;
  final String deliveryAddress;
  final String paymentMethod;
  final String note;

  factory Order.fromMap(Map<String, dynamic> map, {String? id}) {
    final rawDate = map['orderDate'] ?? map['createdAt'];
    DateTime date;
    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    } else if (rawDate is DateTime) {
      date = rawDate;
    } else if (rawDate is String) {
      date = DateTime.tryParse(rawDate) ?? DateTime.fromMillisecondsSinceEpoch(0);
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
      orderDate: date,
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
        'orderDate': Timestamp.fromDate(orderDate),
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
        orderDate: orderDate,
        status: status ?? this.status,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        note: note,
      );

  static double _asDouble(dynamic value) => value is num
      ? value.toDouble()
      : (value is String ? double.tryParse(value) ?? 0 : 0);
}
