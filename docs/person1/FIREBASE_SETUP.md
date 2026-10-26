# Hướng dẫn Firebase cho nhóm

## Cấu hình hiện tại

- Firebase project của nhóm: **`khanhdeptrai-71a05`**.
- `lib/main.dart` gọi `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` trước khi mở app.
- `lib/firebase_options.dart` có cấu hình cho Web, Android, iOS, macOS và Windows; Android được cấu hình thêm trong `android/app/google-services.json`.
- Android Gradle đã áp dụng Google Services plugin.
- Đã xác nhận trên bản Web đang chạy: Firestore trả về `hasData=true`, `count=1`, `error=null` cho danh sách món.
- Các dependency Firebase hiện có trong `pubspec.yaml`: Core, Auth, Firestore và Storage.

## Chọn đúng project trên Console

Trước khi xem dữ liệu hoặc Rules, kiểm tra project ID là `khanhdeptrai-71a05`. Tên hiển thị project có thể khác project ID. Cấu hình hiện tại của app dùng project ID này.

## Collections và schema chuẩn

| Collection | Document ID | Trường chính |
|---|---|---|
| `users/{uid}` | Firebase Authentication UID | `name`, `phone`, `address`, `email`, `photoUrl`, `updatedAt` |
| `restaurants/{restaurantId}` | Firestore auto ID | `name`, `address`, `description`, `imageUrl`, `phone`, `rating`, `isOpen` |
| `foods/{foodId}` | Firestore auto ID | `name`, `price`, `description`, `category`, `restaurantId`, `imageUrl`, `isAvailable`, `rating` |
| `orders/{orderId}` | Firestore auto ID | `userId`, `items`, `totalPrice`, `createdAt`, `status`, `deliveryAddress`, `paymentMethod`, `note` |

Quy ước quan trọng:

- Tên món lưu dưới field `name` (số ít), không phải `names`.
- `price`, `unitPrice`, `subtotal` và `totalPrice` lưu kiểu số, đơn vị VND; không lưu chuỗi như `45.000đ`.
- Món hiển thị trong trang chủ cần `isAvailable: true`.
- `items` trong đơn là mảng snapshot để tên và giá lịch sử không đổi khi món trên menu thay đổi.
- Chi tiết schema và model nằm trong [TEAM_STRUCTURE.md](TEAM_STRUCTURE.md) và [ANALYSIS_AND_ARCHITECTURE.md](ANALYSIS_AND_ARCHITECTURE.md).

## Firestore Security Rules

App khách chưa đăng nhập cần đọc menu. Rules mẫu trong [firestore.rules.example](firestore.rules.example) cho phép đọc `foods` và `restaurants`, nhưng chặn client ghi các collection này. Hồ sơ và đơn hàng yêu cầu đăng nhập.

Nếu cần cấu hình lại Rules trên Firebase Console:

1. Chọn project `khanhdeptrai-71a05` → **Firestore Database → Rules**.
2. Đối chiếu với `firestore.rules.example`, hợp nhất các điều kiện cần dùng rồi bấm **Publish**.
3. Không dùng rule test cho phép đọc/ghi toàn bộ database. Không để quyền ghi công khai cho `foods`, `restaurants` hoặc `orders`.

Luồng đăng nhập do Người 3 phụ trách; trước khi bật tạo đơn, cần bật phương thức đăng nhập trong **Authentication → Sign-in method** và đảm bảo Rules cho `users`/`orders` tương ứng.

## Chạy và xử lý lỗi

```bash
flutter pub get
flutter run -d chrome
```

- Lỗi `[cloud_firestore/permission-denied]`: kiểm tra Rules của đúng project và collection mà app đang truy vấn.
- Không thấy món: kiểm tra collection `foods`, field `name`, kiểu số của `price`, và `isAvailable: true`.
- Lỗi Firebase khởi tạo: kiểm tra `DefaultFirebaseOptions.currentPlatform`, `firebase.json`, Android package name và cấu hình nền tảng tương ứng.
- Linux hiện chưa có cấu hình trong `DefaultFirebaseOptions`; không chọn Linux làm nền tảng chạy cho đến khi nhóm cấu hình FlutterFire cho Linux.

Có thể chạy `flutter analyze` và `flutter test` khi cần kiểm tra. Với thanh toán thật, backend phải xác minh lại giá và tổng tiền; app hiện chỉ mô phỏng thanh toán.
