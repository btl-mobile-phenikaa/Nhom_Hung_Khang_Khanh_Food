import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/services/demo_auth_service.dart';
import 'package:nhom_hung_khang_khanh_food/state/auth_controller.dart';

void main() {
  late DemoAuthService service;
  late AuthController auth;
  setUp(() {
    service = DemoAuthService(delay: Duration.zero);
    auth = AuthController(service);
  });
  tearDown(() => auth.dispose());

  Future<bool> login() =>
      auth.signIn(DemoAuthService.demoEmail, DemoAuthService.demoPassword);

  test('Đăng nhập chuẩn hóa email, thông báo loading và đăng xuất', () async {
    final states = <bool>[];
    auth.addListener(() => states.add(auth.busy));
    expect(
      await auth.signIn(' TAI.DEMO@FOODIE.TEST ', DemoAuthService.demoPassword),
      isTrue,
    );
    expect(auth.user!.name, 'Nguyễn Chí Tài');
    expect(states, containsAllInOrder([true, false]));
    expect(await auth.signOut(), isTrue);
    expect(auth.user, isNull);
    expect(auth.busy, isFalse);
  });
  test('Sai thông tin đăng nhập không tạo phiên', () async {
    expect(await auth.signIn(DemoAuthService.demoEmail, 'incorrect'), isFalse);
    expect(auth.error, 'Email hoặc mật khẩu không chính xác.');
    expect(auth.user, isNull);
    expect(auth.busy, isFalse);
  });
  test(
    'Đăng ký mới, đăng xuất, đăng nhập và giữ hồ sơ trong phiên demo',
    () async {
      expect(
        await auth.signUp(
          ' Tài mới ',
          ' new@example.com ',
          'Foodie123!',
          'Foodie123!',
        ),
        isTrue,
      );
      final uid = auth.user!.id;
      expect(auth.user!.email, 'new@example.com');
      expect(
        await auth.updateProfile('Tài đã sửa', '0901234567', ' Hà Nội '),
        isTrue,
      );
      expect(auth.user!.address, 'Hà Nội');
      await auth.signOut();
      expect(await auth.signIn('new@example.com', 'Foodie123!'), isTrue);
      expect(auth.user!.id, uid);
      expect(auth.user!.name, 'Tài đã sửa');
    },
  );
  test('Đăng ký email trùng và xác nhận sai đều báo lỗi', () async {
    expect(
      await auth.signUp(
        'Tài',
        DemoAuthService.demoEmail,
        'Foodie123!',
        'Foodie123!',
      ),
      isFalse,
    );
    expect(auth.error, 'Email này đã được đăng ký.');
    expect(
      await auth.signUp('Tài', 'new@example.com', 'Foodie123!', 'different'),
      isFalse,
    );
    expect(auth.error, 'Mật khẩu xác nhận không khớp.');
    expect(auth.user, isNull);
  });
  test('Mất kết nối có thể thử lại; cập nhật lỗi giữ hồ sơ cũ', () async {
    auth.toggleOffline();
    expect(await login(), isFalse);
    expect(auth.error, contains('kết nối'));
    auth.toggleOffline();
    expect(await login(), isTrue);
    final previous = auth.user;
    auth.toggleOffline();
    expect(await auth.updateProfile('Tên mới', '', ''), isFalse);
    expect(auth.user, same(previous));
    expect(await auth.signOut(), isFalse);
    expect(auth.user, same(previous));
  });
  test('Chặn dữ liệu không hợp lệ trước khi gọi service', () async {
    expect(await auth.signIn('not-email', 'x'), isFalse);
    expect(
      await auth.signUp('A', 'ok@example.com', '12345678', '12345678'),
      isFalse,
    );
    await login();
    expect(await auth.updateProfile('Tài', 'invalid', ''), isFalse);
    expect(auth.user!.phone, '0901234567');
  });
  test('Không cập nhật được khi chưa đăng nhập', () async {
    expect(await auth.updateProfile('Tài', '', ''), isFalse);
    expect(auth.error, 'Vui lòng đăng nhập lại.');
  });
  test('Chặn gửi trùng khi yêu cầu đang xử lý', () async {
    final first = login();
    expect(auth.busy, isTrue);
    expect(await login(), isFalse);
    expect(await first, isTrue);
  });
  test('Dispose trong lúc xử lý không notify trên controller đã hủy', () async {
    final other = AuthController(
      DemoAuthService(delay: const Duration(milliseconds: 10)),
    );
    final pending = other.signIn(
      DemoAuthService.demoEmail,
      DemoAuthService.demoPassword,
    );
    other.dispose();
    expect(await pending, isFalse);
  });
}
