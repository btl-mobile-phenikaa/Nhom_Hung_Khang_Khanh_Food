import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/models/restaurant.dart';

void main() {
  group('Restaurant model', () {
    test('toMap writes restaurant fields without the document ID', () {
      const restaurant = Restaurant(
        id: 'restaurant-1',
        name: 'Quán Phở A',
        address: 'Hà Nội',
        description: 'Phở bò truyền thống',
        phone: '0900000000',
        rating: 4.5,
      );

      final map = restaurant.toMap();
      expect(map['name'], 'Quán Phở A');
      expect(map['address'], 'Hà Nội');
      expect(map['rating'], 4.5);
      expect(map.containsKey('id'), isFalse);
    });

    test('fromMap uses the Firestore document ID and parses fields', () {
      final restaurant = Restaurant.fromMap({
        'name': 'Quán Phở A',
        'address': 'Hà Nội',
        'rating': 4,
        'isOpen': false,
      }, id: 'restaurant-1');

      expect(restaurant.id, 'restaurant-1');
      expect(restaurant.rating, 4.0);
      expect(restaurant.isOpen, isFalse);
    });
  });
}
