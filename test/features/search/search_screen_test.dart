import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/features/search/screens/search_screen.dart';
import 'package:nhom_hung_khang_khanh_food/models/food.dart';
import 'package:nhom_hung_khang_khanh_food/state/cart_controller.dart';

void main() {
  group('SearchScreen Tests', () {
    final sampleFoods = [
      const Food(
        id: 'f1',
        name: 'Phở bò Hà Nội',
        price: 45000,
        description: 'Phở bò truyền thống thơm phức',
        category: 'Noodles',
        rating: 4.8,
      ),
      const Food(
        id: 'f2',
        name: 'Bún chả Sinh Từ',
        price: 50000,
        description: 'Bún chả nướng than hoa',
        category: 'Vietnamese',
        rating: 4.7,
      ),
      const Food(
        id: 'f3',
        name: 'Burger bò phô mai',
        price: 65000,
        description: 'Burger bò Úc đẫm phô mai',
        category: 'Fast food',
        rating: 4.5,
      ),
    ];

    testWidgets('Displays all foods when search query is empty', (tester) async {
      final cart = CartController.createInstance();
      await tester.pumpWidget(
        MaterialApp(
          home: SearchScreen(
            foodsStream: Stream.value(sampleFoods),
            cartController: cart,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Phở bò Hà Nội'), findsOneWidget);
      expect(find.text('Bún chả Sinh Từ'), findsOneWidget);
      expect(find.text('Burger bò phô mai'), findsOneWidget);
    });

    testWidgets('Filters foods matching search query in textfield', (tester) async {
      final cart = CartController.createInstance();
      await tester.pumpWidget(
        MaterialApp(
          home: SearchScreen(
            foodsStream: Stream.value(sampleFoods),
            cartController: cart,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter search term 'Phở'
      await tester.enterText(find.byType(TextField), 'Phở');
      await tester.pumpAndSettle();

      expect(find.text('Phở bò Hà Nội'), findsOneWidget);
      expect(find.text('Bún chả Sinh Từ'), findsNothing);
      expect(find.text('Burger bò phô mai'), findsNothing);
    });

    testWidgets('Shows empty state when no matching foods found', (tester) async {
      final cart = CartController.createInstance();
      await tester.pumpWidget(
        MaterialApp(
          home: SearchScreen(
            foodsStream: Stream.value(sampleFoods),
            cartController: cart,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Món không tồn tại');
      await tester.pumpAndSettle();

      expect(find.text('Không tìm thấy món ăn phù hợp'), findsOneWidget);
      expect(find.text('Đặt lại bộ lọc'), findsOneWidget);

      // Tap reset filter
      await tester.tap(find.text('Đặt lại bộ lọc'));
      await tester.pumpAndSettle();

      expect(find.text('Phở bò Hà Nội'), findsOneWidget);
    });

    testWidgets('Quick add to cart button adds food to cart', (tester) async {
      final cart = CartController.createInstance();
      await tester.pumpWidget(
        MaterialApp(
          home: SearchScreen(
            foodsStream: Stream.value(sampleFoods),
            cartController: cart,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap quick add button on the first food item
      final addButtons = find.byIcon(Icons.add_shopping_cart);
      expect(addButtons, findsWidgets);
      await tester.tap(addButtons.first);
      await tester.pump();

      expect(cart.totalItemCount, 1);
      expect(cart.hasItem('f1'), isTrue);
    });
  });
}

