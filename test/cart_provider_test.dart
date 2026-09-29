import 'package:flutter_test/flutter_test.dart';
import 'package:nhom_hung_khang_khanh_food/models/cart_item.dart';
import 'package:nhom_hung_khang_khanh_food/models/food.dart';
import 'package:nhom_hung_khang_khanh_food/providers/cart_provider.dart';
import 'package:nhom_hung_khang_khanh_food/utils/currency_format.dart';

Food food({int id = 10}) => Food(
  id: id,
  name: 'Món thử',
  price: 35000,
  description: 'Mô tả',
  category: 'Món chính',
);

void main() {
  test('Mock: 3 dòng, 4 phần, tạm tính 115000, tổng 130000', () {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    expect(cart.items.length, 3);
    expect(cart.items.map((item) => item.subtotal), [35000, 50000, 30000]);
    expect(cart.itemCount, 4);
    expect(cart.calculateTotal(), 115000);
    expect(cart.totalPrice, 115000);
    expect(cart.shippingFee, 15000);
    expect(cart.grandTotal, 130000);
  });

  test('Thêm trùng id gộp số lượng dù khác đối tượng Food', () {
    final cart = CartProvider(loadMockData: false);
    addTearDown(cart.dispose);
    cart.addFood(food());
    cart.addFood(food());
    expect(cart.items.length, 1);
    expect(cart.items.single.quantity, 2);
    expect(cart.subtotal, 70000);
    expect(cart.grandTotal, 85000);
  });

  test('Giảm về 0 xóa món và phí giao hàng', () {
    final cart = CartProvider(loadMockData: false);
    addTearDown(cart.dispose);
    cart.addFood(food());
    cart.increaseQuantity(food());
    cart.decreaseQuantity(food());
    expect(cart.items.single.quantity, 1);
    cart.decreaseQuantity(food());
    expect(cart.isEmpty, isTrue);
    expect(cart.shippingFee, 0);
    expect(cart.grandTotal, 0);
  });

  test('Xóa món xóa toàn bộ số lượng, clear đưa tổng về 0', () {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    cart.removeFood(cart.items[1].food);
    expect(cart.itemCount, 2);
    expect(cart.subtotal, 65000);
    cart.clearCart();
    expect(cart.items, isEmpty);
    expect(cart.grandTotal, 0);
  });

  test('Hoàn tác khôi phục số lượng và thứ tự', () {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    final removed = cart.items[1];
    cart.removeFood(removed.food);
    cart.restoreItem(removed, index: 1);
    expect(cart.items.map((item) => item.food.id), [1, 2, 3]);
    expect(cart.items[1].quantity, 2);
    expect(cart.grandTotal, 130000);
  });

  test('Hoàn tác khi món được thêm lại gộp số lượng', () {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    final removed = cart.items[1];
    cart.removeFood(removed.food);
    cart.addFood(removed.food);
    cart.restoreItem(removed, index: 1);
    expect(cart.items.length, 3);
    expect(cart.items.last.quantity, 3);
    expect(cart.grandTotal, 155000);
  });

  test(
    'Mỗi thay đổi thông báo một lần; thao tác không đổi không thông báo',
    () {
      final cart = CartProvider(loadMockData: false);
      addTearDown(cart.dispose);
      var notifications = 0;
      cart.addListener(() => notifications++);
      cart.removeFood(food());
      cart.increaseQuantity(food());
      cart.decreaseQuantity(food());
      cart.clearCart();
      expect(notifications, 0);
      cart.addFood(food());
      cart.increaseQuantity(food());
      cart.decreaseQuantity(food());
      final removed = cart.items.single;
      cart.removeFood(food());
      cart.restoreItem(removed);
      cart.clearCart();
      expect(notifications, 6);
    },
  );

  test('Danh sách không sửa trực tiếp được và không nhận SL <= 0', () {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    expect(() => cart.items.clear(), throwsUnsupportedError);
    expect(() => CartItem(food: food(), quantity: 0), throwsArgumentError);
    expect(() => CartItem(food: food(), quantity: -1), throwsArgumentError);
  });

  test('Tiền Việt Nam không có khoảng trắng hoặc số lẻ', () {
    expect(formatCurrency(35000), '35.000đ');
    expect(formatCurrency(130000), '130.000đ');
    expect(formatCurrency(0), '0đ');
  });
}
