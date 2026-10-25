import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food.dart';

class FoodRepository {
  FoodRepository({FirebaseFirestore? firestore})
      : _foods = (firestore ?? FirebaseFirestore.instance).collection('foods');

  final CollectionReference<Map<String, dynamic>> _foods;

  Future<List<Food>> getAll({bool availableOnly = true}) async {
    Query<Map<String, dynamic>> query = _foods;
    if (availableOnly) query = query.where('isAvailable', isEqualTo: true);
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Food.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  Stream<List<Food>> watchAll({bool availableOnly = true}) {
    Query<Map<String, dynamic>> query = _foods;
    if (availableOnly) query = query.where('isAvailable', isEqualTo: true);
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Food.fromMap(doc.data(), id: doc.id))
        .toList());
  }

  Future<Food?> getById(String id) async {
    final doc = await _foods.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return Food.fromMap(doc.data()!, id: doc.id);
  }

  Future<String> add(Food food) async {
    final doc = await _foods.add(food.toMap());
    return doc.id;
  }

  Future<void> update(Food food) async {
    if (food.id.isEmpty) throw ArgumentError('Food.id không được để trống');
    await _foods.doc(food.id).update(food.toMap());
  }

  Future<void> delete(String id) => _foods.doc(id).delete();
}
