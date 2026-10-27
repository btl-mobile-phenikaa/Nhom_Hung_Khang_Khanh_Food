import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/demo_auth_service.dart';
import '../features/auth/validators/auth_validators.dart';

class AuthController extends ChangeNotifier {
  AuthController(this.service) : _user = service.currentUser {
    _subscription = service.userChanges.listen(
      (user) {
        if (_disposed) return;
        _user = user;
        notifyListeners();
      },
      onError: (Object error) {
        if (_disposed) return;
        _error = error is AuthFailure
            ? error.message
            : 'Không tải được hồ sơ. Vui lòng thử lại.';
        notifyListeners();
      },
    );
  }

  final AuthService service;
  late final StreamSubscription<User?> _subscription;
  User? _user;
  bool _busy = false;
  bool _disposed = false;
  String? _error;

  User? get user => _user;
  bool get busy => _busy;
  String? get error => _error;
  bool get isDemo => service.isDemo;
  bool get offline =>
      service is DemoAuthService && (service as DemoAuthService).offline;

  void toggleOffline() {
    if (busy || service is! DemoAuthService) return;
    (service as DemoAuthService).offline = !offline;
    clearError();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> _run(
    Future<User?> Function() action, [
    String? validationError,
  ]) async {
    if (_busy || _disposed) return false;
    _error = validationError;
    if (_error != null) {
      notifyListeners();
      return false;
    }
    _busy = true;
    notifyListeners();
    try {
      final nextUser = await action();
      if (_disposed) return false;
      _user = nextUser;
      return true;
    } on AuthFailure catch (failure) {
      if (!_disposed) _error = failure.message;
      return false;
    } catch (_) {
      if (!_disposed) {
        _error = 'Không thể thực hiện thao tác. Vui lòng thử lại.';
      }
      return false;
    } finally {
      _busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) => _run(
    () => service.signIn(email.trim().toLowerCase(), password),
    AuthValidators.email(email) ?? AuthValidators.loginPassword(password),
  );

  Future<bool> signUp(
    String name,
    String email,
    String password,
    String confirm,
  ) => _run(
    () => service.signUp(name.trim(), email.trim().toLowerCase(), password),
    AuthValidators.name(name) ??
        AuthValidators.email(email) ??
        AuthValidators.password(password) ??
        AuthValidators.confirmPassword(confirm, password),
  );

  Future<bool> updateProfile(String name, String phone, String address) => _run(
    () => service.updateProfile(name: name, phone: phone, address: address),
    AuthValidators.name(name) ??
        AuthValidators.phone(phone) ??
        AuthValidators.address(address),
  );

  Future<bool> refreshProfile() => _run(service.refreshProfile);

  Future<bool> signOut() => _run(() async {
    await service.signOut();
    return null;
  });

  // Chủ sở hữu controller cũng sở hữu service; màn hình chỉ mượn controller.
  @override
  void dispose() {
    _disposed = true;
    _subscription.cancel();
    service.dispose();
    super.dispose();
  }
}
