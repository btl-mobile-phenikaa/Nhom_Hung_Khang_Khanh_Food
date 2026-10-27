# Sơ đồ luồng tài khoản — Người 3

Cập nhật 28/10/2026 theo code hiện tại. Giao diện đăng nhập mới dùng `AuthPage`;
đăng ký/hồ sơ/chỉnh sửa dùng `AccountLayout`. Các màn gọi cùng `AuthController`.
Bản chính dùng `FirebaseAuthService`; `DemoAuthService` chỉ dùng bản demo/test.
Các sơ đồ dưới mô tả bản Firebase thật.

## 1. Thành phần và dữ liệu

```mermaid
flowchart LR
    Main["main.dart: khởi tạo Firebase"] --> Nav["MainNavigation: sở hữu AuthController"]
    Nav --> UI["Login / Register / Profile / EditProfile"]
    UI --> C["AuthController: phiên, loading, lỗi, validation"]
    C --> S["AuthService"]
    S --> Real["FirebaseAuthService"]
    S --> Demo["DemoAuthService: RAM, chỉ demo/test"]
    Real --> Auth["Firebase Authentication"]
    Real --> Repo["UserRepository"]
    Repo --> DB["Firestore: users/{uid}"]
    Auth -. "authStateChanges: khôi phục/đổi phiên" .-> Real
    DB -. "watchById: cập nhật hồ sơ" .-> Real
    Real -. "userChanges hoặc lỗi stream" .-> C
```

Mật khẩu chỉ gửi tới Firebase Auth. Document hồ sơ không có trường mật khẩu.
Email hiển thị được lấy từ Firebase Auth; UID là khóa nhận diện tài khoản.

## 2. Đăng ký và phục hồi trường hợp hồ sơ chưa lưu được

```mermaid
sequenceDiagram
    actor U as Người dùng
    participant UI as RegisterScreen
    participant C as AuthController
    participant S as FirebaseAuthService
    participant A as Firebase Authentication
    participant R as UserRepository
    participant DB as Firestore users/uid
    U->>UI: Nhập tên, email, mật khẩu và xác nhận
    UI->>UI: Form.validate
    alt Dữ liệu không hợp lệ
        UI-->>U: Hiển thị lỗi tại trường
    else Dữ liệu hợp lệ
        UI->>C: signUp(name, email, password, confirm)
        C->>C: Kiểm tra lại, chuẩn hóa tên/email, busy=true
        C->>S: signUp(name, email, password)
        S->>A: createUserWithEmailAndPassword
        alt Email trùng / mật khẩu yếu / lỗi mạng
            A-->>S: Lỗi SDK
            S-->>C: AuthFailure bằng tiếng Việt
            C-->>UI: busy=false, error, success=false
            UI-->>U: Giữ form để sửa hoặc thử lại
        else Auth thành công
            A-->>S: User có Firebase UID
            S-->>C: userChanges: thông tin tạm theo UID
            S->>R: getById(uid)
            R->>DB: Đọc hồ sơ
            alt Đọc/lưu hồ sơ thành công
                DB-->>R: Hồ sơ hoặc chưa có document
                opt Chưa có hồ sơ
                    S->>R: save(User có id=UID)
                    R->>DB: Ghi hồ sơ và server timestamp
                    DB-->>R: Thành công
                end
                S->>A: Đồng bộ displayName sau khi lưu hồ sơ
                Note over S,A: Lỗi đồng bộ tên Auth không hủy hồ sơ đã lưu
                S-->>C: User đã đồng bộ
            else Lỗi đọc/ghi hồ sơ
                DB-->>R: Lỗi mạng hoặc quyền
                R-->>S: Lỗi
                S-->>C: Giữ phiên Auth và User tạm, phát cảnh báo
                Note over C,UI: Không đăng ký lại tài khoản đã tạo, có thể lưu lại hồ sơ
            end
            C-->>UI: busy=false, success=true
            UI-->>U: Quay về Hồ sơ, hiển thị cảnh báo nếu có
        end
    end
```

