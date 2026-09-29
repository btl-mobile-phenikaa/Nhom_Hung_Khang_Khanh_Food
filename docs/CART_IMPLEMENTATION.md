# Foodie — Giỏ hàng

Flutter Material 3, Provider và dữ liệu mẫu, không gọi backend.

## Chạy ứng dụng

```sh
flutter pub get
flutter run
```

Môi trường đã kiểm tra: Flutter 3.47.2 stable, Dart 3.13.2. Dự án yêu cầu
Dart `^3.13.0`. Chỉ thêm hai package runtime:
[provider](https://pub.dev/packages/provider) và [intl](https://pub.dev/packages/intl).

Ứng dụng mở tab Cart. Dữ liệu demo: phở bò 1 phần, bánh mì 2 phần, trà sữa 1 phần;
tạm tính **115.000đ**, phí giao hàng **15.000đ**, tổng **130.000đ**.
Badge hiển thị **4** (tổng số phần, không phải số dòng món).

## Ghép code của nhóm

- Giữ `ChangeNotifierProvider<CartProvider>` phía trên `MaterialApp` để các tab
  và route thanh toán dùng cùng giỏ hàng.
- Nút “Thêm vào giỏ” ở màn chi tiết món:

  ```dart
  context.read<CartProvider>().addFood(food);
  ```

  Màn gọi cần import `package:provider/provider.dart` và `cart_provider.dart`.
- Màn thanh toán đọc `context.watch<CartProvider>()` để lấy `items`, `subtotal`,
  `shippingFee`, `grandTotal`. Thay `CheckoutPlaceholderScreen` bằng màn thật.
  Màn tạm không tạo đơn hoặc xóa giỏ.
- Thay ba placeholder Home, Search, Profile trong `MainShell` bằng màn của nhóm.
  Shell sở hữu `Scaffold`, `SafeArea`, `IndexedStack` và thanh điều hướng;
  `CartScreen` cung cấp nội dung `Column` để tránh lặp thanh điều hướng.
- `AppBottomNavBar(currentIndex: ..., onTap: ..., cartItemCount: ...)` không
  phụ thuộc Provider. Shell truyền `cart.itemCount` vào `cartItemCount`.
- Để bắt đầu với giỏ trống: `CartProvider(loadMockData: false)`.
- Thêm ảnh thật tại `assets/images/group.jpg`; thiếu ảnh sẽ hiện placeholder xám.
  Thư mục assets đã có `README.txt` nên build được khi chưa có ảnh.
- Thay `[TÊN SINH VIÊN]` trong `lib/screens/cart_screen.dart` bằng tên của bạn.
- `Food` giữ nguyên API hiện có (`setFood`, `getFoodName`, `getPrice`,
  `getFoodInfo`). Cập nhật số lượng qua Provider, không sửa trực tiếp `items`.
  Các món được nhận diện bằng `Food.id`; nhóm cần dùng id duy nhất, ổn định.

## Hành vi giỏ hàng

- Thêm món trùng id tăng số lượng; giảm từ 1 về 0 sẽ xóa món.
- Vuốt hai chiều, nút thùng rác và giảm về 0 đều hỗ trợ hoàn tác.
  Hoàn tác khôi phục số lượng và vị trí, hoặc gộp nếu món đã được thêm lại.
- Xóa toàn bộ có hộp thoại xác nhận.
- Giỏ trống có phí giao hàng bằng 0, nút thanh toán bị vô hiệu hóa;
  “Khám phá món ăn” chuyển về Home.
- Dữ liệu chỉ ở bộ nhớ, được nạp lại khi khởi động lại ứng dụng.

## Kiểm tra

```sh
dart analyze lib test
flutter test
flutter build web --release
```

18 kiểm thử bao gồm tổng tiền, gộp món, xóa, hoàn tác, thông báo Provider,
badge, điều hướng thanh toán, trạng thái trống và màn hình nhỏ/ngang với chữ lớn.
`flutter analyze` trên SDK tại máy này gặp lỗi giao tiếp LSP (`FormatException`);
`dart analyze lib test` là lệnh thay thế đã chạy thành công.


## Mã nguồn đầy đủ

### `pubspec.yaml`

```yaml
name: nhom_hung_khang_khanh_food
description: "Foodie - Giỏ hàng đặt đồ ăn của nhóm."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.13.0

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1
  intl: ^0.20.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

### `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/cart_screen.dart';
import 'widgets/app_bottom_nav_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3D3D3D);
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Foodie',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primary,
            primary: primary,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: const Color(0xFF242424),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: primary,
            surfaceTintColor: Colors.transparent,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            indicatorColor: const Color(0xFFEAEAEA),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              return TextStyle(
                color: primary,
                fontSize: 12,
                fontWeight: states.contains(WidgetState.selected)
                    ? FontWeight.w700
                    : FontWeight.w400,
              );
            }),
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: primary,
            actionTextColor: Colors.white,
          ),
        ),
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 2;

  void _selectTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartProvider, int>((cart) => cart.itemCount);

    // Shell sở hữu thanh điều hướng; mỗi tab chỉ cung cấp phần nội dung.
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            const Center(child: Text('Home')),
            const Center(child: Text('Search')),
            CartScreen(onExploreFood: () => _selectTab(0)),
            const Center(child: Text('Profile')),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _selectTab,
        cartItemCount: count,
      ),
    );
  }
}
```

### `lib/models/food.dart`

```dart
class Food {
  int id;
  String name;
  double price;
  String description;
  String category;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
  });

  void setFood(
    int id,
    String name,
    double price,
    String description,
    String category,
  ) {
    this.id = id;
    this.name = name;
    this.price = price;
    this.description = description;
    this.category = category;
  }

  String getFoodName() {
    return name;
  }

  double getPrice() {
    return price;
  }

  String getFoodInfo() {
    return 'ID: $id\n'
        'Tên món: $name\n'
        'Giá: $price VNĐ\n'
        'Mô tả: $description\n'
        'Danh mục: $category';
  }
}
```

### `lib/models/cart_item.dart`

```dart
import 'food.dart';

