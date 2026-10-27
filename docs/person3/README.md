# Người 3 — Tài khoản và xác thực

**Phụ trách:** Nguyễn Chí Tài. **Nhánh:** `feature/person3-auth-nguyen-chi-tai`.
**Cập nhật tài liệu:** 28/10/2026.

## Phạm vi và trạng thái bàn giao

Đã có giao diện, logic và kết nối Firebase thật cho đăng ký, đăng nhập, đăng xuất,
hồ sơ cá nhân, chỉnh sửa hồ sơ, khôi phục phiên và xử lý lỗi.

- [Wireframe cập nhật](account_wireframes.svg): bốn màn điện thoại, đăng nhập màn hình rộng và các trạng thái phụ.
- [Sequence/activity diagram](FLOWS.md): luồng thực tế với Firebase và cách phục hồi khi hồ sơ lỗi.
- [Hướng dẫn kiểm thử và ảnh minh chứng](TESTING.md).
- [Kết quả kiểm tra backend thật](FIREBASE_VERIFICATION.json).
- [Đoạn Firestore Rules cho hồ sơ](firestore_users.rules.txt).

Tên đề tài là Foodie. Màn đăng nhập dùng logo **FoodHub** giống Trang chủ;
tiêu đề đăng ký trong code hiện tại là **“Tạo tài khoản Foodie”**. Wireframe giữ
đúng các nhãn đang hiển thị trong ứng dụng.

## Chạy ứng dụng Firebase thật

Từ thư mục `Foodie-Team`:

```sh
flutter pub get
flutter run -d web-server --web-port 8080
```

Mở http://localhost:8080 → **Profile** → **Đăng ký tài khoản** hoặc **Đăng nhập**.
Nếu đang có phiên, Profile hiển thị hồ sơ; đăng xuất trước nếu cần kiểm tra lại
màn đăng nhập. Nhấn `R` trong Terminal để khởi động lại Flutter sau khi sửa code.

`lib/main.dart` khởi tạo Firebase; `MainNavigation` tạo `AuthController` dùng
`FirebaseAuthService` và truyền vào màn tài khoản. Bản thật không hiện nhãn DEMO.
Tài khoản demo được liệt kê ở phần dưới không phải tài khoản Firebase thật.

Project nhóm: **`khanhdeptrai-71a05`**. Web dùng ứng dụng đã đăng ký
`1:121869979750:web:2b0d03928496130a325da7`; cấu hình được lấy bằng Firebase CLI.
`lib/firebase_options.dart` và metadata Web trong `firebase.json` đã đồng bộ.
Android/iOS/macOS/Windows giữ cấu hình thuộc project nhóm.

## Giao diện hiện tại

- **Đăng nhập:** `AuthPage`, nền `#F8FAFC`, thẻ trắng bo góc 28 px, logo FoodHub,
  ô nhập nền nhạt, nút cam `#FF5428`, thông báo lỗi dạng khối đỏ nhạt.
- Dưới **960 px:** form một cột, tối đa 460 px, cuộn được khi bàn phím mở.
  Từ **960 px:** thêm panel giới thiệu/minh họa món ăn, bố cục hai cột tối đa 1120 px.
- **Đăng ký:** `AccountLayout`, bốn trường, dùng chung kiểu ô nhập/mật khẩu và nút cam.
- **Hồ sơ:** avatar xanh, tên/email, số điện thoại/địa chỉ, nút chỉnh sửa, đăng xuất
  có xác nhận và liên kết Lịch sử đơn hàng. Khi chưa đăng nhập có lời chào và hai nút tài khoản.
- **Chỉnh sửa hồ sơ:** email chỉ đọc; tên, điện thoại và địa chỉ có thể sửa.
  Các trường của màn này hiện giữ kiểu viền đơn; nút lưu dùng màu cam chung.
- **Trạng thái:** nút gửi bị khóa và có vòng tiến trình khi xử lý; ẩn/hiện mật khẩu;
  nhấn Enter ở ô mật khẩu đăng nhập để gửi form; lỗi hồ sơ có nút “Tải lại hồ sơ”.

Ảnh render để duyệt giao diện:

- [Điện thoại](login_mobile.png).
- [Màn hình rộng](login_desktop.png).

