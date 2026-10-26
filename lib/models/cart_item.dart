import 'food.dart';

class CartItem {
  CartItem({required this.food, this.quantity = 1}) {
    if (quantity < 1) throw ArgumentError.value(quantity, 'quantity', 'Phải >= 1');
  }

  final Food food;
  int quantity;

  double get subtotal => food.price * quantity;

  void increase() => quantity++;

  /// Keeps quantity at one or more. Use remove-from-cart for deleting an item.
  void decrease() {
    if (quantity > 1) quantity--;
  }

  Map<String, dynamic> toMap() => {
        'foodId': food.id,
        'foodName': food.name,
        'unitPrice': food.price,
        'quantity': quantity,
        'subtotal': subtotal,
      };
}
