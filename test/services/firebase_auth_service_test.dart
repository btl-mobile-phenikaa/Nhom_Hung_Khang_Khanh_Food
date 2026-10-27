import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/models/user.dart';
import 'package:nhom_hung_khang_khanh_food/repositories/user_repository.dart';
import 'package:nhom_hung_khang_khanh_food/services/firebase_auth_service.dart';
import 'package:nhom_hung_khang_khanh_food/state/auth_controller.dart';

class FakeFirebaseUser extends Fake implements firebase.User {
  FakeFirebaseUser(this.uid, this.email, {this.displayName});
  @override
  final String uid;
  @override
  final String email;
  @override
  String? displayName;
  @override
  String? get photoURL => null;
  Object? reloadError;
  @override
  Future<void> updateDisplayName(String? name) async => displayName = name;
  @override
  Future<void> reload() async {
    if (reloadError != null) throw reloadError!;
  }
}

class FakeCredential extends Fake implements firebase.UserCredential {
  FakeCredential(this.user);
  @override
  final firebase.User user;
}

class FakeFirebaseAuth extends Fake implements firebase.FirebaseAuth {
  final changes = StreamController<firebase.User?>.broadcast();
  FakeFirebaseUser? account;
  Object? nextError;
  int calls = 0;
  @override
  firebase.User? get currentUser => account;
  @override
  Stream<firebase.User?> authStateChanges() => Stream.multi((listener) {
    listener.add(account);
    final sub = changes.stream.listen(listener.add, onError: listener.addError);
    listener.onCancel = sub.cancel;
  });
  @override
  Future<firebase.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    calls++;
    final failure = nextError;
    nextError = null;
    if (failure != null) throw failure;
    account = FakeFirebaseUser('uid-a', email);
    changes.add(account);
    return FakeCredential(account!);
  }

  @override
  Future<firebase.UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) => signInWithEmailAndPassword(email: email, password: password);
  @override
  Future<void> signOut() async {
    account = null;
    changes.add(null);
  }
}

class FakeUserRepository extends Fake implements UserRepository {
  final profiles = <String, User>{};
  final changes = <String, StreamController<User?>>{};
  Object? saveError;
  Object? readError;
  int saves = 0;
  @override
  Future<User?> getById(String uid) async {
    if (readError != null) throw readError!;
    return profiles[uid];
  }

  @override
  Stream<User?> watchById(String uid) => Stream.multi((listener) {
    listener.add(profiles[uid]);
    final controller = changes.putIfAbsent(
      uid,
      () => StreamController<User?>.broadcast(),
    );
    final sub = controller.stream.listen(
      listener.add,
      onError: listener.addError,
    );
    listener.onCancel = sub.cancel;
  });
  @override
  Future<void> save(User user) async {
    if (saveError != null) throw saveError!;
    saves++;
    profiles[user.id] = user;
    changes[user.id]?.add(user);
  }

  void emit(User user) {
    profiles[user.id] = user;
    changes[user.id]?.add(user);
  }
}

const profileA = User(
  id: 'uid-a',
  name: 'Tài A',
  email: 'a@example.com',
  phone: '0901234567',
  address: 'Hà Nội',
);