Hai ảnh này được render từ widget Flutter bằng service giả lập, không nhập dữ
liệu; dùng để đối chiếu thiết kế. Chúng không thay thế ảnh chụp kiểm thử Firebase
thật hoặc ảnh đăng ký/hồ sơ của sinh viên. Thông tin người dùng trong SVG là dữ
liệu minh họa, không phải hồ sơ đã lấy từ Firestore.

## Chức năng và xử lý lỗi

- Đăng ký/đăng nhập Email/Password, đăng xuất bằng Firebase Authentication.
- Dùng Firebase UID làm `User.id` và document ID tại `users/{uid}`.
- Tạo, đọc, theo dõi và lưu hồ sơ qua `UserRepository`; không lưu mật khẩu trong Firestore.
- Khôi phục phiên từ Firebase Auth; theo dõi hồ sơ Firestore theo thời gian thực.
- Chuẩn hóa email; kiểm tra đầu vào trước khi gửi; chặn gửi trùng.
- Hiển thị lỗi sai thông tin đăng nhập, email trùng, mật khẩu yếu, tài khoản bị khóa,
  mất mạng/timeout, thiếu quyền và lỗi stream bằng tiếng Việt.
- Nếu Auth tạo tài khoản thành công nhưng đọc/lưu hồ sơ thất bại: **giữ phiên**,
  mở Hồ sơ với thông tin tạm và cảnh báo; người dùng có thể tải lại hoặc chỉnh
  sửa/lưu hồ sơ. Không yêu cầu đăng ký lại tài khoản đã tạo.
- Cập nhật thất bại giữ dữ liệu form và hồ sơ trước đó; tải lại hồ sơ có thể thử lại.
  Khi refresh phát hiện tài khoản bị vô hiệu hóa hoặc token không hợp lệ, kết thúc phiên đó.
- Mỗi phiên chỉ theo dõi document của UID hiện tại; sự kiện hồ sơ cũ bị bỏ qua
  sau khi đổi tài khoản hoặc đăng xuất.

## Firebase Console và quyền hồ sơ

Đã bật **Email/Password** và bổ sung Rules riêng cho `users/{uid}` theo xác nhận
của người dùng. Quy tắc các collection khác được giữ nguyên từ cấu hình lúc tích hợp.

- Chỉ chủ tài khoản được đọc document, tạo và cập nhật hồ sơ theo UID.
- Chặn client đọc danh sách hồ sơ và xóa hồ sơ.
- Chỉ nhận `name`, `email`, `phone`, `address`, `photoUrl`, `updatedAt`.
- Email phải khớp token Firebase Auth; các trường có giới hạn kiểu/độ dài.
- `updatedAt` phải là server timestamp. `UserRepository.save` đã dùng
  `FieldValue.serverTimestamp()`.

[firestore_users.rules.txt](firestore_users.rules.txt) là **đoạn Rules cần ghép
bên trong** `match /databases/{database}/documents`, không phải tệp deploy cả
project. Người 1 cần giữ đoạn quyền hồ sơ này khi xuất bản Rules chung.

## Cấu trúc code và tích hợp

```text
lib/services/auth_service.dart                 Hợp đồng tài khoản và AuthFailure
lib/services/firebase_auth_service.dart        Firebase Auth + UserRepository
lib/services/demo_auth_service.dart            Giả lập độc lập trong RAM
lib/state/auth_controller.dart                 Phiên, loading, lỗi và kiểm tra đầu vào
lib/features/auth/validators/auth_validators.dart
lib/features/auth/widgets/account_widgets.dart  Ô nhập, mật khẩu, nút, lỗi, AccountLayout
lib/features/auth/widgets/auth_page.dart        Khung đăng nhập thích ứng và logo
lib/features/auth/screens/login_screen.dart
lib/features/auth/screens/register_screen.dart
lib/features/profile/screens/profile_screen.dart
lib/features/profile/screens/edit_profile_screen.dart
lib/main_auth_demo.dart                        Điểm vào demo
```

Model `User` và `UserRepository` của Người 1 được dùng lại. `AuthService` cung cấp
`currentUser`, `userChanges`, `isDemo`, `signIn`, `signUp`, `updateProfile`,
`refreshProfile`, `signOut` và `dispose`.

`MyApp(authController: ...)` cho phép truyền controller khi test/tích hợp.
Nếu Firebase chưa được khởi tạo trong test, controller mặc định dùng service demo;
điểm vào chính luôn khởi tạo Firebase trước khi chạy app. Chủ sở hữu controller
chịu trách nhiệm hủy controller/service; các màn hình chỉ mượn controller.

