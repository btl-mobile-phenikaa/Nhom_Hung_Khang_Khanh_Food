import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';
import '../widgets/empty_cart_view.dart';
import 'checkout_placeholder_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.onExploreFood});

  final VoidCallback onExploreFood;

  void _removeItem(BuildContext context, CartItem item) {
    final cart = context.read<CartProvider>();
    final index = cart.items.indexWhere(
      (entry) => entry.food.id == item.food.id,
    );
    cart.removeFood(item.food);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Đã xóa ${item.food.name}'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () => cart.restoreItem(item, index: index),
        ),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa toàn bộ giỏ hàng?'),
        content: const Text('Tất cả món ăn sẽ được xóa khỏi giỏ hàng.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    context.read<CartProvider>().clearCart();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/group.jpg',
                width: double.infinity,
                height: (constraints.maxHeight * 0.15).clamp(48.0, 96.0),
                fit: BoxFit.cover,
                semanticLabel: 'Ảnh nhóm sinh viên',
                errorBuilder: (_, _, _) => Container(
                  height: (constraints.maxHeight * 0.15).clamp(48.0, 96.0),
                  color: const Color(0xFFE6E6E6),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.groups_outlined,
                    size: 40,
                    color: Color(0xFF888888),
                    semanticLabel: 'Ảnh nhóm sinh viên',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const SizedBox(width: 48),
                const Expanded(
                  child: Text(
                    'Giỏ hàng',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: 'Xóa toàn bộ giỏ hàng',
                  onPressed: cart.isEmpty ? null : () => _confirmClear(context),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              children: [
                if (cart.isEmpty)
                  EmptyCartView(onExploreFood: onExploreFood)
                else
                  for (final item in items)
                    Padding(
                      key: ValueKey(item.food.id),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CartItemTile(
                        item: item,
                        onIncrease: () => cart.increaseQuantity(item.food),
                        onDecrease: () {
                          if (item.quantity == 1) {
                            _removeItem(context, item);
                          } else {
                            cart.decreaseQuantity(item.food);
                          }
                        },
                        onRemove: () => _removeItem(context, item),
                      ),
                    ),
                const SizedBox(height: 12),
                CartSummary(
                  subtotal: cart.subtotal,
                  shippingFee: cart.shippingFee,
                  grandTotal: cart.grandTotal,
                  onCheckout: cart.isEmpty
                      ? null
                      : () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const CheckoutPlaceholderScreen(),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              'Phenikaa University - Nguyễn Chí Tài',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Color(0xFF777777)),
            ),
          ),
        ],
      ),
    );
  }
}
