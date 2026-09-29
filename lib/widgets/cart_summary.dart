import 'package:flutter/material.dart';

import '../utils/currency_format.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.grandTotal,
    required this.onCheckout,
  });

  final double subtotal;
  final double shippingFee;
  final double grandTotal;
  // Truyền null để vô hiệu hóa thanh toán khi giỏ trống.
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryRow(label: 'Tạm tính', amount: subtotal),
        const SizedBox(height: 12),
        _SummaryRow(label: 'Phí giao hàng', amount: shippingFee),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(color: Color(0xFFE0E0E0)),
        ),
        _SummaryRow(label: 'Tổng cộng', amount: grandTotal, bold: true),
        const SizedBox(height: 20),
        FilledButton(onPressed: onCheckout, child: const Text('Thanh toán')),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    this.bold = false,
  });

  final String label;
  final double amount;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 18 : 15,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: style)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            formatCurrency(amount),
            textAlign: TextAlign.right,
            style: style,
          ),
        ),
      ],
    );
  }
}
