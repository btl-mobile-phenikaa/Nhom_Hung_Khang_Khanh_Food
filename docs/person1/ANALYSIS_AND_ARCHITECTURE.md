# Phần Người 1 — Phân tích đối tượng, kiến trúc và Firebase

## 1. Mục tiêu

Ứng dụng đặt đồ ăn cho phép người dùng xem nhà hàng/món ăn, quản lý giỏ hàng, tạo đơn hàng và theo dõi trạng thái. Ứng dụng sử dụng Flutter/Dart; Firebase Authentication xác thực người dùng; Cloud Firestore lưu hồ sơ, nhà hàng, món ăn và đơn hàng; Firebase Storage có thể lưu ảnh nếu nhóm dùng ảnh tải lên.

## 2. Phân tích đối tượng (C2)

| Lớp | Thuộc tính chính | Phương thức/ trách nhiệm |
|---|---|---|
| `User` | `id`, `name`, `phone`, `address`, `email`, `photoUrl` | `fromMap`, `toMap`, `copyWith`, `updateAddress`; đại diện hồ sơ gắn với Firebase UID |
| `Restaurant` | `id`, `name`, `address`, `description`, `imageUrl`, `phone`, `rating`, `isOpen` | `fromMap`, `toMap`; biểu diễn nhà hàng |
| `Food` | `id`, `restaurantId`, `name`, `price`, `description`, `category`, `imageUrl`, `isAvailable`, `rating` | `fromMap`, `toMap`, `copyWith`; biểu diễn món ăn |
| `CartItem` | `food`, `quantity` | `increase`, `decrease`, `subtotal`, `toMap`; biểu diễn món trong giỏ và số lượng |
| `OrderItem` | `foodId`, `foodName`, `unitPrice`, `quantity`, `imageUrl` | `fromMap`, `toMap`, `subtotal`; lưu ảnh chụp dữ liệu món tại thời điểm đặt hàng |
| `Order` | `id`, `userId`, `items`, `totalPrice`, `orderDate`, `status`, `deliveryAddress`, `paymentMethod`, `note` | `fromMap`, `toMap`, `copyWith`; biểu diễn đơn hàng và trạng thái |
| `FoodRepository` | Tham chiếu collection `foods` | `getAll`, `watchAll`, `getById`, `add`, `update`, `delete` |
| `RestaurantRepository` | Tham chiếu collection `restaurants` | `getAll`, `watchAll`, `getById`, `add`, `update` |
| `UserRepository` | Tham chiếu collection `users` | `getById`, `watchById`, `save`, `updateProfile` |
| `OrderRepository` | Tham chiếu collection `orders` | `create`, `watchByUser`, `getById`, `updateStatus` |

### Quy tắc nghiệp vụ chính

1. `User.id` là UID từ Firebase Authentication, không tự tăng số nguyên.
2. `Food.price` và `OrderItem.unitPrice` là giá tại thời điểm đặt; đơn hàng không nên lấy giá mới nhất để tính lại lịch sử.
3. `CartItem.quantity` phải lớn hơn hoặc bằng 1. Muốn xóa hẳn món, giao diện gọi thao tác xóa khỏi danh sách giỏ hàng.
4. Đơn hàng phải thuộc một `userId` và có ít nhất một món.
5. Trạng thái được hỗ trợ trong repository: `pending`, `confirmed`, `preparing`, `delivering`, `completed`, `cancelled`.
6. Dữ liệu tiền tệ dùng kiểu số (`double` trong mô hình học tập). Với hệ thống thanh toán thực tế, nên cân nhắc lưu tiền theo đơn vị nguyên (VND) để tránh sai số dấu phẩy động.

## 3. Quan hệ giữa các lớp

- Một `Restaurant` có thể cung cấp nhiều `Food`; mỗi `Food` tham chiếu một `restaurantId`.
- Một `User` có thể tạo nhiều `Order`; mỗi `Order` tham chiếu `userId`.
- Một `CartItem` tham chiếu một `Food` và lưu số lượng người dùng chọn.
- Một `Order` bao gồm một hoặc nhiều `OrderItem`.
- `OrderItem` lưu bản sao tên món/đơn giá/số lượng tại thời điểm đặt, tránh lịch sử bị thay đổi khi thông tin `Food` thay đổi.
- Các repository thao tác với Firestore và chuyển đổi dữ liệu thông qua model; UI không cần tự xử lý cấu trúc document.

## 4. Class Diagram (C3)

