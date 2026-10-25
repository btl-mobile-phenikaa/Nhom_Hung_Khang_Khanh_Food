# Sequence diagrams đề xuất cho C3

Các sơ đồ dưới đây mô tả luồng nghiệp vụ chính của ứng dụng. Tên lớp/service có thể đổi theo cách đặt tên thực tế của nhóm, nhưng cần giữ nhất quán giữa diagram và code.

## 1. Đăng ký tài khoản

```mermaid
sequenceDiagram
  actor User as Người dùng
  participant UI as RegisterScreen
  participant Auth as Firebase Authentication
  participant Repo as UserRepository
  participant DB as Cloud Firestore
  User->>UI: Nhập email, mật khẩu, thông tin
  UI->>Auth: createUserWithEmailAndPassword()
  Auth-->>UI: Trả về UID
  UI->>Repo: save(User(uid, ...))
  Repo->>DB: set users/{uid}
  DB-->>Repo: Thành công
  Repo-->>UI: Hoàn tất
  UI-->>User: Thông báo đăng ký thành công
```

## 2. Tìm kiếm món ăn

```mermaid
sequenceDiagram
  actor User as Người dùng
  participant UI as SearchScreen
  participant Repo as FoodRepository
  participant DB as Cloud Firestore
  User->>UI: Nhập từ khóa
  UI->>Repo: Lấy danh sách món
  Repo->>DB: Query collection foods
  DB-->>Repo: Danh sách document
  Repo-->>UI: List<Food>
  UI->>UI: Lọc/hiển thị kết quả theo từ khóa
  UI-->>User: Danh sách món phù hợp
```

## 3. Thêm món vào giỏ hàng

```mermaid
sequenceDiagram
  actor User as Người dùng
  participant UI as FoodDetailScreen
  participant Cart as Cart state/service
  participant Model as CartItem
  User->>UI: Chọn số lượng và nhấn Thêm
  UI->>Model: Tạo CartItem(food, quantity)
  Model-->>Cart: Cung cấp item/subtotal
  Cart->>Cart: Nếu món đã có thì tăng số lượng
  Cart-->>UI: Cập nhật giỏ hàng
  UI-->>User: Hiển thị xác nhận
```

## 4. Đặt hàng

```mermaid
sequenceDiagram
  actor User as Người dùng
  participant UI as CheckoutScreen
  participant Auth as Firebase Authentication
  participant Repo as OrderRepository
  participant DB as Cloud Firestore
  User->>UI: Xác nhận địa chỉ và phương thức thanh toán
  UI->>Auth: Lấy UID hiện tại
  Auth-->>UI: UID
  UI->>UI: Tạo OrderItem snapshot và tính tổng tạm tính
  UI->>Repo: create(Order)
  Repo->>Repo: Kiểm tra userId, items, totalPrice
  Repo->>DB: Tạo orders/{orderId}, createdAt=serverTimestamp
  DB-->>Repo: Xác nhận lưu
  Repo-->>UI: orderId
  UI-->>User: Thông báo đặt hàng thành công
```

## 5. Xem lịch sử đơn hàng

```mermaid
sequenceDiagram
  actor User as Người dùng
  participant UI as OrderHistoryScreen
  participant Auth as Firebase Authentication
  participant Repo as OrderRepository
  participant DB as Cloud Firestore
  User->>UI: Mở Lịch sử đơn hàng
  UI->>Auth: Lấy UID hiện tại
  Auth-->>UI: UID
  UI->>Repo: watchByUser(uid)
  Repo->>DB: Query orders where userId=uid, orderBy createdAt desc
  DB-->>Repo: Snapshot đơn hàng
  Repo-->>UI: List<Order>
  UI-->>User: Hiển thị đơn hàng và trạng thái
```

## 6. Cập nhật hồ sơ (diagram dự phòng)

```mermaid
sequenceDiagram
  actor User as Người dùng
  participant UI as ProfileScreen
  participant Auth as Firebase Authentication
  participant Repo as UserRepository
  participant DB as Cloud Firestore
  User->>UI: Sửa thông tin hồ sơ
  UI->>Auth: Lấy UID hiện tại
  Auth-->>UI: UID
  UI->>Repo: updateProfile(uid, fields)
  Repo->>DB: set fields with merge=true
  DB-->>Repo: Thành công
  Repo-->>UI: Hoàn tất
  UI-->>User: Hiển thị thông tin mới
```
