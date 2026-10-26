import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/models/food.dart';

void main() {
  group('Food model', () {
    test('toMap writes fields used by Firestore', () {
      const food = Food(
        id: 'food-1',
        name: 'Cơm gà',
        price: 35000,
        description: 'Cơm gà giòn',
        category: 'Cơm',
        restaurantId: 'restaurant-1',
        imageUrl: 'https://example.com/food.jpg',
      );

      final map = food.toMap();
      expect(map['name'], 'Cơm gà');
      expect(map['price'], 35000.0);
      expect(map['restaurantId'], 'restaurant-1');
      expect(map['isAvailable'], isTrue);
    });

    test('fromMap parses numeric fields and uses document ID', () {
      final food = Food.fromMap({
        'name': 'Phở bò',
        'price': 45000,
        'description': 'Phở bò tái',
        'category': 'Món nước',
        'rating': 4.5,
      }, id: 'food-2');

      expect(food.id, 'food-2');
      expect(food.price, 45000.0);
      expect(food.rating, 4.5);
      expect(food.isAvailable, isTrue);
    });
  });
}
