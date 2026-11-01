# Hướng dẫn Firebase cho nhóm (Ứng dụng FoodHub)

## Cấu hình hiện tại

- Tên ứng dụng thống nhất: **FoodHub**.
- Firebase project của nhóm: **`khanhdeptrai-71a05`**.
- `lib/main.dart` gọi `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` trước khi mở app.
- `lib/firebase_options.dart` có cấu hình cho Web, Android, iOS, macOS và Windows; Android được cấu hình thêm trong `android/app/google-services.json`.

## Collections và schema chuẩn

| Collection | Document ID | Trường chính |
|---|---|---|
| `users/{uid}` | Firebase Authentication UID | `name`, `phone`, `address`, `email`, `photoUrl`, `updatedAt` |
| `carts/{uid}` | Firebase Authentication UID | `userId`, `deliveryAddress`, `totalItemCount`, `subtotal`, `updatedAt`, `items` (`foodId`, `foodName`, `unitPrice`, `quantity`, `size`, `toppings`, `note`, `subtotal`) |
| `restaurants/{restaurantId}` | Firestore ID | `name`, `address`, `description`, `imageUrl`, `phone`, `rating`, `categories` |
| `foods/{foodId}` | Firestore ID | `name`, `price`, `description`, `category`, `restaurantId`, `imageUrl`, `isAvailable`, `rating` |
| `orders/{orderId}` | Firestore auto ID | `userId`, `items` (`foodId`, `foodName`, `unitPrice`, `quantity`, `size`, `toppings`, `note`, `subtotal`), `totalPrice`, `createdAt`, `status`, `deliveryAddress`, `paymentMethod`, `note` |

Quy ước quan trọng:

- Trường thời gian tạo đơn hàng thống nhất là **`createdAt`**.
- `OrderItem` và `CartItem` đều lưu rõ **`size`**, **`toppings`** và **`unitPrice`** (giá snapshot tại thời điểm đặt hàng, không lấy giá hiện tại của món để tính lại đơn cũ).
- Giỏ hàng lưu đồng bộ cùng một cấu trúc giữa `localStorage` (`foodhub_active_cart_v1`) và Firestore (`carts/{uid}`).

## Firestore Security Rules (`firestore.rules`)

- `users/{uid}`: Chỉ chủ tài khoản (`request.auth.uid == uid`) được đọc, tạo, sửa.
- `carts/{uid}`: Chỉ chủ tài khoản (`request.auth.uid == uid`) được đọc và sửa giỏ hàng của chính mình.
- `restaurants/{restaurantId}` và `foods/{foodId}`: Cho phép đọc công khai (`allow read: if true;`), nhưng chỉ Quản trị viên hoặc Trusted Backend mới được phép ghi (`allow write: if isAdmin();`), ngăn chặn người dùng thường tự ý sửa giá hoặc thực đơn.
- `orders/{orderId}`: Người dùng đã đăng nhập chỉ được tạo và xem đơn hàng của chính mình (`userId == request.auth.uid`); việc cập nhật trạng thái đơn hàng (`status`) chỉ do Quản trị viên (`isAdmin()`) hoặc Trusted Backend thực hiện.
