import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart' as app_model;

class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
      : _users = (firestore ?? FirebaseFirestore.instance).collection('users');

  final CollectionReference<Map<String, dynamic>> _users;

  Future<app_model.User?> getById(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return app_model.User.fromMap(doc.data()!, id: doc.id);
  }

  Stream<app_model.User?> watchById(String uid) =>
      _users.doc(uid).snapshots().map((doc) {
        if (!doc.exists || doc.data() == null) return null;
        return app_model.User.fromMap(doc.data()!, id: doc.id);
      });

  /// Save profile fields under the Firebase Authentication UID.
  Future<void> save(app_model.User user) async {
    if (user.id.trim().isEmpty) {
      throw ArgumentError('User.id phải là Firebase Authentication UID');
    }
    await _users.doc(user.id).set(
      {...user.toMap(), 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<void> updateProfile(
    String uid, {
    String? name,
    String? phone,
    String? address,
    String? photoUrl,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (name != null) updates['name'] = name.trim();
    if (phone != null) updates['phone'] = phone.trim();
    if (address != null) updates['address'] = address.trim();
    if (photoUrl != null) updates['photoUrl'] = photoUrl.trim();
    await _users.doc(uid).set(updates, SetOptions(merge: true));
  }
}
