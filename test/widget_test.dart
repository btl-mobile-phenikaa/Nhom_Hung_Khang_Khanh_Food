import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:nhom_hung_khang_khanh_food/main.dart';
import 'package:nhom_hung_khang_khanh_food/providers/cart_provider.dart';
import 'package:nhom_hung_khang_khanh_food/screens/cart_screen.dart';
import 'package:nhom_hung_khang_khanh_food/screens/checkout_placeholder_screen.dart';
import 'package:nhom_hung_khang_khanh_food/widgets/app_bottom_nav_bar.dart';
import 'package:nhom_hung_khang_khanh_food/widgets/cart_summary.dart';

Future<void> pumpFoodie(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

CartProvider cartOf(WidgetTester tester) =>
    tester.element(find.byType(CartScreen)).read<CartProvider>();

void main() {
  testWidgets('Mở tab Cart, dữ liệu mẫu và badge đúng', (tester) async {
    await pumpFoodie(tester);
    expect(find.text('Giỏ hàng'), findsOneWidget);
    expect(find.text('Phở bò đặc biệt'), findsOneWidget);
    expect(find.text('Bánh mì thịt nướng'), findsOneWidget);
    expect(find.text('Trà sữa trân châu'), findsOneWidget);
    final nav = tester.widget<AppBottomNavBar>(find.byType(AppBottomNavBar));
    expect(nav.currentIndex, 2);
    expect(nav.cartItemCount, 4);
    await tester.ensureVisible(find.byType(CartSummary));
    await tester.pumpAndSettle();
    expect(find.text('115.000đ'), findsOneWidget);
    expect(find.text('130.000đ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tăng giảm cập nhật tổng và badge', (tester) async {
    await pumpFoodie(tester);
    await tester.tap(find.byTooltip('Tăng Phở bò đặc biệt'));
    await tester.pumpAndSettle();
    expect(cartOf(tester).grandTotal, 165000);
    expect(
      tester
          .widget<AppBottomNavBar>(find.byType(AppBottomNavBar))
          .cartItemCount,
      5,
    );
    await tester.tap(find.byTooltip('Giảm Phở bò đặc biệt'));
    await tester.pumpAndSettle();
    expect(cartOf(tester).grandTotal, 130000);
  });

  testWidgets('Vuốt xóa và hoàn tác khôi phục SL 2, đúng vị trí', (
    tester,
  ) async {
    await pumpFoodie(tester);
    await tester.drag(
      find.byKey(const ValueKey('dismiss-food-2')),
      const Offset(-400, 0),
    );
    await tester.pumpAndSettle();
    expect(cartOf(tester).items.map((item) => item.food.id), [1, 3]);
    expect(cartOf(tester).grandTotal, 80000);
    await tester.tap(find.text('Hoàn tác'));
    await tester.pumpAndSettle();
    expect(cartOf(tester).items.map((item) => item.food.id), [1, 2, 3]);
    expect(cartOf(tester).items[1].quantity, 2);
    expect(cartOf(tester).grandTotal, 130000);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Nút xóa và giảm về 0 đều hỗ trợ hoàn tác', (tester) async {
    await pumpFoodie(tester);
    await tester.tap(find.byTooltip('Xóa Bánh mì thịt nướng'));
    await tester.pumpAndSettle();
    expect(cartOf(tester).itemCount, 2);
    await tester.tap(find.text('Hoàn tác'));
    await tester.pumpAndSettle();
    expect(cartOf(tester).itemCount, 4);
    await tester.tap(find.byTooltip('Giảm Phở bò đặc biệt'));
    await tester.pumpAndSettle();
    expect(cartOf(tester).items.map((item) => item.food.id), [2, 3]);
    await tester.tap(find.text('Hoàn tác'));
    await tester.pumpAndSettle();
    expect(cartOf(tester).grandTotal, 130000);
  });

  testWidgets('Xóa tất cả cần xác nhận, giỏ trống khám phá về Home', (
    tester,
  ) async {
    await pumpFoodie(tester);
    await tester.tap(find.byTooltip('Xóa toàn bộ giỏ hàng'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(cartOf(tester).itemCount, 4);
    await tester.tap(find.byTooltip('Xóa toàn bộ giỏ hàng'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xóa tất cả'));
    await tester.pumpAndSettle();
    expect(find.text('Giỏ hàng của bạn đang trống'), findsOneWidget);
    expect(cartOf(tester).grandTotal, 0);
    final checkout = find.widgetWithText(FilledButton, 'Thanh toán');
    await tester.ensureVisible(checkout);
    expect(tester.widget<FilledButton>(checkout).onPressed, isNull);
    final explore = find.text('Khám phá món ăn');
    await tester.ensureVisible(explore);
    await tester.tap(explore);
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppBottomNavBar>(find.byType(AppBottomNavBar)).currentIndex,
      0,
    );
  });

  testWidgets('Thanh toán đọc cùng Provider và quay lại giữ giỏ', (
    tester,
  ) async {
    await pumpFoodie(tester);
    final cart = cartOf(tester);
    final checkout = find.widgetWithText(FilledButton, 'Thanh toán');
    await tester.ensureVisible(checkout);
    await tester.pumpAndSettle();
    await tester.tap(checkout);
    await tester.pumpAndSettle();
    expect(find.byType(CheckoutPlaceholderScreen), findsOneWidget);
    expect(find.text('Tổng cộng: 130.000đ'), findsOneWidget);
    expect(
      tester
          .element(find.byType(CheckoutPlaceholderScreen))
          .read<CartProvider>(),
      same(cart),
    );
    await tester.tap(find.text('Quay lại giỏ hàng'));
    await tester.pumpAndSettle();
    expect(cartOf(tester).grandTotal, 130000);
  });

  testWidgets('Chuyển đủ bốn tab và giữ số lượng', (tester) async {
    await pumpFoodie(tester);
    await tester.tap(find.byTooltip('Tăng Phở bò đặc biệt'));
    await tester.pumpAndSettle();
    for (final entry in {
      0: 'Home',
      1: 'Search',
      3: 'Profile',
      2: 'Cart',
    }.entries) {
      await tester.tap(find.byType(NavigationDestination).at(entry.key));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<AppBottomNavBar>(find.byType(AppBottomNavBar))
            .currentIndex,
        entry.key,
      );
    }
    expect(cartOf(tester).itemCount, 5);
    expect(tester.takeException(), isNull);
  });

  for (final size in [const Size(320, 568), const Size(568, 320)]) {
    testWidgets('Không overflow trên $size với cỡ chữ 1.5', (tester) async {
      await pumpFoodie(tester);
      tester.view.physicalSize = size;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.widgetWithText(FilledButton, 'Thanh toán'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Xóa toàn bộ giỏ hàng'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xóa tất cả'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Khám phá món ăn'),
        -100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
