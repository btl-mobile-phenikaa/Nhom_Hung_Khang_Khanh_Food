class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format an amount into standard display (e.g. 45000 -> "45.000 VNĐ")
  static String format(num amount) {
    final raw = amount.toStringAsFixed(0);
    final withDots = raw.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return '$withDots VNĐ';
  }

  /// Format raw without thousand separator if required (e.g. "45000 VNĐ")
  static String formatSimple(num amount) {
    return '${amount.toStringAsFixed(0)} VNĐ';
  }
}

