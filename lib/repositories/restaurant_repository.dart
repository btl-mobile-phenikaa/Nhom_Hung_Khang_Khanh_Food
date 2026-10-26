import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/restaurant.dart';

class RestaurantRepository {
  RestaurantRepository({FirebaseFirestore? firestore})
      : _restaurants =
            (firestore ?? FirebaseFirestore.instance).collection('restaurants');

  final CollectionReference<Map<String, dynamic>> _restaurants;

  Future<List<Restaurant>> getAll({bool openOnly = false}) async {
    Query<Map<String, dynamic>> query = _restaurants;
    if (openOnly) query = query.where('isOpen', isEqualTo: true);
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Restaurant.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  Stream<List<Restaurant>> watchAll({bool openOnly = false}) {
    Query<Map<String, dynamic>> query = _restaurants;
    if (openOnly) query = query.where('isOpen', isEqualTo: true);
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Restaurant.fromMap(doc.data(), id: doc.id))
        .toList());
  }

  Future<Restaurant?> getById(String id) async {
    final doc = await _restaurants.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return Restaurant.fromMap(doc.data()!, id: doc.id);
  }

  Future<String> add(Restaurant restaurant) async {
    final doc = await _restaurants.add(restaurant.toMap());
    return doc.id;
  }

  Future<void> update(Restaurant restaurant) async {
    if (restaurant.id.isEmpty) {
      throw ArgumentError('Restaurant.id không được để trống');
    }
    await _restaurants.doc(restaurant.id).update(restaurant.toMap());
  }
}
