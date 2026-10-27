import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/features/cart/screens/cart_screen.dart';
import 'package:nhom_hung_khang_khanh_food/models/food.dart';
import 'package:nhom_hung_khang_khanh_food/state/cart_controller.dart';

void main() {
  group('CartScreen Tests', () {
    final food1 = const Food(
      id: 'f-1',
      name: 'Trà sữa trân châu',
      price: 35000,
      description: 'Trà sữa thơm béo',
      category: 'Drinks',
    );

    testWidgets('Displays empty cart state with message and explore button', (tester) async {
      final cart = CartController.createInstance();
      var explored = false;

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(
            cartController: cart,
            onExploreFoods: () => explored = true,
          ),
        ),
      );

      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Khám phá món ngon'), findsOneWidget);

      await tester.tap(find.text('Khám phá món ngon'));
      expect(explored, isTrue);
    });

    testWidgets('Displays items in cart with order summary and handles quantity changes', (tester) async {
      final cart = CartController.createInstance();
      cart.addItem(food1, quantity: 2);

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cartController: cart),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Trà sữa trân châu'), findsOneWidget);
      expect(find.text('35000 VNĐ'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Đặt hàng'), findsOneWidget);

      // Tap + button to increase quantity
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(cart.getQuantity('f-1'), 3);
      expect(find.text('3'), findsOneWidget);

      // Tap - button to decrease quantity
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(cart.getQuantity('f-1'), 2);
    });

    testWidgets('Remove item and clear cart functionality', (tester) async {
      final cart = CartController.createInstance();
      cart.addItem(food1, quantity: 1);

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cartController: cart),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Trà sữa trân châu'), findsOneWidget);

      // Tap clear all icon in app bar
      await tester.tap(find.byTooltip('Xóa giỏ hàng'));
      await tester.pumpAndSettle();

      expect(find.text('Xóa giỏ hàng?'), findsOneWidget);
      await tester.tap(find.text('Xóa hết'));
      await tester.pumpAndSettle();

      expect(cart.isEmpty, isTrue);
      expect(find.text('Your cart is empty.'), findsOneWidget);
    });

    testWidgets('Displays dynamic store origin address and allows changing delivery address', (tester) async {
      final cart = CartController.createInstance();
      const phoFood = Food(
        id: 'pho-1',
        name: 'Phở bò tái nạm',
        price: 55000,
        description: 'Nước dùng ngọt thanh',
        category: 'Noodle',
      );
      cart.addItem(phoFood, quantity: 1);

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cartController: cart),
        ),
      );
      await tester.pumpAndSettle();

      // Shows dynamic store name and address for Phở (Noodle)
      expect(find.textContaining('Phở Thìn Bờ Hồ'), findsOneWidget);
      expect(find.text('Từ quán: 13 Lò Đúc, Quận Hai Bà Trưng, Hà Nội'), findsOneWidget);
      expect(find.text('Giao đến: 144 Xuân Thủy, Cầu Giấy, Hà Nội'), findsOneWidget);

      // Tap 'Thay đổi' button to change delivery address
      await tester.tap(find.text('Thay đổi'));
      await tester.pumpAndSettle();

      expect(find.text('Thay đổi địa chỉ nhận hàng'), findsOneWidget);

      // Select saved address or enter custom address
      await tester.enterText(
        find.byType(TextField),
        'Số 99 Nguyễn Chí Thanh, Đống Đa, Hà Nội',
      );
      await tester.tap(find.text('Lưu địa chỉ'));
      await tester.pumpAndSettle();

      expect(
        find.text('Giao đến: Số 99 Nguyễn Chí Thanh, Đống Đa, Hà Nội'),
        findsOneWidget,
      );
      expect(cart.deliveryAddress, 'Số 99 Nguyễn Chí Thanh, Đống Đa, Hà Nội');
    });
  });
}

