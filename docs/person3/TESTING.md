# Kiểm thử và minh chứng — Người 3

Cập nhật 28/10/2026. Dùng bản Firebase thật để kiểm tra trước khi bàn giao;
bản demo chỉ dùng duyệt giao diện và thử lỗi giả lập.

## Kết quả kiểm tra tự động đã có

Lần kiểm tra code gần nhất: **66/66 unit/widget test toàn dự án đạt**, analyzer
không báo lỗi và build web release thành công. Thay đổi tài liệu/wireframe không
được tính là một lần chạy lại các kiểm thử ứng dụng.

```sh
dart analyze lib test
flutter test
flutter build web --release
```

Muốn chạy riêng test tài khoản:

```sh
flutter test test/features/auth test/state/auth_controller_test.dart test/services/firebase_auth_service_test.dart
```

Test kiểm tra validation, đăng nhập/đăng ký, email trùng, sai mật khẩu, sửa hồ sơ,
đăng xuất, trạng thái tải, lỗi/thử lại, gửi trùng, hủy controller khi đang xử lý,
khôi phục phiên, sự kiện hồ sơ cũ, lỗi stream và phục hồi. Widget test bao gồm
màn 320×568, 568×320, 1280×900 với cỡ chữ 1,5 lần và bàn phím mở.
Firebase SDK/repository trong unit test được giả lập để chạy ổn định, không tạo
người dùng thật khi chạy `flutter test`.

## Kiểm tra backend thật đã có

[FIREBASE_VERIFICATION.json](FIREBASE_VERIFICATION.json) ghi kết quả REST API
trên `khanhdeptrai-71a05`: đăng ký hai tài khoản tạm, đăng nhập, từ chối mật khẩu
sai, ghi/đọc/cập nhật hồ sơ chính chủ, chặn đọc/sửa chéo và chặn khách chưa đăng
nhập. Các mục dọn tài khoản/hồ sơ tạm cũng đã đạt.

Bằng chứng này là kiểm tra backend, không phải integration test Flutter đầu-cuối
trên trình duyệt. Quyền xem dữ liệu của thành viên trong Firebase Console khác
với quyền của người dùng app; không dùng việc xem được document trên Console
để kết luận Rules của client đúng hoặc sai.

## Checklist thủ công trên ứng dụng thật

Chạy từ `Foodie-Team`:

```sh
flutter run -d web-server --web-port 8080
```

Mở http://localhost:8080 → Profile. Dùng tài khoản tự đăng ký; không dùng email
`@foodie.test` của demo. Các ô dưới đây để sinh viên tự đánh dấu sau khi kiểm tra;
chúng chưa được ghi là hoàn thành chỉ dựa trên unit test hoặc ảnh thiết kế.

- [ ] **P3-M01 — Đúng bản chạy:** màn đăng nhập không có nhãn DEMO, logo FoodHub,
  nút cam và bố cục đúng [wireframe](account_wireframes.svg).
- [ ] **P3-M02 — Form đăng ký sai:** bỏ trống, email sai, tên dưới 2 ký tự,
  mật khẩu dưới 8 ký tự, xác nhận không khớp → báo lỗi tại trường, không tạo tài khoản.
- [ ] **P3-M03 — Đăng ký hợp lệ:** tạo tài khoản, quay về Hồ sơ; email xuất hiện
  ở Authentication → Users của đúng project; document `users/{uid}` có ID trùng
  Firebase UID, không có trường mật khẩu.
- [ ] **P3-M04 — Email đã dùng:** đăng ký lại email vừa tạo → báo lỗi; không tạo
  tài khoản thứ hai cho cùng email.
- [ ] **P3-M05 — Đăng nhập hợp lệ:** email/mật khẩu đúng → mở đúng Hồ sơ;
  nút con mắt ẩn/hiện và Enter ở ô mật khẩu hoạt động.
- [ ] **P3-M06 — Đăng nhập sai:** sai mật khẩu/email chưa đăng ký → thông báo lỗi,
  không chuyển sang phiên người dùng khác; sửa dữ liệu và thử lại thành công.
