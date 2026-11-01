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

    test('toOrderItem preserves snapshot unitPrice, size and toppings even if food price changes later', () {
      final item = CartItem(
        food: food,
        quantity: 2,
        size: 'Size L',
        toppings: const ['Thêm trứng ốp la', 'Thêm sốt đặc biệt'],
        unitPrice: 48000,
        note: 'Không ớt',
      );

      final orderItem = item.toOrderItem();
      expect(orderItem.foodId, 'food-1');
      expect(orderItem.size, 'Size L');
      expect(orderItem.toppings, ['Thêm trứng ốp la', 'Thêm sốt đặc biệt']);
      expect(orderItem.unitPrice, 48000);
      expect(orderItem.subtotal, 96000);
      expect(orderItem.note, 'Không ớt');
    });

    test('toMap and fromMap share unified schema for localStorage and Firestore', () {
      final original = CartItem(
        food: food,
        quantity: 3,
        size: 'Size L',
        toppings: const ['Thêm quẩy giòn'],
        unitPrice: 45000,
      );

      final serialized = original.toMap();
      final restored = CartItem.fromMap(serialized);

      expect(restored.food.id, original.food.id);
      expect(restored.quantity, 3);
      expect(restored.size, 'Size L');
      expect(restored.toppings, ['Thêm quẩy giòn']);
      expect(restored.unitPrice, 45000);
      expect(restored.subtotal, 135000);
    });
  });
}