class CartItem {
  CartItem({required this.food, this.quantity = 1}) {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'Phải lớn hơn 0');
    }
  }

  final Food food;
  final int quantity;

  double get subtotal => food.price * quantity;
}
```

### `lib/providers/cart_provider.dart`

```dart
import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/food.dart';

class CartProvider extends ChangeNotifier {
  CartProvider({this.id = 1, bool loadMockData = true}) {
    if (loadMockData) {
      _items.addAll([
        CartItem(
          food: Food(
            id: 1,
            name: 'Phở bò đặc biệt',
            price: 35000,
            description: 'Phở bò với nước dùng đậm đà.',
            category: 'Món chính',
          ),
        ),
        CartItem(
          food: Food(
            id: 2,
            name: 'Bánh mì thịt nướng',
            price: 25000,
            description: 'Bánh mì giòn với thịt nướng và rau tươi.',
            category: 'Món chính',
          ),
          quantity: 2,
        ),
        CartItem(
          food: Food(
            id: 3,
            name: 'Trà sữa trân châu',
            price: 30000,
            description: 'Trà sữa kèm trân châu dai mềm.',
            category: 'Đồ uống',
          ),
        ),
      ]);
    }
  }

  final int id;
  final List<CartItem> _items = [];

  // Ngăn màn hình tự thay đổi danh sách hoặc số lượng ngoài Provider.
  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (count, item) => count + item.quantity);
  double get totalPrice => calculateTotal();
  double get subtotal => totalPrice;
  double get shippingFee => isEmpty ? 0 : 15000;
  double get grandTotal => subtotal + shippingFee;

  double calculateTotal() =>
      _items.fold(0.0, (total, item) => total + item.subtotal);

  int _indexOf(Food food) =>
      _items.indexWhere((item) => item.food.id == food.id);

  void addFood(Food food) {
    final index = _indexOf(food);
    if (index == -1) {
      _items.add(CartItem(food: food));
    } else {
      final item = _items[index];
      _items[index] = CartItem(food: item.food, quantity: item.quantity + 1);
    }
    notifyListeners();
  }

  void removeFood(Food food) {
    final index = _indexOf(food);
    if (index == -1) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void increaseQuantity(Food food) {
    if (_indexOf(food) == -1) return;
    addFood(food);
  }

  void decreaseQuantity(Food food) {
    final index = _indexOf(food);
    if (index == -1) return;
    final item = _items[index];
    if (item.quantity == 1) {
      _items.removeAt(index);
    } else {
      _items[index] = CartItem(food: item.food, quantity: item.quantity - 1);
    }
    notifyListeners();
  }

  void clearCart() {
    if (isEmpty) return;
    _items.clear();
    notifyListeners();
  }

  // Hoàn tác khôi phục cả số lượng và vị trí món vừa xóa.
  void restoreItem(CartItem item, {int? index}) {
    final existing = _indexOf(item.food);
    if (existing == -1) {
      final position = (index ?? _items.length).clamp(0, _items.length);
      _items.insert(position, item);
    } else {
      final current = _items[existing];
      _items[existing] = CartItem(
        food: current.food,
        quantity: current.quantity + item.quantity,
      );
    }
    notifyListeners();
  }
}
```

### `lib/screens/cart_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';
import '../widgets/empty_cart_view.dart';
import 'checkout_placeholder_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.onExploreFood});

  final VoidCallback onExploreFood;

  void _removeItem(BuildContext context, CartItem item) {
    final cart = context.read<CartProvider>();
    final index = cart.items.indexWhere(
      (entry) => entry.food.id == item.food.id,
    );
    cart.removeFood(item.food);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Đã xóa ${item.food.name}'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () => cart.restoreItem(item, index: index),
        ),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa toàn bộ giỏ hàng?'),
        content: const Text('Tất cả món ăn sẽ được xóa khỏi giỏ hàng.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    context.read<CartProvider>().clearCart();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/group.jpg',
                width: double.infinity,
                height: (constraints.maxHeight * 0.15).clamp(48.0, 96.0),
                fit: BoxFit.cover,
                semanticLabel: 'Ảnh nhóm sinh viên',
                errorBuilder: (_, _, _) => Container(
                  height: (constraints.maxHeight * 0.15).clamp(48.0, 96.0),
                  color: const Color(0xFFE6E6E6),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.groups_outlined,
                    size: 40,
                    color: Color(0xFF888888),
                    semanticLabel: 'Ảnh nhóm sinh viên',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const SizedBox(width: 48),
                const Expanded(
                  child: Text(
                    'Giỏ hàng',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: 'Xóa toàn bộ giỏ hàng',
                  onPressed: cart.isEmpty ? null : () => _confirmClear(context),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              children: [
                if (cart.isEmpty)
                  EmptyCartView(onExploreFood: onExploreFood)
                else
                  for (final item in items)
                    Padding(
                      key: ValueKey(item.food.id),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CartItemTile(
                        item: item,
                        onIncrease: () => cart.increaseQuantity(item.food),
                        onDecrease: () {
                          if (item.quantity == 1) {
                            _removeItem(context, item);
                          } else {
                            cart.decreaseQuantity(item.food);
                          }
                        },
                        onRemove: () => _removeItem(context, item),
                      ),
                    ),
                const SizedBox(height: 12),
                CartSummary(
                  subtotal: cart.subtotal,
                  shippingFee: cart.shippingFee,
                  grandTotal: cart.grandTotal,
                  onCheckout: cart.isEmpty
                      ? null
                      : () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const CheckoutPlaceholderScreen(),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              'Phenikaa University - Nguyễn Chí Tài',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Color(0xFF777777)),
            ),
          ),
        ],
      ),
    );
  }
}
```

### `lib/screens/checkout_placeholder_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/currency_format.dart';

