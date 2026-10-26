import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/main.dart';
import 'package:nhom_hung_khang_khanh_food/models/food.dart';

Stream<List<Food>> _emptyFoods() => Stream.value(const []);

void main() {
  testWidgets('Food app shows main navigation destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(foodsStream: _emptyFoods()));

    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Recommended for you'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Chưa có món ăn nào trong Firestore.'), findsOneWidget);
  });

  testWidgets('bottom navigation opens cart page', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(foodsStream: _emptyFoods()));
    await tester.tap(find.text('Cart').last);
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty.'), findsOneWidget);
  });

  testWidgets('HomeScreen displays foods from its stream', (
    WidgetTester tester,
  ) async {
    final food = Food(
      id: 'food-1',
      name: 'Phở bò',
      price: 45000,
      description: 'Phở bò truyền thống',
      category: 'Món nước',
      rating: 4.5,
    );

    await tester.pumpWidget(MyApp(foodsStream: Stream.value([food])));
    await tester.pumpAndSettle();

    expect(find.text('Phở bò'), findsOneWidget);
    expect(find.text('45000 VNĐ'), findsOneWidget);
  });
}
