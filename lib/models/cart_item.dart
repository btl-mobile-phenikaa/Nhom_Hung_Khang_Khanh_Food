import 'food.dart';

class CartItem {
  CartItem({required this.food, this.quantity = 1}) {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'Phải lớn hơn 0');
    }
  }

  final Food food;
  final int quantity;

  double get subtotal => food.price * quantity;
}