Người 4 lấy UID bằng **`AuthController.user?.id`**. Checkout/lịch sử của nhánh
`hung` hiện vẫn dùng `demo_user`: cần ghép UID thật, yêu cầu đăng nhập trước khi
đặt hàng và thống nhất quyền `orders` với Người 1. Việc này chưa được coi là hoàn
thành chỉ vì phần tài khoản đã hoạt động.

## Quy tắc nhập liệu

- Email trim và chuyển chữ thường; không trim mật khẩu.
- Tên 2–80 ký tự sau trim. Đăng ký yêu cầu mật khẩu ít nhất 8 ký tự;
  Firebase có thể yêu cầu mạnh hơn và trả lỗi tương ứng.
- Đăng nhập chỉ yêu cầu mật khẩu không rỗng để không chặn tài khoản cũ.
- Điện thoại/địa chỉ có thể để trống. Nếu có điện thoại, dùng `0` + 9 chữ số hoặc
  `+84` + 9 chữ số. Địa chỉ tối đa 250 ký tự.
- Chỉnh sửa hồ sơ không đổi email đăng nhập. Đăng xuất hiện không thay đổi giỏ hàng.

## Kiểm thử đã có

**Lần kiểm tra code gần nhất (28/10/2026): 66/66 unit/widget test toàn dự án đạt,
Dart analyzer không báo lỗi và build web release thành công.**

```sh
dart analyze lib test
flutter test
flutter build web --release
```

Các tệp test phần tài khoản:

- `test/features/auth/auth_validators_test.dart` — quy tắc nhập liệu.
- `test/state/auth_controller_test.dart` — phiên, trạng thái tải, lỗi, gửi trùng và demo.
- `test/services/firebase_auth_service_test.dart` — adapter qua fake SDK/repository,
  khôi phục phiên, đồng bộ hồ sơ, phục hồi lỗi và cô lập phiên.
- `test/features/auth/account_flow_test.dart` — điều hướng, ẩn/hiện mật khẩu,
  lỗi/thử lại, giữ phiên khi chuyển tab và các màn 320×568, 568×320, 1280×900 với chữ lớn/bàn phím.

Backend thật đã được kiểm tra riêng qua REST API: đăng ký hai tài khoản tạm,
đăng nhập, từ chối mật khẩu sai, ghi/đọc/cập nhật hồ sơ chính chủ, chặn đọc/sửa
chéo và chặn khách chưa đăng nhập. Tài khoản/hồ sơ thử đã được dọn sạch;
[kết quả JSON](FIREBASE_VERIFICATION.json) lưu nguyên bằng chứng của lần kiểm tra đó.

Đây chưa phải integration test Flutter đầu-cuối trên trình duyệt hoặc thiết bị thật.
Dùng [checklist thủ công](TESTING.md) để kiểm tra bản app đang chạy, ghi kết quả
và bổ sung ảnh/video minh chứng trước khi nộp.

## Demo độc lập

```sh
flutter run -t lib/main_auth_demo.dart -d web-server --web-port 8080
```

- Email `tai.demo@foodie.test`, mật khẩu `Foodie123!`; có nút điền mẫu.
- Có nhãn DEMO. Tài khoản và phiên chỉ ở RAM, mất khi tải lại trang.
- Biểu tượng Wi-Fi mô phỏng lỗi mạng và thử lại; không thay đổi mạng thật.
- Điểm vào này không khởi tạo Firebase hoặc đọc/ghi backend.

## Công việc bàn giao còn lại

1. Sinh viên chạy checklist, chụp ảnh màn hình thật và cập nhật kết quả.
2. Người 4 nối UID thật cho đơn hàng/lịch sử; Người 1 tích hợp Rules chung.
3. Commit, push nhánh và tạo Pull Request để nhóm xem xét, tích hợp.

Chưa triển khai: quên mật khẩu, đổi email/mật khẩu, tải ảnh đại diện, xóa tài khoản,
đơn hàng theo UID và integration test Android/iOS thật.

Tham khảo: [Firebase Authentication Flutter](https://firebase.google.com/docs/auth/flutter/start),
[Email/Password](https://firebase.google.com/docs/auth/flutter/password-auth),
[xử lý lỗi](https://firebase.google.com/docs/auth/flutter/errors).
