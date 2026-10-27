import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/features/auth/validators/auth_validators.dart';

void main() {
  test('Tên người dùng có dấu, khoảng trắng và giới hạn', () {
    expect(AuthValidators.name(' Nguyễn Chí Tài '), isNull);
    expect(AuthValidators.name(' '), isNotNull);
    expect(AuthValidators.name('A'), isNotNull);
    expect(AuthValidators.name('a' * 81), isNotNull);
  });
  test('Email loại bỏ khoảng trắng ngoài và từ chối email sai', () {
    expect(AuthValidators.email(' tai@example.com '), isNull);
    for (final text in [
      '',
      'tai',
      'tai@',
      '@example.com',
      'a b@example.com',
      'a@@b.com',
    ]) {
      expect(AuthValidators.email(text), isNotNull, reason: text);
    }
  });
  test('Đăng nhập không ép chính sách mật khẩu đăng ký', () {
    expect(AuthValidators.loginPassword('abc'), isNull);
    expect(AuthValidators.loginPassword(''), isNotNull);
    expect(AuthValidators.password('abc'), isNotNull);
    expect(AuthValidators.password('Foodie123!'), isNull);
  });
  test('Xác nhận mật khẩu phải khớp nguyên bản', () {
    expect(AuthValidators.confirmPassword('Foodie123!', 'Foodie123!'), isNull);
    expect(
      AuthValidators.confirmPassword('Foodie123! ', 'Foodie123!'),
      isNotNull,
    );
    expect(AuthValidators.confirmPassword('', 'Foodie123!'), isNotNull);
  });
  test('Số điện thoại Việt Nam và địa chỉ tùy chọn', () {
    for (final text in ['', '0901234567', '+84901234567']) {
      expect(AuthValidators.phone(text), isNull);
    }
    for (final text in ['123', '090abc4567', '090123456789']) {
      expect(AuthValidators.phone(text), isNotNull);
    }
    expect(AuthValidators.address(''), isNull);
    expect(AuthValidators.address('a' * 251), isNotNull);
  });
}
