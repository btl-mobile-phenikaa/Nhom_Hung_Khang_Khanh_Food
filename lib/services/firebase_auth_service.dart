import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';

import '../models/user.dart';
import '../repositories/user_repository.dart';
import 'auth_service.dart';

/// Firebase Auth quản lý phiên; Firestore chỉ lưu thông tin hồ sơ theo UID.
class FirebaseAuthService implements AuthService {
  FirebaseAuthService({firebase.FirebaseAuth? auth, UserRepository? users})
    : _auth = auth ?? firebase.FirebaseAuth.instance,
      _users = users ?? UserRepository() {
    final initial = _auth.currentUser;
    _current = initial == null ? null : _fallback(initial);
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (!_working) _watchUser(user);
    }, onError: (Object error) => _report(error));
  }

  final firebase.FirebaseAuth _auth;
  final UserRepository _users;
  final _changes = StreamController<User?>.broadcast();
  late final StreamSubscription<firebase.User?> _authSubscription;
  StreamSubscription<User?>? _profileSubscription;
  User? _current;
  int _generation = 0;
  bool _working = false;
  bool _disposed = false;
  static const _timeout = Duration(seconds: 15);

  @override
  User? get currentUser => _current;
  @override
  Stream<User?> get userChanges => _changes.stream;
  @override
  bool get isDemo => false;

  User _fallback(firebase.User user, {String? name}) => User(
    id: user.uid,
    name: name ?? user.displayName ?? 'Người dùng Foodie',
    email: user.email ?? '',
    phone: '',
    address: '',
    photoUrl: user.photoURL ?? '',
  );

  void _publish(User? user) {
    if (_disposed) return;
    _current = user;
    _changes.add(user);
  }

  void _report(Object error) {
    if (!_disposed) {
      _changes.addError(error is AuthFailure ? error : failureFor(error));
    }
  }

  void _watchUser(firebase.User? firebaseUser) {
    if (_disposed) return;
    final generation = ++_generation;
    unawaited(_profileSubscription?.cancel());
    _profileSubscription = null;
    if (firebaseUser == null) {
      _publish(null);
      return;
    }
    if (_current?.id != firebaseUser.uid) _publish(_fallback(firebaseUser));
    _profileSubscription = _users
        .watchById(firebaseUser.uid)
        .listen(
          (profile) {
            if (_disposed ||
                generation != _generation ||
                _working ||
                _auth.currentUser?.uid != firebaseUser.uid) {
              return;
            }
            if (profile == null) {
              _report(
                const AuthFailure(
                  'Hồ sơ chưa được lưu. Hãy mở Chỉnh sửa hồ sơ và lưu lại.',
                ),
              );
            } else {
              // Email lấy từ Auth; không tin email do client khác ghi trong document.
              _publish(
                profile.copyWith(
                  id: firebaseUser.uid,
                  email: firebaseUser.email ?? profile.email,
                ),
              );
            }
          },
          onError: (Object error) {
            if (!_disposed && generation == _generation && !_working) {
              _report(error);
            }
          },
        );
  }

  Future<User> _authenticate(
    Future<firebase.UserCredential> Function() action, {
    String? registrationName,
  }) async {
    _working = true;
    ++_generation;
    await _profileSubscription?.cancel();
    _profileSubscription = null;
    try {
      final result = await action().timeout(_timeout);
      final firebaseUser = result.user;
      if (firebaseUser == null) {
        throw const AuthFailure(
          'Không lấy được phiên đăng nhập. Vui lòng thử lại.',
        );
      }
      var profile = _fallback(firebaseUser, name: registrationName);
      _publish(profile);
      try {
        final saved = await _users.getById(firebaseUser.uid).timeout(_timeout);
        profile =
            saved?.copyWith(
              id: firebaseUser.uid,
              email: firebaseUser.email ?? saved.email,
            ) ??
            profile;
        if (saved == null) await _users.save(profile).timeout(_timeout);
        _publish(profile);
        if (registrationName != null) {
          // Lỗi đồng bộ tên Auth không làm mất hồ sơ đã ghi ở Firestore.
          try {
            await firebaseUser
                .updateDisplayName(registrationName)
                .timeout(_timeout);
          } catch (_) {}
        }
      } catch (_) {
        // Auth đã thành công: giữ phiên để người dùng có thể lưu lại hồ sơ.
        _report(
          const AuthFailure(
            'Đã đăng nhập, nhưng chưa đồng bộ được hồ sơ. '
            'Hãy kiểm tra kết nối hoặc quyền Firestore, rồi tải lại/lưu hồ sơ.',
          ),
        );
      }
      if (_auth.currentUser?.uid != firebaseUser.uid) {
        throw const AuthFailure(
          'Phiên đăng nhập đã thay đổi. Vui lòng thử lại.',
        );
      }
      return profile;
    } catch (error) {
      throw error is AuthFailure ? error : failureFor(error);
    } finally {
      _working = false;
      _watchUser(_auth.currentUser);
    }
  }

  @override
  Future<User> signIn(String email, String password) => _authenticate(
    () => _auth.signInWithEmailAndPassword(email: email, password: password),
  );

  @override
  Future<User> signUp(String name, String email, String password) =>
      _authenticate(
        () => _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
        registrationName: name,
      );

  @override
  Future<User> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw const AuthFailure(
        'Phiên đăng nhập đã hết. Vui lòng đăng nhập lại.',
      );
    }
    if (_current?.id != firebaseUser.uid) {
      throw const AuthFailure('Phiên đăng nhập đã thay đổi. Vui lòng thử lại.');
    }
    final profile = (_current ?? _fallback(firebaseUser)).copyWith(
      name: name,
      phone: phone,
      address: address,
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
    );
    _working = true;
    try {
      // Ghi đủ trường để phục hồi cả trường hợp tạo tài khoản nhưng thiếu hồ sơ.
      await _users.save(profile).timeout(_timeout);
      if (_auth.currentUser?.uid != firebaseUser.uid) {
        throw const AuthFailure(
          'Phiên đăng nhập đã thay đổi. Vui lòng thử lại.',
        );
      }
      _publish(profile);
      return profile;
    } catch (error) {
      throw error is AuthFailure ? error : failureFor(error);
    } finally {
      _working = false;
      _watchUser(_auth.currentUser);
    }
  }

  @override
  Future<User> refreshProfile() async {
    final user = _auth.currentUser;
    if (user == null) throw const AuthFailure('Vui lòng đăng nhập lại.');
    try {
      await user.reload().timeout(_timeout);
      if (_auth.currentUser?.uid != user.uid) {
        throw const AuthFailure('Phiên đăng nhập đã thay đổi.');
      }
      final profile = await _users.getById(user.uid).timeout(_timeout);
      if (profile == null) {
        throw const AuthFailure(
          'Chưa có hồ sơ. Hãy mở Chỉnh sửa hồ sơ và lưu lại.',
        );
      }
      final result = profile.copyWith(
        id: user.uid,
        email: _auth.currentUser?.email ?? profile.email,
      );
      _publish(result);
      _watchUser(_auth.currentUser);
      return result;
    } catch (error) {
      if (_auth.currentUser?.uid == user.uid &&
          error is firebase.FirebaseAuthException &&
          [
            'user-disabled',
            'user-not-found',
            'user-token-expired',
            'invalid-user-token',
          ].contains(error.code)) {
        await _auth.signOut();
        _publish(null);
      }
      throw error is AuthFailure ? error : failureFor(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut().timeout(_timeout);
      _publish(null);
    } catch (error) {
      throw failureFor(error);
    }
  }

  /// Không hiển thị token, mật khẩu hoặc thông báo kỹ thuật của SDK.
  static AuthFailure failureFor(Object error) {
    if (error is TimeoutException) {
      return const AuthFailure('Kết nối quá chậm. Vui lòng thử lại.');
    }
    if (error is! FirebaseException) {
      return const AuthFailure('Không thể kết nối dịch vụ. Vui lòng thử lại.');
    }
    return AuthFailure(switch (error.code) {
      'invalid-email' => 'Email không đúng định dạng.',
      'email-already-in-use' => 'Email này đã được đăng ký.',
      'weak-password' || 'password-does-not-meet-requirements' =>
        'Mật khẩu chưa đáp ứng yêu cầu của hệ thống.',
      'invalid-credential' ||
      'invalid-login-credentials' ||
      'wrong-password' ||
      'user-not-found' => 'Email hoặc mật khẩu không chính xác.',
      'user-disabled' =>
        'Tài khoản đã bị vô hiệu hóa. Vui lòng liên hệ nhóm quản trị.',
      'network-request-failed' ||
      'unavailable' ||
      'deadline-exceeded' => 'Không có kết nối mạng. Vui lòng thử lại.',
      'too-many-requests' ||
      'quota-exceeded' => 'Bạn đã thử quá nhiều lần. Vui lòng đợi rồi thử lại.',
      'permission-denied' => 'Chưa có quyền truy cập hồ sơ. Vui lòng kiểm tra Firestore Rules với Người 1.',
      'operation-not-allowed' || 'configuration-not-found' =>
        'Project chưa bật đăng nhập Email/Password. Vui lòng liên hệ Người 1.',
      'unauthenticated' ||
      'user-token-expired' ||
      'invalid-user-token' => 'Phiên đăng nhập đã hết. Vui lòng đăng nhập lại.',
      _ => 'Không thể thực hiện thao tác. Vui lòng thử lại.',
    });
  }

  @override
  void dispose() {
    _disposed = true;
    ++_generation;
    unawaited(_authSubscription.cancel());
    unawaited(_profileSubscription?.cancel());
    unawaited(_changes.close());
  }
}
