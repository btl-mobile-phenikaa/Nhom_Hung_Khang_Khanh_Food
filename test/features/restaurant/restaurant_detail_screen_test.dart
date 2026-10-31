import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/core/data/sample_food_catalog.dart';
import 'package:nhom_hung_khang_khanh_food/features/restaurant/screens/restaurant_detail_screen.dart';
import 'package:nhom_hung_khang_khanh_food/models/food.dart';
import 'package:nhom_hung_khang_khanh_food/models/restaurant.dart';
import 'package:nhom_hung_khang_khanh_food/state/cart_controller.dart';

void main() {
  group('User Stories 13 - 16 Verification Tests', () {
    const testRestaurant = Restaurant(
      id: 'res_test',
      name: 'Quán Ăn Hoàng Gia',
      address: '88 Phố Huế, Hai Bà Trưng, Hà Nội',
      phone: '0988.123.456',
      rating: 4.9,
      isOpen: true,
      imageUrl: '',
    );

    final testFoods = [
      const Food(
        id: 'food_1',
        name: 'Phở Bò Tái Lăn',
        price: 50000,
        description: 'Thịt bò xào lăn thơm phức nước gừng tỏi',
        category: 'Noodles',
        restaurantId: 'res_test',
      ),
      const Food(
        id: 'food_2',
        name: 'Cơm Rang Dưa Bò',
        price: 55000,
        description: 'Cơm rang vàng giòn cùng thịt bò mềm và dưa chua',
        category: 'Vietnamese',
        restaurantId: 'res_test',
      ),
    ];

    testWidgets('US13: RestaurantDetailScreen renders restaurant info and dishes',
        (tester) async {
      final cartController = CartController();

      await tester.pumpWidget(
        MaterialApp(
          home: RestaurantDetailScreen(
            restaurant: testRestaurant,
            cartController: cartController,
            foodsStream: Stream.value(testFoods),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Kiểm tra tên và thông tin quán
      expect(find.text('Quán Ăn Hoàng Gia'), findsOneWidget);
      expect(find.text('Đang mở cửa • Giao ngay'), findsOneWidget);
      expect(find.text('0988.123.456'), findsOneWidget);

      // Kiểm tra danh sách món ăn thời gian thực
      expect(find.text('Phở Bò Tái Lăn'), findsOneWidget);
      expect(find.text('Cơm Rang Dưa Bò'), findsOneWidget);
    });

    testWidgets('US13: Searching within restaurant filters the dish list',
        (tester) async {
      final cartController = CartController();

      await tester.pumpWidget(
        MaterialApp(
          home: RestaurantDetailScreen(
            restaurant: testRestaurant,
            cartController: cartController,
            foodsStream: Stream.value(testFoods),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Nhập từ khóa tìm kiếm
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'Phở');
      await tester.pumpAndSettle();

      // Kết quả lọc
      expect(find.text('Phở Bò Tái Lăn'), findsOneWidget);
      expect(find.text('Cơm Rang Dưa Bò'), findsNothing);
    });

    testWidgets('US13: Adding item from restaurant screen updates CartController',
        (tester) async {
      final cartController = CartController();

      await tester.pumpWidget(
        MaterialApp(
          home: RestaurantDetailScreen(
            restaurant: testRestaurant,
            cartController: cartController,
            foodsStream: Stream.value(testFoods),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(cartController.totalQuantity, 0);

      // Bấm nút thêm món đầu tiên
      final addButtons = find.byIcon(Icons.add);
      expect(addButtons, findsWidgets);
      await tester.tap(addButtons.first);
      await tester.pumpAndSettle();

      expect(cartController.totalQuantity, 1);
      expect(find.text('Xem giỏ hàng'), findsOneWidget);
    });

    test('US15: SampleFoodCatalog.seedAllData prepares all default foods and restaurants',
        () async {
      final result = await SampleFoodCatalog.seedAllData();
      expect(result.foodsCount, 20);
      expect(result.restaurantsCount, 3);
    });

    test('US16: firestore.rules exists and enforces strict security policies', () {
      final rulesFile = File('firestore.rules');
      expect(rulesFile.existsSync(), isTrue, reason: 'firestore.rules file must exist');

      final content = rulesFile.readAsStringSync();
      expect(content, contains('rules_version = \'2\';'));
      expect(content, contains('match /users/{userId}'));
      expect(content, contains('request.auth.uid == userId'));
      expect(content, contains('match /restaurants/{restaurantId}'));
      expect(content, contains('match /foods/{foodId}'));
      expect(content, contains('match /orders/{orderId}'));
      expect(content, contains('allow create: if request.auth != null'));
    });
  });
}
