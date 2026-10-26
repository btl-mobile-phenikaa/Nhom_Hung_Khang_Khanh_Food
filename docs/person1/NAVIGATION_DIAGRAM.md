# Sơ đồ điều hướng tổng thể

Sơ đồ mô tả luồng mục tiêu của ứng dụng và các màn hình cần nối. Đây là sơ đồ cấu trúc điều hướng, không thay cho wireframe của từng màn hình.

```mermaid
flowchart TD
  Start([Mở ứng dụng]) --> Home[Trang chủ]

  Home --> Search[Tìm kiếm]
  Search --> Results[Kết quả tìm kiếm]
  Results --> Detail[Chi tiết món ăn]
  Home --> Detail
  Detail -->|Thêm món| Cart[Giỏ hàng]
  Home -->|Mở giỏ| Cart

  Cart -->|Tiếp tục chọn món| Home
  Cart -->|Đặt hàng| AuthCheck{Đã đăng nhập?}
  AuthCheck -->|Chưa| Login[Đăng nhập]
  AuthCheck -->|Rồi| Checkout[Xác nhận đơn hàng]
  Login -->|Đăng nhập thành công| Checkout
  Login --> Register[Đăng ký]
  Register -->|Đăng ký thành công| Checkout
  Register -->|Đã có tài khoản| Login

  Checkout -->|Quay lại sửa giỏ| Cart
  Checkout -->|Xác nhận| Confirmation[Đặt hàng thành công]
  Confirmation --> History[Lịch sử đơn hàng]
  History --> OrderDetail[Chi tiết đơn hàng]
  OrderDetail --> History

  Home --> Profile[Hồ sơ cá nhân]
  Profile -->|Khách chưa đăng nhập| Login
  Profile --> EditProfile[Chỉnh sửa hồ sơ]
  EditProfile -->|Lưu| Profile
  Profile -->|Đăng xuất| Home

  Home -. thanh điều hướng .-> Search
  Search -. thanh điều hướng .-> Cart
  Cart -. thanh điều hướng .-> Profile
```

## Ghi chú điều hướng

- Trang chủ, Tìm kiếm, Giỏ hàng và Hồ sơ nằm trên thanh điều hướng chính.
- Có thể thêm món vào giỏ trước khi đăng nhập; yêu cầu đăng nhập xuất hiện khi người dùng bắt đầu checkout.
- Sau khi đăng nhập/đăng ký từ luồng checkout, tiếp tục đến màn hình xác nhận đơn hàng.
- Sau khi xác nhận đơn, mở màn hình thành công; từ đó người dùng vào Lịch sử đơn hàng và Chi tiết đơn hàng.
- Đăng xuất đưa người dùng về Trang chủ ở trạng thái khách.
- Đây là luồng mục tiêu theo phân công nhóm. Khi tích hợp, cập nhật sơ đồ nếu nhóm đổi chính sách đăng nhập hoặc cách điều hướng.
