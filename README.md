    # Food Delivery App

## Wireframe
-wire frame home
![Wireframe](wireframe-home.jpg)


## Màn hình Giỏ hàng — Nguyễn Chí Tài


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

## Bản mã để chia sẻ

`docs/CART_IMPLEMENTATION.md` chứa `pubspec.yaml` và toàn bộ các tệp phần Cart,
mỗi tệp trong một khối mã riêng có đường dẫn, cùng các điểm tích hợp của nhóm.
