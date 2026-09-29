import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../utils/currency_format.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  Widget _deleteBackground(Alignment alignment) => Container(
    alignment: alignment,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: const Color(0xFF3D3D3D),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(Icons.delete_outline, color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('dismiss-food-${item.food.id}'),
      direction: DismissDirection.horizontal,
      background: _deleteBackground(Alignment.centerLeft),
      secondaryBackground: _deleteBackground(Alignment.centerRight),
      onDismissed: (_) => onRemove(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.image_outlined,
                color: Color(0xFF888888),
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.food.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Xóa ${item.food.name}',
                        onPressed: onRemove,
                        style: IconButton.styleFrom(
                          minimumSize: const Size(40, 40),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.delete_outline, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Tự xuống dòng trên màn hình hẹp hoặc khi tăng cỡ chữ.
                  LayoutBuilder(
                    builder: (context, constraints) => Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _QuantityButton(
                              icon: Icons.remove,
                              tooltip: 'Giảm ${item.food.name}',
                              onPressed: onDecrease,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                '${item.quantity}',
                                semanticsLabel: 'Số lượng ${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            _QuantityButton(
                              icon: Icons.add,
                              tooltip: 'Tăng ${item.food.name}',
                              onPressed: onIncrease,
                            ),
                          ],
                        ),
                        SizedBox(
                          width:
                              constraints.maxWidth < 240 ||
                                  MediaQuery.textScalerOf(context).scale(14) >
                                      18
                              ? constraints.maxWidth
                              : null,
                          child: Text(
                            formatCurrency(item.subtotal),
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: Icon(icon, size: 18),
    style: IconButton.styleFrom(
      backgroundColor: const Color(0xFFF2F2F2),
      foregroundColor: const Color(0xFF3D3D3D),
      minimumSize: const Size(40, 40),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