- [ ] **P3-M07 — Sửa hồ sơ:** đổi tên/điện thoại/địa chỉ → lưu → quay về Hồ sơ,
  có thông báo cập nhật; Firestore và giao diện hiển thị đúng dữ liệu mới.
- [ ] **P3-M08 — Hồ sơ không hợp lệ:** tên trống/điện thoại sai/địa chỉ quá dài
  → báo lỗi; email đăng nhập không được sửa ở màn hồ sơ.
- [ ] **P3-M09 — Giữ phiên và dữ liệu:** F5 khi đã đăng nhập, chuyển Home rồi
  quay lại Profile, đăng xuất/đăng nhập lại → đúng UID và dữ liệu đã lưu.
- [ ] **P3-M10 — Đăng xuất:** chọn Hủy → giữ phiên; xác nhận → về trạng thái
  chưa đăng nhập; F5 sau đăng xuất không tự vào lại tài khoản.
- [ ] **P3-M11 — Mất mạng/thử lại:** thử đăng nhập hoặc lưu hồ sơ khi mất mạng
  → lỗi hoặc timeout; có mạng trở lại → thử lại được, form không mất dữ liệu.
- [ ] **P3-M12 — Bố cục:** cửa sổ hẹp/ngang/rộng, chữ lớn, mở bàn phím → cuộn
  đến được nút gửi, không tràn; màn rộng từ 960 px có panel giới thiệu.
- [ ] **P3-M13 — Gửi trùng:** bấm nút liên tục khi đang xử lý → nút bị khóa,
  có tiến trình; không gửi nhiều yêu cầu từ một form.
- [ ] **P3-M14 — Phục hồi hồ sơ:** dùng tài khoản thử có hồ sơ thiếu/lỗi đồng bộ
  để kiểm tra cảnh báo, Tải lại hồ sơ và Chỉnh sửa hồ sơ → Lưu; không đăng ký lại
  email đã tạo. Trường hợp này đã có unit test, chỉ tự đánh dấu khi đã chạy thử thực tế.

Firestore có bộ nhớ đệm và có thể xếp hàng thao tác ghi khi mất mạng. Vì vậy
vẫn nhìn thấy hồ sơ khi offline không chứng minh ứng dụng lỗi. Sau khi kết nối
lại, kiểm tra kết quả cuối trên server; không coi thông báo timeout là bằng chứng
thao tác ghi không bao giờ được SDK gửi lại.

Khi ghi kết quả, lưu mã ca, môi trường (Web/Android/iOS), Đạt/Không đạt, lỗi và tên
ảnh minh chứng. Nếu phát hiện lỗi, giữ lại các bước tái hiện để nhóm sửa.

## Ảnh và video cần chuẩn bị để nộp

1. Màn đăng nhập mới trên ứng dụng đang chạy.
2. Lỗi kiểm tra dữ liệu đăng ký/đăng nhập.
3. Hồ sơ sau đăng ký hoặc đăng nhập thành công.
4. Hồ sơ sau chỉnh sửa, kèm dữ liệu tương ứng trong Firestore.
5. Authentication → Users có tài khoản vừa đăng ký; đối chiếu UID với document hồ sơ.
6. Trạng thái sau đăng xuất hoặc video ngắn minh họa đầy đủ các thao tác.

Có thể lưu ảnh tự chụp vào thư mục `docs/person3/evidence/` rồi bổ sung link trong
README. Thư mục này chưa có ảnh thực tế được sinh viên bàn giao.

`login_mobile.png` và `login_desktop.png` là ảnh render widget để duyệt thiết kế;
`account_wireframes.svg` là bản vẽ. Không dùng ba tệp này làm bằng chứng đã đăng ký
Firebase thành công. Bộ hồ sơ nộp dùng thêm ảnh/video app và Console thực tế.

## Điểm cần phối hợp trước khi kiểm thử toàn ứng dụng

- Người 1 tích hợp Rules `users/{uid}` vào Rules chung khi deploy lại.
- Người 4 thay `demo_user` bằng UID đang đăng nhập và nối yêu cầu đăng nhập trước
  checkout/lịch sử; thống nhất quyền `orders` với Người 1.
- Không báo các luồng đặt hàng theo UID là đã đạt chỉ dựa trên test tài khoản.
