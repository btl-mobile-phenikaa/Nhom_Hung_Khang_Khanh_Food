import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/currency_format.dart';

class CheckoutPlaceholderScreen extends StatelessWidget {
  const CheckoutPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider nằm trên MaterialApp nên dùng chung được giữa các route.
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(Icons.receipt_long_outlined, size: 64),
            const SizedBox(height: 20),
            const Text(
              'Màn hình thanh toán đang được phát triển',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            for (final item in cart.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '${item.food.name} × ${item.quantity} — '
                  '${formatCurrency(item.subtotal)}',
                ),
              ),
            const Divider(),
            Text('Phí giao hàng: ${formatCurrency(cart.shippingFee)}'),
            const SizedBox(height: 12),
            Text(
              'Tổng cộng: ${formatCurrency(cart.grandTotal)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Quay lại giỏ hàng'),
            ),
          ],
        ),
      ),
    );
  }
}
