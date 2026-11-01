ĐẠI HỌC PHENIKAA

TRƯỜNG CÔNG NGHỆ THÔNG TIN PHENIKAA

BÁO CÁO ĐỒ ÁN HỌC PHẦN

LẬP TRÌNH CHO THIẾT BỊ DI ĐỘNG

ĐỀ TÀI: ỨNG DỤNG ĐẶT ĐỒ ĂN

Lớp: Lập trình cho thiết bị di động N05 Nhóm: Nhóm Hưng – Khang – Khanh – Tài Thành viên: Nguyễn Đức Khanh - 24100401 Ngô Đức Khang Bùi Khánh Hưng Nguyễn Chí Tài Giảng viên hướng dẫn: Nguyễn Lệ Thu

Hà Nội, tháng 10 năm 2026

ĐẠI HỌC PHENIKAA

TRƯỜNG CÔNG NGHỆ THÔNG TIN PHENIKAA

TRANG BÌA PHỤ — BÁO CÁO KẾT QUẢ THỰC HIỆN ĐỀ TÀI

ĐỀ TÀI: ỨNG DỤNG ĐẶT ĐỒ ĂN (FoodHub)

Xây dựng ứng dụng di động đa nền tảng với Flutter SDK, Material Design 3 & Google Firebase

Hạng mục thông tin Chi tiết nội dung Trường / Khoa quản lý Đại học Phenikaa — Trường Công nghệ Thông tin Phenikaa Tên học phần Lập trình cho thiết bị di động Lớp học phần Lập trình cho thiết bị di động N05 Tên đề tài Ứng dụng Đặt Đồ Ăn Trực Tuyến (Food Delivery App — FoodHub) Giảng viên hướng dẫn ThS.  Nguyễn Lệ Thu Nhóm thực hiện Nhóm Hưng – Khang – Khanh – Tài (Nhom_Hung_Khang_Khanh_Food) Sinh viên thực hiện 1.  Nguyễn Đức Khanh  — MSSV:  24100401  (Nhóm trưởng / Kiến trúc & Firebase)
2.  Ngô Đức Khang  — Lớp N05 (Giao diện Trang chủ Bento Grid, Tìm kiếm, Chi tiết món & Giỏ hàng)
3.  Bùi Khánh Hưng  — Lớp N05 (Thanh toán đặt hàng Checkout, Lịch sử & Chi tiết hóa đơn)
4.  Nguyễn Chí Tài  — Lớp N05 (Xác thực Firebase Auth, Hồ sơ cá nhân & Kiểm định bảo mật) Công nghệ & Nền tảng Dart 3 (^3.11.0), Flutter SDK (Material Design 3), Firebase Authentication, Cloud Firestore, LocalStorage Firebase Project ID khanhdeptrai-71a05 (Cấu hình đa nền tảng: Android, iOS, Web, Windows, macOS) Kết quả Kiểm thử 71/71  Unit & Widget Tests PASS (100%), flutter analyze  0 lỗi ,  10/10  kịch bản Backend PASS Thời gian hoàn thành Hà Nội, tháng 10 năm 2026

PHẦN MỞ ĐẦU & THÔNG TIN CHUNG

1. Bảng phân chia công việc & Đánh giá mức độ hoàn thành

Đề tài  "Ứng dụng Đặt Đồ Ăn (FoodHub)"  được thực hiện bởi nhóm 4 sinh viên thuộc lớp  Lập trình cho thiết bị di động N05 , Trường Công nghệ Thông tin Phenikaa – Đại học Phenikaa. Công việc được phân chia minh bạch theo kiến trúc phân tầng (Clean Architecture & Feature-first) và 16 User Stories cốt lõi, đảm bảo mỗi thành viên phụ trách trọn vẹn từ thiết kế giao diện (UI/UX), lập trình logic nghiệp vụ, kết nối cơ sở dữ liệu Firebase đến kiểm thử tự động (Unit Test & Widget Test).

Bảng 0.1. Bảng phân chia nhiệm vụ, khối lượng công việc và đánh giá mức độ hoàn thành của các thành viên

Thành viên (Họ tên & MSSV) Nhiệm vụ đảm nhiệm chi tiết (Modules, Màn hình & User Stories) Tỉ lệ đóng góp (%) Chữ ký / Ghi chú đánh giá Nguyễn Đức Khanh 
MSSV:  24100401 
(Lớp N05 — Nhóm trưởng) •  Kiến trúc hệ thống & Domain Models:  Thiết kế và lập trình 6 lớp thực thể cốt lõi (User, Restaurant, Food, CartItem, Order, OrderItem) kèm cơ chế ánh xạ dữ liệu hai chiều ORM (fromMap, toMap, copyWith) tại lib/models/.
•  Tầng Repositories & Firebase Core:  Khởi tạo dự án Firebase khanhdeptrai-71a05 (lib/firebase_options.dart), xây dựng 4 lớp truy xuất dữ liệu FoodRepository, RestaurantRepository, UserRepository, OrderRepository (lib/repositories/).
•  Chức năng Nhà hàng đối tác & Đồng bộ Realtime (US13, US14, US15, US16):  Xây dựng màn hình RestaurantDetailScreen (lib/features/restaurant/), luồng đồng bộ thực đơn thời gian thực watchByRestaurant(), công cụ nạp dữ liệu mẫu tự động 20 món ăn & 3 nhà hàng (SampleFoodCatalog.seedAllData()), cấu hình phân quyền bảo mật firestore.rules và viết Unit/Widget Test (restaurant_detail_screen_test.dart). 25% 
(Hoàn thành 100% nhiệm vụ) Đã ký xác nhận
*(Đạt xuất sắc)* Ngô Đức Khang 
(Lớp N05) •  Giao diện Trang chủ Bento Grid & Màn hình mẫu (US01):  Thiết kế và hiện thực hóa HomeScreen (lib/features/home/), CategorySection, FoodGridSection, RestaurantSection, AgodaDemoScreen và ButtonDemoScreen với bố cục Bento Grid 2+3 danh mục pastel, thẻ Coupon giảm 18% và danh sách món ăn/nhà hàng nổi bật.
•  Tìm kiếm & Lọc đa tiêu chí (US02):  Lập trình SearchScreen (lib/features/search/) hỗ trợ tìm kiếm từ khóa tức thời, lọc theo 5 danh mục món ăn và sắp xếp theo đơn giá tăng/giảm hoặc điểm đánh giá.
•  Chi tiết món ăn & Giỏ hàng lưu trữ kép (US03, US04, US05):  Xây dựng FoodDetailScreen (chọn Size S/M/L, Topping, số lượng), CartScreen và CartController (lib/state/cart_controller.dart) với cơ chế lưu trữ 2 lớp (localStorage + Cloud Firestore carts/{uid}) chống mất giỏ hàng khi tải lại trang (F5), tự động miễn phí giao hàng cho đơn từ 150.000đ, áp dụng Voucher 20.000đ và hoàn tác xóa món (Undo). 25% 
(Hoàn thành 100% nhiệm vụ) Đã ký xác nhận
*(Đạt xuất sắc)* Bùi Khánh Hưng 
(Lớp N05) •  Luồng Xác nhận Đặt hàng & Thanh toán đa phương thức (US10):  Thiết kế và lập trình màn hình CheckoutScreen (lib/features/checkout/screens/checkout_screen.dart), tự động đồng bộ địa chỉ nhận hàng mặc định từ hồ sơ người dùng, cho phép nhập ghi chú giao hàng, kiểm tra bảng tính tổng tiền và hỗ trợ  5 phương thức thanh toán  (Tiền mặt COD, Ví MoMo, Ví ZaloPay, Chuyển khoản ngân hàng, Thẻ Quốc tế Visa/MasterCard).
•  Đóng gói Snapshot Đơn hàng & Lưu trữ Firestore: Data Modeling: Thiết kế thực thể Order, OrderItem (lưu snapshot foodId, foodName, size, toppings, unitPrice, quantity, note độc lập với giá món hiện tại) và OrderStatus enum (pending, confirmed, preparing, delivering, delivered, cancelled). Theo dõi Lịch sử & Chi tiết Hóa đơn Realtime (US11, US12):  Xây dựng OrderHistoryScreen lắng nghe StreamBuilder<List<Order>> theo thời gian thực với 5 nhãn màu trạng thái trực quan và OrderDetailScreen hiển thị biên lai chi tiết. 25% 
(Hoàn thành 100% nhiệm vụ) Đã ký xác nhận
*(Đạt xuất sắc)* Nguyễn Chí Tài 
(Lớp N05) •  Hệ thống Xác thực Người dùng (US06, US07):  Thiết kế và lập trình LoginScreen (giao diện thích ứng Responsive 1 cột trên thiết bị di động <960px và 2 cột kèm Hero Panel trên màn hình rộng >=960px), RegisterScreen, AuthPage, bộ kiểm định AuthValidators (lib/features/auth/).
•  Quản lý Hồ sơ cá nhân & Đăng xuất an toàn (US08, US09):  Xây dựng ProfileScreen, EditProfileScreen (lib/features/profile/), tích hợp FirebaseAuthService, DemoAuthService và AuthController (lib/state/auth_controller.dart) hỗ trợ tự động khôi phục phiên đăng nhập, chuẩn hóa thông báo lỗi tiếng Việt thân thiện và hộp thoại xác nhận đăng xuất.
•  Kiểm định Bảo mật & Kiểm thử tự động:  Thực hiện kiểm định REST API trực tiếp trên dự án Firebase thật (docs/person3/FIREBASE_VERIFICATION.json đạt 10/10 kịch bản) và viết bộ Unit/Widget Test toàn diện cho luồng tài khoản. 25% 
(Hoàn thành 100% nhiệm vụ) Đã ký xác nhận
*(Đạt xuất sắc)*

2. Lời cảm ơn / Lời mở đầu

Trong kỷ nguyên chuyển đổi số mạnh mẽ hiện nay, các thiết bị di động thông minh đã trở thành phương tiện kết nối thiết yếu trong đời sống hàng ngày. Đặc biệt, lĩnh vực thương mại điện tử và giao nhận ẩm thực trực tuyến (Online Food Delivery) đã chứng kiến sự bùng nổ vượt bậc, thay đổi hoàn toàn thói quen khám phá ẩm thực và đặt món của người tiêu dùng đô thị cũng như cộng đồng sinh viên. Việc nghiên cứu, phân tích, thiết kế và hiện thực hóa một ứng dụng đặt đồ ăn đa nền tảng hoàn chỉnh không chỉ mang ý nghĩa thực tiễn cao mà còn giúp sinh viên ngành Công nghệ Thông tin rèn luyện tư duy kiến trúc phần mềm hiện đại, kỹ năng quản lý trạng thái, đồng bộ dữ liệu thời gian thực và bảo mật hệ thống trên đám mây.

Lời đầu tiên, nhóm sinh viên thực hiện đề tài  Nhóm Hưng – Khang – Khanh – Tài  xin bày tỏ lòng biết ơn chân thành và sâu sắc nhất tới Ban Giám hiệu  Đại học Phenikaa , Ban Chủ nhiệm cùng quý Thầy/Cô giảng viên  Trường Công nghệ Thông tin Phenikaa  đã tạo điều kiện môi trường học tập, trang bị cơ sở vật chất và chương trình đào tạo hiện đại, sát với thực tiễn doanh nghiệp.

Đặc biệt, nhóm chúng em xin gửi lời cảm ơn trân trọng nhất tới Giảng viên hướng dẫn —  Cô Nguyễn Lệ Thu , người đã trực tiếp giảng dạy học phần  Lập trình cho thiết bị di động (Lớp N05)  và tận tình định hướng, chỉ dẫn chuyên môn cho nhóm trong suốt quá trình thực hiện đồ án. Những góp ý sâu sắc của Cô về cách phân tích yêu cầu hệ thống, chuẩn hóa sơ đồ UML, thiết kế giao diện người dùng chuẩn Material Design 3 trên Flutter cũng như phương pháp tổ chức kiến trúc kết nối Google Firebase đã giúp nhóm hoàn thiện sản phẩm một cách bài bản, chặt chẽ và khoa học nhất.

Mặc dù các thành viên trong nhóm đã nỗ lực hết mình để hoàn thành 100% các mục tiêu đề ra cùng bộ kiểm thử tự động nghiêm ngặt, song do thời gian và kinh nghiệm thực tế còn nhất định nên báo cáo và sản phẩm khó tránh khỏi những điểm còn có thể tối ưu hơn nữa. Nhóm rất mong nhận được những nhận xét, đánh giá quý báu của Cô  Nguyễn Lệ Thu  và quý Thầy/Cô trong Hội đồng chấm đồ án để tiếp tục hoàn thiện ứng dụng trong tương lai. Nhóm chúng em xin chân thành cảm ơn!

3. Hệ thống Mục lục Báo cáo

3.1. Mục lục nội dung

Bảng 0.2. Cấu trúc tổng thể các phần và chương mục của Báo cáo đồ án

Chương / Mục Tên chương mục và nội dung chi tiết Trang / Tham chiếu PHẦN MỞ ĐẦU • Trang bìa chính & Trang bìa phụ (Đại học Phenikaa — Trường CNTT Phenikaa)
• Bảng phân chia công việc & Đánh giá mức độ hoàn thành của 4 thành viên
• Lời cảm ơn / Lời mở đầu
• Mục lục nội dung, Danh mục từ viết tắt, Danh mục bảng biểu, Danh mục hình vẽ Trang i – iv CHƯƠNG 1 TỔNG QUAN VỀ ĐỀ TÀI 
• 1.1. Lý do chọn đề tài (Bối cảnh thực tế, vấn đề đặt ra & nhu cầu phát triển)
• 1.2. Mục tiêu đề tài (Bài toán giải quyết & Đối tượng người dùng mục tiêu)
• 1.3. Phạm vi nghiên cứu (Chức năng, Nền tảng Android/iOS/Web, OS tối thiểu)
• 1.4. Khảo sát các ứng dụng tương tự — Benchmark (ShopeeFood, GrabFood & Điểm khác biệt) Chương 1 CHƯƠNG 2 PHÂN TÍCH YÊU CẦU HỆ THỐNG 
• 2.1. Yêu cầu chức năng (Xác thực, Nghiệp vụ chính, Bổ trợ & 16 User Stories)
• 2.2. Yêu cầu phi chức năng (Hiệu năng, Bảo mật JWT/Rules, Khả năng tương thích)
• 2.3. Mô hình hóa yêu cầu UML (Sơ đồ Use Case tổng quát, Đặc tả chi tiết 5 Use Cases cốt lõi, Sơ đồ hoạt động Activity Diagrams) Chương 2 CHƯƠNG 3 THIẾT KẾ HỆ THỐNG & GIAO DIỆN 
• 3.1. Kiến trúc phần mềm ứng dụng (Clean Architecture, Repository & State Management)
• 3.2. Thiết kế dữ liệu (Local DB/LocalStorage, Cloud Firestore NoSQL ERD & Danh sách API Endpoints/Service Methods)
• 3.3. Thiết kế chi tiết các lớp & tương tác (Class Diagram & Sequence Diagrams)
• 3.4. Thiết kế giao diện người dùng UI/UX (Screen Navigation Flow & Bản vẽ Wireframes) Chương 3 CHƯƠNG 4 CÀI ĐẶT VÀ HIỆN THỰC HÓA ỨNG DỤNG 
• 4.1. Môi trường phát triển & Công nghệ sử dụng (Dart/Flutter, IDE, SDK bên thứ ba)
• 4.2. Hiện thực các tính năng đặc thù trên thiết bị di động (Quyền truy cập & Bảo mật, Realtime Streams/Thông báo, Caching & Xử lý mất mạng)
• 4.3. Kết quả giao diện & Thao tác chức năng (Ảnh màn hình thực tế & Code Snippets) Chương 4 CHƯƠNG 5 KIỂM THỬ VÀ ĐÁNH GIÁ 
• 5.1. Môi trường kiểm thử (Emulator, Thiết bị thật, Trình duyệt & Khung nhìn Responsive)
• 5.2. Kịch bản kiểm thử — Test Cases (Bảng 20 Test Cases chi tiết & 71/71 Automated Tests)
• 5.3. Đánh giá kết quả & Trải nghiệm trên các điều kiện biên (Mất mạng, Sai dữ liệu, Xoay màn hình) Chương 5 KẾT LUẬN & PHỤ LỤC • Kết luận (Tóm tắt kết quả đạt được, Khó khăn & Bài học kinh nghiệm)
• Hạn chế & Hướng phát triển trong tương lai (AI gợi ý, Bản đồ GPS, Google Play/App Store)
• Tài liệu tham khảo chính thống
• Phụ lục (Link GitHub Repository, Hướng dẫn biên dịch APK & Video Demo) Phần cuối

3.2. Danh mục từ viết tắt

Bảng 0.3. Danh mục các từ viết tắt và thuật ngữ chuyên ngành sử dụng trong báo cáo

