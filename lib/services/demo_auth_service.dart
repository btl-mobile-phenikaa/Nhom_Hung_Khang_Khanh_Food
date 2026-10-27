import 'dart:async';

import '../models/user.dart';
import 'auth_service.dart';

/// Chỉ dùng demo: tài khoản nằm trong RAM và mất khi khởi động lại.
class DemoAuthService implements AuthService {
  DemoAuthService({this.delay = const Duration(milliseconds: 350)}) {
    _accounts[demoEmail] = (
      user: const User(
        id: 'demo-tai',
        name: 'Nguyễn Chí Tài',
        email: demoEmail,
        phone: '0901234567',
        address: 'Phenikaa University, Hà Nội',
      ),
      password: demoPassword,
    );
  }

  static const demoEmail = 'tai.demo@foodie.test';
  static const demoPassword = 'Foodie123!';
  final Duration delay;
  final _changes = StreamController<User?>.broadcast();
  final Map<String, ({User user, String password})> _accounts = {};
  User? _user;
  bool offline = false;
  int _nextId = 1;

  @override
  bool get isDemo => true;
  @override
  User? get currentUser => _user;
  @override
  Stream<User?> get userChanges => _changes.stream;

  Future<void> _checkConnection() async {
    await Future<void>.delayed(delay);
    if (offline) {
      throw const AuthFailure('Không có kết nối mạng. Vui lòng thử lại.');
    }
  }

  User _publish(User user) {
    _user = user;
    _changes.add(user);
    return user;
  }

  @override
  Future<User> signIn(String email, String password) async {
    await _checkConnection();
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw const AuthFailure('Email hoặc mật khẩu không chính xác.');
    }
    return _publish(account.user);
  }

  @override
  Future<User> signUp(String name, String email, String password) async {
    await _checkConnection();
    final normalized = email.trim().toLowerCase();
    if (_accounts.containsKey(normalized)) {
      throw const AuthFailure('Email này đã được đăng ký.');
    }
    final user = User(
      id: 'demo-user-${_nextId++}',
      name: name.trim(),
      email: normalized,
      phone: '',
      address: '',
    );
    _accounts[normalized] = (user: user, password: password);
    return _publish(user);
  }

  @override
  Future<User> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    await _checkConnection();
    final current = _user;
    if (current == null) throw const AuthFailure('Vui lòng đăng nhập lại.');
    final updated = current.copyWith(
      name: name.trim(),
      phone: phone.trim(),
      address: address.trim(),
    );
    _accounts[current.email] = (
      user: updated,
      password: _accounts[current.email]!.password,
    );
    return _publish(updated);
  }

  @override
  Future<User> refreshProfile() async {
    await _checkConnection();
    final user = _user;
    if (user == null) throw const AuthFailure('Vui lòng đăng nhập lại.');
    return user;
  }

  @override
  Future<void> signOut() async {
    await _checkConnection();
    _user = null;
    _changes.add(null);
  }

  @override
  void dispose() => _changes.close();
}
