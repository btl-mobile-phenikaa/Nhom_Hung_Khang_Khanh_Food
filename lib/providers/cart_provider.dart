import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/food.dart';

class CartProvider extends ChangeNotifier {
  CartProvider({this.id = 1, bool loadMockData = true}) {
    if (loadMockData) {
      _items.addAll([
        CartItem(
          food: Food(
            id: 1,
            name: 'Phở bò đặc biệt',
            price: 35000,
            description: 'Phở bò với nước dùng đậm đà.',
            category: 'Món chính',
          ),
        ),
        CartItem(
          food: Food(
            id: 2,
            name: 'Bánh mì thịt nướng',
            price: 25000,
            description: 'Bánh mì giòn với thịt nướng và rau tươi.',
            category: 'Món chính',
          ),
          quantity: 2,
        ),
        CartItem(
          food: Food(
            id: 3,
            name: 'Trà sữa trân châu',
            price: 30000,
            description: 'Trà sữa kèm trân châu dai mềm.',
            category: 'Đồ uống',
          ),
        ),
      ]);
    }
  }

  final int id;
  final List<CartItem> _items = [];

  // Ngăn màn hình tự thay đổi danh sách hoặc số lượng ngoài Provider.
  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (count, item) => count + item.quantity);
  double get totalPrice => calculateTotal();
  double get subtotal => totalPrice;
  double get shippingFee => isEmpty ? 0 : 15000;
  double get grandTotal => subtotal + shippingFee;

  double calculateTotal() =>
      _items.fold(0.0, (total, item) => total + item.subtotal);

  int _indexOf(Food food) =>
      _items.indexWhere((item) => item.food.id == food.id);

  void addFood(Food food) {
    final index = _indexOf(food);
    if (index == -1) {
      _items.add(CartItem(food: food));
    } else {
      final item = _items[index];
      _items[index] = CartItem(food: item.food, quantity: item.quantity + 1);
    }
    notifyListeners();
  }

  void removeFood(Food food) {
    final index = _indexOf(food);
    if (index == -1) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void increaseQuantity(Food food) {
    if (_indexOf(food) == -1) return;
    addFood(food);
  }

  void decreaseQuantity(Food food) {
    final index = _indexOf(food);
    if (index == -1) return;
    final item = _items[index];
    if (item.quantity == 1) {
      _items.removeAt(index);
    } else {
      _items[index] = CartItem(food: item.food, quantity: item.quantity - 1);
    }
    notifyListeners();
  }

  void clearCart() {
    if (isEmpty) return;
    _items.clear();
    notifyListeners();
  }

  // Hoàn tác khôi phục cả số lượng và vị trí món vừa xóa.
  void restoreItem(CartItem item, {int? index}) {
    final existing = _indexOf(item.food);
    if (existing == -1) {
      final position = (index ?? _items.length).clamp(0, _items.length);
      _items.insert(position, item);
    } else {
      final current = _items[existing];
      _items[existing] = CartItem(
        food: current.food,
        quantity: current.quantity + item.quantity,
      );
    }
    notifyListeners();
  }
}