void main() {
  late FakeFirebaseAuth firebaseAuth;
  late FakeUserRepository users;
  late FirebaseAuthService service;
  late AuthController controller;

  setUp(() {
    firebaseAuth = FakeFirebaseAuth();
    users = FakeUserRepository();
    service = FirebaseAuthService(auth: firebaseAuth, users: users);
    controller = AuthController(service);
  });
  tearDown(() async {
    controller.dispose();
    await firebaseAuth.changes.close();
    for (final channel in users.changes.values) {
      await channel.close();
    }
  });
  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 10));

  test('Đăng ký tạo hồ sơ theo UID, không lưu mật khẩu', () async {
    expect(
      await controller.signUp(
        'Tài mới',
        'new@example.com',
        'Foodie123!',
        'Foodie123!',
      ),
      isTrue,
    );
    await settle();
    expect(service.isDemo, isFalse);
    expect(users.profiles['uid-a']!.name, 'Tài mới');
    expect(users.profiles['uid-a']!.toMap().containsKey('password'), isFalse);
    expect(firebaseAuth.account!.displayName, 'Tài mới');
    expect(controller.user!.id, 'uid-a');
  });
  test('Đăng nhập đọc hồ sơ cũ và giữ email chính thức từ Auth', () async {
    users.profiles['uid-a'] = profileA.copyWith(email: 'untrusted@example.com');
    expect(await controller.signIn('a@example.com', 'Foodie123!'), isTrue);
    await settle();
    expect(controller.user!.name, profileA.name);
    expect(controller.user!.email, 'a@example.com');
    expect(users.saves, 0);
  });
  test(
    'Sai thông tin và email trùng được ánh xạ sang thông báo Việt',
    () async {
      firebaseAuth.nextError = firebase.FirebaseAuthException(
        code: 'invalid-credential',
      );
      expect(await controller.signIn('a@example.com', 'wrong'), isFalse);
      expect(controller.error, 'Email hoặc mật khẩu không chính xác.');
      firebaseAuth.nextError = firebase.FirebaseAuthException(
        code: 'email-already-in-use',
      );
      expect(
        await controller.signUp(
          'Tài',
          'a@example.com',
          'Foodie123!',
          'Foodie123!',
        ),
        isFalse,
      );
      expect(controller.error, 'Email này đã được đăng ký.');
    },
  );
  test(
    'Ghi hồ sơ thất bại sau đăng ký vẫn giữ phiên và có thể lưu lại',
    () async {
      users.saveError = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
      );
      expect(
        await controller.signUp(
          'Tài mới',
          'new@example.com',
          'Foodie123!',
          'Foodie123!',
        ),
        isTrue,
      );
      await settle();
      expect(controller.user, isNotNull);
      expect(controller.error, isNotNull);
      expect(users.profiles, isEmpty);
      users.saveError = null;
      expect(
        await controller.updateProfile('Tài mới', '0901234567', 'Hà Nội'),
        isTrue,
      );
      await settle();
      expect(users.profiles['uid-a']!.email, 'new@example.com');
      expect(controller.error, isNull);
    },
  );
  test(
    'Phiên được phục hồi từ stream Firebase và nghe cập nhật Firestore',
    () async {
      users.profiles['uid-a'] = profileA;
      firebaseAuth.account = FakeFirebaseUser('uid-a', 'a@example.com');
      firebaseAuth.changes.add(firebaseAuth.account);
      await settle();
      expect(controller.user!.name, 'Tài A');
      users.emit(profileA.copyWith(name: 'Tài đã sửa ở thiết bị khác'));
      await settle();
      expect(controller.user!.name, 'Tài đã sửa ở thiết bị khác');
      expect(firebaseAuth.calls, 0);
    },
  );
  test(
    'Đăng xuất hủy watcher; cập nhật hồ sơ cũ không hồi sinh phiên',
    () async {
      users.profiles['uid-a'] = profileA;
      await controller.signIn('a@example.com', 'Foodie123!');
      await controller.signOut();
      users.emit(profileA.copyWith(name: 'Sự kiện cũ'));
      await settle();
      expect(controller.user, isNull);
      expect(service.currentUser, isNull);
    },
  );
  test('Không lấy nhầm hồ sơ A khi chuyển sang tài khoản B', () async {
    users.profiles['uid-a'] = profileA;
    await controller.signIn('a@example.com', 'Foodie123!');
    users.profiles['uid-b'] = profileA.copyWith(
      id: 'uid-b',
      name: 'Tài B',
      email: 'b@example.com',
    );
    firebaseAuth.account = FakeFirebaseUser('uid-b', 'b@example.com');
    firebaseAuth.changes.add(firebaseAuth.account);
    await settle();
    users.emit(profileA.copyWith(name: 'Cập nhật chậm của A'));
    await settle();
    expect(controller.user!.id, 'uid-b');
    expect(controller.user!.name, 'Tài B');
  });
  test('Lỗi stream hồ sơ không làm crash, có thể tải lại', () async {
    users.profiles['uid-a'] = profileA;
    await controller.signIn('a@example.com', 'Foodie123!');
    await settle();
    users.changes['uid-a']!.addError(
      FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
    );
    await settle();
    expect(controller.error, contains('kết nối'));
    expect(await controller.refreshProfile(), isTrue);
    expect(controller.error, isNull);
  });
  test('Cập nhật lỗi giữ hồ sơ cũ và chưa đăng nhập không được lưu', () async {
    expect(await controller.updateProfile('Tài', '', ''), isFalse);
    users.profiles['uid-a'] = profileA;
    await controller.signIn('a@example.com', 'Foodie123!');
    users.saveError = FirebaseException(
      plugin: 'cloud_firestore',
      code: 'permission-denied',
    );
    expect(await controller.updateProfile('Tên mới', '', ''), isFalse);
    expect(controller.user!.name, 'Tài A');
    expect(controller.error, contains('quyền'));
  });
  test('Phiên bị vô hiệu hóa được đăng xuất khi refresh', () async {
    await controller.signIn('a@example.com', 'Foodie123!');
    firebaseAuth.account!.reloadError = firebase.FirebaseAuthException(
      code: 'user-disabled',
    );
    expect(await controller.refreshProfile(), isFalse);
    await settle();
    expect(controller.user, isNull);
    expect(controller.error, contains('vô hiệu hóa'));
  });
  test(
    'Ánh xạ lỗi mạng, timeout, chưa bật provider và không lộ thông báo SDK',
    () {
      expect(
        FirebaseAuthService.failureFor(TimeoutException('secret')).message,
        contains('quá chậm'),
      );
      expect(
        FirebaseAuthService.failureFor(
          firebase.FirebaseAuthException(code: 'operation-not-allowed'),
        ).message,
        contains('Email/Password'),
      );
      expect(
        FirebaseAuthService.failureFor(
          firebase.FirebaseAuthException(code: 'network-request-failed'),
        ).message,
        contains('kết nối'),
      );
      expect(
        FirebaseAuthService.failureFor(Exception('private token')).message,
        isNot(contains('private token')),
      );
    },
  );
  test('Dữ liệu không hợp lệ không gửi đến Firebase', () async {
    expect(await controller.signIn('invalid', 'password'), isFalse);
    expect(firebaseAuth.calls, 0);
  });
}