```mermaid
classDiagram
  class User {
    +String id
    +String name
    +String phone
    +String address
    +String email
    +String photoUrl
    +fromMap(map, id)
    +toMap()
    +copyWith()
    +updateAddress(newAddress)
  }
  class Restaurant {
    +String id
    +String name
    +String address
    +String imageUrl
    +double rating
    +bool isOpen
    +fromMap(map, id)
    +toMap()
  }
  class Food {
    +String id
    +String restaurantId
    +String name
    +double price
    +String category
    +String imageUrl
    +bool isAvailable
    +fromMap(map, id)
    +toMap()
    +copyWith()
  }
  class CartItem {
    +Food food
    +int quantity
    +subtotal double
    +increase()
    +decrease()
    +toMap()
  }
  class OrderItem {
    +String foodId
    +String foodName
    +double unitPrice
    +int quantity
    +subtotal double
    +fromMap(map)
    +toMap()
  }
  class Order {
    +String id
    +String userId
    +List~OrderItem~ items
    +double totalPrice
    +DateTime orderDate
    +String status
    +String deliveryAddress
    +String paymentMethod
    +fromMap(map, id)
    +toMap()
    +copyWith(status)
  }
  class FoodRepository {
    +getAll()
    +watchAll()
    +getById(id)
    +add(food)
    +update(food)
    +delete(id)
  }
  class RestaurantRepository {
    +getAll()
    +watchAll()
    +getById(id)
    +add(restaurant)
    +update(restaurant)
  }
  class UserRepository {
    +getById(uid)
    +watchById(uid)
    +save(user)
    +updateProfile(uid)
  }
  class OrderRepository {
    +create(order)
    +watchByUser(uid)
    +getById(id)
    +updateStatus(id, status)
  }
  Restaurant "1" --> "0..*" Food : cung cấp
  User "1" --> "0..*" Order : đặt
  CartItem "0..*" --> "1" Food : tham chiếu
  Order "1" *-- "1..*" OrderItem : gồm
  FoodRepository ..> Food : chuyển đổi dữ liệu
  RestaurantRepository ..> Restaurant : chuyển đổi dữ liệu
  UserRepository ..> User : chuyển đổi dữ liệu
  OrderRepository ..> Order : chuyển đổi dữ liệu
```

## 5. Kiến trúc hệ thống

```mermaid
flowchart TD
  UI[Flutter UI: Home / Search / Cart / Profile / Orders]
  REPO[Repository layer]
  MODEL[Domain models and map serialization]
  AUTH[Firebase Authentication]
  DB[(Cloud Firestore)]
  STORAGE[Firebase Storage - optional images]
  UI --> REPO
  REPO --> MODEL
  REPO --> DB
  UI --> AUTH
  REPO -. image URL .-> STORAGE
```

## 6. Thiết kế Firestore

### `users/{uid}`

```json
{
  "name": "Nguyen Van A",
  "phone": "0900000000",
  "address": "Ha Noi",
  "email": "a@example.com",
  "photoUrl": "",
  "updatedAt": "server timestamp"
}
```

Document ID nên trùng với UID của Firebase Authentication.

### `restaurants/{restaurantId}`

```json
{
  "name": "Quan Pho A",
  "address": "Ha Noi",
  "description": "Pho bo truyen thong",
  "imageUrl": "",
  "phone": "0900000000",
  "rating": 4.5,
  "isOpen": true
}
```

### `foods/{foodId}`

```json
{
  "restaurantId": "restaurant-document-id",
  "name": "Pho bo",
  "price": 45000,
  "description": "Pho bo tai",
  "category": "Mon nuoc",
  "imageUrl": "",
  "isAvailable": true,
  "rating": 4.5
}
```

### `orders/{orderId}`

```json
{
  "userId": "firebase-auth-uid",
  "items": [
    {
      "foodId": "food-document-id",
      "foodName": "Pho bo",
      "unitPrice": 45000,
      "quantity": 2,
      "imageUrl": "",
      "subtotal": 90000
    }
  ],
  "totalPrice": 90000,
  "createdAt": "server timestamp",
  "status": "pending",
  "deliveryAddress": "Ha Noi",
  "paymentMethod": "cash",
  "note": ""
}
```

## 7. Ghi chú bảo mật và giới hạn

- Firebase API key phía client không thay thế cơ chế bảo vệ dữ liệu. Cần bật Firestore Security Rules và chỉ cho người dùng đọc/sửa hồ sơ của chính họ; đơn hàng chỉ được người sở hữu đọc, còn cập nhật trạng thái quản trị cần quyền riêng.
- Không để client tự do sửa `totalPrice` hoặc trạng thái đơn hàng trong ứng dụng thực tế. Với đồ án, hãy ghi rõ đây là mô hình học tập; nếu cần tính tiền đáng tin cậy thì tính/kiểm tra ở môi trường tin cậy.
- Nếu dùng `where(userId == ...)` kết hợp `orderBy(createdAt)`, Firestore có thể yêu cầu tạo composite index; tạo index theo liên kết mà Firebase cung cấp khi chạy truy vấn.
- Firestore là NoSQL document database, không phải ORM quan hệ truyền thống. Trong báo cáo nên mô tả `fromMap`/`toMap` là ánh xạ giữa document và Dart model, cùng repository quản lý CRUD.