Nếu đăng ký được mở từ Đăng nhập, khi thành công cả route đăng ký và đăng nhập
được đóng để quay về Hồ sơ. Đăng ký trực tiếp từ Profile chỉ đóng route đăng ký.

## 3. Đăng nhập

```mermaid
sequenceDiagram
    actor U as Người dùng
    participant UI as LoginScreen
    participant C as AuthController
    participant S as FirebaseAuthService
    participant A as Firebase Authentication
    participant R as UserRepository
    U->>UI: Nhập email/mật khẩu hoặc nhấn Enter ở ô mật khẩu
    UI->>UI: Form.validate
    UI->>C: signIn(email, password) nếu form hợp lệ
    C->>C: Trim/lowercase email, giữ nguyên mật khẩu, busy=true
    C->>S: signIn(email, password)
    S->>A: signInWithEmailAndPassword
    alt Sai thông tin / tài khoản bị khóa / mất mạng
        A-->>S: FirebaseAuthException
        S-->>C: AuthFailure
        C-->>UI: Lỗi tiếng Việt, busy=false
        UI-->>U: Hiển thị lỗi, cho thử lại
    else Auth thành công
        A-->>S: User và UID
        S->>R: getById(uid)
        alt Hồ sơ đọc được
            R-->>S: User hoặc null
            opt Hồ sơ chưa tồn tại
                S->>R: save(hồ sơ cơ bản theo UID)
            end
            S-->>C: User và userChanges
        else Hồ sơ chưa đồng bộ được
            R-->>S: Lỗi
            S-->>C: User tạm, giữ phiên Auth và cảnh báo
        end
        C-->>UI: success=true, busy=false
        UI-->>U: Đóng Đăng nhập, hiển thị Hồ sơ
    end
```

Trong lúc chờ, nút gửi bị khóa và hiển thị vòng tiến trình. Nút con mắt chỉ đổi
trạng thái ẩn/hiện mật khẩu, không thay đổi dữ liệu nhập hoặc gọi Firebase.

## 4. Khôi phục phiên và theo dõi hồ sơ

```mermaid
sequenceDiagram
    participant App as MainNavigation
    participant S as FirebaseAuthService
    participant A as Firebase Authentication
    participant R as UserRepository
    participant C as AuthController
    participant UI as ProfileScreen
    App->>S: Khởi tạo service/controller
    S->>A: currentUser và authStateChanges
    A-->>S: User đã lưu hoặc null
    alt Chưa đăng nhập
        S-->>C: userChanges(null)
        C-->>UI: Lời chào, nút Đăng nhập/Đăng ký
    else Có phiên
        S-->>C: User tạm từ thông tin Auth
        S->>R: watchById(uid)
        alt Có hồ sơ
            R-->>S: User Firestore, tiếp tục cập nhật theo thời gian thực
            S-->>C: User của đúng UID hiện tại
            C-->>UI: Hiển thị hồ sơ
        else Thiếu hồ sơ / lỗi stream
            R-->>S: null hoặc lỗi
            S-->>C: Cảnh báo qua userChanges.error
            C-->>UI: Giữ phiên, hiện lỗi và nút Tải lại hồ sơ
        end
    end
    Note over S,R: Khi đổi tài khoản/đăng xuất, hủy watcher cũ và bỏ qua sự kiện cũ
```

## 5. Cập nhật và tải lại hồ sơ

```mermaid
sequenceDiagram
    actor U as Người dùng
    participant UI as EditProfileScreen
    participant C as AuthController
    participant S as FirebaseAuthService
    participant R as UserRepository
    participant DB as Firestore users/uid
    U->>UI: Sửa tên, điện thoại, địa chỉ
    UI->>UI: Form.validate, email chỉ đọc
    UI->>C: updateProfile(name, phone, address)
    C->>S: updateProfile sau kiểm tra đầu vào
    S->>S: Kiểm tra UID phiên hiện tại
    S->>R: save(hồ sơ đầy đủ của UID)
    R->>DB: Merge hồ sơ, updatedAt=server timestamp
    alt Lưu lỗi hoặc phiên thay đổi
        DB-->>R: Lỗi nếu thao tác ghi bị từ chối
        R-->>S: Lỗi
        S-->>C: AuthFailure
        C-->>UI: busy=false, giữ dữ liệu form và hồ sơ cũ
    else Thành công
        DB-->>R: Ghi thành công
        R-->>S: Hoàn tất
        S-->>C: User mới và userChanges
        C-->>UI: success=true, busy=false
        UI-->>U: Quay về Hồ sơ, thông báo Đã cập nhật hồ sơ
    end
```

