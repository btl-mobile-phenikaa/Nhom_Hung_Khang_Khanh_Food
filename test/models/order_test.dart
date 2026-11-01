import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/models/order.dart' as app_model;

void main() {
  group('Order model', () {
    test('toMap stores unified createdAt, size, toppings and snapshot unitPrice for Firestore', () {
      final createdAt = DateTime(2026, 10, 26);
      final order = app_model.Order(
        id: 'order-1',
        userId: 'user-1',
        items: const [
          app_model.OrderItem(
            foodId: 'food-1',
            foodName: 'Phở bò',
            unitPrice: 65000,
            quantity: 2,
            size: 'Size L',
            toppings: ['Thêm quẩy giòn', 'Thêm trứng ốp la'],
            note: 'Ít hành',
          ),
        ],
        totalPrice: 130000,
        createdAt: createdAt,
        status: 'pending',
        deliveryAddress: 'Hà Nội',
      );

      final map = order.toMap();
      expect(map['userId'], 'user-1');
      expect(map['totalPrice'], 130000);
      expect(map['items'], hasLength(1));
      expect(map['items'].first['subtotal'], 130000);
      expect(map['items'].first['size'], 'Size L');
      expect(map['items'].first['toppings'], ['Thêm quẩy giòn', 'Thêm trứng ốp la']);
      expect(map['items'].first['unitPrice'], 65000);
      expect(map['createdAt'], isA<Timestamp>());
      expect(map.containsKey('orderDate'), isFalse);
      expect(map.containsKey('id'), isFalse);
    });

    test('fromMap reads Firestore createdAt, size, toppings and document ID', () {
      final createdAt = DateTime(2026, 10, 26);
      final order = app_model.Order.fromMap({
        'userId': 'user-1',
        'items': [
          {
            'foodId': 'food-1',
            'foodName': 'Phở bò',
            'unitPrice': 65000,
            'quantity': 2,
            'size': 'Size L',
            'toppings': ['Thêm quẩy giòn'],
          },
        ],
        'totalPrice': 130000,
        'createdAt': Timestamp.fromDate(createdAt),
        'status': 'pending',
        'deliveryAddress': 'Hà Nội',
      }, id: 'order-1');

      expect(order.id, 'order-1');
      expect(order.createdAt, createdAt);
      expect(order.orderDate, createdAt);
      expect(order.items.single.subtotal, 130000);
      expect(order.items.single.size, 'Size L');
      expect(order.items.single.toppings, ['Thêm quẩy giòn']);
      expect(order.status, 'pending');
    });
  });
}
