import '../models/user.dart';

/// Hợp đồng tài khoản dùng chung cho Firebase thật và bản demo.
abstract class AuthService {
  User? get currentUser;
  Stream<User?> get userChanges;
  bool get isDemo;
  Future<User> signIn(String email, String password);
  Future<User> signUp(String name, String email, String password);
  Future<User> updateProfile({
    required String name,
    required String phone,
    required String address,
  });
  Future<User> refreshProfile();
  Future<void> signOut();
  void dispose();
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}