Nút **Tải lại hồ sơ** gọi `AuthController.refreshProfile()` → service reload user
Firebase Auth → `UserRepository.getById(uid)` → cập nhật hồ sơ và khởi động lại
watcher. Nếu chưa có document, hướng dẫn mở Chỉnh sửa hồ sơ để lưu. Nếu reload
phát hiện phiên đó bị vô hiệu hóa/token không hợp lệ, service đăng xuất phiên đó
và controller hiển thị lỗi. Lỗi mạng thông thường không tự xóa phiên hiện có.

## 6. Đăng xuất có xác nhận

```mermaid
sequenceDiagram
    actor U as Người dùng
    participant UI as ProfileScreen
    participant C as AuthController
    participant S as FirebaseAuthService
    participant A as Firebase Authentication
    U->>UI: Chọn Đăng xuất
    UI-->>U: Hộp thoại xác nhận
    alt Chọn Hủy
        UI-->>U: Đóng hộp thoại, giữ phiên
    else Xác nhận
        UI->>C: signOut()
        C->>S: signOut()
        S->>A: signOut()
        alt Thành công
            A-->>S: Phiên đã kết thúc
            S-->>C: userChanges(null)
            S->>S: Hủy theo dõi hồ sơ cũ
            C-->>UI: user=null, busy=false
            UI-->>U: Trạng thái chưa đăng nhập
        else Lỗi SDK/timeout
            S-->>C: AuthFailure
            C-->>UI: Hiển thị lỗi và cho thử lại
        end
    end
```

Đăng xuất hiện không thay đổi giỏ hàng và không xóa document hồ sơ.

## 7. Activity diagram tổng thể

```mermaid
flowchart TD
    A["Mở app / tab Profile"] --> B{"Có phiên đăng nhập?"}
    B -->|Không| C["Chọn Đăng nhập hoặc Đăng ký"]
    C --> D["Nhập thông tin"]
    D --> E{"Form hợp lệ?"}
    E -->|Không| D
    E -->|Có| F["Gọi Firebase Auth, khóa nút gửi"]
    F --> G{"Auth thành công?"}
    G -->|Không| H["Hiển thị lỗi, giữ dữ liệu để thử lại"]
    H --> D
    G -->|Có| I{"Hồ sơ đồng bộ được?"}
    B -->|Có| I
    I -->|Có| J["Hiển thị hồ sơ"]
    I -->|Không| K["Giữ phiên, hồ sơ tạm và cảnh báo"]
    K --> L["Tải lại hồ sơ hoặc chỉnh sửa để lưu lại"]
    L --> I
    J --> M["Chỉnh sửa hồ sơ"]
    M --> N{"Dữ liệu hợp lệ và lưu thành công?"}
    N -->|Không| M
    N -->|Có| J
    J --> O["Chọn Đăng xuất"]
    K --> O
    O --> P{"Xác nhận?"}
    P -->|Hủy| J
    P -->|Có| Q["Gọi signOut"]
    Q --> R{"Thành công?"}
    R -->|Có| C
    R -->|Không| J
```

## Phạm vi tích hợp còn lại

Bộ sơ đồ này mô tả tài khoản và hồ sơ. Checkout/lịch sử của Người 4 vẫn cần nhận
UID thật từ `AuthController.user?.id`; không coi luồng đặt hàng đã được tích hợp
chỉ từ các sơ đồ tài khoản này.
