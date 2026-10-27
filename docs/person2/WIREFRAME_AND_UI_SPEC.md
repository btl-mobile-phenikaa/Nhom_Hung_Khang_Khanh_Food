# Báo cáo nhiệm vụ Người 2 — Thiết kế Giao diện Chính theo Mẫu Câu 5 (Chủ đề Food Delivery) & Search, Food Detail, Cart

Tài liệu chi tiết về kết quả thực hiện của **Người 2**, trong đó **Màn hình Trang chủ chính (`HomeScreen`)** được thiết kế theo đúng bố cục & phong cách giao diện mẫu **Câu 5** do giảng viên yêu cầu nhưng chuyển hóa 100% sang **chủ đề Đặt đồ ăn (Food Delivery)**, đồng thời giữ nguyên ranh giới phân công (không can thiệp vào màn hình `Profile` của Người 3).

---

## 1. Màn hình Trang chủ chính (`HomeScreen`) — Thiết kế theo bố cục Câu 5 (Chủ đề Food)

File mã nguồn:
- [`lib/features/home/screens/home_screen.dart`](file:///c:/Users/ADMIN/Food_Project/lib/features/home/screens/home_screen.dart)
- [`lib/features/home/widgets/category_section.dart`](file:///c:/Users/ADMIN/Food_Project/lib/features/home/widgets/category_section.dart)
- [`lib/features/home/widgets/food_grid_section.dart`](file:///c:/Users/ADMIN/Food_Project/lib/features/home/widgets/food_grid_section.dart)
- [`lib/features/home/widgets/restaurant_section.dart`](file:///c:/Users/ADMIN/Food_Project/lib/features/home/widgets/restaurant_section.dart)

### 🎯 Chi tiết bố cục giao diện chính theo mẫu Câu 5 (Chủ đề Đồ ăn):

1. **Thanh Header chuẩn bố cục mẫu Câu 5:**
   - Logo thương hiệu **`Food`** kèm dãy **5 chấm tròn màu sắc** (Đỏ, Vàng, Xanh lá, Tím, Xanh ngọc) ở góc trái.
   - Huy hiệu thành viên **`★ VIP Platinum`** nền tối (`#0F172A`) với nhãn `Platinum` xám bạc.
   - Huy hiệu ví thưởng đặt món xanh lá **`₫ 734K`** kèm badge đỏ số **`3`**.

2. **Thanh tìm kiếm nhanh (Search Bar):**
   - Tìm kiếm nhanh món ăn, nhà hàng, ưu đãi; chạm vào sẽ chuyển sang tab **Tìm kiếm (`SearchScreen`)**.

3. **Danh mục đồ ăn Bento Grid 2 + 3 + Hộp 5 icon tiện ích (`CategorySection`):**
   - **Hàng 1 (2 thẻ lớn pastel):**
     - **`Món Việt`** (`Phở, Bún & Cơm`): Nền pastel cam đào (`#FFE8E5` → `#FFD5D0`), minh họa tô Phở & nồi súp góc phải dưới.
     - **`Đồ ăn nhanh`** (`Burger & Gà rán`): Nền pastel tím lavender (`#F3E8FF` → `#E5D4FF`), minh họa Burger & Pizza góc phải dưới.
   - **Hàng 2 (3 thẻ vừa pastel):**
     - **`Combo + Nước`** (`Tiết kiệm 35%`): Nền pastel xanh da trời (`#E0F4FF` → `#BAE6FD`), minh họa Combo đồ ăn nhanh & ly nước.
     - **`Trà sữa & Cafe`** (`Mát lạnh`): Nền pastel vàng ấm (`#FFF4D6` → `#FDE68A`), minh họa ly Cafe / Trà sữa.
     - **`Bánh ngọt & Ăn vặt`** (`Tráng miệng`): Nền pastel xanh bạc hà (`#E6FAEA` → `#BBF7D0`), minh họa bánh ngọt.
   - **Hàng 3 (Khung trắng bo góc 5 icon danh mục đồ ăn nhanh):**
     - `Giao Siêu Tốc`, `Món Nước`, `Cơm Ngon`, `Bánh Mì`, `Đồ Uống`.

4. **Thẻ Coupon khuyến mại đặt món:**
   - Card trắng viền mỏng kèm icon vé giảm giá, nội dung ***"Giảm tới 18% cho đơn đặt món tiếp theo trên ứng dụng"*** và nút bấm **"Nhận mã"** màu xanh `#2563EB` (tương tác đổi sang *"Đã lưu ✓"*).

5. **Mục "Tiếp tục đặt món yêu thích":**
   - Card lịch sử quán quen hiển thị ảnh tô Phở Bò, tiêu đề **"Phở Thìn Bờ Hồ - Đặc Sản Hà Nội"**, thông tin **"Giao 15 - 20 phút • 👥 2 phần"** và nút mũi tên điều hướng.

6. **Mục "Ưu đãi món ngon hôm nay" / "Recommended for you" & "Featured restaurants":**
   - Kết nối trực tiếp `StreamBuilder<List<Food>>` và `StreamBuilder<List<Restaurant>>` từ Firestore để hiển thị danh sách món ăn phổ biến & nhà hàng nổi bật.
   - Cho phép bấm xem chi tiết món ([`FoodDetailScreen`](file:///c:/Users/ADMIN/Food_Project/lib/features/food_detail/screens/food_detail_screen.dart)) hoặc thêm nhanh vào giỏ hàng.

7. **Thanh điều hướng dưới (`NavigationBar`):**
   - Nền trắng tinh khiết, hiệu ứng chọn pill xanh nhạt `#E0F2FE` với icon xanh `#1D4ED8` đồng bộ với ảnh mẫu Câu 5.
   - **Lưu ý phân công:** Tab `Profile` được giữ nguyên hoàn toàn cho **Người 3** làm việc.

---

## 2. Các màn hình còn lại của Người 2

1. **Màn hình Tìm kiếm ([`SearchScreen`](file:///c:/Users/ADMIN/Food_Project/lib/features/search/screens/search_screen.dart)):**
   - Ô nhập từ khóa tìm kiếm theo tên/mô tả món ăn, từ khóa xu hướng, bộ lọc chip danh mục (`Tất cả`, `Món nước`, `Cơm`, `Bánh mì`, `Đồ uống`, `Ăn vặt`), menu sắp xếp giá, danh sách kết quả và trạng thái không có kết quả.
2. **Màn hình Chi tiết món ăn ([`FoodDetailScreen`](file:///c:/Users/ADMIN/Food_Project/lib/features/food_detail/screens/food_detail_screen.dart)):**
   - Ảnh món ăn lớn, tên món, giá tiền, mô tả, tuỳ chọn kích cỡ (Size S/M/L), topping thêm, ghi chú cho quán, bộ chọn số lượng (`-` / `+`) và nút **"Thêm vào giỏ"**.
3. **Màn hình Giỏ hàng ([`CartScreen`](file:///c:/Users/ADMIN/Food_Project/lib/features/cart/screens/cart_screen.dart)) & Quản lý trạng thái ([`CartController`](file:///c:/Users/ADMIN/Food_Project/lib/state/cart_controller.dart)):**
   - Danh sách món trong giỏ, tăng/giảm số lượng, xóa món (kèm Hoàn tác), áp mã giảm giá 20.000đ, bảng tính tạm tính/phí giao hàng/tổng thanh toán và nút **"Đặt hàng"**.

---

## 3. Kiểm thử tự động (Unit & Widget Tests)

- [`test/state/cart_controller_test.dart`](file:///c:/Users/ADMIN/Food_Project/test/state/cart_controller_test.dart): 7/7 tests PASS
- [`test/features/cart/cart_screen_test.dart`](file:///c:/Users/ADMIN/Food_Project/test/features/cart/cart_screen_test.dart): 3/3 tests PASS
- [`test/features/food_detail/food_detail_screen_test.dart`](file:///c:/Users/ADMIN/Food_Project/test/features/food_detail/food_detail_screen_test.dart): 2/2 tests PASS
- [`test/features/search/search_screen_test.dart`](file:///c:/Users/ADMIN/Food_Project/test/features/search/search_screen_test.dart): 4/4 tests PASS
- [`test/widget_test.dart`](file:///c:/Users/ADMIN/Food_Project/test/widget_test.dart): Toàn bộ integration/smoke tests PASS
