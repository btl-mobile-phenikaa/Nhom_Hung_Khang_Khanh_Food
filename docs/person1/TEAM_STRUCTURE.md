# Cấu trúc và quy ước làm việc của nhóm

## 1. Cấu trúc thư mục thống nhất

```text
lib/
  main.dart                         # Bootstrap: khởi tạo Firebase, chạy ứng dụng
  firebase_options.dart             # Cấu hình FlutterFire theo nền tảng
  app/
    app.dart                         # MaterialApp, theme và điểm vào điều hướng
    app_router.dart                  # Route names và ánh xạ route -> màn hình
  core/
    constants/
      firestore_collections.dart    # Tên collection dùng chung
    order_status.dart               # Giá trị trạng thái đơn chuẩn
    payment_methods.dart            # Phương thức thanh toán mô phỏng
    app_routes.dart                 # Tên route chuẩn
    formatters/
      currency_formatter.dart       # Hiển thị tiền VND
    widgets/                         # Widget dùng chung: loading, lỗi, nút...
  models/                            # Model và ánh xạ Firestore <-> Dart
    food.dart
    restaurant.dart
    user.dart
    cart_item.dart
    order.dart
  repositories/                      # Truy vấn/ghi Firestore, không chứa UI
    food_repository.dart
    restaurant_repository.dart
    user_repository.dart
    order_repository.dart
  services/                          # Tích hợp Firebase không thuộc repository
    auth_service.dart
  state/
    cart_controller.dart             # Giỏ hàng trong phiên sử dụng
  features/
    home/
      screens/home_screen.dart
      widgets/
    search/
      screens/search_screen.dart
      widgets/
    food_detail/
      screens/food_detail_screen.dart
      widgets/
    cart/
      screens/cart_screen.dart
      widgets/
    auth/
      screens/login_screen.dart
      screens/register_screen.dart
    profile/
      screens/profile_screen.dart
      screens/edit_profile_screen.dart
    checkout/
      screens/checkout_screen.dart
    orders/
      screens/order_history_screen.dart
      screens/order_detail_screen.dart
test/
  models/                            # Test model/ánh xạ dữ liệu
  repositories/                      # Test repository khi có emulator/mock
  features/                          # Test widget theo tính năng
docs/
  person1/                           # Kiến trúc, schema, Firebase, sơ đồ nhóm
```

Đây là cấu trúc đích. Hiện các model và repository đã nằm đúng thư mục; giao diện còn tập trung trong `lib/main.dart`. Tách màn hình từng phần sang `features/` khi thành viên bắt đầu làm phần đó, không cần di chuyển toàn bộ trong một lần.

## 2. Quy ước dữ liệu Firestore

| Collection | Document ID | Trường chuẩn |
|---|---|---|
| `users` | Firebase Auth UID | `name`, `phone`, `address`, `email`, `photoUrl`, `updatedAt` |
| `restaurants` | Firestore auto ID | `name`, `address`, `description`, `imageUrl`, `phone`, `rating`, `isOpen` |
| `foods` | Firestore auto ID | `name`, `price`, `description`, `category`, `restaurantId`, `imageUrl`, `isAvailable`, `rating` |
| `orders` | Firestore auto ID | `userId`, `items`, `totalPrice`, `createdAt`, `status`, `deliveryAddress`, `paymentMethod`, `note` |

- Tên field thống nhất theo `lowerCamelCase`; tên món luôn là `name` (số ít), không dùng `names`.
- `price`, `unitPrice`, `subtotal`, `totalPrice` là số VND, không lưu chuỗi có dấu phân cách.
- `isAvailable` và `isOpen` là boolean.
- `Order.items` là mảng snapshot gồm `foodId`, `foodName`, `unitPrice`, `quantity`, `imageUrl`; giá/name được chụp tại lúc đặt.
- `createdAt` dùng Firestore server timestamp. Trạng thái chuẩn: `pending`, `confirmed`, `preparing`, `delivering`, `completed`, `cancelled`.
- Giỏ hàng chỉ lưu trong state của ứng dụng, chưa tạo collection Firestore riêng.

## 3. Phân công sở hữu file

| Thành viên | Sở hữu chính | Trách nhiệm tích hợp |
|---|---|---|
| Người 1 | `models/`, `repositories/`, `core/`, `app/`, `docs/person1/` | Chốt schema/API repository, Firebase, điều hướng và tích hợp nhánh. Thống nhất thay đổi model trước khi các bạn sửa. |
| Người 2 | `features/home/`, `features/search/`, `features/food_detail/`, `features/cart/`, `state/cart_controller.dart` | Gọi `FoodRepository`, quản lý giỏ trong state, viết test tìm kiếm/giỏ và làm màn hình mẫu Câu 5 nếu cần. |
| Người 3 | `features/auth/`, `features/profile/`, `services/auth_service.dart` | Firebase Authentication, tạo/cập nhật hồ sơ qua `UserRepository`, trạng thái đăng nhập và lỗi tài khoản. |
| Người 4 | `features/checkout/`, `features/orders/` | Checkout/thanh toán mô phỏng, tạo đơn qua `OrderRepository`, lịch sử/trạng thái và test tích hợp. |

Mỗi người viết test cho phần mình phụ trách. Người 1 không tự ý đổi tên field/API repository sau khi các màn hình đã tích hợp; nếu cần đổi thì cập nhật model, tài liệu và báo nhóm cùng lúc.

## 4. Quy tắc điều hướng và tích hợp

Sơ đồ điều hướng tổng thể chi tiết nằm tại [NAVIGATION_DIAGRAM.md](NAVIGATION_DIAGRAM.md).

```text
Home -> Search -> Food detail -> Cart -> Checkout -> Order confirmation
  |                                      |                         |
  +-> Profile <-> Login/Register         +-------------------------+-> Order history -> Order detail
```

- `main.dart` chỉ khởi tạo Firebase và gọi `runApp`; không viết màn hình trong file này.
- `app/app.dart` giữ `MaterialApp`, theme và cấu hình router. Mỗi màn hình nằm trong feature tương ứng.
- Màn hình dùng repository/service; không gọi `FirebaseFirestore.instance` trực tiếp trong widget.
- Repository trả model, không trả widget hoặc định dạng chuỗi giao diện.
- Khi cần thay đổi collection, field hoặc chữ ký hàm repository, thành viên báo Người 1 để cập nhật hợp đồng dùng chung trước.
- Tích hợp bằng nhánh/commit nhỏ; chạy kiểm tra phần mình trước khi gộp. Không sửa file của thành viên khác nếu chưa trao đổi.

## 5. API dùng chung hiện có

- `FoodRepository`: `getAll`, `watchAll`, `getById`, `add`, `update`, `delete`.
- `RestaurantRepository`: `getAll`, `watchAll`, `getById`, `add`, `update`.
- `UserRepository`: `getById`, `watchById`, `save`, `updateProfile`.
- `OrderRepository`: `create`, `watchByUser`, `getById`.

Giữ các API này làm hợp đồng tích hợp hiện tại; nếu checkout hoặc giao diện cần thêm API, thống nhất chữ ký và quyền Firestore trước khi triển khai.
