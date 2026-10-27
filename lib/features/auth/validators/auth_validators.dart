class AuthValidators {
  AuthValidators._();

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Vui lòng nhập họ tên.';
    if (text.length < 2) return 'Họ tên cần ít nhất 2 ký tự.';
    if (text.length > 80) return 'Họ tên tối đa 80 ký tự.';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Vui lòng nhập email.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(text)) {
      return 'Email không đúng định dạng.';
    }
    return null;
  }

  static String? loginPassword(String? value) =>
      value == null || value.isEmpty ? 'Vui lòng nhập mật khẩu.' : null;

  // Tối thiểu của ứng dụng; Firebase có thể yêu cầu mật khẩu mạnh hơn.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu.';
    if (value.length < 8) return 'Mật khẩu cần ít nhất 8 ký tự.';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Vui lòng xác nhận mật khẩu.';
    return value != password ? 'Mật khẩu xác nhận không khớp.' : null;
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (!RegExp(r'^(0[0-9]{9}|\+84[0-9]{9})$').hasMatch(text)) {
      return 'Nhập số điện thoại dạng 0xxxxxxxxx hoặc +84xxxxxxxxx.';
    }
    return null;
  }

  static String? address(String? value) =>
      (value?.trim().length ?? 0) > 250 ? 'Địa chỉ tối đa 250 ký tự.' : null;
}
