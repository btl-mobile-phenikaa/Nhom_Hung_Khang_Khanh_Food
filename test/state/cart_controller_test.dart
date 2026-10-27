import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/models/food.dart';
import 'package:nhom_hung_khang_khanh_food/state/cart_controller.dart';

void main() {
  group('CartController Tests', () {
    late CartController controller;

    final foodA = Food(
      id: 'f1',
      name: 'Phở bò',
      price: 50000,
      description: 'Phở bò thơm ngon',
      category: 'Noodles',
    );

    final foodB = Food(
      id: 'f2',
      name: 'Bánh mì pate',
      price: 25000,
      description: 'Bánh mì giòn rụm',
      category: 'Vietnamese',
    );

    setUp(() {
      controller = CartController.createInstance();
    });

    test('Initial state is empty', () {
      expect(controller.isEmpty, isTrue);
      expect(controller.items, isEmpty);
      expect(controller.totalItemCount, 0);
      expect(controller.subtotal, 0.0);
      expect(controller.totalPrice, 0.0);
    });

    test('Add item creates CartItem and notifies', () {
      controller.addItem(foodA, quantity: 2);
      expect(controller.isEmpty, isFalse);
      expect(controller.items.length, 1);
      expect(controller.totalItemCount, 2);
      expect(controller.subtotal, 100000.0);
      expect(controller.hasItem('f1'), isTrue);
      expect(controller.getQuantity('f1'), 2);
    });

    test('Adding same item increases existing item quantity', () {
      controller.addItem(foodA, quantity: 1);
      controller.addItem(foodA, quantity: 3);

      expect(controller.items.length, 1);
      expect(controller.totalItemCount, 4);
      expect(controller.subtotal, 200000.0);
    });

    test('Increase and decrease quantity', () {
      controller.addItem(foodA, quantity: 2);
      controller.increaseQuantity('f1');
      expect(controller.getQuantity('f1'), 3);

      controller.decreaseQuantity('f1');
      expect(controller.getQuantity('f1'), 2);

      // Decreasing down to 0 removes item
      controller.decreaseQuantity('f1');
      expect(controller.getQuantity('f1'), 1);

      controller.decreaseQuantity('f1');
      expect(controller.isEmpty, isTrue);
      expect(controller.hasItem('f1'), isFalse);
    });

    test('Remove item removes directly from list', () {
      controller.addItem(foodA, quantity: 2);
      controller.addItem(foodB, quantity: 1);
      expect(controller.items.length, 2);

      final removed = controller.removeItem('f1');
      expect(removed?.food.name, 'Phở bò');
      expect(controller.items.length, 1);
      expect(controller.hasItem('f1'), isFalse);
      expect(controller.hasItem('f2'), isTrue);
    });

    test('Clear empties all items', () {
      controller.addItem(foodA);
      controller.addItem(foodB);
      expect(controller.items.length, 2);

      controller.clear();
      expect(controller.isEmpty, isTrue);
      expect(controller.totalPrice, 0.0);
    });

    test('Delivery fee logic', () {
      // Empty: fee is 0
      expect(controller.deliveryFee, 0.0);

      // Subtotal < 150.000: fee is 15.000
      controller.addItem(foodA, quantity: 1); // 50.000
      expect(controller.subtotal, 50000.0);
      expect(controller.deliveryFee, 15000.0);
      expect(controller.totalPrice, 65000.0);

      // Subtotal >= 150.000: fee is free (0.0)
      controller.addItem(foodA, quantity: 2); // 150.000
      expect(controller.subtotal, 150000.0);
      expect(controller.deliveryFee, 0.0);
      expect(controller.totalPrice, 150000.0);
    });
  });
}

