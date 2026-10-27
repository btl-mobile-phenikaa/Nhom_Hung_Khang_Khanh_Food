import 'package:flutter/material.dart';
import 'package:nhom_hung_khang_khanh_food/models/food.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/features/profile/screens/profile_screen.dart';
import 'package:nhom_hung_khang_khanh_food/features/auth/screens/login_screen.dart';
import 'package:nhom_hung_khang_khanh_food/features/auth/screens/register_screen.dart';
import 'package:nhom_hung_khang_khanh_food/features/profile/screens/edit_profile_screen.dart';
import 'package:nhom_hung_khang_khanh_food/services/demo_auth_service.dart';
import 'package:nhom_hung_khang_khanh_food/state/auth_controller.dart';
import 'package:nhom_hung_khang_khanh_food/main.dart';

void main() {
  late AuthController auth;
  setUp(() => auth = AuthController(DemoAuthService(delay: Duration.zero)));
  tearDown(() => auth.dispose());

  Future<void> pumpAccount(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(MaterialApp(home: ProfileScreen(controller: auth)));
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final Finder finder;
    if ([
      'Đăng nhập',
      'Tạo tài khoản',
      'Lưu thay đổi',
      'Chỉnh sửa hồ sơ',
    ].contains(text)) {
      finder = find.widgetWithText(FilledButton, text);
    } else {
      finder = find.text(text);
    }
    if (finder.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        finder,
        100,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await Scrollable.ensureVisible(tester.element(finder.last), alignment: 0.5);
    await tester.pumpAndSettle();
    await tester.tap(finder.last);
    await tester.pumpAndSettle();
  }

  Future<void> fill(WidgetTester tester, String label, String value) async {
    final finder = find.widgetWithText(TextFormField, label);
    if (finder.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        finder,
        100,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await tester.ensureVisible(finder);
    await tester.enterText(finder, value);
    await tester.pumpAndSettle();
  }

  Future<void> login(WidgetTester tester) async {
    await tapText(tester, 'Đăng nhập');
    await tapText(tester, 'Điền tài khoản mẫu');
    await tapText(tester, 'Đăng nhập');
  }

  testWidgets('Demo đăng nhập, sửa hồ sơ và đăng xuất có xác nhận', (
    tester,
  ) async {
    await pumpAccount(tester);
    await login(tester);
    expect(find.text('Nguyễn Chí Tài'), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
    await tapText(tester, 'Chỉnh sửa hồ sơ');
    await fill(tester, 'Họ và tên', 'Tài đã cập nhật');
    await fill(tester, 'Số điện thoại', '0987654321');
    await fill(tester, 'Địa chỉ', 'Hà Nội');
    await tapText(tester, 'Lưu thay đổi');
    expect(find.byType(EditProfileScreen), findsNothing);
    expect(find.text('Tài đã cập nhật'), findsOneWidget);
    expect(find.text('0987654321'), findsOneWidget);
    await tapText(tester, 'Đăng xuất');
    await tapText(tester, 'Hủy');
    expect(auth.user, isNotNull);
    await tapText(tester, 'Đăng xuất');
    await tapText(tester, 'Đăng xuất');
    expect(auth.user, isNull);
    expect(find.text('Đăng ký tài khoản'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Đăng ký từ login quay về hồ sơ và bỏ cả hai route', (
    tester,
  ) async {
    await pumpAccount(tester);
    await tapText(tester, 'Đăng nhập');
    await tapText(tester, 'Chưa có tài khoản? Đăng ký');
    await fill(tester, 'Họ và tên', 'Tài mới');
    await fill(tester, 'Email', 'new@example.com');
    await fill(tester, 'Mật khẩu', 'Foodie123!');
    await fill(tester, 'Xác nhận mật khẩu', 'Foodie123!');
    await tapText(tester, 'Tạo tài khoản');
    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.text('Tài mới'), findsOneWidget);
    expect(auth.user!.email, 'new@example.com');
  });

  testWidgets(
    'Kiểm tra nhập liệu, ẩn hiện mật khẩu, lỗi đăng nhập và thử lại',
    (tester) async {
      await pumpAccount(tester);
      await tapText(tester, 'Đăng nhập');
      await tapText(tester, 'Đăng nhập');
      expect(find.text('Vui lòng nhập email.'), findsOneWidget);
      await fill(tester, 'Email', DemoAuthService.demoEmail);
      await fill(tester, 'Mật khẩu', 'incorrect');
      await tester.tap(find.byTooltip('Hiện mật khẩu'));
      await tester.pump();
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: find.widgetWithText(TextFormField, 'Mật khẩu'),
                matching: find.byType(TextField),
              ),
            )
            .obscureText,
        isFalse,
      );
      await tapText(tester, 'Đăng nhập');
      expect(find.text('Email hoặc mật khẩu không chính xác.'), findsOneWidget);
      await tapText(tester, 'Điền tài khoản mẫu');
      await Scrollable.ensureVisible(
        tester.element(find.byTooltip('Mô phỏng mất kết nối')),
        alignment: 0.5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Mô phỏng mất kết nối'));
      await tester.pump();
      await tapText(tester, 'Đăng nhập');
      expect(
        find.text('Không có kết nối mạng. Vui lòng thử lại.'),
        findsOneWidget,
      );
      await Scrollable.ensureVisible(
        tester.element(find.byTooltip('Mô phỏng mất kết nối')),
        alignment: 0.5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Mô phỏng mất kết nối'));
      await tester.pump();
      await tapText(tester, 'Đăng nhập');
      expect(auth.user, isNotNull);
    },
  );

  testWidgets('Tab Profile tích hợp và giữ phiên khi chuyển tab', (
    tester,
  ) async {
    await tester.pumpWidget(
      MyApp(
        foodsStream: Stream<List<Food>>.value(const []).asBroadcastStream(),
        authController: auth,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await login(tester);
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Nguyễn Chí Tài'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Lịch sử đơn hàng'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Lịch sử đơn hàng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Màn hẹp, chữ lớn và bàn phím không overflow', (tester) async {
    await pumpAccount(tester);
    tester.view.physicalSize = const Size(320, 568);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();
    await tapText(tester, 'Đăng ký tài khoản');
    tester.view.viewInsets = const FakeViewPadding(bottom: 220);
    addTearDown(tester.view.resetViewInsets);
    await fill(tester, 'Họ và tên', 'Tài nhỏ');
    await fill(tester, 'Email', 'small@example.com');
    await fill(tester, 'Mật khẩu', 'Foodie123!');
    await fill(tester, 'Xác nhận mật khẩu', 'Foodie123!');
    await tapText(tester, 'Tạo tài khoản');
    expect(auth.user?.name, 'Tài nhỏ');
    expect(find.byType(RegisterScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });
  for (final size in [
    const Size(320, 568),
    const Size(568, 320),
    const Size(1280, 900),
  ]) {
    testWidgets('Đăng nhập thích ứng $size, chữ lớn và bàn phím', (
      tester,
    ) async {
      await pumpAccount(tester);
      tester.view.physicalSize = size;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpAndSettle();
      await tapText(tester, 'Đăng nhập');
      expect(
        find.byKey(const ValueKey('login-welcome-panel')),
        size.width >= 960 ? findsOneWidget : findsNothing,
      );
      tester.view.viewInsets = const FakeViewPadding(bottom: 120);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      await fill(tester, 'Email', DemoAuthService.demoEmail);
      await fill(tester, 'Mật khẩu', DemoAuthService.demoPassword);
      await tapText(tester, 'Đăng nhập');
      expect(auth.user?.email, DemoAuthService.demoEmail);
      expect(find.byType(LoginScreen), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