Từ viết tắt Thuật ngữ tiếng Anh đầy đủ Giải nghĩa tiếng Việt trong ngữ cảnh đề tài API Application Programming Interface Giao diện lập trình ứng dụng, kết nối giữa ứng dụng Flutter và dịch vụ đám mây Firebase. APK Android Package Kit Định dạng tệp gói cài đặt ứng dụng dành cho hệ điều hành di động Android. BaaS Backend-as-a-Service Mô hình dịch vụ đám mây cung cấp sẵn hệ thống phụ trợ (xác thực, cơ sở dữ liệu, lưu trữ). COD Cash On Delivery Phương thức thanh toán bằng tiền mặt trực tiếp khi nhận đồ ăn. CRUD Create, Read, Update, Delete Bốn thao tác cơ bản trên dữ liệu: Tạo mới, Đọc/Truy vấn, Cập nhật và Xóa. ERD Entity-Relationship Diagram Sơ đồ thực thể - liên kết biểu diễn cấu trúc và mối quan hệ giữa các tập dữ liệu. JSON JavaScript Object Notation Định dạng chuỗi dữ liệu nhẹ dùng để lưu trữ giỏ hàng cục bộ và giao tiếp REST API. JWT JSON Web Token Chuỗi mã thông báo xác thực điện tử có chữ ký số do Firebase Authentication cấp phát. MVVM Model – View – ViewModel Mô hình kiến trúc tách biệt giao diện hiển thị (View) và điều khiển trạng thái (Controller/ViewModel). NoSQL Not Only SQL Hệ quản trị cơ sở dữ liệu phi quan hệ hướng tài liệu (Document-oriented) như Cloud Firestore. ORM Object-Relational / Document Mapping Kỹ thuật ánh xạ hai chiều giữa tài liệu cơ sở dữ liệu (Map<String, dynamic>) và đối tượng Dart. SDK Software Development Kit Bộ công cụ phát triển phần mềm (Flutter SDK, Android SDK, FlutterFire SDK). UI / UX User Interface / User Experience Giao diện người dùng và Trải nghiệm người dùng trên thiết bị di động. UID Unique Identifier Mã định danh duy nhất của mỗi tài khoản người dùng trên hệ thống Firebase Authentication. UML Unified Modeling Language Ngôn ngữ mô hình hóa thống nhất (Use Case, Activity, Class, Sequence Diagrams).

3.3. Danh mục bảng biểu

Bảng 0.4. Danh mục các bảng biểu phân tích, thiết kế và kiểm thử trong báo cáo

Số hiệu bảng Tên bảng biểu Chương mục Bảng 0.1 Bảng phân chia nhiệm vụ, khối lượng công việc và đánh giá mức độ hoàn thành Phần mở đầu Bảng 0.2 – 0.5 Mục lục nội dung, Danh mục từ viết tắt, Danh mục bảng biểu & Danh mục hình vẽ Phần mở đầu Bảng 1.1 Phạm vi hỗ trợ nền tảng, hệ điều hành tối thiểu và môi trường triển khai ứng dụng Chương 1 (Mục 1.3) Bảng 1.2 Khảo sát và so sánh đối sánh (Benchmark) giữa ShopeeFood, GrabFood và ứng dụng FoodHub Chương 1 (Mục 1.4) Bảng 2.1 Danh sách 16 User Stories đặc tả yêu cầu chức năng của hệ thống Chương 2 (Mục 2.1) Bảng 2.2 Tổng hợp các chỉ số yêu cầu phi chức năng (Hiệu năng, Bảo mật, Tương thích) Chương 2 (Mục 2.2) Bảng 2.3 – 2.7 Bảng đặc tả chi tiết 5 Use Cases cốt lõi (UC01/03, UC05, UC06/07, UC08, UC10) Chương 2 (Mục 2.3) Bảng 3.1 Cấu trúc lưu trữ cục bộ (Local Storage & Auth Cache) trên thiết bị Chương 3 (Mục 3.2.1) Bảng 3.2 Thiết kế chi tiết các Collections trên Cloud Firestore và chính sách bảo mật Chương 3 (Mục 3.2.2) Bảng 3.3 Danh sách các API Endpoints và phương thức giao tiếp dịch vụ Firebase / Repositories Chương 3 (Mục 3.2.3) Bảng 3.4 Đặc tả chi tiết các lớp thực thể (Domain Models), Repositories và State Controllers Chương 3 (Mục 3.3) Bảng 4.1 Môi trường phát triển, công cụ IDE và các thư viện / SDK bên thứ ba trong pubspec.yaml Chương 4 (Mục 4.1) Bảng 5.1 Thông số cấu hình các thiết bị kiểm thử (Android Emulator, Thiết bị thật, Web Responsive) Chương 5 (Mục 5.1) Bảng 5.2 Bảng kịch bản kiểm thử chức năng và điều kiện biên (20 Test Cases chính thức) Chương 5 (Mục 5.2) Bảng 5.3 Thống kê kết quả chạy 71 Unit & Widget Tests tự động và 10 kịch bản kiểm định Backend Firebase Chương 5 (Mục 5.2)

3.4. Danh mục hình vẽ

Bảng 0.5. Danh mục các sơ đồ UML, sơ đồ kiến trúc, bản vẽ Wireframe và ảnh chụp giao diện

Số hiệu hình | Tên hình vẽ / Sơ đồ minh họa | Chương mục
---|---|---
Hình 2.1 | Sơ đồ Use Case tổng quát của hệ thống ứng dụng đặt đồ ăn trực tuyến FoodHub | Chương 2 (Mục 2.3.1)
Hình 2.2 | Sơ đồ hoạt động (Activity Diagram) luồng Xác thực tài khoản và Quản lý hồ sơ cá nhân | Chương 2 (Mục 2.3.3)
Hình 2.3 | Sơ đồ hoạt động (Activity Diagram) luồng Tìm kiếm, Giỏ hàng và Đặt hàng thanh toán | Chương 2 (Mục 2.3.3)
Hình 3.1 | Sơ đồ kiến trúc phân tầng phần mềm ứng dụng Flutter và luồng quản lý trạng thái | Chương 3 (Mục 3.1)
Hình 3.2 | Sơ đồ thiết kế dữ liệu Cloud Firestore Collections (NoSQL ERD) và Local Storage | Chương 3 (Mục 3.2)
Hình 3.3 | Sơ đồ lớp (UML Class Diagram) của các thực thể Domain Models, Controllers và Repositories | Chương 3 (Mục 3.3.1)
Hình 3.4 | Sơ đồ tuần tự (Sequence Diagram) cho các thao tác Đăng nhập, Giỏ hàng và Đặt hàng | Chương 3 (Mục 3.3.2)
Hình 3.5 | Sơ đồ chuyển trang (Screen Navigation Flow / Sitemap) tổng thể của ứng dụng | Chương 3 (Mục 3.4.1)
Hình 3.6 | Wireframe màn hình trang chủ (1. Trang chủ) | Chương 3 (Mục 3.4.2)
Hình 3.7 | Wireframe màn hình tìm kiếm và lọc món ăn (2. Tìm kiếm & Lọc) | Chương 3 (Mục 3.4.2)
Hình 3.8 | Wireframe màn hình chi tiết món ăn (3. Chi tiết món ăn) | Chương 3 (Mục 3.4.2)
Hình 3.9 | Wireframe màn hình giỏ hàng (4. Giỏ hàng) | Chương 3 (Mục 3.4.2)
Hình 3.10 | Wireframe màn hình lịch sử đơn hàng (5. Lịch sử đơn hàng) | Chương 3 (Mục 3.4.2)
Hình 3.11 | Sơ đồ tổng hợp luồng thao tác của người dùng từ khi mở ứng dụng đến khi theo dõi đơn hàng | Chương 3 (Mục 3.4.2)
Hình 4.1 | Giao diện thực tế Màn hình Trang chủ (HomeScreen Bento Grid) & Chi tiết Nhà hàng (RestaurantDetailScreen) | Chương 4 (Mục 4.3.1)
Hình 4.2 | Giao diện thực tế Màn hình Tìm kiếm (SearchScreen), Chi tiết món (FoodDetailScreen) & Giỏ hàng (CartScreen) | Chương 4 (Mục 4.3.2)
Hình 4.3 | Giao diện thực tế Màn hình Đăng nhập trên Thiết bị di động (<960px) | Chương 4 (Mục 4.3.3)
Hình 4.4 | Giao diện thực tế Màn hình Đăng nhập Responsive 2 cột trên Máy tính / Tablet (>=960px) | Chương 4 (Mục 4.3.3)
Hình 4.5 | Giao diện thực tế Màn hình Đặt hàng (CheckoutScreen), Lịch sử đơn (OrderHistoryScreen) & Hóa đơn (OrderDetailScreen) | Chương 4 (Mục 4.3.4)

CHƯƠNG 1: TỔNG QUAN VỀ ĐỀ TÀI

1.1. Lý do chọn đề tài

Trong bối cảnh nền kinh tế số Việt Nam đang tăng trưởng nhanh chóng, dịch vụ đặt và giao đồ ăn trực tuyến trên thiết bị di động (Mobile Food Delivery) đã trở thành một phần tất yếu của nhịp sống đô thị hiện đại. Tại các khu vực tập trung đông sinh viên, giảng viên và nhân viên văn phòng — điển hình như khuôn viên  Đại học Phenikaa (Yên Nghĩa, Hà Đông, Hà Nội)  và các quận nội thành — nhu cầu tìm kiếm quán ăn uy tín, đặt bữa trưa/bữa tối nhanh chóng, tùy biến khẩu phần (kích cỡ, đồ ăn kèm) và theo dõi tiến độ giao hàng theo thời gian thực diễn ra liên tục mỗi ngày.

Tuy nhiên, qua khảo sát thực tế thói quen đặt món của sinh viên và các cửa hàng ẩm thực vừa và nhỏ, nhóm nhận thấy vẫn tồn tại nhiều bất cập đáng kể:

•   Thứ nhất, quy trình đặt món thủ công qua tin nhắn hoặc điện thoại còn rời rạc:  Nhiều quán ăn truyền thống xung quanh trường học vẫn nhận đơn qua Zalo, Facebook hoặc gọi điện trực tiếp, dẫn đến tình trạng sót đơn vào giờ cao điểm, nhầm lẫn ghi chú (như "không hành", "thêm trứng", "size L") và người mua không biết chính xác tổng tiền hay phí vận chuyển.

•   Thứ hai, các siêu ứng dụng (Super Apps) trên thị trường có giao diện quá phức tạp và nặng nề:  Nhiều ứng dụng tích hợp hàng chục dịch vụ không liên quan (đặt xe, vé máy bay, tài chính, quảng cáo dày đặc) khiến dung lượng bộ cài lớn, thao tác tìm món rườm rà và dễ gây mất dữ liệu giỏ hàng khi kết nối mạng chập chờn hoặc khi người dùng vô tình tải lại trang trên nền tảng Web/Mobile.

•   Thứ ba, bài toán đồng bộ dữ liệu thời gian thực và bảo toàn lịch sử đơn hàng:  Khi nhà hàng thay đổi giá bán hoặc trạng thái còn/hết món, ứng dụng truyền thống không cập nhật tức thì trên màn hình khách hàng. Đồng thời, nếu thiết kế cơ sở dữ liệu không tách biệt dữ liệu thực đơn hiện tại với dữ liệu快照 (Snapshot) lúc đặt hàng, hóa đơn lịch sử của khách sẽ bị sai lệch khi quán điều chỉnh giá.

Xuất phát từ những yêu cầu thực tiễn đó, cùng mong muốn vận dụng toàn diện kiến thức của học phần  Lập trình cho thiết bị di động , nhóm quyết định lựa chọn đề tài  "Ứng dụng Đặt Đồ Ăn (FoodHub)"  phát triển bằng  Flutter SDK  kết hợp nền tảng đám mây  Google Firebase (Firebase Authentication & Cloud Firestore) . Đây là giải pháp cho phép xây dựng một ứng dụng di động đa nền tảng có giao diện hiện đại chuẩn Material Design 3, tốc độ phản hồi mượt mà, hỗ trợ đồng bộ thời gian thực và bảo mật dữ liệu chặt chẽ.

1.2. Mục tiêu đề tài

Đề tài hướng tới việc xây dựng hoàn chỉnh một hệ thống ứng dụng đặt đồ ăn trực tuyến trên thiết bị di động và nền tảng Web nhằm giải quyết trọn vẹn bài toán kết nối giữa thực khách và các nhà hàng đối tác:

•   Về mặt bài toán nghiệp vụ cần giải quyết:

◦   Cung cấp không gian khám phá ẩm thực trực quan với bố cục  Bento Grid 2+3  phân loại rõ ràng (Món Việt, Đồ ăn nhanh, Combo + Nước, Trà sữa & Cafe, Bánh ngọt & Ăn vặt), tích hợp thẻ ưu đãi Coupon và danh sách nhà hàng đối tác.

◦   Hỗ trợ công cụ tìm kiếm tức thời kết hợp bộ lọc danh mục và sắp xếp đa tiêu chí (theo giá tăng/giảm dần, theo điểm đánh giá sao), giúp người dùng tìm được món ăn phù hợp túi tiền chỉ trong vài giây.

◦   Tự động hóa quy trình tính toán giỏ hàng (tạm tính, tự động miễn phí giao hàng cho đơn từ 150.000đ, áp dụng mã giảm giá 20.000đ), hỗ trợ lưu trữ giỏ hàng hai lớp ( Dual-Layer Persistence  gồm localStorage và Cloud Firestore) chống mất dữ liệu khi mất mạng tạm thời hoặc nhấn F5.

◦   Đảm bảo quy trình đặt hàng (Checkout) minh bạch với  5 phương thức thanh toán  linh hoạt, lưu trữ  OrderItem Snapshot  bất biến và theo dõi trạng thái đơn hàng theo thời gian thực.

•   Về mặt đối tượng người dùng mục tiêu:

◦   Sinh viên, giảng viên và nhân viên văn phòng:  Nhóm người dùng trẻ, thường xuyên sử dụng điện thoại thông minh Android/iOS hoặc trình duyệt máy tính để đặt bữa ăn nhanh gọn, cần giao diện trực quan, minh bạch về giá cả và ưu đãi vận chuyển.

◦   Khách hàng vãng lai (Guest Users):  Người dùng mới muốn duyệt thử thực đơn, xem thông tin nhà hàng, tìm kiếm món và thêm thử vào giỏ hàng trước khi quyết định đăng ký tài khoản để thanh toán.

◦   Các cửa hàng ăn uống và nhà hàng đối tác:  Cần kênh hiển thị thông tin quán (địa chỉ, hotline, giờ mở cửa, đánh giá) và cập nhật thực đơn món ăn theo thời gian thực tới khách hàng.

1.3. Phạm vi nghiên cứu

Để đảm bảo tính khả thi, chiều sâu kỹ thuật và chất lượng kiểm thử trong khuôn khổ đồ án học phần Lập trình cho thiết bị di động, nhóm xác định rõ phạm vi nghiên cứu về chức năng, nền tảng hỗ trợ và môi trường triển khai như trong  Bảng 1.1  dưới đây:

Bảng 1.1. Phạm vi chức năng, nền tảng hỗ trợ và môi trường triển khai của đề tài

Tiêu chí phạm vi Nội dung giới hạn và thông số kỹ thuật hỗ trợ Phạm vi chức năng • Tập trung hoàn thiện phân hệ  Ứng dụng Khách hàng (Customer App)  với đầy đủ  16 User Stories  chia làm 4 phân hệ: (1) Khám phá Trang chủ & Nhà hàng đối tác, (2) Tìm kiếm, Chi tiết món & Giỏ hàng thông minh, (3) Xác thực Firebase Auth & Quản lý hồ sơ cá nhân, (4) Đặt hàng thanh toán (Checkout) & Lịch sử đơn hàng Realtime.
• Tích hợp sẵn công cụ  Quản trị dữ liệu mẫu (Seed Data Migration)  ngay trên ứng dụng để khởi tạo tự động 3 nhà hàng đối tác và 20 món ăn chuẩn lên Cloud Firestore.
• Các cổng thanh toán điện tử (MoMo, ZaloPay, Visa, VietQR) được mô phỏng quy trình xác nhận giao dịch ở mức giao diện người dùng và lưu trạng thái phương thức thanh toán vào đơn hàng. Nền tảng hỗ trợ (Cross-platform) Nhờ kiến trúc đa nền tảng của  Flutter SDK 3.x (Dart ^3.11.0)  và cấu hình lib/firebase_options.dart, mã nguồn hỗ trợ biên dịch và vận hành đồng nhất trên:
•  Android:  Hỗ trợ từ  Android 5.0 (Lollipop — API Level 21)  trở lên, khuyến nghị Android 10.0 – 14.0 (API 29 – 34).
•  iOS:  Hỗ trợ từ  iOS 12.0  trở lên.
•  Web & Desktop:  Tương thích hoàn toàn với Chrome, Edge, Safari (Web) và Windows/macOS phục vụ kiểm thử giao diện thích ứng (Responsive). Môi trường triển khai Backend Triển khai trực tiếp trên nền tảng đám mây  Google Firebase  (Project ID: khanhdeptrai-71a05), sử dụng dịch vụ xác thực  Firebase Authentication  (Email/Password), cơ sở dữ liệu thời gian thực  Cloud Firestore  (NoSQL Document DB) và bảo vệ bằng tệp quy tắc phân quyền  firestore.rules .

1.4. Khảo sát các ứng dụng tương tự (Benchmark)

Trước khi tiến hành thiết kế hệ thống, nhóm đã khảo sát hai ứng dụng giao đồ ăn phổ biến nhất tại thị trường Việt Nam hiện nay là  ShopeeFood  và  GrabFood , đồng thời tham khảo phong cách thiết kế lưới thẻ hiện đại (Bento Grid) từ các ứng dụng thương mại điện tử hàng đầu để định hình lợi thế khác biệt cho  FoodHub .

Bảng 1.2. Bảng phân tích ưu/nhược điểm của các ứng dụng trên thị trường và điểm khác biệt của FoodHub

