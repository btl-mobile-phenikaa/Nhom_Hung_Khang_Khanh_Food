import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order.dart' as app_model;

class OrderRepository {
  OrderRepository({FirebaseFirestore? firestore})
    : _orders = (firestore ?? FirebaseFirestore.instance).collection('orders');

  final CollectionReference<Map<String, dynamic>> _orders;

  Future<String> create(app_model.Order order) async {
    if (order.userId.trim().isEmpty) {
      throw ArgumentError('Không thể tạo đơn hàng khi thiếu userId');
    }
    if (order.items.isEmpty) {
      throw ArgumentError('Đơn hàng phải có ít nhất một món');
    }
    if (order.totalPrice < 0) {
      throw ArgumentError('Tổng tiền không hợp lệ');
    }

    final doc = _orders.doc();
    final data = order.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    await doc.set(data);
    return doc.id;
  }

  Stream<List<app_model.Order>> watchByUser(String uid) => _orders
      .where('userId', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => app_model.Order.fromMap(doc.data(), id: doc.id))
            .toList(),
      );

  Future<app_model.Order?> getById(String id) async {
    final doc = await _orders.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return app_model.Order.fromMap(doc.data()!, id: doc.id);
  }
}