class CheckoutPlaceholderScreen extends StatelessWidget {
  const CheckoutPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider nằm trên MaterialApp nên dùng chung được giữa các route.
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(Icons.receipt_long_outlined, size: 64),
            const SizedBox(height: 20),
            const Text(
              'Màn hình thanh toán đang được phát triển',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            for (final item in cart.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '${item.food.name} × ${item.quantity} — '
                  '${formatCurrency(item.subtotal)}',
                ),
              ),
            const Divider(),
            Text('Phí giao hàng: ${formatCurrency(cart.shippingFee)}'),
            const SizedBox(height: 12),
            Text(
              'Tổng cộng: ${formatCurrency(cart.grandTotal)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Quay lại giỏ hàng'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### `lib/widgets/app_bottom_nav_bar.dart`

```dart
import 'package:flutter/material.dart';

/// Dùng chung: Shell truyền số lượng từ Provider, widget không xử lý giỏ hàng.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartItemCount = 0,
  }) : assert(currentIndex >= 0 && currentIndex < 4),
       assert(cartItemCount >= 0);

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartItemCount;

  Widget _cartIcon(IconData icon) => Badge.count(
    count: cartItemCount,
    isLabelVisible: cartItemCount > 0,
    backgroundColor: const Color(0xFF3D3D3D),
    textColor: Colors.white,
    child: Icon(icon),
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: NavigationBar(
        height: 72,
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search, weight: 700),
            label: 'Search',
          ),
          NavigationDestination(
            icon: _cartIcon(Icons.shopping_cart_outlined),
            selectedIcon: _cartIcon(Icons.shopping_cart),
            label: 'Cart',
            tooltip: 'Cart, $cartItemCount món',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

### `lib/widgets/cart_item_tile.dart`

```dart
import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../utils/currency_format.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  Widget _deleteBackground(Alignment alignment) => Container(
    alignment: alignment,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: const Color(0xFF3D3D3D),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(Icons.delete_outline, color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('dismiss-food-${item.food.id}'),
      direction: DismissDirection.horizontal,
      background: _deleteBackground(Alignment.centerLeft),
      secondaryBackground: _deleteBackground(Alignment.centerRight),
      onDismissed: (_) => onRemove(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.image_outlined,
                color: Color(0xFF888888),
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.food.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Xóa ${item.food.name}',
                        onPressed: onRemove,
                        style: IconButton.styleFrom(
                          minimumSize: const Size(40, 40),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.delete_outline, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Tự xuống dòng trên màn hình hẹp hoặc khi tăng cỡ chữ.
                  LayoutBuilder(
                    builder: (context, constraints) => Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _QuantityButton(
                              icon: Icons.remove,
                              tooltip: 'Giảm ${item.food.name}',
                              onPressed: onDecrease,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                '${item.quantity}',
                                semanticsLabel: 'Số lượng ${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            _QuantityButton(
                              icon: Icons.add,
                              tooltip: 'Tăng ${item.food.name}',
                              onPressed: onIncrease,
                            ),
                          ],
                        ),
                        SizedBox(
                          width:
                              constraints.maxWidth < 240 ||
                                  MediaQuery.textScalerOf(context).scale(14) >
                                      18
                              ? constraints.maxWidth
                              : null,
                          child: Text(
                            formatCurrency(item.subtotal),
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: Icon(icon, size: 18),
    style: IconButton.styleFrom(
      backgroundColor: const Color(0xFFF2F2F2),
      foregroundColor: const Color(0xFF3D3D3D),
      minimumSize: const Size(40, 40),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
```

### `lib/widgets/cart_summary.dart`

```dart
import 'package:flutter/material.dart';

import '../utils/currency_format.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.grandTotal,
    required this.onCheckout,
  });

  final double subtotal;
  final double shippingFee;
  final double grandTotal;
  // Truyền null để vô hiệu hóa thanh toán khi giỏ trống.
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryRow(label: 'Tạm tính', amount: subtotal),
        const SizedBox(height: 12),
        _SummaryRow(label: 'Phí giao hàng', amount: shippingFee),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(color: Color(0xFFE0E0E0)),
        ),
        _SummaryRow(label: 'Tổng cộng', amount: grandTotal, bold: true),
        const SizedBox(height: 20),
        FilledButton(onPressed: onCheckout, child: const Text('Thanh toán')),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    this.bold = false,
  });

  final String label;
  final double amount;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 18 : 15,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: style)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            formatCurrency(amount),
            textAlign: TextAlign.right,
            style: style,
          ),
        ),
      ],
    );
  }
}
```

### `lib/widgets/empty_cart_view.dart`

```dart
import 'package:flutter/material.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key, required this.onExploreFood});

  final VoidCallback onExploreFood;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
    child: Column(
      children: [
        const Icon(
          Icons.shopping_cart_outlined,
          size: 72,
          color: Color(0xFF888888),
        ),
        const SizedBox(height: 16),
        const Text(
          'Giỏ hàng của bạn đang trống',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onExploreFood,
          child: const Text('Khám phá món ăn'),
        ),
      ],
    ),
  );
}
```

### `lib/utils/currency_format.dart`

```dart
import 'package:intl/intl.dart';

final _vietnameseNumberFormat = NumberFormat('#,##0', 'vi_VN');

String formatCurrency(num amount) =>
    '${_vietnameseNumberFormat.format(amount)}đ';
```

### `assets/images/README.txt`

```text
Đặt ảnh thật của nhóm tại assets/images/group.jpg.
Nếu chưa có ảnh, ứng dụng hiển thị placeholder xám qua errorBuilder.
Tệp này giữ thư mục assets hợp lệ ngay cả khi chưa có group.jpg.
```

### `test/cart_provider_test.dart`

```dart
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
```

### `test/widget_test.dart`

```dart
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
```
