import 'package:flutter/material.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key, required this.onExploreFood});

  final VoidCallback onExploreFood;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
    child: Column(
      children: [
        const Icon(
          Icons.shopping_cart_outlined,
          size: 72,
          color: Color(0xFF888888),
        ),
        const SizedBox(height: 16),
        const Text(
          'Giỏ hàng của bạn đang trống',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onExploreFood,
          child: const Text('Khám phá món ăn'),
        ),
      ],
    ),
  );
}
