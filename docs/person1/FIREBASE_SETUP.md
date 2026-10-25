# Hướng dẫn Firebase cho nhóm

## Trạng thái kiểm tra từ source ZIP

- `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` đã được khai báo trong `pubspec.yaml`.
- `lib/firebase_options.dart` đã tồn tại và có cấu hình cho Web, Android, iOS, macOS, Windows.
- `android/app/google-services.json` có trong project ZIP.
- Code ban đầu chưa gọi `Firebase.initializeApp()` trong `main()`; bản cập nhật thêm bước khởi tạo trước khi chạy ứng dụng.

## Các bước cần kiểm tra trên Firebase Console

1. Mở Firebase Console và chọn project `khanhdeptrai-71a05` (nếu đây là project đúng của nhóm).
2. Vào **Authentication → Sign-in method**, bật Email/Password nếu nhóm dùng email/mật khẩu.
3. Vào **Firestore Database** và tạo database nếu chưa có.
4. Kiểm tra ứng dụng Android/Web đang dùng đúng Firebase project và package/bundle ID.
5. Thiết lập Firestore Security Rules trước khi demo; không dùng rule cho phép mọi người đọc/ghi dữ liệu.
6. Nếu dùng ảnh upload, kiểm tra Firebase Storage và rules tương ứng. Nếu chỉ dùng URL ảnh công khai, Storage chưa bắt buộc.

## Cấu trúc collection

- `users/{uid}`
- `restaurants/{restaurantId}`
- `foods/{foodId}`
- `orders/{orderId}`

## Ví dụ sử dụng repository

```dart
final foodRepository = FoodRepository();
final foods = await foodRepository.getAll();

final orderRepository = OrderRepository();
final orderId = await orderRepository.create(order);
```

Các ví dụ trên cần chạy sau khi Firebase được khởi tạo. UI nên hiển thị loading/error state khi gọi repository và không giả định mạng luôn hoạt động.

## Lệnh kiểm tra trong terminal project

```bash
flutter pub get
flutter analyze
flutter test
```

Nếu có lỗi platform Firebase, kiểm tra FlutterFire options, package name/bundle ID và cấu hình Gradle/iOS. Không commit file secret hoặc thông tin tài khoản cá nhân.

A starter rules example is included as `firestore.rules.example`. Review it before deploying. It allows signed-in users to create/read their own orders but does not allow client-side order-status updates; production order status changes should be performed by trusted server/admin logic. Also note that client-supplied item prices and totals must be revalidated by trusted code for a real payment flow. Do not deploy test-mode rules to production.