Tiêu chí so sánh ShopeeFood GrabFood Ứng dụng đề xuất (FoodHub) Ưu điểm nổi bật • Mạng lưới quán ăn nhỏ lẻ và quán vỉa hè rất phong phú.
• Nhiều mã giảm giá theo khung giờ Flash Sale. • Tốc độ định vị và điều phối tài xế ổn định.
• Giao diện danh mục quán ăn chuyên nghiệp, rõ ràng. •  Bố cục Bento Grid 2+3 Pastel  hiện đại, trực quan, truy cập mọi danh mục chỉ với 1 chạm.
• Khởi động cực nhanh, không chứa quảng cáo rác. Nhược điểm tồn tại • Giao diện dày đặc banner quảng cáo, dễ gây rối mắt trên màn hình nhỏ.
• Không hỗ trợ tốt giao diện Web Desktop. • Là một phần của siêu ứng dụng Grab nên bộ cài rất nặng (>150MB).
• Phí giao hàng đơn lẻ thường cao. • Chưa tích hợp định vị GPS bản đồ thời gian thực cho tài xế ngoài đời thực (đang ở mức mô phỏng trạng thái đơn). Cơ chế lưu trữ giỏ hàng & Offline • Phụ thuộc mạnh vào kết nối máy chủ; dễ phải tải lại khi mất sóng. • Lưu giỏ hàng theo từng phiên ứng dụng di động. •  Dual-Layer Persistence:  Đồng bộ tức thời cả localStorage và Cloud Firestore carts/{uid}, giữ nguyên 100% giỏ hàng khi nhấn F5 hoặc mất mạng tạm thời. Khả năng thích ứng màn hình (Responsive) • Chỉ tối ưu cho khung nhìn dọc (Portrait) trên điện thoại. • Chủ yếu thiết kế cho màn hình điện thoại di động. •  Responsive toàn diện:  Tự động chuyển đổi mượt mà giữa bố cục 1 cột Mobile (<960px) và 2 cột Desktop/Tablet (>=960px), hỗ trợ xoay ngang và cỡ chữ 1.5x. Bảo toàn lịch sử giá đơn hàng • Lưu hóa đơn phía máy chủ đóng. • Lưu hóa đơn phía máy chủ đóng. • Cơ chế  OrderItem Snapshot  tường minh tại tầng Model/Repository, đảm bảo đơn giá lịch sử không bao giờ bị biến đổi khi quán cập nhật giá mới.

CHƯƠNG 2: PHÂN TÍCH YÊU CẦU HỆ THỐNG

2.1. Yêu cầu chức năng (Functional Requirements)

Dựa trên kết quả khảo sát thực tế và mục tiêu đề tài, hệ thống ứng dụng đặt đồ ăn  FoodHub  được chia thành  3 nhóm chức năng chính  và cụ thể hóa thành  16 User Stories (US01 – US16) :

2.1.1. Nhóm chức năng xác thực và quản lý tài khoản

•   Đăng ký tài khoản mới (US06):  Cho phép khách vãng lai tạo tài khoản bằng Họ tên, Email và Mật khẩu; kiểm tra tính hợp lệ ngay tại các trường nhập liệu (AuthValidators: tên tối thiểu 2 ký tự, email đúng chuẩn, mật khẩu tối thiểu 8 ký tự và khớp xác nhận mật khẩu); tự động khởi tạo hồ sơ người dùng users/{uid} trên Cloud Firestore gắn liền với UID của Firebase Authentication.

•   Đăng nhập và khôi phục phiên tự động (US07):  Hỗ trợ đăng nhập bằng Email/Mật khẩu với nút ẩn/hiện mật khẩu, hỗ trợ nhấn phím Enter để gửi nhanh, khóa nút gửi khi đang xử lý (isBusy = true) chống bấm trùng, dịch toàn bộ mã lỗi của Firebase SDK sang thông báo tiếng Việt thân thiện và tự động khôi phục phiên đăng nhập khi mở lại ứng dụng.

•   Quản lý và chỉnh sửa hồ sơ cá nhân (US08):  Hiển thị thông tin tài khoản theo thời gian thực (watchById(uid)), cho phép cập nhật Họ tên, Số điện thoại, Địa chỉ giao hàng mặc định và tải lại hồ sơ khi mạng chập chờn. Địa chỉ mặc định này được tự động điền sẵn khi người dùng chuyển sang màn hình Đặt hàng.

•   Đăng xuất an toàn có xác nhận (US09):  Cung cấp hộp thoại AlertDialog xác nhận trước khi kết thúc phiên làm việc để tránh thao tác chạm nhầm, đồng thời hủy các luồng lắng nghe dữ liệu cá nhân cũ nhằm bảo vệ quyền riêng tư.

2.1.2. Nhóm chức năng nghiệp vụ đặt đồ ăn cốt lõi

•   Duyệt Trang chủ Bento Grid & Khuyến mại (US01):  Hiển thị thanh Header thương hiệu, huy hiệu thành viên VIP Platinum, ví thưởng 734K, lưới danh mục  Bento Grid 2+3  màu pastel, hộp 5 tiện ích nhanh, thẻ nhận mã Coupon giảm 18%, thẻ "Tiếp tục đặt món yêu thích" và danh sách món ăn/nhà hàng nổi bật.

•   Khám phá Nhà hàng đối tác (US13):  Xem danh sách nhà hàng và truy cập màn hình chi tiết từng nhà hàng (RestaurantDetailScreen) gồm ảnh bìa, địa chỉ, hotline, trạng thái mở cửa, điểm đánh giá sao, thời gian giao dự kiến và tìm kiếm/lọc thực đơn riêng của nhà hàng đó.

•   Tìm kiếm, Lọc danh mục và Sắp xếp giá (US02):  Tìm kiếm tức thời theo tên món hoặc mô tả (không phân biệt hoa/thường), kết hợp lọc theo 5 danh mục (Món nước, Cơm, Bánh mì, Đồ uống, Ăn vặt) và sắp xếp theo đơn giá tăng/giảm dần hoặc điểm đánh giá.

•   Xem Chi tiết món ăn và Tùy biến khẩu phần (US03):  Hiển thị ảnh lớn, mô tả chi tiết, đánh giá sao, cho phép chọn kích cỡ khẩu phần ( Size S / M / L ), chọn  Topping ăn kèm , điều chỉnh số lượng và thêm vào giỏ hàng.

•   Quản lý Giỏ hàng và Tính phí tự động (US04, US05):  Tăng/giảm số lượng từng món, xóa món kèm thanh thông báo  Hoàn tác (Undo) , tự động tính tổng tạm tính,  miễn phí giao hàng cho đơn từ 150.000đ  (dưới 150.000đ tính phí 15.000đ) và cho phép bật/tắt  Voucher giảm giá 20.000đ .

•   Xác nhận Đặt hàng & Thanh toán 5 phương thức (US10):  Kiểm tra lại danh sách món, chỉnh sửa địa chỉ giao hàng, nhập ghi chú cho quán, chọn 1 trong  5 phương thức thanh toán  (Tiền mặt, MoMo, ZaloPay, Chuyển khoản, Thẻ Visa) và lưu đơn hàng kèm OrderItem Snapshot lên Cloud Firestore.

•   Theo dõi Lịch sử đơn hàng và Xem Hóa đơn chi tiết (US11, US12):  Theo dõi danh sách đơn hàng đã đặt theo thời gian thực với 5 nhãn màu trạng thái trực quan (Chờ xác nhận, Đang chuẩn bị, Đang giao, Đã giao, Đã hủy) và mở xem lại hóa đơn chi tiết (OrderDetailScreen).

2.1.3. Nhóm chức năng bổ trợ, đồng bộ ngoại tuyến và bảo mật

•   Đồng bộ Thực đơn Thời gian thực — Realtime Sync (US14):  Sử dụng cơ chế StreamBuilder kết nối trực tiếp với Cloud Firestore (watchAll, watchByRestaurant, watchByCategory), tự động cập nhật giao diện ngay khi dữ liệu món ăn thay đổi mà không cần tải lại ứng dụng.

•   Lưu trữ ngoại tuyến / cục bộ hai lớp — Offline & Local Persistence (US04):  Giỏ hàng được lưu đồng thời vào window.localStorage và Firestore, kết hợp cơ chế tự động chuyển sang bộ dữ liệu mẫu nội bộ (SampleFoodCatalog) khi thiết bị ngoại tuyến.

•   Nạp dữ liệu mẫu tự động — Seed Data Migration (US15) & Phân quyền bảo mật (US16):  Cung cấp chức năng đồng bộ tự động 20 món ăn và 3 nhà hàng mẫu lên Firestore chỉ bằng 1 nút bấm và bảo vệ nghiêm ngặt dữ liệu người dùng bằng firestore.rules.

Bảng 2.1. Bảng tổng hợp 16 User Stories đặc tả yêu cầu chức năng của hệ thống

Mã US Nhóm chức năng Nội dung đặc tả User Story (Vai trò – Mong muốn – Mục đích) Độ ưu tiên Thành viên phụ trách US01 Trang chủ & Khám phá Là người dùng, tôi muốn xem màn hình Trang chủ với danh mục đồ ăn Bento Grid 2+3, thẻ Coupon ưu đãi, nhà hàng và món ăn nổi bật để nhanh chóng chọn món. Cao Ngô Đức Khang US02 Tìm kiếm & Bộ lọc Là người dùng, tôi muốn tìm kiếm món theo từ khóa kết hợp lọc theo 5 danh mục và sắp xếp theo giá tăng/giảm dần để tìm món phù hợp ngân sách. Cao Ngô Đức Khang US03 Chi tiết món ăn Là người dùng, tôi muốn xem chi tiết món ăn (ảnh, mô tả, giá, sao đánh giá) và tùy chọn Size S/M/L, Topping, số lượng trước khi thêm vào giỏ. Cao Ngô Đức Khang US04 Quản lý giỏ hàng Là người dùng, tôi muốn tăng/giảm số lượng, xóa món (có nút Hoàn tác - Undo) và giữ nguyên giỏ hàng ngay cả khi nhấn F5 hoặc mất mạng tạm thời. Cao Ngô Đức Khang US05 Voucher & Phí giao Là người dùng, tôi muốn hệ thống tự động miễn phí giao hàng cho đơn từ 150.000đ và cho phép áp dụng mã giảm giá Voucher 20.000đ. Trung bình Ngô Đức Khang US06 Đăng ký tài khoản Là khách vãng lai, tôi muốn đăng ký tài khoản mới bằng họ tên, email và mật khẩu để lưu hồ sơ cá nhân và thực hiện đặt hàng. Cao Nguyễn Chí Tài US07 Đăng nhập & Phiên Là thành viên, tôi muốn đăng nhập bằng Email/Mật khẩu (hỗ trợ ẩn/hiện mật khẩu, báo lỗi tiếng Việt) và tự động khôi phục phiên khi mở lại app. Cao Nguyễn Chí Tài US08 Quản lý hồ sơ Là thành viên đã đăng nhập, tôi muốn xem và cập nhật họ tên, số điện thoại, địa chỉ mặc định để địa chỉ này tự động điền sẵn khi đặt món. Cao Nguyễn Chí Tài US09 Đăng xuất an toàn Là thành viên đã đăng nhập, tôi muốn có hộp thoại xác nhận trước khi đăng xuất để tránh thao tác chạm nhầm. Trung bình Nguyễn Chí Tài US10 Đặt hàng & Thanh toán Là khách hàng, tôi muốn kiểm tra lại đơn, sửa địa chỉ nhận, nhập ghi chú và chọn 1 trong 5 phương thức thanh toán để hoàn tất đặt hàng. Cao Bùi Khánh Hưng US11 Lịch sử đơn hàng Là khách hàng, tôi muốn theo dõi danh sách các đơn hàng đã đặt theo thời gian thực cùng nhãn màu trạng thái trực quan. Cao Bùi Khánh Hưng US12 Chi tiết hóa đơn Là khách hàng, tôi muốn xem lại hóa đơn chi tiết của từng đơn hàng (mã đơn, thời gian, đơn giá snapshot lúc đặt, địa chỉ, PTTT và tổng tiền). Cao Bùi Khánh Hưng US13 Nhà hàng đối tác Là người dùng, tôi muốn xem trang chi tiết nhà hàng đối tác (ảnh bìa, địa chỉ, hotline, giờ mở cửa, đánh giá và thực đơn riêng của quán). Cao Nguyễn Đức Khanh US14 Đồng bộ Realtime Là người dùng, tôi muốn thực đơn món ăn tự động cập nhật theo thời gian thực từ Cloud Firestore khi có thay đổi về giá hoặc trạng thái món. Cao Nguyễn Đức Khanh US15 Nạp dữ liệu mẫu Là quản trị viên/nhà phát triển, tôi muốn có công cụ tự động nạp 20 món ăn & 3 nhà hàng mẫu lên Firestore để hệ thống sẵn sàng hoạt động. Trung bình Nguyễn Đức Khanh US16 Bảo mật dữ liệu Là thành viên hệ thống, tôi muốn hồ sơ cá nhân và đơn hàng của mình được bảo vệ nghiêm ngặt bằng Firestore Security Rules chính chủ. Cao Nguyễn Đức Khanh

2.2. Yêu cầu phi chức năng (Non-functional Requirements)

Bên cạnh các yêu cầu chức năng nghiệp vụ, ứng dụng được thiết kế để đáp ứng nghiêm ngặt các tiêu chuẩn phi chức năng về hiệu năng, bảo mật và khả năng tương thích trên thiết bị di động:

Bảng 2.2. Đặc tả chi tiết các yêu cầu phi chức năng của hệ thống

