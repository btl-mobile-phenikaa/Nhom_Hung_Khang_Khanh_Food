import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/models/order.dart' as app_model;

void main() {
  group('Order model', () {
    test('toMap stores items and order fields for Firestore', () {
      final order = app_model.Order(
        id: 'order-1',
        userId: 'user-1',
        items: const [
          app_model.OrderItem(
            foodId: 'food-1',
            foodName: 'Phở bò',
            unitPrice: 45000,
            quantity: 2,
          ),
        ],
        totalPrice: 90000,
        orderDate: DateTime(2026, 10, 26),
        status: 'pending',
        deliveryAddress: 'Hà Nội',
      );

      final map = order.toMap();
      expect(map['userId'], 'user-1');
      expect(map['totalPrice'], 90000);
      expect(map['items'], hasLength(1));
      expect(map['items'].first['subtotal'], 90000);
      expect(map['orderDate'], isA<Timestamp>());
      expect(map.containsKey('id'), isFalse);
    });

    test('fromMap reads Firestore timestamp and document ID', () {
      final orderDate = DateTime(2026, 10, 26);
      final order = app_model.Order.fromMap({
        'userId': 'user-1',
        'items': [
          {
            'foodId': 'food-1',
            'foodName': 'Phở bò',
            'unitPrice': 45000,
            'quantity': 2,
          },
        ],
        'totalPrice': 90000,
        'createdAt': Timestamp.fromDate(orderDate),
        'status': 'pending',
        'deliveryAddress': 'Hà Nội',
      }, id: 'order-1');

      expect(order.id, 'order-1');
      expect(order.orderDate, orderDate);
      expect(order.items.single.subtotal, 90000);
      expect(order.status, 'pending');
    });
  });
}
