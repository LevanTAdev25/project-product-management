# 🛒 Sales & Product Management App (Flutter + GetX MVC)

[![Flutter](https://img.shields.io/badge/Flutter-v3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-v3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State%20Management-GetX-9C27B0)](https://pub.dev/packages/get)
[![Local Database](https://img.shields.io/badge/Storage-Hive%20NoSQL-FFB300)](https://pub.dev/packages/hive)
[![Network](https://img.shields.io/badge/HTTP%20Client-Dio-blue)](https://pub.dev/packages/dio)
[![Architecture](https://img.shields.io/badge/Architecture-MVC%20%2B%20Repository-success)]()

> **Ứng dụng Quản lý Sản phẩm & Bán hàng** được xây dựng trên nền tảng **Flutter** kết hợp mô hình kiến trúc **MVC (Model - View - Controller)** kết hợp **Repository Pattern** và thư viện **GetX**. Dự án được thiết kế chuẩn chỉnh theo hướng module hóa (Feature-first / Modular Architecture), tối ưu hóa hiệu năng, xử lý bất đồng bộ, quản lý state và lưu trữ offline mượt mà.

---

## 📌 Mục lục
- [Giới thiệu dự án](#-giới-thiệu-dự-án)
- [Tính năng nổi bật](#-tính-năng-nổi-bật)
- [Kiến trúc ứng dụng (MVC Pattern)](#-kiến-trúc-ứng-dụng-mvc-pattern)
- [Cấu trúc thư mục dự án](#-cấu-trúc-thư-mục-dự-án)
- [Công nghệ & Thư viện sử dụng](#-công-nghệ--thư-viện-sử-dụng)
- [Điểm sáng kỹ thuật dành cho Nhà Tuyển Dụng](#-điểm-sáng-kỹ-thuật-dành-cho-nhà-tuyển-dụng)
- [Hướng dẫn cài đặt & Khởi chạy](#-hướng-dẫn-cài-đặt--khởi-chạy)
- [Thông tin liên hệ](#-thông-tin-liên-hệ)

---

## 🌟 Giới thiệu dự án

Dự án là giải pháp di động toàn diện hỗ trợ quản lý bán hàng, theo dõi danh mục sản phẩm, kiểm soát tồn kho và giỏ hàng. Ứng dụng tập trung vào:
- **Trải nghiệm người dùng (UX/UI)**: Thiết kế trực quan, mượt mà với pull-to-refresh, lazy loading / infinite scroll, bottom sheets tiện lợi.
- **Tính ổn định & mở rộng (Scalability)**: Tách biệt rõ ràng giữa Business Logic, Data Access và UI layer thông qua MVC + Repository.
- **Quản lý phiên & bảo mật**: Tích hợp JWT Authentication, Interceptors tự động đính kèm Bearer token và xử lý phân quyền / hết hạn phiên đăng nhập.

---

## ✨ Tính năng nổi bật

### 🔐 1. Xác thực & Điều hướng (Authentication & Splash)
- **Splash Screen**: Tự động kiểm tra tính hợp lệ của JWT Token và phiên đăng nhập khi khởi động app.
- **Login**: Đăng nhập tài khoản an toàn, lưu trữ token với `AuthService`.
- **Session Interceptor**: Tự động bắt lỗi Unauthorized (401), điều hướng về trang Login khi hết hạn phiên làm việc.

### 📦 2. Quản lý Sản phẩm (Product Management)
- **Danh sách sản phẩm**: Hiển thị dạng GridView tối ưu hình ảnh và thông tin giá (format tiền tệ VND chuẩn `intl`).
- **Phân trang (Pagination / Infinite Scroll)**: Tự động tải thêm sản phẩm khi cuộn trang, hạn chế quá tải bộ nhớ và băng thông.
- **Tìm kiếm & Lọc (Search & Filter)**: Tìm kiếm sản phẩm theo thời gian thực kết hợp lọc nhanh theo danh mục (Chip filter).
- **CRUD đầy đủ**: Thêm mới, chỉnh sửa thông tin sản phẩm (tên, giá, mô tả, danh mục) và xóa sản phẩm có dialog xác nhận an toàn.
- **Chi tiết sản phẩm**: Xem chi tiết thông số, hình ảnh và thêm nhanh vào giỏ hàng qua Modal Bottom Sheet linh hoạt.

### 🗂️ 3. Quản lý Danh mục (Category Management)
- Xem danh sách danh mục hiện có.
- Thêm mới và quản lý danh mục giúp phân loại sản phẩm logic.

### 🛒 4. Giỏ hàng & Offline Cache (Cart & Local Storage)
- **Lưu trữ cục bộ NoSQL với Hive**: Giỏ hàng được lưu trực tiếp trên thiết bị (offline-first), tốc độ đọc/ghi cực nhanh.
- Tùy chỉnh số lượng mua hàng trực quan, tính toán giá trị đơn hàng tức thì.
- Badge đếm số lượng mặt hàng trong giỏ cập nhật phản ứng nhanh (reactive state) theo thời gian thực.

---

## 🏛️ Kiến trúc ứng dụng (MVC Pattern)

Dự án áp dụng mô hình kiến trúc **MVC (Model - View - Controller)** kết hợp **Repository Pattern** và **Dependency Injection (Bindings)** của GetX:

```
┌────────────────────────────────────────────────────────┐
│                        VIEW                            │
│  (UI / Widgets / Pages: Lắng nghe state & bắt sự kiện) │
└───────────────────────▲────────────────────────────────┘
                        │ Obx() / GetBuilder()
                        ▼
┌────────────────────────────────────────────────────────┐
│                     CONTROLLER                         │
│  (Business Logic, Quản lý State, Xử lý tương tác UI)   │
└───────────────────────▲────────────────────────────────┘
                        │ Gọi phương thức Data
                        ▼
┌────────────────────────────────────────────────────────┐
│                  REPOSITORY / SERVICE                  │
│  (Trừu tượng hóa nguồn dữ liệu: Remote API hoặc Cache) │
└───────────▲────────────────────────────────▲───────────┘
            │                                │
            ▼                                ▼
┌───────────────────────┐        ┌───────────────────────┐
│     REMOTE API        │        │   LOCAL STORAGE       │
│  (Dio HTTP Client)    │        │   (Hive NoSQL DB)     │
└───────────────────────┘        └───────────────────────┘
            │                                │
            └────────────────┬───────────────┘
                             ▼
┌────────────────────────────────────────────────────────┐
│                         MODEL                          │
│   (Data Transfer Objects, Entities, Serialization)     │
└────────────────────────────────────────────────────────┘
```

### Chi tiết các tầng trong MVC:
1. **Model (Dữ liệu & Thực thể)**:
   - Đại diện cho các đối tượng nghiệp vụ (`Product`, `Category`, `CartRequest`, `LoginResponse`).
   - Hỗ trợ Serialize/Deserialize JSON và Hive TypeAdapters (`.g.dart`) cho lưu trữ offline.
2. **View (Giao diện người dùng)**:
   - Các màn hình (`Page`) và Widget con tái sử dụng (`build_chip_filter_widget`, `build_product_drawer`,...).
   - Chỉ đảm nhận hiển thị và bắt thao tác từ người dùng, hoàn toàn không chứa logic nghiệp vụ.
   - Lắng nghe sự thay đổi của dữ liệu phản ứng thông qua `Obx()`.
3. **Controller (Điều khiển & Logic nghiệp vụ)**:
   - Kế thừa từ `GetxController`, quản lý vòng đời (`onInit`, `onClose`).
   - Chứa các biến trạng thái phản ứng (`RxList`, `RxBool`, `RxString`).
   - Xử lý các luồng: gọi Repository lấy dữ liệu, bắt ngoại lệ (`try/catch`), hiển thị Dialog/SnackBar và phân trang.
4. **Repository & Service Layer**:
   - Tách biệt logic truy xuất mạng (`Dio`) và truy xuất bộ nhớ cục bộ (`Hive Box`).
   - Controller không trực tiếp giao tiếp với HTTP client, giúp dễ dàng viết Unit Test hoặc hoán đổi nguồn dữ liệu.
5. **GetX Binding (Dependency Injection)**:
   - Khởi tạo controller và dependency đúng lúc (Lazy loading) theo từng Route, tự động giải phóng RAM khi rời màn hình.

---

## 📂 Cấu trúc thư mục dự án

```text
lib/
├── main.dart                          # Điểm khởi động ứng dụng, nạp Hive & Singleton Services
│
├── cores/                             # Thành phần dùng chung toàn hệ thống (Core modules)
│   ├── api/
│   │   └── data_api_config.dart       # Cấu hình Dio client, Base URL, Timeout
│   ├── arguments/                     # Các class truyền tham số an toàn giữa các màn hình
│   │   ├── cart_argument.dart
│   │   ├── category_argument.dart
│   │   └── form_product_argument.dart
│   ├── base/                          # Các lớp Base & Tiện ích UI dùng lại
│   │   ├── base_api.dart              # Base class xử lý gọi API & chuẩn hóa Response
│   │   ├── base_dialog.dart           # Dialog thông báo & xác nhận dùng chung
│   │   ├── base_form_text_field.dart  # Form Input chuẩn hóa thiết kế & validation
│   │   ├── base_snack_bar.dart        # Thông báo trạng thái nhanh
│   │   └── base_unauthorized.dart     # Xử lý tự động khi phiên hết hạn
│   ├── exceptions/                    # Định nghĩa các Custom Exception theo từng module
│   │   ├── cart_exception.dart
│   │   ├── category_exception.dart
│   │   ├── product_exception.dart
│   │   └── unauthorized_exception.dart
│   ├── interceptors/
│   │   └── auth_request_interceptor.dart # Dio Interceptor tự động gắn Bearer Token
│   ├── routes/
│   │   ├── page_app.dart              # Định nghĩa tên định tuyến (Route constants)
│   │   └── page_route.dart            # Cấu hình GetPage gắn liền với Binding tương ứng
│   └── services/
│       └── auth_service.dart          # Quản lý Token & thông tin người dùng trong RAM/Bộ nhớ
│
└── modules/                           # Thiết kế Module theo chuẩn Feature-based MVC
    ├── splash/                        # Màn hình chờ kiểm tra phiên làm việc
    │   ├── bindings/
    │   ├── controllers/
    │   ├── repositories/
    │   └── views/
    ├── login/                         # Phân hệ Xác thực
    │   ├── bindings/
    │   ├── controllers/
    │   ├── models/
    │   ├── repositories/
    │   └── views/
    ├── product/                       # Phân hệ Quản lý & Xem sản phẩm
    │   ├── bindings/                  # ProductBinding, FormProductBinding
    │   ├── controllers/               # ProductController, FormProductController
    │   ├── models/                    # ProductRequest, ProductResponse
    │   ├── repositories/              # ProductRepository (Gọi API CRUD)
    │   └── views/                     # ProductPage, DetailPage, FormPage, Widgets...
    ├── category/                      # Phân hệ Quản lý Danh mục
    │   ├── bindings/
    │   ├── controllers/
    │   ├── models/
    │   ├── repositories/
    │   └── views/
    └── cart/                          # Phân hệ Giỏ hàng (Offline với Hive)
        ├── bindings/
        ├── controllers/
        ├── models/
        └── views/
```

---

## 🛠️ Công nghệ & Thư viện sử dụng

| Công nghệ / Thư viện | Phiên bản | Mục đích sử dụng |
|:---|:---:|:---|
| **Flutter SDK** | `>=3.12.1` | Framework phát triển đa nền tảng (Android / iOS) |
| **GetX** | `^4.7.3` | Quản lý State Reactive, Điều hướng thông minh & Dependency Injection |
| **Dio** | `^5.10.0` | HTTP Client mạnh mẽ, hỗ trợ Interceptor, BaseOptions, Timeout |
| **Hive & Hive Flutter** | `^2.2.3` | Cơ sở dữ liệu NoSQL Key-Value siêu nhẹ, tốc độ cao cho lưu trữ Offline |
| **JWT Decoder** | `^2.0.1` | Giải mã và kiểm tra hạn sử dụng của JWT Token |
| **Intl** | `^0.20.3` | Định dạng tiền tệ Việt Nam Đồng (VND) và ngày tháng chuẩn hóa |
| **Build Runner & Hive Generator** | Dev | Sinh mã tự động cho Hive Type Adapters |

---

## 🎯 Điểm sáng kỹ thuật dành cho Nhà Tuyển Dụng

1. **Kiến trúc phân tầng sạch sẽ (Clean Architecture & Modular MVC)**:
   - Không bị lẫn lộn giữa UI và Logic; các chức năng được đóng gói theo từng module (`modules/product`, `modules/cart`,...) giúp dễ bảo trì và phân chia công việc trong đội ngũ.
2. **Quản lý tài nguyên & Bộ nhớ thông minh**:
   - Sử dụng cơ chế `Binding` của GetX kết hợp phân trang `ScrollController`, hạn chế triệt để hiện tượng memory leak.
3. **Mạng & Xử lý ngoại lệ chuyên nghiệp (Robust Error Handling)**:
   - Xây dựng tầng `BaseApi`, `Custom Exceptions` và `AuthRequestInterceptor` riêng biệt; ứng dụng tự phục hồi hoặc thông báo rõ ràng cho người dùng khi gặp sự cố mạng hoặc lỗi xác thực (401, 403, 500).
4. **Offline First với NoSQL Hive**:
   - Dữ liệu giỏ hàng và danh mục được cache offline qua Hive Box, cho phép người dùng xem và thao tác mượt mà ngay cả khi đường truyền chập chờn.
5. **Code Style chuẩn mực**:
   - Tuân thủ bộ quy tắc `flutter_lints`, đặt tên biến/hàm theo chuẩn Dart Style Guide, cấu trúc component nhỏ gọn và tái sử dụng cao.

---

## 🚀 Hướng dẫn cài đặt & Khởi chạy

### Yêu cầu tiên quyết:
- Đã cài đặt [Flutter SDK](https://docs.flutter.dev/get-started/install) (khuyến nghị phiên bản `>=3.12.1`).
- Android Studio / VS Code đã cài extension Flutter & Dart.
- Backend API đang hoạt động (cấu hình IP tại `lib/cores/api/data_api_config.dart`).

### Các bước cài đặt:

1. **Clone repository về máy:**
   ```bash
   git clone <repository-url>
   cd prjgetxmvc
   ```

2. **Cài đặt các gói phụ thuộc (Dependencies):**
   ```bash
   flutter pub get
   ```

3. **Tạo mã chuyển đổi cho Hive Adapters (nếu cần):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Cấu hình địa chỉ API Backend:**
   Mở file [`lib/cores/api/data_api_config.dart`](lib/cores/api/data_api_config.dart) và điều chỉnh lại IP máy chủ:
   ```dart
   baseUrl: "http://<YOUR_API_IP_OR_DOMAIN>:<PORT>/api/v1"
   ```
   *(Lưu ý: Mặc định `10.0.2.2` dùng cho Android Emulator truy cập localhost máy tính host).*

5. **Khởi chạy ứng dụng:**
   ```bash
   flutter run
   ```

---

## 👨‍💻 Thông tin liên hệ & Ứng tuyển

- **Họ và tên**: Lê Văn Tạ (Ga)
- **Vị trí ứng tuyển**: Flutter Developer / Mobile App Developer
- **Email**: *(Cập nhật email của bạn)*
- **GitHub**: [github.com/LevanTAdev25](https://github.com/LevanTAdev25)
- **LinkedIn**: *(Cập nhật link LinkedIn của bạn)*

---
*⭐ Nếu bạn thấy dự án hữu ích hoặc muốn trao đổi cơ hội việc làm, đừng ngần ngại kết nối với tôi!*