Nhóm tiêu chí Chỉ số kỹ thuật & Yêu cầu cụ thể Giải pháp hiện thực hóa trong dự án 1. Hiệu năng (Performance) •  Tốc độ phản hồi giao diện:  Mọi thao tác chuyển tab, lọc danh mục, tăng/giảm giỏ hàng phản hồi dưới  100ms  (duy trì tốc độ khung hình 60fps).
•  Độ trễ đồng bộ đám mây:  Cập nhật dữ liệu thời gian thực từ Cloud Firestore trong vòng  300ms – 1.000ms .
•  Dung lượng ứng dụng:  Tối ưu hóa tài nguyên để tệp cài đặt APK Release nhỏ gọn ( ~20MB – 25MB ), bản Web bundle tải nhanh. • Sử dụng kiến trúc IndexedStack giữ trạng thái 4 tab chính mà không phải dựng lại cây Widget.
• Áp dụng const constructors triệt để trên toàn bộ Widgets và chỉ vẽ lại vùng giao diện cần thiết bằng ListenableBuilder / StreamBuilder.
• Sử dụng FoodImageHelper có bộ đệm và ảnh đại diện fallback nhẹ. 2. Bảo mật (Security) •  Xác thực người dùng:  Mật khẩu tuyệt đối không lưu trong cơ sở dữ liệu ứng dụng; sử dụng cơ chế mã thông báo  JWT (Firebase ID Token)  tự động làm mới.
•  Phân quyền truy cập (Authorization):  Ngăn chặn hoàn toàn việc đọc/sửa chéo hồ sơ hoặc đơn hàng của người dùng khác.
•  An toàn dữ liệu cục bộ:  Chỉ lưu giỏ hàng (FoodHub_{uid}_v1), không lưu thông tin nhạy cảm dạng rõ ở bộ nhớ trình duyệt. • Ủy quyền toàn bộ việc băm và kiểm tra mật khẩu cho  Firebase Authentication .
• Thiết lập tệp  firestore.rules  kiểm tra điều kiện request.auth != null && request.auth.uid == userId cho users/{uid} và orders/{orderId}.
• Đã kiểm định thực tế bằng 10 kịch bản REST API trong FIREBASE_VERIFICATION.json. 3. Khả năng tương thích (Compatibility & UI) •  Độ phân giải màn hình:  Hiển thị không tràn lề (Zero RenderFlex Overflow) trên mọi kích thước từ màn hình nhỏ 320×568 (iPhone SE), màn hình tiêu chuẩn 390×844, màn hình xoay ngang 568×320 đến màn hình lớn 1280×900.
•  Khả năng tiếp cận (Accessibility):  Không vỡ bố cục khi người dùng phóng to phông chữ hệ thống lên  1.5 lần (textScaler: 1.5x)  hoặc khi bàn phím ảo bật lên.
•  Giao diện & Bảng màu:  Thiết kế chuẩn  Material Design 3 , kết hợp hài hòa giữa các khối thẻ sáng rõ và Header/Badge nền tối (#0F172A) độ tương phản cao. • Sử dụng LayoutBuilder, MediaQuery, SingleChildScrollView, Wrap và Expanded linh hoạt.
• Thiết kế AuthPage tự động chuyển đổi giữa bố cục 1 cột (Mobile <960px) và 2 cột có bảng giới thiệu thương hiệu (Desktop/Tablet >=960px).
• Được kiểm chứng tự động bằng Widget Tests đa khung nhìn trong account_flow_test.dart.

2.3. Mô hình hóa yêu cầu (UML)

2.3.1. Sơ đồ Use Case tổng quát (Actors & Use Cases)

Hệ thống có sự tham gia của  3 tác nhân (Actors)  chính:

•   Khách vãng lai (Guest User):  Người dùng chưa đăng nhập; có thể xem Trang chủ Bento Grid (UC01), khám phá Nhà hàng đối tác (UC02), Tìm kiếm & Lọc món ăn (UC03), xem Chi tiết món (UC04), thêm món vào Giỏ hàng & áp dụng Voucher (UC05), cũng như thực hiện Đăng ký (UC06) hoặc Đăng nhập (UC07).

•   Thành viên đã đăng nhập (Authenticated User):  Kế thừa toàn bộ quyền của Khách vãng lai, đồng thời thực hiện các chức năng yêu cầu định danh UID gồm: Xem & Chỉnh sửa Hồ sơ cá nhân (UC08), Đăng xuất an toàn (UC09), Xác nhận Đặt hàng & Thanh toán (UC10), Theo dõi Lịch sử đơn hàng Realtime (UC11), Xem Chi tiết Hóa đơn & Nạp dữ liệu mẫu (UC12).

•   Hệ thống Phụ trợ Đám mây (Firebase Auth & Cloud Firestore):  Tác nhân hệ thống ngoài chịu trách nhiệm xác thực thông tin đăng nhập, cấp phát UID/JWT Token, lưu trữ tài liệu và đẩy luồng dữ liệu thời gian thực về ứng dụng.

Hình 2.1. Sơ đồ Use Case tổng quát của hệ thống ứng dụng đặt đồ ăn trực tuyến FoodHub

2.3.2. Đặc tả chi tiết các Use Case chính

Dưới đây là các bảng đặc tả chi tiết (bao gồm Tên Use Case, Tác nhân, Tiền điều kiện, Hậu điều kiện, Luồng sự kiện chính và Luồng sự kiện phụ / Ngoại lệ) cho  5 Use Cases cốt lõi nhất  của hệ thống:

Bảng 2.3. Đặc tả chi tiết Use Case UC06 & UC07 — Đăng ký và Đăng nhập tài khoản người dùng

Thuộc tính Use Case Nội dung đặc tả chi tiết Mã & Tên Use Case UC06 / UC07: Đăng ký tài khoản mới & Đăng nhập hệ thống Tác nhân (Actors) Khách vãng lai (Guest User), Hệ thống Firebase Authentication & Cloud Firestore. Mô tả tóm tắt Cho phép người dùng tạo tài khoản mới hoặc đăng nhập vào tài khoản đã có để đồng bộ hồ sơ cá nhân users/{uid} và sử dụng chức năng đặt hàng. Tiền điều kiện (Pre-conditions) • Thiết bị có kết nối mạng Internet.
• Người dùng đang ở trạng thái chưa đăng nhập (AuthController.isSignedIn == false). Hậu điều kiện (Post-conditions) • Phiên xác thực Firebase Auth được thiết lập thành công với mã UID duy nhất.
• Tài liệu hồ sơ users/{uid} được tạo mới hoặc đồng bộ về AuthController.user.
• Ứng dụng tự động điều hướng về màn hình Hồ sơ hoặc tiếp tục luồng Đặt hàng (Checkout). Luồng sự kiện chính (Basic Flow) 1. Người dùng mở tab  Hồ sơ (Profile)  hoặc bấm  Đặt hàng  khi chưa đăng nhập; hệ thống hiển thị màn hình LoginScreen (hoặc chuyển sang RegisterScreen).
2. Người dùng nhập  Email ,  Mật khẩu  (và  Họ tên ,  Xác nhận mật khẩu  nếu đăng ký).
3. Người dùng nhấn nút  "Đăng nhập"  (hoặc  "Đăng ký tài khoản" ) hoặc nhấn phím Enter tại ô mật khẩu.
4. Hệ thống gọi AuthValidators kiểm tra định dạng dữ liệu đầu vào tại chỗ.
5. AuthController bật trạng thái isBusy = true (khóa nút gửi, hiển thị vòng xoay tiến trình) và gọi FirebaseAuthService.signIn() / signUp().
6. Firebase Authentication xác thực thông tin và trả về đối tượng UserCredential chứa UID.
7. UserRepository đọc hoặc ghi thông tin hồ sơ vào users/{uid} trên Cloud Firestore.
8. AuthController cập nhật trạng thái đã đăng nhập và điều hướng người dùng về màn hình đích. Luồng sự kiện phụ & Ngoại lệ (Alternative / Exception Flows) •  4a. Dữ liệu nhập không hợp lệ (Email sai cú pháp, mật khẩu < 8 ký tự, xác nhận mật khẩu lệch):  Hiển thị thông báo lỗi màu đỏ ngay dưới ô nhập liệu tương ứng; dừng gửi yêu cầu lên server.
•  6a. Sai mật khẩu, email không tồn tại hoặc email đã được sử dụng:  FirebaseAuthService bắt ngoại lệ FirebaseAuthException, ánh xạ sang thông báo tiếng Việt rõ ràng ("Email hoặc mật khẩu không chính xác", "Email này đã được đăng ký"); giữ nguyên dữ liệu trên form để người dùng sửa lại.
•  7a. Lỗi mạng khi đồng bộ Firestore sau khi Auth thành công:  Hệ thống vẫn giữ phiên đăng nhập với thông tin tạm từ Firebase Auth, hiển thị cảnh báo nhẹ và cung cấp nút  "Tải lại hồ sơ"  để đồng bộ lại mà không bắt người dùng đăng ký lại.

Bảng 2.4. Đặc tả chi tiết Use Case UC02 & UC03 — Tìm kiếm, Lọc món ăn và Tùy chọn chi tiết món

Thuộc tính Use Case Nội dung đặc tả chi tiết Mã & Tên Use Case UC02 / UC03: Tìm kiếm, Lọc đa tiêu chí và Xem chi tiết món ăn Tác nhân (Actors) Khách vãng lai / Thành viên đã đăng nhập, Cloud Firestore (foods collection). Mô tả tóm tắt Người dùng tìm kiếm món ăn theo từ khóa, lọc theo danh mục, sắp xếp theo giá/đánh giá và tùy chọn kích cỡ (Size S/M/L), Topping trước khi thêm vào giỏ. Tiền điều kiện (Pre-conditions) • Ứng dụng đã khởi tạo danh sách món ăn từ Cloud Firestore (hoặc bộ dữ liệu fallback SampleFoodCatalog). Hậu điều kiện (Post-conditions) • Danh sách món ăn hiển thị chính xác theo điều kiện lọc/sắp xếp.
• Món ăn được chọn cùng cấu hình khẩu phần và số lượng được đẩy vào CartController. Luồng sự kiện chính (Basic Flow) 1. Người dùng chuyển sang tab  Tìm kiếm (SearchScreen)  hoặc chạm vào thanh tìm kiếm / thẻ danh mục trên Trang chủ.
2. Hệ thống hiển thị ô nhập từ khóa, các từ khóa gợi ý xu hướng, dãy ChoiceChip 5 danh mục (Món nước, Cơm, Bánh mì, Đồ uống, Ăn vặt) và bộ chọn sắp xếp.
3. Người dùng nhập từ khóa (ví dụ: "Phở") và chọn danh mục / thứ tự sắp xếp giá.
4. Hệ thống lọc tức thời trên tập dữ liệu món ăn và hiển thị danh sách kết quả khớp điều kiện.
5. Người dùng chạm vào một món ăn để mở màn hình  Chi tiết món ăn (FoodDetailScreen) .
6. Người dùng xem mô tả, chọn  Size (S / M / L) , tích chọn  Topping thêm , điều chỉnh  Số lượng (- / +)  và nhấn  "Thêm vào giỏ" . Luồng sự kiện phụ & Ngoại lệ (Alternative / Exception Flows) •  4a. Không có món ăn nào khớp từ khóa tìm kiếm:  Hệ thống hiển thị giao diện trạng thái trống (Empty State) kèm thông báo "Không tìm thấy món ăn phù hợp" và nút  "Xóa bộ lọc"  để quay về danh sách đầy đủ.
•  5a. Món ăn đang ở trạng thái hết hàng (isAvailable == false):  Hệ thống hiển thị nhãn "Tạm hết hàng" và vô hiệu hóa nút thêm vào giỏ.

Bảng 2.5. Đặc tả chi tiết Use Case UC04 & UC05 — Quản lý Giỏ hàng lưu trữ kép và Áp dụng ưu đãi

Thuộc tính Use Case Nội dung đặc tả chi tiết Mã & Tên Use Case UC04 / UC05: Quản lý Giỏ hàng (Dual-Layer Persistence) & Tính phí/Voucher Tác nhân (Actors) Người dùng (Guest / Member), Bộ nhớ cục bộ (localStorage) & Cloud Firestore (carts/{uid}). Mô tả tóm tắt Quản lý danh sách món đã chọn, điều chỉnh số lượng, xóa món có hoàn tác (Undo), tự động tính phí giao hàng, áp mã giảm giá và bảo toàn giỏ hàng khi tải lại trang (F5). Tiền điều kiện (Pre-conditions) • Người dùng đã thêm ít nhất 1 món ăn vào giỏ hàng hoặc có dữ liệu giỏ hàng lưu từ phiên trước. Hậu điều kiện (Post-conditions) • Số lượng món, tổng tạm tính, phí giao hàng và giảm giá được cập nhật chính xác trên UI và đồng bộ xuống cả localStorage lẫn Firestore. Luồng sự kiện chính (Basic Flow) 1. Người dùng mở tab  Giỏ hàng (CartScreen) .
2. CartController hiển thị danh sách CartItem hiện có cùng đơn giá và thành tiền từng món.
3. Người dùng nhấn nút + hoặc - để tăng/giảm số lượng món, hoặc bật công tắc áp dụng  Mã giảm giá Voucher (-20.000đ) .
4. CartController tự động tính lại:
   • subtotal = Σ(price × quantity)
   • deliveryFee = (subtotal >= 150000) ? 0 : 15000 (Miễn phí giao hàng cho đơn từ 150.000đ)
   • finalTotal = max(0, subtotal + deliveryFee - discount)
5. Mọi thay đổi được ghi tức thời vào localStorage (FoodHub_{uid}_v1) và đồng bộ bất đồng bộ lên carts/{uid} trên Firestore. Luồng sự kiện phụ & Ngoại lệ (Alternative / Exception Flows) •  3a. Người dùng giảm số lượng xuống 0 hoặc nhấn biểu tượng thùng rác xóa món:  Món ăn được đưa ra khỏi danh sách; hệ thống hiển thị SnackBar kèm nút  "Hoàn tác (Undo)"  để khôi phục lại món nếu bấm nhầm.
•  5a. Người dùng nhấn F5 (Tải lại trình duyệt) hoặc tắt/mở lại ứng dụng:  CartController._initializePersistence() đọc lại dữ liệu từ localStorage ngay lập tức (0ms độ trễ) và đối chiếu với Firestore để không bị mất bất kỳ món nào.

Bảng 2.6. Đặc tả chi tiết Use Case UC10 — Xác nhận Đặt hàng và Thanh toán đa phương thức (Checkout)

Thuộc tính Use Case Nội dung đặc tả chi tiết Mã & Tên Use Case UC10: Đặt hàng và Thanh toán (Checkout & Order Snapshot) Tác nhân (Actors) Thành viên đã đăng nhập (Authenticated User), Cloud Firestore (orders collection). Mô tả tóm tắt Khách hàng kiểm tra lại đơn hàng, xác nhận địa chỉ nhận hàng, nhập ghi chú, chọn phương thức thanh toán và tạo đơn hàng chính thức trên Cloud Firestore. Tiền điều kiện (Pre-conditions) • Giỏ hàng có ít nhất 1 món ăn (!cartController.isEmpty).
• Người dùng đã đăng nhập (authController.isSignedIn == true). Hậu điều kiện (Post-conditions) • Một tài liệu mới orders/{orderId} chứa danh sách OrderItem snapshot được lưu thành công trên Cloud Firestore.
• Giỏ hàng hiện tại được làm trống (cartController.clear()).
• Người dùng được chuyển tới màn hình theo dõi lịch sử đơn hàng. Luồng sự kiện chính (Basic Flow) 1. Tại màn hình Giỏ hàng, người dùng nhấn nút  "Đặt hàng" .
2. Hệ thống kiểm tra trạng thái đăng nhập và mở màn hình  Xác nhận đặt hàng (CheckoutScreen) .
3. Hệ thống tự động điền sẵn  Địa chỉ giao hàng  từ hồ sơ cá nhân của người dùng (AuthController.user.address), cho phép người dùng chỉnh sửa nếu muốn giao tới địa chỉ khác.
4. Người dùng nhập  Ghi chú đơn hàng  (tùy chọn) và chọn  1 trong 5 phương thức thanh toán : Tiền mặt (COD), Ví MoMo, Ví ZaloPay, Chuyển khoản ngân hàng, hoặc Thẻ Visa.
5. Người dùng nhấn nút  "Xác nhận đặt hàng" 6. Hệ thống kiểm tra tính hợp lệ của địa chỉ giao hàng (không rỗng).
7. Hệ thống chuyển đổi danh sách CartItem thành danh sách OrderItem (lưu snapshot foodId, foodName, size, toppings, unitPrice, quantity, note độc lập với giá món ăn hiện tại).
8. Hệ thống khởi tạo đối tượng Order mới với id = "ORD-" + millisecondsSinceEpoch, status = OrderStatus.delivering, createdAt = DateTime.now(). Luồng sự kiện phụ & Ngoại lệ (Alternative / Exception Flows) •  2a. Người dùng chưa đăng nhập khi nhấn Đặt hàng:  Hệ thống hiển thị thông báo yêu cầu đăng nhập và điều hướng sang LoginScreen; sau khi đăng nhập thành công, người dùng tiếp tục đặt hàng với giỏ hàng được giữ nguyên.
•  3a. Người dùng để trống địa chỉ nhận hàng:  Hệ thống cảnh báo "Vui lòng nhập địa chỉ giao hàng" và không gửi đơn cho tới khi địa chỉ hợp lệ.

Bảng 2.7. Đặc tả chi tiết Use Case UC02/US13 & US14 — Khám phá Nhà hàng đối tác và Thực đơn Realtime

Thuộc tính Use Case Nội dung đặc tả chi tiết Mã & Tên Use Case UC02 (US13 & US14): Khám phá Chi tiết Nhà hàng đối tác & Đồng bộ Thực đơn Realtime Tác nhân (Actors) Người dùng (Guest / Member), Cloud Firestore (restaurants & foods collections). Mô tả tóm tắt Cho phép người dùng xem thông tin chi tiết của một nhà hàng đối tác và duyệt danh sách món ăn của riêng nhà hàng đó với dữ liệu cập nhật thời gian thực. Tiền điều kiện (Pre-conditions) • Người dùng đang ở màn hình Trang chủ (HomeScreen) tại mục "Nhà hàng nổi bật". Hậu điều kiện (Post-conditions) • Màn hình RestaurantDetailScreen hiển thị đầy đủ thông tin quán và thực đơn món ăn được lọc theo restaurantId. Luồng sự kiện chính (Basic Flow) 1. Trên màn hình Trang chủ, người dùng chạm vào một thẻ nhà hàng trong danh sách RestaurantSection.
2. Hệ thống điều hướng sang RestaurantDetailScreen và truyền đối tượng Restaurant được chọn.
3. Hệ thống hiển thị ảnh bìa nhà hàng, tên quán, nhãn trạng thái (*Đang mở cửa* / *Tạm đóng cửa*), điểm đánh giá sao, thời gian giao dự kiến, địa chỉ và số điện thoại liên hệ.
4. Màn hình đăng ký lắng nghe luồng dữ liệu FoodRepository.watchByRestaurant(restaurant.id).
5. Người dùng có thể tìm kiếm món ăn trong phạm vi nhà hàng, lọc theo danh mục con, bấm xem chi tiết món hoặc bấm  "+ Thêm"  để đưa món thẳng vào giỏ hàng kèm thanh tóm tắt giỏ hàng ở đáy màn hình. Luồng sự kiện phụ & Ngoại lệ (Alternative / Exception Flows) •  4a. Firestore chưa có dữ liệu hoặc thiết bị ngoại tuyến:  Hệ thống tự động fallback sang danh sách món ăn của nhà hàng tương ứng trong SampleFoodCatalog để đảm bảo trải nghiệm liền mạch không bị trắng màn hình.

2.3.3. Sơ đồ hoạt động (Activity Diagrams) cho các luồng nghiệp vụ cốt lõi

Để làm rõ trình tự xử lý logic, các điểm rẽ nhánh điều kiện và sự phối hợp giữa thao tác người dùng (Actor), tầng giao diện/trạng thái (Flutter UI & Controllers) và tầng dữ liệu (Cloud Firestore & LocalStorage), nhóm xây dựng  2 sơ đồ hoạt động (Activity Diagrams)  cho hai luồng nghiệp vụ quan trọng nhất:

•   Luồng 1 (Hình 2.2):  Sơ đồ hoạt động luồng  Xác thực người dùng, Khôi phục phiên và Quản lý hồ sơ cá nhân  (Đăng nhập, Đăng ký, Kiểm định form, Đồng bộ users/{uid}, Chỉnh sửa hồ sơ và Đăng xuất có xác nhận).

•   Luồng 2 (Hình 2.3):  Sơ đồ hoạt động luồng  Tìm kiếm món ăn, Quản lý giỏ hàng lưu trữ kép và Đặt hàng thanh toán (Checkout)  chia theo 3 làn bơi (Swimlanes) rõ ràng.

Hình 2.2. Sơ đồ hoạt động (Activity Diagram) luồng Xác thực tài khoản và Quản lý hồ sơ cá nhân

Hình 2.3. Sơ đồ hoạt động (Activity Diagram) luồng Tìm kiếm, Giỏ hàng và Đặt hàng thanh toán

CHƯƠNG 3: THIẾT KẾ HỆ THỐNG & GIAO DIỆN

3.1. Kiến trúc phần mềm ứng dụng

3.1.1. Mô hình kiến trúc lựa chọn (Layered Clean Architecture & Repository Pattern)

Để đảm bảo mã nguồn dễ bảo trì, dễ mở rộng, tách biệt hoàn toàn giữa giao diện hiển thị (UI) và logic truy xuất cơ sở dữ liệu đám mây, đồng thời cho phép 4 thành viên làm việc song song mà không xảy ra xung đột mã nguồn (Git merge conflicts), nhóm lựa chọn  Kiến trúc phân tầng (Layered Clean Architecture)  kết hợp tổ chức thư mục theo tính năng ( Feature-first ) và mẫu thiết kế  Repository Pattern / MVVM :

•   Tầng 1 — Presentation Layer (lib/features/):  Bao gồm toàn bộ các màn hình (HomeScreen, RestaurantDetailScreen, SearchScreen, FoodDetailScreen, CartScreen, CheckoutScreen, OrderHistoryScreen, OrderDetailScreen, LoginScreen, RegisterScreen, ProfileScreen, EditProfileScreen) và các Widget thành phần. Tầng UI tuyệt đối không gọi trực tiếp SDK của Cloud Firestore hay Firebase Auth mà chỉ giao tiếp thông qua Controllers và Repositories.

•   Tầng 2 — State Management & Controllers Layer (lib/state/):  Bao gồm CartController và AuthController kế thừa từ lớp ChangeNotifier của Flutter SDK, đóng vai trò như tầng  ViewModel  trong mô hình MVVM. Tầng này nắm giữ trạng thái phiên đăng nhập, trạng thái giỏ hàng, xử lý kiểm định dữ liệu và phát tín hiệu notifyListeners() để cập nhật giao diện.

•   Tầng 3 — Domain Models & Repository / Service Layer (lib/models/, lib/repositories/, lib/services/):  Bao gồm 6 lớp thực thể dữ liệu (User, Restaurant, Food, CartItem, Order, OrderItem) với các phương thức ánh xạ dữ liệu ORM (fromMap, toMap, copyWith), cùng 4 lớp Repository (FoodRepository, RestaurantRepository, UserRepository, OrderRepository) và giao diện AuthService (FirebaseAuthService & DemoAuthService).

•   Tầng 4 — Data & Cloud Persistence Layer (Firebase & Local Storage):  Bao gồm dịch vụ đám mây  Firebase Authentication ,  Cloud Firestore  (project khanhdeptrai-71a05) và bộ nhớ cục bộ localStorage (lib/core/storage/).

Hình 3.1. Sơ đồ kiến trúc phân tầng phần mềm ứng dụng Flutter và cơ sở dữ liệu Firebase

3.1.2. Quản lý trạng thái (State Management) và Luồng dữ liệu (Data Flow)

Ứng dụng áp dụng giải pháp quản lý trạng thái kết hợp giữa  Reactive ChangeNotifier (ListenableBuilder)  cho trạng thái ứng dụng toàn cục và  Reactive Streams (StreamBuilder)  cho dữ liệu thời gian thực từ Cloud Firestore, tuân thủ nghiêm ngặt nguyên lý  Luồng dữ liệu một chiều (Unidirectional Data Flow) :

•   Quản lý trạng thái Giỏ hàng (CartController):  Khởi tạo tại MainNavigation và truyền xuống các màn hình con. Khi người dùng thêm món, tăng/giảm số lượng, xóa món hoặc áp mã giảm giá, UI phát sự kiện (Action) tới CartController. Controller cập nhật danh sách _items, ghi xuống localStorage + Firestore và gọi notifyListeners() để mọi ListenableBuilder (badge số lượng trên thanh điều hướng, tổng tiền giỏ hàng) tự động vẽ lại tức thì.

•   Quản lý trạng thái Xác thực & Hồ sơ (AuthController):  Lắng nghe luồng authStateChanges() từ Firebase Auth và watchById(uid) từ UserRepository. Quản lý đồng nhất các trạng thái: user (hồ sơ hiện tại), isSignedIn (đã đăng nhập hay chưa), isBusy (đang xử lý mạng), errorMessage (lỗi xác thực tiếng Việt) và infoMessage (thông báo thành công).

•   Luồng dữ liệu thời gian thực (StreamBuilder):  Các màn hình thực đơn (HomeScreen, RestaurantDetailScreen) và lịch sử đơn hàng (OrderHistoryScreen) đăng ký lắng nghe trực tiếp Stream<List<Food>>, Stream<List<Restaurant>> và Stream<List<Order>> từ tầng Repository. Ngay khi dữ liệu trên Cloud Firestore thay đổi, gói tin snapshot mới được đẩy về Repository, ánh xạ qua fromMap() thành danh sách đối tượng Dart và tự động kết xuất lại giao diện.

3.2. Thiết kế dữ liệu

3.2.1. Cơ sở dữ liệu cục bộ (Local DB / Local Storage)

Để đảm bảo tốc độ khởi động tức thì (0ms latency) và chống mất dữ liệu giỏ hàng hay phiên đăng nhập khi người dùng tải lại trang (F5) hoặc mất kết nối mạng đột ngột, ứng dụng thiết kế tầng lưu trữ cục bộ theo cấu trúc  Key-Value JSON  thông qua cơ chế  Conditional Import  (lib/core/storage/cart_storage.dart tự động chọn cart_storage_web.dart trên Web hoặc cart_storage_stub.dart trên Mobile/Test) kết hợp bộ đệm phiên cục bộ của Firebase Auth SDK:

Bảng 3.1. Thiết kế cấu trúc lưu trữ dữ liệu cục bộ (Local Storage & Auth Token Cache)

Khóa lưu trữ (Storage Key) Nơi lưu trữ cục bộ Cấu trúc dữ liệu (JSON Schema / Value) Mục đích sử dụng foodhub_​{uid}_​v1 window.localStorage /​ Bộ nhớ cục bộ ứng dụng (CartStorage) {"restaurantId": "r1",​ "deliveryAddress": "...",​ "updatedAt": "...",​ "items": [{"food": {...},​ "quantity": 2,​ "size": "Size L",​ "toppings": ["Thêm phô mai (+10k)"],​ "unitPrice": 65000.0,​ "note": "Ít cay"}]} Lưu trữ bền vững trạng thái giỏ hàng hiện tại trên trình duyệt (đồng bộ 100% cấu trúc với carts/​{uid} trên Firestore). firebase:authUser:[API_​KEY] IndexedDB /​ Keychain /​ Encrypted SharedPreferences (do Firebase Auth SDK quản lý) Đối tượng JSON chứa:
• uid: Mã định danh người dùng
• email,​ displayName
• stsTokenManager: accessToken (JWT),​ refreshToken,​ expirationTime Lưu trữ an toàn mã thông báo xác thực  JWT (JSON Web Token)  để tự động khôi phục phiên đăng nhập khi người dùng tắt và mở lại ứng dụng. Firestore Offline Cache IndexedDB /​ SQLite nội bộ của Cloud Firestore SDK Bản sao cục bộ các Document thuộc collections foods,​ restaurants,​ users/​{uid},​ orders đã truy vấn gần nhất. Hỗ trợ đọc dữ liệu ngoại tuyến và xếp hàng (queue) các thao tác ghi khi thiết bị mất mạng tạm thời.

3.2.2. Cơ sở dữ liệu đám mây (Cloud Firestore Collections & NoSQL ERD)

Hệ thống phụ trợ sử dụng  Google Cloud Firestore  (Project ID: khanhdeptrai-71a05) — một cơ sở dữ liệu NoSQL hướng tài liệu (Document-oriented) thời gian thực. Cấu trúc cơ sở dữ liệu gồm  5 Collections chính , được thiết kế tối ưu cho truy vấn thời gian thực và bảo toàn lịch sử đơn hàng bằng kỹ thuật nhúng  Embedded Snapshot (OrderItem) :

Hình 3.2. Sơ đồ thiết kế dữ liệu Cloud Firestore Collections (NoSQL ERD) và Local Storage

Bảng 3.2. Thiết kế chi tiết các Collections trên Cloud Firestore và quy tắc bảo mật (firestore.rules)

Collection & Document Path Khóa chính / Khóa ngoại Các trường dữ liệu (Fields & Kiểu dữ liệu) Quy tắc phân quyền (firestore.rules) users/​{uid} 
*(Hồ sơ người dùng)* •  PK:  uid (Trùng 100% với Firebase Auth UID) • name (String): Họ và tên người dùng
• email (String): Địa chỉ email đăng nhập
• phone (String): Số điện thoại liên hệ
• address (String): Địa chỉ giao hàng mặc định
• photoUrl (String): Đường dẫn ảnh đại diện
• updatedAt (Timestamp): Thời điểm cập nhật allow read,​ write: if request.auth != null && request.auth.uid == uid; restaurants/​{restaurantId} 
*(Nhà hàng đối tác)* •  PK:  restaurantId (r1,​ r2,​ r3...) • name (String): Tên nhà hàng đối tác
• address (String): Địa chỉ cửa hàng
• description (String): Mô tả chuyên môn quán
• phone (String): Hotline nhà hàng
• imageUrl (String): URL ảnh đại diện quán
• rating (double): Điểm đánh giá (0.0 – 5.0)
• isOpen (bool): Trạng thái đang mở cửa allow read: if true; allow write: if isAdmin(); (Chỉ Admin/​Backend được sửa nhà hàng) foods/​{foodId} 
*(Thực đơn món ăn)* •  PK:  foodId (f1..f20)
•  FK:  restaurantId tham chiếu restaurants/​{id} • restaurantId (String): Mã nhà hàng cung cấp
• name (String): Tên món ăn
• price (double): Đơn giá hiện tại (VNĐ)
• category (String): Danh mục (Món nước,​ Cơm...)
• description (String): Mô tả thành phần món
• imageUrl (String): URL hình ảnh món ăn
• isAvailable (bool): Trạng thái còn/​hết món
• rating (double): Điểm sao đánh giá món allow read: if true; allow write: if isAdmin(); (Chỉ Admin/​Backend được sửa giá và thực đơn) orders/​{orderId} 
*(Đơn đặt hàng)* •  PK:  orderId (Auto ID)
•  FK:  userId tham chiếu users/​{uid} createdAt timestamp (ISO 8601 /​ Timestamp) Thời điểm tạo đơn hàng (thống nhất tên trường createdAt trên toàn hệ thống). items array<map> Danh sách OrderItem snapshot: {foodId,​ foodName,​ quantity,​ size,​ toppings,​ unitPrice,​ note} (giữ nguyên giá,​ size và topping tại thời điểm đặt). Quyền truy cập (firestore.rules) Security Rule read,​ create: owner (userId == auth.uid); update status: isAdmin(); delete: false (Section 5: carts/​{uid} chỉ cho phép chủ sở hữu auth.uid == uid đọc/​ghi).

3.2.3. Danh sách các API Endpoints và Giao thức giao tiếp dịch vụ

Ứng dụng giao tiếp với hệ thống phụ trợ Google Firebase thông qua giao thức HTTPS / WebSockets (gRPC) của bộ SDK chính thức (firebase_auth và cloud_firestore) cũng như REST API chuẩn của Google Identity Toolkit & Firestore REST v1.  Bảng 3.3  liệt kê chi tiết danh sách các API Endpoints và phương thức Repository tương ứng:

Bảng 3.3. Danh sách các API Endpoints và phương thức giao tiếp dữ liệu của hệ thống

Phương thức Đường dẫn Endpoint / Collection & Hàm Repository Dữ liệu truyền vào (Request Payload) Dữ liệu trả về (Response Data) POST identitytoolkit.googleapis.com/​v1/​accounts:signUp
(FirebaseAuthService.signUp) { email,​ password,​ returnSecureToken: true } kèm name UserCredential (uid,​ idToken JWT,​ refreshToken) POST identitytoolkit.googleapis.com/​v1/​accounts:signInWithPassword
(FirebaseAuthService.signIn) { email,​ password,​ returnSecureToken: true } UserCredential (uid,​ idToken JWT) & đồng bộ User GET /​ STREAM Firestore: /​users/​{uid}
(UserRepository.getById /​ watchById) uid (String — Firebase Auth UID) + Header Bearer <JWT> Đối tượng User (id,​ name,​ email,​ phone,​ address) PUT /​ PATCH Firestore: /​users/​{uid}
(UserRepository.save /​ updateProfile) User.toMap() + updatedAt: serverTimestamp() (SetOptions(merge: true)) Trạng thái hoàn tất (Future<void>) & phát sự kiện stream mới GET /​ STREAM Firestore: /​restaurants & /​restaurants/​{id}
(RestaurantRepository.getAll /​ watchAll) Truy vấn toàn bộ collection restaurants List<Restaurant> hoặc Stream<List<Restaurant>> GET /​ STREAM Firestore: /​foods (lọc theo restaurantId /​ category)
(FoodRepository.watchAll /​ watchByRestaurant) Tham số lọc tùy chọn: restaurantId hoặc category Stream<List<Food>> cập nhật thời gian thực POST /​ PUT Firestore: /​foods/​{id} & /​restaurants/​{id}
(SampleFoodCatalog.seedAllData) Danh sách 3 Restaurant.toMap() và 20 Food.toMap() Khởi tạo /​ cập nhật đồng bộ toàn bộ thực đơn mẫu trên Cloud POST Firestore: /​orders (Auto Document ID)
(OrderRepository.create) Order.toMap() (userId,​ items[] snapshot,​ totalPrice,​ deliveryAddress,​ paymentMethod,​ note,​ createdAt) Future<String> trả về mã đơn hàng orderId vừa tạo GET /​ STREAM Firestore: /​orders?where=userId
(OrderRepository.watchByUser(uid)) orders (add & orderBy("createdAt")) Stream<List<Order>> lịch sử đơn hàng thời gian thực PUT /​ DELETE localStorage (foodhub_​{uid}_​v1) carts/​{uid} (set /​ get /​ delete) Lưu trữ thành công ở cả 2 tầng (Local & Cloud)

3.3. Thiết kế chi tiết các lớp & tương tác

3.3.1. Sơ đồ lớp (UML Class Diagram) của các thực thể và tầng xử lý chính

Hệ thống đối tượng của ứng dụng được thiết kế chặt chẽ theo nguyên lý lập trình hướng đối tượng (OOP) trong ngôn ngữ Dart, đảm bảo tính đóng gói (Encapsulation), bất biến (Immutability với từ khóa final và phương thức copyWith) và tách biệt trách nhiệm (Single Responsibility Principle):

Hình 3.3. Sơ đồ lớp (UML Class Diagram) của các thực thể Domain Models, State Controllers và tầng Repositories

Bảng 3.4. Đặc tả chi tiết các lớp thực thể (Models), tầng truy xuất dữ liệu (Repositories) và điều khiển trạng thái (Controllers)

Tên lớp & Tệp nguồn Thuộc tính chính (Attributes) Phương thức & Trách nhiệm cốt lõi (Methods & Responsibilities) User 
(lib/​models/​user.dart) id,​ name,​ phone,​ address,​ email,​ photoUrl • fromMap(map,​ {id}),​ toMap(),​ copyWith(),​ updateAddress(newAddress).
• Biểu diễn hồ sơ người dùng gắn liền với UID của Firebase Authentication. Restaurant 
(lib/​models/​restaurant.dart) id,​ name,​ address,​ description,​ imageUrl,​ phone,​ rating,​ isOpen • fromMap(map,​ {id}),​ toMap().
• Biểu diễn thông tin nhà hàng đối tác cung cấp món ăn trên hệ thống. Food 
(lib/​models/​food.dart) id,​ restaurantId,​ name,​ price,​ description,​ category,​ imageUrl,​ isAvailable,​ rating • fromMap(map,​ {id}),​ toMap(),​ copyWith().
• Biểu diễn món ăn trên thực đơn; kiểm tra ràng buộc price >= 0. CartItem 
(lib/​models/​cart_​item.dart) food,​ quantity,​ size,​ toppings,​ unitPrice,​ note totalPrice (getter),​ itemKey,​ copyWith(),​ toOrderItem(),​ toMap(),​ fromMap() OrderItem 
(lib/​models/​order.dart) foodId,​ foodName,​ quantity,​ size,​ toppings,​ unitPrice,​ note • subtotal (unitPrice * quantity),​ fromMap(map),​ toMap().
•  Lưu ảnh chụp bất biến (Snapshot) Lưu trữ bản chụp (snapshot) của món ăn (gồm cả Size S/​M/​L,​ danh sách Topping và đơn giá unitPrice tại thời điểm đặt hàng). Đảm bảo nếu giá món ăn gốc thay đổi trong tương lai hoặc người dùng đặt món Size L kèm topping,​ lịch sử đơn hàng vẫn giữ nguyên thông tin và số tiền lịch sử. Order 
(lib/​models/​order.dart) id,​ userId,​ restaurantId,​ restaurantName,​ items,​ subtotal,​ shippingFee,​ discount,​ totalAmount,​ createdAt,​ status,​ paymentMethod,​ deliveryAddress,​ note totalPrice (alias),​ orderDate (alias -> createdAt),​ copyWith(),​ fromMap(),​ toMap() FoodRepository & RestaurantRepository 
(lib/​repositories/​) _​foods (CollectionReference),​ _​restaurants (CollectionReference) • getAll(),​ watchAll(),​ watchByRestaurant(id),​ watchByCategory(cat),​ getById(id),​ add(),​ update(),​ delete(). UserRepository & OrderRepository 
(lib/​repositories/​) _​users (CollectionReference),​ _​orders (CollectionReference) • getById(uid),​ watchById(uid),​ save(user),​ updateProfile().
• create(order) (kiểm tra ràng buộc hợp lệ trước khi ghi),​ watchByUser(uid). CartController 
(lib/​state/​cart_​controller.dart) _​items (List<CartItem>),​ _​deliveryAddress,​ subtotal,​ deliveryFee,​ totalPrice • addItem(),​ increaseQuantity(),​ decreaseQuantity(),​ removeItem(),​ clear(),​ _​persistCart(),​ _​initializePersistence(). AuthController 
(lib/​state/​auth_​controller.dart) _​service (AuthService),​ user,​ isSignedIn,​ isBusy,​ errorMessage,​ infoMessage • signIn(),​ signUp(),​ updateProfile(),​ refreshProfile(),​ signOut(),​ _​run() (chống gọi trùng khi isBusy).

3.3.2. Sơ đồ tuần tự (Sequence Diagrams) cho các thao tác quan trọng

Sơ đồ tuần tự trong  Hình 3.4  minh họa chi tiết thông điệp trao đổi theo trình tự thời gian giữa  Người dùng (Actor) ,  Giao diện Flutter (UI Screens) ,  Bộ điều khiển trạng thái (AuthController / CartController) ,  Tầng Repositories  và  Dịch vụ đám mây Firebase (Firebase Auth & Cloud Firestore)  qua 3 kịch bản cốt lõi: (1) Đăng nhập & Đồng bộ hồ sơ, (2) Thêm món vào giỏ & Đồng bộ Dual-Layer, (3) Xác nhận đặt hàng (Checkout) & Tạo OrderItem Snapshot.

Hình 3.4. Sơ đồ tuần tự (Sequence Diagram) cho các thao tác Đăng nhập, Giỏ hàng và Đặt hàng

3.4. Thiết kế giao diện người dùng (UI/UX)

3.4.1. Sơ đồ chuyển trang (Screen Navigation Flow / Sitemap)

Hệ thống điều hướng của ứng dụng được tổ chức xoay quanh trục trung tâm là màn hình  MainNavigation  (lib/main.dart) sử dụng thanh điều hướng dưới  NavigationBar  chuẩn Material Design 3 gồm  4 Tab chính : Trang chủ (Home), Tìm kiếm (Search), Giỏ hàng (Cart - có Badge đếm số món) và Hồ sơ (Profile). Từ 4 tab gốc này, người dùng có thể điều hướng mượt mà tới 8 màn hình chức năng chuyên sâu như thể hiện trên  Hình 3.5 :

Hình 3.5. Sơ đồ chuyển trang (Screen Navigation Flow / Sitemap) tổng thể của ứng dụng

3.4.2. Thiết kế Wireframe và mô tả luồng thao tác

3.4.2.1. Wireframe màn hình trang chủ

![Hình 3.6. Wireframe màn hình trang chủ (1. Trang chủ)](report_images/wireframe_1_trang_chu.png)

Hình 3.6. Wireframe màn hình trang chủ (1. Trang chủ)

Mô tả giao diện:  
Màn hình trang chủ là giao diện đầu tiên người dùng nhìn thấy khi truy cập ứng dụng FoodHub. Màn hình bao gồm thanh tìm kiếm, khu vực banner quảng cáo, danh mục món ăn, danh sách món ăn nổi bật và thanh điều hướng phía dưới.

Luồng thao tác:
1. Người dùng mở ứng dụng FoodHub.
2. Hệ thống hiển thị màn hình trang chủ.
3. Người dùng xem các danh mục và món ăn được đề xuất.
4. Người dùng có thể chọn một món ăn để xem thông tin chi tiết.
5. Người dùng có thể sử dụng thanh tìm kiếm để tìm món ăn hoặc nhà hàng.
6. Người dùng có thể chuyển sang các màn hình Tìm kiếm, Giỏ hàng hoặc Tài khoản thông qua thanh điều hướng.

3.4.2.2. Wireframe màn hình tìm kiếm và lọc món ăn

![Hình 3.7. Wireframe màn hình tìm kiếm và lọc món ăn (2. Tìm kiếm & Lọc)](report_images/wireframe_2_tim_kiem.png)

Hình 3.7. Wireframe màn hình tìm kiếm và lọc món ăn (2. Tìm kiếm & Lọc)

Mô tả giao diện:  
Màn hình tìm kiếm cung cấp chức năng tìm kiếm món ăn theo tên, đồng thời hỗ trợ lọc món ăn theo danh mục và sắp xếp danh sách theo giá.

Luồng thao tác:
1. Người dùng chọn mục Tìm kiếm trên thanh điều hướng.
2. Hệ thống hiển thị giao diện tìm kiếm món ăn.
3. Người dùng nhập tên món ăn vào ô tìm kiếm.
4. Hệ thống hiển thị danh sách món ăn phù hợp với từ khóa.
5. Người dùng chọn danh mục món ăn hoặc tiêu chí sắp xếp.
6. Hệ thống cập nhật danh sách theo điều kiện đã chọn.
7. Người dùng chọn một món ăn để chuyển đến màn hình chi tiết.

3.4.2.3. Wireframe màn hình chi tiết món ăn

![Hình 3.8. Wireframe màn hình chi tiết món ăn (3. Chi tiết món ăn)](report_images/wireframe_3_chi_tiet_mon.png)

Hình 3.8. Wireframe màn hình chi tiết món ăn (3. Chi tiết món ăn)

Mô tả giao diện:  
Màn hình chi tiết món ăn hiển thị các thông tin cơ bản như hình ảnh, tên món ăn, giá bán và mô tả. Người dùng có thể lựa chọn kích cỡ, topping và số lượng trước khi thêm món vào giỏ hàng.

Luồng thao tác:
1. Người dùng chọn một món ăn từ trang chủ hoặc màn hình tìm kiếm.
2. Hệ thống hiển thị thông tin chi tiết của món ăn.
3. Người dùng lựa chọn kích cỡ món ăn.
4. Người dùng lựa chọn topping nếu có.
5. Người dùng điều chỉnh số lượng món ăn.
6. Hệ thống cập nhật giá tiền theo lựa chọn của người dùng.
7. Người dùng nhấn nút Thêm vào giỏ hàng.
8. Hệ thống thêm món ăn vào giỏ hàng và thông báo kết quả.

3.4.2.4. Wireframe màn hình giỏ hàng

![Hình 3.9. Wireframe màn hình giỏ hàng (4. Giỏ hàng)](report_images/wireframe_4_gio_hang.png)

Hình 3.9. Wireframe màn hình giỏ hàng (4. Giỏ hàng)

Mô tả giao diện:  
Màn hình giỏ hàng hiển thị danh sách các món ăn người dùng đã lựa chọn. Mỗi sản phẩm có thông tin về tên món, kích cỡ, giá tiền và số lượng. Màn hình cũng hiển thị tổng tiền và nút đặt hàng.

Luồng thao tác:
1. Người dùng chọn mục Giỏ hàng trên thanh điều hướng.
2. Hệ thống hiển thị danh sách món ăn đã thêm.
3. Người dùng có thể tăng hoặc giảm số lượng từng món.
4. Người dùng có thể xóa món ăn không còn nhu cầu.
5. Hệ thống tự động tính lại tạm tính, phí giao hàng và giảm giá.
6. Người dùng kiểm tra tổng số tiền cần thanh toán.
7. Người dùng nhấn nút Đặt hàng để chuyển đến màn hình xác nhận đơn hàng.

3.4.2.5. Wireframe màn hình lịch sử đơn hàng

![Hình 3.10. Wireframe màn hình lịch sử đơn hàng (5. Lịch sử đơn hàng)](report_images/wireframe_5_lich_su_don.png)

Hình 3.10. Wireframe màn hình lịch sử đơn hàng (5. Lịch sử đơn hàng)

Mô tả giao diện:  
Màn hình lịch sử đơn hàng giúp người dùng theo dõi các đơn hàng đã tạo. Mỗi đơn hàng hiển thị mã đơn, thông tin sản phẩm, tổng tiền và trạng thái xử lý.

Luồng thao tác:
1. Người dùng truy cập mục Tài khoản hoặc chức năng Lịch sử đơn hàng.
2. Hệ thống hiển thị danh sách các đơn hàng của người dùng.
3. Người dùng xem mã đơn hàng, thời gian đặt hàng và tổng tiền.
4. Người dùng theo dõi trạng thái đơn hàng như Đang giao, Đã giao hoặc Đã hủy.
5. Người dùng chọn một đơn hàng để xem thông tin chi tiết nếu chức năng này được triển khai.
6. Hệ thống hiển thị thông tin chi tiết của đơn hàng đã chọn.

![Hình 3.11. Sơ đồ tổng hợp luồng thao tác của người dùng từ khi mở ứng dụng đến khi theo dõi đơn hàng](report_images/wireframe_luong_thao_tac.png)

Hình 3.11. Sơ đồ tổng hợp luồng thao tác của người dùng từ khi mở ứng dụng đến khi theo dõi đơn hàng

Kết luận:  
Các Wireframe trên mô tả những màn hình chính trong quá trình sử dụng ứng dụng FoodHub, từ tìm kiếm món ăn, lựa chọn sản phẩm, quản lý giỏ hàng đến theo dõi đơn hàng. Việc xây dựng Wireframe giúp xác định bố cục và luồng tương tác trước khi triển khai giao diện thực tế bằng Flutter.

CHƯƠNG 4: CÀI ĐẶT VÀ HIỆN THỰC HÓA ỨNG DỤNG

4.1. Môi trường phát triển & Công nghệ sử dụng

Dự án được xây dựng bằng bộ công cụ phát triển đa nền tảng  Flutter SDK  mới nhất, sử dụng ngôn ngữ  Dart 3  với tính năng kiểm tra an toàn rỗng ( Sound Null Safety ) và hệ thống thiết kế  Material Design 3 . Toàn bộ công nghệ, công cụ IDE và thư viện bên thứ ba được tổng hợp trong  Bảng 4.1 :

Bảng 4.1. Môi trường phát triển, công cụ hỗ trợ và các thư viện / SDK sử dụng trong dự án

Phân loại công nghệ Tên công nghệ / Thư viện (Phiên bản) Vai trò và ứng dụng thực tế trong dự án Ngôn ngữ & Framework •  Dart SDK:  ^3.11.0
•  Flutter Framework:  3.x (Material Design 3) Ngôn ngữ lập trình hướng đối tượng hiệu năng cao; hỗ trợ biên dịch AOT (Ahead-of-Time) ra mã máy ARM cho Android/iOS và biên dịch Web. IDE & Công cụ hỗ trợ •  Visual Studio Code & Android Studio 
•  Flutter DevTools & Widget Inspector 
•  Firebase Console & Firebase CLI 
•  Git & GitHub Môi trường lập trình, gỡ lỗi cây Widget, kiểm tra hiệu năng khung hình, quản trị cơ sở dữ liệu Cloud Firestore, kiểm định REST API và quản lý phiên bản nhóm. Thư viện Đám mây & Xác thực (FlutterFire) • firebase_core: ^3.15.2
• firebase_auth: ^5.7.0
• cloud_firestore: ^5.6.12 • Khởi tạo kết nối đa nền tảng tới dự án Firebase khanhdeptrai-71a05.
• Xác thực người dùng bằng Email/Mật khẩu, quản lý phiên JWT Token.
• Truy vấn và đồng bộ thời gian thực (Realtime Streams) cho 5 collections. Thư viện Giao diện & Lưu trữ cục bộ • flutter/material.dart (Material 3)
• cupertino_icons: ^1.0.8
• dart:html (Conditional Web Storage) Xây dựng hệ thống giao diện thích ứng (Responsive), biểu tượng trực quan và lưu trữ giỏ hàng liên tục trong window.localStorage. Thư viện Kiểm thử & Phân tích mã tĩnh • flutter_test (SDK)
• flutter_lints: ^6.0.0 Thực thi  71 kịch bản Unit Test & Widget Test tự động  và kiểm tra quy chuẩn mã nguồn nghiêm ngặt (flutter analyze đạt 0 lỗi).

4.2. Hiện thực các tính năng đặc thù trên thiết bị di động

4.2.1. Quản lý quyền truy cập, định danh thiết bị và bảo mật dữ liệu (Permissions & Security Rules)

Trên môi trường di động và đám mây, ứng dụng thiết lập hai lớp bảo vệ và cấp quyền:

•   Quyền truy cập thiết bị và mạng (Android/iOS/Web Permissions):  Cấu hình quyền kết nối mạng Internet (android.permission.INTERNET, ACCESS_NETWORK_STATE) để giao tiếp với Firebase Auth và Cloud Firestore, đồng thời quản lý quyền truy cập bộ nhớ cục bộ (localStorage / IndexedDB) để lưu trữ giỏ hàng và phiên đăng nhập.

•   Phân quyền dữ liệu cấp máy chủ bằng firestore.rules (US16):  Không phụ thuộc vào việc ẩn nút trên giao diện client, tệp cấu hình firestore.rules kiểm tra trực tiếp mã định danh request.auth.uid trong JWT Token của từng yêu cầu truy cập:

Trích đoạn mã nguồn: firestore.rules — Phân quyền bảo mật dữ liệu theo UID chính chủ rules_version = '2'; service cloud.firestore {   match /databases/{database}/documents { rules_version = '2'; service cloud.firestore {   match /databases/{database}/documents {     function isSignedIn() { return request.auth != null; }     function isOwner(uid) { return isSignedIn() && request.auth.uid == uid; }     function isAdmin() {       return isSignedIn() && (request.auth.token.admin == true ||         (exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&          get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin'));     }     match /users/{uid} { allow read, write: if isOwner(uid); }     match /carts/{uid} { allow read, write: if isOwner(uid); }     match /restaurants/{id} { allow read: if true; allow write: if isAdmin(); }     match /foods/{id} { allow read: if true; allow write: if isAdmin(); }     match /orders/{orderId} {       allow read: if isSignedIn() && (resource.data.userId == request.auth.uid || isAdmin());       allow create: if isSignedIn() && request.resource.data.userId == request.auth.uid;       allow update: if isAdmin() && request.resource.data.diff(resource.data).affectedKeys().hasOnly(['status', 'updatedAt']); allow delete: if false; } } }   } }

4.2.2. Xử lý luồng dữ liệu thời gian thực (Realtime Streams) và Thông báo phản hồi

Thay vì chỉ tải dữ liệu tĩnh một lần bằng HTTP GET truyền thống, ứng dụng khai thác cơ chế  WebSocket / Snapshot Streams  của Cloud Firestore kết hợp hệ thống thông báo trong ứng dụng (SnackBar, MaterialBanner, AlertDialog):

•   Đồng bộ thực đơn và trạng thái đơn hàng thời gian thực (US11, US14):  Các phương thức watchAll(), watchByRestaurant(restaurantId) trong FoodRepository và watchByUser(userId) trong OrderRepository mở kênh lắng nghe liên tục. Khi nhà hàng cập nhật giá món ăn hoặc đổi trạng thái đơn hàng từ pending (Chờ xác nhận) sang delivering (Đang giao), giao diện người dùng tự động cập nhật ngay lập tức.

•   Xử lý tác vụ nền bất đồng bộ (Async Background Sync):  Khi người dùng thao tác trên giỏ hàng hoặc cập nhật hồ sơ, giao diện phản hồi tức thì (Optimistic UI), trong khi tác vụ ghi lên Cloud Firestore được thực thi bất đồng bộ ở nền cùng cơ chế timeout 12 giây chống treo giao diện khi mạng yếu.

Trích đoạn mã nguồn: lib/repositories/food_repository.dart — Lắng nghe thực đơn Realtime theo nhà hàng Stream<List<Food>> watchByRestaurant(String restaurantId) {   return _foods       .where('restaurantId', isEqualTo: restaurantId)       .snapshots()       .map((snapshot) => snapshot.docs           .map((doc) => Food.fromMap(doc.data(), id: doc.id))           .toList()); }  Stream<List<Food>> watchByCategory(String category) {   return _foods       .where('category', isEqualTo: category)       .snapshots()       .map((snapshot) => snapshot.docs           .map((doc) => Food.fromMap(doc.data(), id: doc.id))           .toList()); }

4.2.3. Quản lý bộ nhớ đệm (Caching), Lưu trữ hai lớp (Dual-Layer) và Xử lý mất mạng

Một trong những điểm nhấn kỹ thuật quan trọng nhất của đồ án là giải quyết triệt để bài toán  mất kết nối mạng đột ngột  hoặc  tải lại trang (F5)  thông qua 3 cơ chế phòng vệ:

•   Cơ chế 1 — Dual-Layer Cart Persistence (CartController):  Kết hợp lưu trữ đồng bộ vào localStorage (writeLocalCartJson) và lưu trữ đám mây vào Firestore (carts/{uid}). Khi khởi tạo ứng dụng, CartController nạp ngay lập tức dữ liệu từ localStorage để hiển thị giỏ hàng không độ trễ, sau đó mới đồng bộ ngầm với Firestore.

•   Cơ chế 2 — Tự động chuyển đổi dữ liệu dự phòng (Offline Catalog Fallback):  Trên HomeScreen và RestaurantDetailScreen, nếu kết nối tới Firestore gặp lỗi mạng (snapshot.hasError) hoặc dữ liệu đám mây đang trống, ứng dụng tự động sử dụng bộ danh mục 20 món ăn và 3 nhà hàng nội bộ trong SampleFoodCatalog, đảm bảo ứng dụng luôn hoạt động trơn tru 100% ngay cả khi ngoại tuyến.

•   Cơ chế 3 — Phục hồi phiên và hồ sơ thông minh khi lỗi mạng (FirebaseAuthService):  Nếu người dùng đã đăng nhập thành công qua Firebase Auth nhưng truy vấn Firestore users/{uid} bị gián đoạn do mạng yếu, hệ thống vẫn duy trì phiên đăng nhập bằng đối tượng User tạm tạo từ thông tin Auth và cung cấp nút  "Tải lại hồ sơ"  để đồng bộ lại khi có mạng.

Trích đoạn mã nguồn: lib/state/cart_controller.dart — Lưu trữ giỏ hàng 2 lớp & Tính phí tự động double get subtotal => _items.fold<double>(0, (sum, item) => sum + item.subtotal);  // Tự động miễn phí giao hàng (0đ) cho đơn từ 150.000đ, ngược lại tính 15.000đ double get deliveryFee => isEmpty ? 0 : (subtotal >= 150000 ? 0 : 15000); double get totalPrice => subtotal + deliveryFee;  Future<void> _persistCart() async {   final payload = toCartPayload(); // {userId, restaurantId, deliveryAddress, items, updatedAt}   await LocalStorageService.write(_cartStorageKey, jsonEncode(payload));   if (!_syncRemote || _items.isEmpty) return;   final uid = currentUserId;   if (uid == null) return; // Chi dong bo Firestore khi da dang nhap   try {     await FirebaseFirestore.instance         .collection('carts')         .doc(uid)         .set(payload);   } catch (e) {     debugPrint('Firestore cart sync error: $e');   }

4.3. Kết quả giao diện & Thao tác chức năng

Dưới đây là kết quả hiện thực hóa toàn bộ các màn hình chính của ứng dụng cùng hướng dẫn thao tác người dùng và trích đoạn mã nguồn xử lý nghiệp vụ tương ứng của cả 4 thành viên trong nhóm:

4.3.1. Màn hình Trang chủ (HomeScreen Bento Grid) & Chi tiết Nhà hàng đối tác (RestaurantDetailScreen)

•   Mô tả giao diện & Thao tác người dùng:  Khi mở ứng dụng, người dùng được chào đón bởi màn hình Trang chủ (HomeScreen) thiết kế theo phong cách Bento Grid hiện đại: thanh Header hiển thị thương hiệu FoodHub kèm 5 chấm tròn màu sắc, huy hiệu VIP Foodie và ví thưởng ₫ 734K (kèm badge 3 thông báo). Phía dưới là thanh tìm kiếm nhanh hỗ trợ gợi ý từ khóa (Phở bò, Cơm tấm, Trà sữa, Bánh ngọt...) kèm nút bộ lọc màu cam, lưới Bento Grid 2+3 gồm 5 danh mục màu pastel nổi bật (Món Việt HOT, Món Nước 4.9 sao, Combo + Đồ nhanh -35%, Trà sữa & Cafe mới, Bánh ngọt & Ăn vặt ngon), hộp 5 tiện ích nhanh truy cập tức thì (Tất Cả Thực Đơn với badge 20 món, Phở & Bún Nóng Hổi, Cơm Trưa Văn Phòng, Bánh Mì & Bánh Ngọt, Trà Sữa & Cà Phê) và thẻ Kho Voucher ưu đãi hôm nay. Khi người dùng chạm vào một nhà hàng đối tác (ví dụ: Phở Thìn Bờ Hồ - Đặc Sản Hà Nội), ứng dụng mở màn hình Chi tiết Nhà hàng đối tác (RestaurantDetailScreen) hiển thị ảnh không gian quán sắc nét, tag Đang mở cửa • Giao ngay, điểm đánh giá 4.9 sao (420+ đánh giá), thời gian giao 12 - 15 phút (1.2 km), địa chỉ tại 13 Lò Đúc, hotline 0904.123.888, giờ mở cửa 06:00 - 22:30, ô tìm kiếm món ăn riêng trong quán và danh sách thực đơn được đồng bộ Realtime từ Cloud Firestore.

Hình 4.1. Giao diện thực tế Màn hình Trang chủ (HomeScreen Bento Grid) và Chi tiết Nhà hàng đối tác (RestaurantDetailScreen)

Trích đoạn mã nguồn: lib/features/restaurant/screens/restaurant_detail_screen.dart — Kết nối Stream thực đơn quán StreamBuilder<List<Food>>(   stream: _foodStream,   builder: (context, snapshot) {     final firestoreFoods = snapshot.data ?? const <Food>[];     final baseFoods = firestoreFoods.isNotEmpty         ? firestoreFoods         : SampleFoodCatalog.foodsByRestaurant(widget.restaurant.id);     final filteredFoods = _applyFilter(baseFoods);     return SliverList.builder(       itemCount: filteredFoods.length,       itemBuilder: (context, index) => _buildFoodItemCard(filteredFoods[index]),     );   }, )

4.3.2. Màn hình Tìm kiếm (SearchScreen), Chi tiết món ăn (FoodDetailScreen) & Giỏ hàng (CartScreen)

•   Mô tả giao diện & Thao tác người dùng:  Tại màn hình  Tìm kiếm (SearchScreen) , người dùng nhập từ khóa vào ô tìm kiếm hoặc chọn các thẻ gợi ý nhanh; hệ thống kết hợp lọc theo danh mục (ChoiceChip) và sắp xếp theo đơn giá tăng/giảm dần. Khi chạm vào một món ăn, màn hình  Chi tiết món ăn (FoodDetailScreen)  mở ra cho phép chọn kích cỡ  Size S (+0đ), Size M (+10.000đ), Size L (+20.000đ) , chọn thêm  Topping  (trứng chần, quẩy giòn, thêm thịt), điều chỉnh số lượng và bấm  "Thêm vào giỏ" . Tại màn hình  Giỏ hàng (CartScreen) , người dùng có thể tăng/giảm số lượng, xóa món (kèm nút  Hoàn tác - Undo  trên SnackBar), bật áp dụng  Voucher giảm 20.000đ  và kiểm tra bảng tính phí tự động trước khi nhấn  "Đặt hàng" .

Hình 4.2. Giao diện thực tế Màn hình Tìm kiếm (SearchScreen), Chi tiết món (FoodDetailScreen) và Giỏ hàng (CartScreen)

Trích đoạn mã nguồn: lib/features/search/screens/search_screen.dart — Thuật toán lọc đa tiêu chí và sắp xếp List<Food> get _filteredFoods {   final query = _searchController.text.trim().toLowerCase();   final filtered = widget.foods.where((food) {     final matchCategory = _selectedCategory == 'Tất cả' || food.category == _selectedCategory;     final matchQuery = query.isEmpty ||         food.name.toLowerCase().contains(query) ||         food.description.toLowerCase().contains(query);     return matchCategory && matchQuery;   }).toList();   if (_sortBy == 'price_asc') filtered.sort((a, b) => a.price.compareTo(b.price));   if (_sortBy == 'price_desc') filtered.sort((a, b) => b.price.compareTo(a.price));   return filtered; }

4.3.3. Màn hình Đăng nhập / Đăng ký thích ứng (Responsive Login/Register) & Quản lý Hồ sơ (ProfileScreen)

•   Mô tả giao diện & Thao tác người dùng:  Hệ thống màn hình xác thực (LoginScreen, RegisterScreen) được thiết kế thích ứng thông minh: trên điện thoại di động (<960px), giao diện hiển thị dạng 1 cột gọn gàng dễ thao tác bằng một tay; trên máy tính bảng hoặc trình duyệt máy tính (>=960px), giao diện tự động mở rộng thành 2 cột với bảng giới thiệu thương hiệu FoodHub bên trái và biểu mẫu xác thực bên phải. Sau khi đăng nhập thành công, màn hình  Hồ sơ cá nhân (ProfileScreen)  hiển thị đầy đủ Họ tên, Email, Số điện thoại, Địa chỉ giao hàng mặc định, nút mở  Chỉnh sửa hồ sơ (EditProfileScreen) , nút  Nạp dữ liệu mẫu lên Firestore (Seed Data)  và nút  Đăng xuất an toàn .

Hình 4.3. Giao diện thực tế Màn hình Đăng nhập trên Thiết bị di động (Khung nhìn <960px)

Hình 4.4. Giao diện thực tế Màn hình Đăng nhập Responsive 2 cột trên Máy tính / Tablet (Khung nhìn >=960px)

Trích đoạn mã nguồn: lib/state/auth_controller.dart — Xử lý đăng nhập bất đồng bộ an toàn chống gửi trùng Future<bool> signIn({required String email, required String password}) {   final normalizedEmail = email.trim().toLowerCase();   final validationError = AuthValidators.email(normalizedEmail) ??       AuthValidators.password(password);   if (validationError != null) {     _setValidationError(validationError);     return Future<bool>.value(false);   }   return _run(() async {     _user = await _service.signIn(email: normalizedEmail, password: password);   }); }

4.3.4. Màn hình Đặt hàng thanh toán (CheckoutScreen), Lịch sử đơn (OrderHistoryScreen) & Chi tiết hóa đơn (OrderDetailScreen)

•   Mô tả giao diện & Thao tác người dùng:  Khi nhấn  "Đặt hàng"  từ Giỏ hàng, màn hình  Xác nhận đặt hàng (CheckoutScreen)  tự động lấy địa chỉ mặc định từ hồ sơ người dùng (AuthController.user.address) điền vào ô địa chỉ giao hàng, liệt kê danh sách món ăn, cho phép nhập ghi chú và chọn  1 trong 5 phương thức thanh toán  (Tiền mặt, MoMo, ZaloPay, Chuyển khoản, Thẻ Visa). Khi nhấn  "Xác nhận đặt hàng" , hệ thống tạo bản ghi Order chứa danh sách OrderItem Snapshot lưu lên Cloud Firestore, xóa giỏ hàng và chuyển người dùng sang  Lịch sử đơn hàng (OrderHistoryScreen)  để theo dõi trạng thái thời gian thực hoặc chạm vào đơn để xem biên lai chi tiết trên  OrderDetailScreen .

Hình 4.5. Giao diện thực tế Màn hình Đặt hàng (CheckoutScreen), Lịch sử đơn (OrderHistoryScreen) và Chi tiết hóa đơn (OrderDetailScreen)

Trích đoạn mã nguồn: lib/features/checkout/screens/checkout_screen.dart — Tạo OrderItem Snapshot và lưu đơn hàng final orderItems = cart.items     .map((cartItem) => cartItem.toOrderItem()) // Snapshot: foodId, foodName, size, toppings, unitPrice, quantity, note     .toList(); final newOrder = Order(   id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',   userId: currentUser.id,   restaurantId: cart.currentRestaurantId ?? 'unknown',   restaurantName: restaurantName,   items: orderItems,   subtotal: cart.subtotal,   shippingFee: cart.shippingFee,   discount: cart.discount,   totalAmount: cart.totalPrice,   createdAt: DateTime.now(),   status: 'pending',   deliveryAddress: address,   paymentMethod: _selectedPaymentMethod,   note: _noteController.text.trim(), ); final orderId = await _orderRepository.create(order); widget.cartController.clear();



CHƯƠNG 5: KIỂM THỬ VÀ ĐÁNH GIÁ

5.1. Môi trường kiểm thử

Để đảm bảo ứng dụng vận hành ổn định, chính xác trên cả thiết bị di động thực tế, máy ảo Android Emulator và trình duyệt đa nền tảng, nhóm đã thiết lập môi trường kiểm thử kết hợp giữa  Kiểm thử tự động (Automated Unit & Widget Testing) ,  Kiểm định Backend Firebase thật (REST API Security Verification)  và  Kiểm thử thủ công trên thiết bị (Manual Device Testing)  với thông số chi tiết trong  Bảng 5.1 :

Bảng 5.1. Thông số kỹ thuật các thiết bị, máy ảo và môi trường kiểm thử ứng dụng

Loại thiết bị / Môi trường Tên thiết bị / Cấu hình phần cứng Hệ điều hành & Phiên bản Kích thước màn hình / Khung nhìn kiểm thử Máy ảo Android (Emulator) Google Pixel 7 Pro AVD (Android Studio Emulator, RAM 4GB) Android 14.0 (API Level 34 — UpsideDownCake) 6.7 inch (1440 × 3120 px, mật độ điểm ảnh 512 dpi, Portrait & Landscape) Thiết bị di động thật Samsung Galaxy S23 / Xiaomi Redmi Note 12 (Thiết bị sinh viên) Android 13 / Android 14 (OneUI / MIUI) 6.1 inch – 6.67 inch (1080 × 2400 px, tần số quét 120Hz) Khung nhìn Mobile nhỏ & Xoay ngang (Widget Test) Môi trường giả lập khung nhìn flutter_test (iPhone SE / Small Phone) Flutter Test VM (Dart 3.11) • Dọc (Portrait): 320 × 568 px (Cỡ chữ 1.5x)
• Ngang (Landscape): 568 × 320 px Môi trường Web & Desktop Responsive PC Windows 11 (Intel Core i7, RAM 16GB) — Google Chrome 130 Windows 11 64-bit / Chrome Web Engine • Desktop Wide: 1280 × 900 px & 1920 × 1080 px (Bố cục 2 cột >=960px) Môi trường Backend Đám mây Google Firebase Cloud (khanhdeptrai-71a05) Firebase Auth & Cloud Firestore Production Kiểm định trực tiếp qua HTTPS / gRPC và bộ kịch bản FIREBASE_VERIFICATION.json

5.2. Kịch bản kiểm thử (Test Cases)

Nhóm đã xây dựng và thực thi bộ kịch bản kiểm thử toàn diện bao phủ đầy đủ 16 User Stories, các quy tắc kiểm định biểu mẫu, tính toán tiền giỏ hàng, đồng bộ thời gian thực và phân quyền bảo mật.  Bảng 5.2  trình bày  20 kịch bản kiểm thử (Test Cases)  đại diện theo đúng chuẩn:  ID | Tên chức năng | Dữ liệu đầu vào | Kết quả mong muốn | Kết quả thực tế | Đánh giá (Pass/Fail) :

Bảng 5.2. Bảng kịch bản kiểm thử chức năng và điều kiện biên chính thức (Test Cases)

ID Tên chức năng Dữ liệu đầu vào (Input) Kết quả mong muốn (Expected Output) Kết quả thực tế (Actual Output) Đánh giá TC01 Đăng ký tài khoản hợp lệ (US06) Tên: "Nguyễn Đức Khanh", Email: "khanh.​24100401@​phenikaa.​edu.​vn", Pass: "Phenikaa123", Confirm: "Phenikaa123" Tạo tài khoản Auth thành công, sinh document users/​{uid} trên Firestore (không lưu trường password), tự động mở màn Hồ sơ.​ Tài khoản được tạo với UID khớp 100% trên Firestore, điều hướng về Hồ sơ hiển thị đúng tên và email.​ PASS TC02 Đăng ký với dữ liệu sai quy chuẩn (US06) Tên: "A" (<2 ký tự), Email: "khanh@​", Pass: "12345" (<8 ký tự), Confirm: "123456" Báo lỗi tiếng Việt tại từng trường không hợp lệ; khóa gửi yêu cầu lên Firebase.​ Hiển thị đúng thông báo lỗi dưới từng ô nhập liệu, không phát sinh request mạng.​ PASS TC03 Đăng ký trùng Email đã tồn tại (US06) Email đã đăng ký: "khanh.​24100401@​phenikaa.​edu.​vn", Pass: "Phenikaa123" Firebase trả lỗi email-already-in-use, ứng dụng hiển thị thông báo tiếng Việt thân thiện và giữ nguyên dữ liệu form.​ Hiển thị rõ thông báo "Email này đã được đăng ký", không tạo tài khoản trùng.​ PASS TC04 Đăng nhập hợp lệ & Ẩn/​hiện mật khẩu (US07) Email: "khanh.​24100401@​phenikaa.​edu.​vn", Pass: "Phenikaa123", bấm icon con mắt và nhấn Enter Icon con mắt đổi trạng thái ẩn/​hiện mật khẩu; nhấn Enter gửi form đăng nhập thành công và đồng bộ users/​{uid}.​ Đăng nhập thành công trong 450ms, tải đúng hồ sơ và địa chỉ mặc định của người dùng.​ PASS TC05 Đăng nhập sai mật khẩu (US07) Email đúng, Pass nhập sai: "SaiMatKhau999" Từ chối đăng nhập, hiển thị lỗi tiếng Việt, giữ nguyên email đã nhập để thử lại.​ Báo lỗi "Email hoặc mật khẩu không chính xác", trạng thái isSignedIn giữ nguyên false.​ PASS TC06 Khôi phục phiên tự động khi mở lại app (US07) Người dùng đã đăng nhập, nhấn F5 hoặc đóng/​mở lại ứng dụng Tự động khôi phục phiên từ JWT Token của Firebase Auth và lắng nghe watchById(uid).​ Phiên đăng nhập và hồ sơ cá nhân được khôi phục tự động, không bắt đăng nhập lại.​ PASS TC07 Cập nhật hồ sơ cá nhân & Địa chỉ mặc định (US08) Tên mới: "Nguyễn Đức Khanh N05", SĐT: "0987654321", Địa chỉ: "ĐH Phenikaa, Hà Đông, Hà Nội" Ghi merge vào users/​{uid} kèm updatedAt, hiển thị thông báo "Đã cập nhật hồ sơ" và đồng bộ sang Checkout.​ Dữ liệu trên Firestore và ProfileScreen cập nhật tức thì; mở Checkout tự điền sẵn địa chỉ mới.​ PASS TC08 Đăng xuất an toàn có hộp thoại xác nhận (US09) Bấm nút "Đăng xuất" -> Chọn "Hủy" (Lần 1) /​ Chọn "Đăng xuất" (Lần 2) Bấm Hủy: giữ nguyên phiên; Bấm Xác nhận: gọi signOut(), xóa trạng thái user và quay về màn Khách.​ Hộp thoại AlertDialog hoạt động chính xác ở cả 2 nhánh Hủy và Đồng ý.​ PASS TC09 Hiển thị Trang chủ Bento Grid & Nhận mã Coupon (US01) Mở tab Trang chủ, chạm vào nút "Nhận mã" trên thẻ Coupon 18% Hiển thị đúng Bento Grid 2+3 pastel, nút đổi thành "Đã lưu" và hiện SnackBar xác nhận.​ Giao diện hiển thị sắc nét, nút chuyển sang trạng thái "Đã lưu" kèm thông báo.​ PASS TC10 Xem Chi tiết Nhà hàng đối tác & Thực đơn Realtime (US13, US14) Chạm vào thẻ nhà hàng "Bếp Phở Hà Nội", nhập từ khóa "Bún" trong thanh tìm kiếm của quán Mở RestaurantDetailScreen, hiển thị thông tin quán và lọc thực đơn của riêng quán khớp từ khóa "Bún".​ Hiển thị đúng ảnh bìa, hotline, đánh giá 4.​8 sao và các món Bún của nhà hàng.​ PASS TC11 Tìm kiếm kết hợp Lọc danh mục & Sắp xếp giá (US02) Chọn danh mục "Món nước", từ khóa "Phở", sắp xếp "Giá tăng dần" Chỉ hiển thị các món thuộc danh mục Món nước có chứa chữ Phở theo thứ tự giá từ thấp đến cao.​ Danh sách kết quả lọc và sắp xếp chính xác 100% theo đơn giá tăng dần.​ PASS TC12 Chọn Size S/​M/​L, Topping & Thêm vào giỏ (US03) Mở món "Phở Bò Tái Lăn" (55.​000đ), chọn Size M, thêm Trứng chần, số lượng 2, bấm "Thêm vào giỏ" Thêm món vào CartController với số lượng 2, cập nhật badge giỏ hàng trên thanh điều hướng.​ Badge giỏ hàng tăng thêm 2, hiển thị SnackBar đã thêm món vào giỏ.​ PASS TC13 Tính phí giao hàng tự động & Áp mã Voucher (US05) Trường hợp 1: Tạm tính 110.​000đ (<150K).​
Trường hợp 2: Tạm tính 170.​000đ (>=150K) + Bật Voucher -20.​000đ.​ TH1: Phí giao = 15.​000đ (Tổng 125.​000đ).​
TH2: Phí giao = 0đ (Miễn phí) + Giảm 20.​000đ -> Tổng = 150.​000đ.​ Thuật toán tính subtotal, deliveryFee và voucherDiscount cho kết quả khớp tuyệt đối.​ PASS TC14 Xóa món khỏi giỏ & Hoàn tác Undo /​ Giữ giỏ khi nhấn F5 (US04) Xóa 1 món rồi bấm "Hoàn tác" trên SnackBar; sau đó nhấn F5 tải lại trang Bấm Hoàn tác khôi phục lại món vừa xóa; nhấn F5 giỏ hàng vẫn giữ nguyên 100% nhờ localStorage.​ Món ăn được khôi phục đầy đủ; sau khi F5 giỏ hàng hiển thị tức thì không mất dữ liệu.​ PASS TC15 Đặt hàng với 5 phương thức thanh toán & Tạo Snapshot (US10) Tại CheckoutScreen, kiểm tra địa chỉ, nhập ghi chú "Nhiều hành", chọn PTTT "Ví MoMo", bấm "Xác nhận đặt hàng" Lưu document mới vào orders/​{orderId} kèm mảng OrderItem snapshot, làm trống giỏ hàng.​ Đơn hàng được tạo trên Firestore với đầy đủ thông tin, giỏ hàng về 0 món.​ PASS TC16 Theo dõi Lịch sử đơn hàng Realtime & Xem Hóa đơn (US11, US12) Mở OrderHistoryScreen, sau đó chạm vào đơn vừa đặt để mở OrderDetailScreen Hiển thị danh sách đơn sắp xếp mới nhất lên đầu kèm nhãn màu trạng thái và biên lai chi tiết.​ Hiển thị đúng nhãn "Chờ xác nhận", mã đơn, địa chỉ, PTTT và đơn giá snapshot.​ PASS TC17 Nạp dữ liệu mẫu tự động lên Firestore (US15) Tại ProfileScreen, nhấn nút "Nạp dữ liệu mẫu (20 món & 3 nhà hàng)" Gọi SampleFoodCatalog.​seedAllData() ghi đồng bộ 3 nhà hàng và 20 món ăn lên Cloud Firestore.​ Hoàn tất đồng bộ và hiển thị thông báo thành công; dữ liệu xuất hiện ngay trên Console.​ PASS TC18 Kiểm định bảo mật Firestore Rules chặn đọc/​ghi chéo (US16) Tài khoản User A gửi request đọc hoặc sửa hồ sơ users/​{uid_​B} của User B hoặc truy cập khi chưa đăng nhập Firestore Security Rules từ chối truy cập với mã lỗi PERMISSION_​DENIED (403).​ Chặn 100% các truy cập trái phép (đã lưu bằng chứng tại FIREBASE_​VERIFICATION.​json).​ PASS TC19 Kiểm thử điều kiện biên: Chống bấm gửi trùng (Double-submit) Nhấn liên tiếp nhiều lần vào nút "Đăng nhập" hoặc "Lưu hồ sơ" khi mạng đang xử lý Nút gửi bị khóa ngay từ lần nhấn đầu (isBusy = true), chỉ gửi duy nhất 1 request.​ Controller chặn hoàn toàn các lệnh gọi trùng khi isBusy == true.​ PASS TC20 Kiểm thử điều kiện biên: Màn hình nhỏ 320×568, xoay ngang & chữ lớn 1.​5x Render ứng dụng ở kích thước 320×568, 568×320, 1280×900 với textScaler = 1.​5 và mở bàn phím ảo Giao diện tự cuộn mượt mà, chuyển đổi đúng 1 cột /​ 2 cột, không xảy ra lỗi RenderFlex overflowed.​ 0 lỗi tràn viền trên toàn bộ các độ phân giải và tỷ lệ phông chữ.​ PASS

Bên cạnh bảng kịch bản kiểm thử chức năng, toàn bộ mã nguồn dự án đã vượt qua  100% bộ kiểm thử tự động (71/71 Unit & Widget Tests PASS)  trên 15 tệp kiểm thử trong thư mục test/ cùng  10/10 kịch bản kiểm định Backend Firebase thật  như tổng hợp tại  Bảng 5.3 :

Bảng 5.3. Tổng hợp kết quả thực thi 71 Unit & Widget Tests tự động và 10 kịch bản kiểm định Backend Firebase

Nhóm kiểm thử / Tệp kiểm thử trong dự án Số lượng Test Nội dung kiểm tra tự động Kết quả test/models/*_test.dart (5 tệp: user, restaurant, food, cart_item, order) 18 Tests Kiểm tra khởi tạo đối tượng, ánh xạ ORM fromMap/toMap, copyWith, tính subtotal và bắt lỗi dữ liệu âm/rỗng. 18/18 PASS test/state/cart_controller_test.dart & test/features/cart/cart_screen_test.dart 10 Tests Kiểm tra thêm/sửa/xóa món, hoàn tác Undo, tính phí giao hàng ngưỡng 150.000đ, Voucher 20.000đ và lưu trữ giỏ. 10/10 PASS test/features/search/search_screen_test.dart & food_detail_screen_test.dart 6 Tests Kiểm tra tìm kiếm từ khóa, lọc danh mục, sắp xếp giá tăng/giảm và chọn Size/Topping trên màn Chi tiết món. 6/6 PASS test/features/restaurant/restaurant_detail_screen_test.dart 5 Tests Kiểm tra hiển thị thông tin nhà hàng đối tác (US13), lọc thực đơn quán, thêm món vào giỏ và seedAllData (US15). 5/5 PASS test/features/auth/* & test/state/auth_controller_test.dart & test/services/firebase_auth_service_test.dart 28 Tests Kiểm tra AuthValidators, đăng nhập/đăng ký, sai mật khẩu, trùng email, khôi phục phiên, sửa hồ sơ, đăng xuất, khóa gửi trùng và giao diện Responsive 320×568 / 1280×900 (1.5x font). 28/28 PASS test/widget_test.dart (Integration Smoke Tests) 4 Tests Kiểm tra khởi chạy toàn ứng dụng, chuyển đổi thanh điều hướng 4 tab và luồng tích hợp tổng thể. 4/4 PASS docs/person3/FIREBASE_VERIFICATION.json (Live Firebase REST Verification) 10 Kịch bản Kiểm định trực tiếp trên project khanhdeptrai-71a05: đăng ký, đăng nhập, đọc/sửa hồ sơ chính chủ, chặn đọc/sửa chéo 403. 10/10 PASS TỔNG CỘNG TOÀN DỰ ÁN (flutter test & flutter analyze) 71 Tests + 10 Live Checks Toàn bộ kiểm thử tự động và kiểm định bảo mật đám mây đạt tuyệt đối; flutter analyze báo  0 issues found . 100% PASS

5.3. Đánh giá kết quả & Trải nghiệm người dùng

5.3.1. Mức độ đáp ứng yêu cầu người dùng

Qua quá trình chạy thử nghiệm thực tế và kiểm thử chéo giữa các thành viên trong nhóm, ứng dụng  FoodHub  đã đáp ứng  100% các yêu cầu chức năng và phi chức năng  đề ra ở Chương 2:

•   Trải nghiệm khám phá và đặt món trực quan, hiện đại:  Bố cục Trang chủ Bento Grid 2+3 màu pastel kết hợp thanh tìm kiếm và bộ lọc thông minh giúp người dùng tìm thấy món ăn mong muốn chỉ sau 2–3 thao tác chạm.

•   Tính nhất quán dữ liệu giữa các phân hệ:  Địa chỉ giao hàng mặc định cập nhật ở màn hình Hồ sơ (EditProfileScreen của Nguyễn Chí Tài) được đồng bộ tự động sang màn hình Đặt hàng (CheckoutScreen của Bùi Khánh Hưng); món ăn thêm từ Trang chủ, Tìm kiếm (Ngô Đức Khang) hay Chi tiết Nhà hàng (Nguyễn Đức Khanh) đều hội tụ chính xác về cùng một CartController duy nhất.

•   Độ tin cậy của dữ liệu lịch sử đơn hàng: Kiến trúc dữ liệu & Bảo toàn lịch sử (Data Integrity): Việc tách biệt rõ ràng giữa CartItem (trạng thái giỏ hàng tạm thời) và OrderItem (bản chụp lịch sử bất biến lưu đầy đủ size, toppings, unitPrice và note) giúp hệ thống bảo toàn tuyệt đối tính chính xác của hóa đơn lịch sử (ví dụ: khách đặt món Size L kèm topping vẫn hiển thị đầy đủ trong lịch sử đơn hàng và không bị ảnh hưởng khi nhà hàng thay đổi giá món gốc), đồng thời đồng bộ trường thời gian createdAt và cấu trúc giỏ hàng giữa localStorage (foodhub_{uid}_v1) và Firestore (carts/{uid}).

5.3.2. Thử nghiệm trên các điều kiện biên (Boundary & Stress Conditions)

•   Điều kiện biên 1 — Mất kết nối mạng đột ngột hoặc nhấn F5 tải lại trang:  Khi ngắt kết nối Wi-Fi/4G đột ngột trong lúc đang chọn món, giỏ hàng vẫn được bảo toàn nguyên vẹn trong localStorage; thực đơn tự động chuyển sang bộ dữ liệu dự phòng SampleFoodCatalog mà không gây văng ứng dụng (Zero Crash). Khi đang ở màn hình đăng nhập hoặc sửa hồ sơ mà mất mạng, hệ thống bắt ngoại lệ timeout sau 12 giây, hiển thị thông báo tiếng Việt rõ ràng và giữ nguyên dữ liệu người dùng vừa nhập trên biểu mẫu để thử lại ngay khi có mạng.

•   Điều kiện biên 2 — Nhập sai định dạng dữ liệu và tấn công bấm lặp (Rapid Tap / Invalid Input):  Mọi trường nhập liệu đều được lọc khoảng trắng thừa (trim()), chuẩn hóa chữ thường cho email (toLowerCase()) và kiểm tra ràng buộc chặt chẽ trước khi gọi dịch vụ mạng. Cơ chế khóa _busy trong AuthController và _isSubmitting trong CheckoutScreen ngăn chặn triệt để tình trạng tạo 2 đơn hàng trùng hoặc gửi 2 yêu cầu xác thực cùng lúc khi người dùng bấm liên tục.

•   Điều kiện biên 3 — Xoay ngang màn hình, màn hình siêu nhỏ và phóng to cỡ chữ 1.5 lần:  Toàn bộ các màn hình biểu mẫu và danh sách đều được bọc trong SingleChildScrollView / CustomScrollView kết hợp LayoutBuilder và SafeArea. Khi xoay ngang màn hình (568×320) hoặc bật bàn phím ảo kèm cỡ chữ hệ thống 1.5x, người dùng vẫn cuộn tới mọi nút bấm một cách dễ dàng, không xảy ra hiện tượng tràn khung hình.

PHẦN KẾT LUẬN & PHỤ LỤC

1. Kết luận

1.1. Tóm tắt các kết quả chính đã đạt được

Sau quá trình nghiên cứu, phân tích, thiết kế và lập trình nghiêm túc dưới sự hướng dẫn của Cô  Nguyễn Lệ Thu , nhóm sinh viên  Nhóm Hưng – Khang – Khanh – Tài (Lớp Lập trình cho thiết bị di động N05 — Trường Công nghệ Thông tin Phenikaa)  đã hoàn thành trọn vẹn 100% mục tiêu của đề tài  "Ứng dụng Đặt Đồ Ăn (FoodHub)"  với các kết quả nổi bật sau:

•   Hoàn thiện hồ sơ phân tích và thiết kế hệ thống chuẩn mực:  Xây dựng đầy đủ bộ sơ đồ UML gồm Sơ đồ Use Case tổng quát, 5 bảng đặc tả Use Case chi tiết, 2 Sơ đồ hoạt động (Activity Diagrams), Sơ đồ kiến trúc phân tầng Clean Architecture, Sơ đồ thiết kế dữ liệu NoSQL ERD, Sơ đồ lớp (Class Diagram), Sơ đồ tuần tự (Sequence Diagram), Sơ đồ chuyển trang (Navigation Sitemap) và bộ bản vẽ Wireframe chi tiết.

•   Hiện thực hóa 100% 16 User Stories trên nền tảng Flutter & Firebase:  Xây dựng hoàn chỉnh 12 màn hình chức năng mượt mà chuẩn Material Design 3, tích hợp xác thực  Firebase Authentication , cơ sở dữ liệu thời gian thực  Cloud Firestore  (khanhdeptrai-71a05), lưu trữ giỏ hàng hai lớp ( Dual-Layer Persistence ), tự động tính phí vận chuyển/Voucher, lưu trữ  OrderItem Snapshot  và bảo mật dữ liệu bằng  firestore.rules .

•   Đạt chất lượng kiểm thử tự động tuyệt đối:  Toàn bộ dự án vượt qua  71/71 Unit & Widget Tests (100% PASS) , vượt qua  10/10 kịch bản kiểm định bảo mật REST API  trên Firebase thật và đạt  0 lỗi phân tích mã tĩnh (flutter analyze) .

1.2. Những khó khăn gặp phải và bài học kinh nghiệm rút ra

•   Khó khăn gặp phải:  Trong giai đoạn đầu, nhóm gặp thách thức khi đồng bộ trạng thái giỏ hàng lúc người dùng tải lại trình duyệt (F5) trên nền tảng Web, xử lý bất đồng bộ giữa việc tạo tài khoản Firebase Auth và việc ghi hồ sơ users/{uid} trên Firestore khi mạng chập chờn, cũng như việc phối hợp ghép nối mã nguồn giữa 4 thành viên.

•   Bài học kinh nghiệm rút ra:  Nhóm đã học được cách thiết kế giao diện trừu tượng (AuthService, Repositories) và chia tách thư mục theo tính năng (lib/features/) để các thành viên phát triển độc lập mà không xung đột Git; biết cách kết hợp lưu trữ cục bộ (localStorage) với đám mây (Firestore) để tối ưu trải nghiệm người dùng; đồng thời rèn luyện thói quen viết Unit Test và Widget Test song hành với quá trình viết code.

2. Hạn chế & Hướng phát triển trong tương lai

2.1. Những hạn chế cần tối ưu thêm

•   Các phương thức thanh toán trực tuyến (MoMo, ZaloPay, VietQR, Thẻ Visa) hiện đang dừng ở bước lựa chọn phương thức và ghi nhận vào hóa đơn đơn hàng, chưa kết nối trực tiếp tới cổng thanh toán (Payment Gateway Webhook) thực tế.

•   Chức năng theo dõi đơn hàng hiện cập nhật theo trạng thái chữ (Chờ xác nhận, Đang chuẩn bị, Đang giao, Đã giao), chưa tích hợp bản đồ số thời gian thực để xem vị trí di chuyển của tài xế trên bản đồ.

2.2. Kế hoạch nâng cấp tính năng trong tương lai

•   Tích hợp Trí tuệ nhân tạo (AI Food Recommendation & Chatbot):  Tích hợp mô hình ngôn ngữ lớn (Gemini API) để gợi ý thực đơn cá nhân hóa theo lịch sử đặt món, thời tiết, ngân sách và hỗ trợ tìm kiếm món ăn bằng giọng nói hoặc ngôn ngữ tự nhiên.

•   Tích hợp Bản đồ số GPS & Định vị thời gian thực (Google Maps SDK / Geolocator):  Tự động lấy tọa độ GPS hiện tại của người dùng để tính khoảng cách giao hàng thực tế và hiển thị lộ trình di chuyển của tài xế trực tiếp trên bản đồ.

•   Kết nối Cổng thanh toán điện tử Sandbox & Thông báo đẩy (FCM):  Tích hợp cổng thanh toán VNPay / MoMo Sandbox (quét mã QR tự động xác nhận giao dịch) và dịch vụ  Firebase Cloud Messaging (FCM)  để gửi thông báo đẩy (Push Notifications) ngay cả khi người dùng đã đóng ứng dụng.

•   Phát triển Phân hệ Nhà hàng (Merchant App) & Phát hành lên chợ ứng dụng:  Xây dựng thêm giao diện quản lý dành riêng cho chủ quán để duyệt đơn/cập nhật thực đơn và đóng gói phát hành chính thức lên  Google Play Store  và  Apple App Store .

3. Tài liệu tham khảo

•   [1] Google Flutter Team, "Flutter Documentation — UI, State Management, Testing & Architecture", truy cập tại: https://docs.flutter.dev, 2026.

•   [2] Dart Team, "Dart Language Tour & Sound Null Safety Specification", truy cập tại: https://dart.dev/guides, 2026.

•   [3] Google Firebase, "FlutterFire Documentation — Firebase Authentication & Cloud Firestore Security Rules", truy cập tại: https://firebase.google.com/docs/flutter, 2026.

•   [4] Google Material Design, "Material Design 3 Guidelines for Mobile & Adaptive Layouts", truy cập tại: https://m3.material.io, 2026.

•   [5] Trường Công nghệ Thông tin Phenikaa – Đại học Phenikaa, "Bài giảng và Đề cương Học phần Lập trình cho thiết bị di động", Giảng viên hướng dẫn: ThS. Nguyễn Lệ Thu, Hà Nội, 2026.

4. Phụ lục

Bảng Phụ lục. Thông tin kho mã nguồn, cấu trúc dự án và hướng dẫn biên dịch / chạy sản phẩm

Hạng mục phụ lục Đường dẫn / Lệnh thực thi chi tiết Kho mã nguồn dự án (Git Repository) Thư mục dự án: Nhom_Hung_Khang_Khanh_Food
Nhánh chính: main (Tích hợp đầy đủ mã nguồn của 4 thành viên, cấu hình Firebase và 71 bài kiểm thử tự động). Tệp cấu hình Firebase & Bảo mật • Cấu hình đa nền tảng: lib/firebase_options.dart (Project ID: khanhdeptrai-71a05)
• Quy tắc phân quyền Firestore: firestore.rules & firebase.json
• Bằng chứng kiểm định REST API: docs/person3/FIREBASE_VERIFICATION.json Lệnh cài đặt & Chạy ứng dụng trực tiếp 1. Tải các gói thư viện phụ thuộc:
   flutter pub get
2. Chạy ứng dụng trên thiết bị Android / Emulator hoặc trình duyệt Chrome:
   flutter run
   flutter run -d chrome Lệnh đóng gói tệp cài đặt Android (.apk) Biên dịch tệp cài đặt .apk bản Release tối ưu dung lượng:
   flutter build apk --release
Đường dẫn tệp .apk sau khi biên dịch:
   build/app/outputs/flutter-apk/app-release.apk Lệnh chạy Kiểm thử tự động & Phân tích mã nguồn 1. Kiểm tra phân tích mã tĩnh (0 lỗi):
   flutter analyze
2. Chạy toàn bộ 71 Unit Tests & Widget Tests:
   flutter test