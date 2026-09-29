import 'package:intl/intl.dart';

final _vietnameseNumberFormat = NumberFormat('#,##0', 'vi_VN');

String formatCurrency(num amount) =>
    '${_vietnameseNumberFormat.format(amount)}đ';
