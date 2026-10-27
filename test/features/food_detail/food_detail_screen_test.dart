import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/features/food_detail/screens/food_detail_screen.dart';
import 'package:nhom_hung_khang_khanh_food/models/food.dart';
import 'package:nhom_hung_khang_khanh_food/state/cart_controller.dart';

void main() {
  group('FoodDetailScreen Tests', () {
    final sampleFood = const Food(
      id: 'f-101',
      name: 'Cơm tấm sườn bì chả',
      price: 55000,
      description: 'Cơm tấm sườn nướng mỡ hành đậm vị Sài Gòn',
      category: 'Vietnamese',
      rating: 4.9,
    );

    testWidgets('Displays food details properly', (tester) async {
      final cart = CartController.createInstance();
      await tester.pumpWidget(
        MaterialApp(
          home: FoodDetailScreen(
            food: sampleFood,
            cartController: cart,
          ),
        ),
      );

      expect(find.text('Cơm tấm sườn bì chả'), findsWidgets);
      expect(find.text('55000 VNĐ'), findsWidgets);
      expect(find.text('Vietnamese'), findsOneWidget);
      expect(find.text('4.9'), findsOneWidget);
      expect(find.text('Cơm tấm sườn nướng mỡ hành đậm vị Sài Gòn'), findsOneWidget);
      expect(find.text('Thêm vào giỏ'), findsOneWidget);
    });

    testWidgets('Increases and decreases quantity before adding to cart', (tester) async {
      final cart = CartController.createInstance();
      await tester.pumpWidget(
        MaterialApp(
          home: FoodDetailScreen(
            food: sampleFood,
            cartController: cart,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to make sure quantity row is fully visible
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Initial quantity is 1
      expect(find.text('1'), findsOneWidget);

      // Tap + button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Tap + button again
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('3'), findsOneWidget);

      // Tap - button
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Tap "Thêm vào giỏ"
      await tester.tap(find.text('Thêm vào giỏ'));
      await tester.pump();

      expect(cart.totalItemCount, 2);
      expect(cart.subtotal, 110000.0);
    });

    testWidgets('Selecting topping updates price and adds topping to cart item', (tester) async {
      final cart = CartController.createInstance();
      const bunCha = Food(
        id: 'f-buncha',
        name: 'Bún chả que tre',
        price: 50000,
        description: 'Bún chả truyền thống',
        category: 'Vietnamese',
        rating: 4.8,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: FoodDetailScreen(
            food: bunCha,
            cartController: cart,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to topping "Thêm quẩy giòn" (+5000 VNĐ) and select it
      final quayFinder = find.text('Thêm quẩy giòn');
      await tester.ensureVisible(quayFinder);
      await tester.pumpAndSettle();
      await tester.tap(quayFinder);
      await tester.pump();

      // Tap "Thêm vào giỏ"
      await tester.tap(find.text('Thêm vào giỏ'));
      await tester.pump();

      expect(cart.totalItemCount, 1);
      expect(cart.subtotal, 55000.0);
      expect(cart.items.first.food.price, 55000.0);
      expect(cart.items.first.food.name, contains('Thêm quẩy giòn'));
    });
  });
}
