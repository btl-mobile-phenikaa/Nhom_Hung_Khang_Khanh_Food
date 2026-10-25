import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/main.dart';

void main() {
  testWidgets('Food app shows main navigation destinations',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Recommended for you'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('bottom navigation opens cart page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Cart').last);
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty.'), findsOneWidget);
  });
}
