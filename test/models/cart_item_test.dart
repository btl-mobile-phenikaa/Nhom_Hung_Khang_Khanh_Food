import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/models/cart_item.dart';
import 'package:nhom_hung_khang_khanh_food/models/food.dart';

void main() {
  const food = Food(
    id: 'food-1',
    name: 'Bánh mì',
    price: 25000,
    description: 'Bánh mì thịt',
    category: 'Đồ ăn nhanh',
  );

  group('CartItem', () {
    test('subtotal reflects unit price multiplied by quantity', () {
      final item = CartItem(food: food, quantity: 2);
      expect(item.subtotal, 50000);
    });

    test('decrease never reduces quantity below one', () {
      final item = CartItem(food: food);
      item.decrease();
      expect(item.quantity, 1);
      item.increase();
      expect(item.quantity, 2);
      item.decrease();
      expect(item.quantity, 1);
    });

    test('quantity must start at one or more', () {
      expect(() => CartItem(food: food, quantity: 0), throwsArgumentError);
    });
  });
}
