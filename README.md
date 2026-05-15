# 📐 Hướng Dẫn Kiến Trúc Dự Án — MVVM + Folder-by-Feature

> **Mục tiêu:** Tối ưu hóa làm việc nhóm, giảm thiểu conflict, tách biệt module rõ ràng.

---

## 1. Cấu Trúc Thư Mục (Folder Structure)

Mỗi developer làm việc trên một Feature riêng biệt, **không chạm vào file của người khác**.

```
lib/
├── core/                    # Các thiết lập dùng chung toàn app
│   ├── values/              # Màu sắc, font chữ, hằng số
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_constants.dart
│   ├── theme/               # ThemeData, AppStyles
│   │   └── app_theme.dart
│   ├── utils/               # Helper functions, formatters
│   │   ├── date_formatter.dart
│   │   └── number_formatter.dart
│   └── network/             # Base API provider, interceptors
│       ├── api_client.dart
│       └── interceptors.dart
│
├── data/                    # Tầng dữ liệu (Model & Provider)
│   ├── models/              # Các class POJO/Entity
│   ├── services/            # Gọi API, Local DB (GetConnect / Dio)
│   └── repositories/        # Cầu nối Service ↔ ViewModel
│
├── modules/                 # Tầng UI & Logic (MVVM) — Chia theo Feature
│   ├── home/
│   │   ├── bindings/        # Khai báo Controller (GetX DI)
│   │   │   └── home_binding.dart
│   │   ├── controllers/     # ViewModel — xử lý logic màn hình
│   │   │   └── home_controller.dart
│   │   └── views/           # Giao diện
│   │       ├── home_screen.dart
│   │       └── widgets/     # Widget nhỏ thuộc riêng module home
│   │           ├── kpi_card_widget.dart
│   │           └── progress_bar_widget.dart
│   │
│   └── kpi_detail/
│       ├── bindings/
│       ├── controllers/
│       └── views/
│
├── routes/                  # Quản lý navigation
│   ├── app_pages.dart
│   └── app_routes.dart
│
└── widgets/                 # Widget dùng chung toàn app
    ├── custom_button.dart
    ├── custom_card.dart
    └── loading_indicator.dart
```

---

## 2. Bảng Màu Chuẩn (AppColors)

**File:** `lib/core/values/app_colors.dart`

```dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Không cho khởi tạo

  // --- Primary ---
  static const Color primaryBlue     = Color(0xFF2F80ED);
  static const Color primaryBlueDark = Color(0xFF175CD3);

  // --- Status ---
  static const Color successGreen  = Color(0xFF26A69A);
  static const Color alertRed      = Color(0xFFE74C3C);
  static const Color warningYellow = Color(0xFFF2C94C);

  // --- Background & Surface ---
  static const Color neutralBackground = Color(0xFFF5F7FB);
  static const Color cardWhite         = Color(0xFFFFFFFF);

  // --- Text ---
  static const Color textPrimary   = Color(0xFF0F1724);
  static const Color textSecondary = Color(0xFF6B7280);

  // --- Shadow ---
  static BoxShadow get lightShadow => BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );
}
```

---

## 3. Text Styles Chuẩn (AppTextStyles)

**File:** `lib/core/values/app_text_styles.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get heading1 => GoogleFonts.inter(
    fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary,
  );

  static TextStyle get heading2 => GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textPrimary,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12, color: AppColors.textSecondary,
  );
}
```

---

## 4. Cấu Trúc Một Module (Ví dụ: `home`)

### 4.1 Binding — Khai báo Dependency Injection

```dart
// lib/modules/home/bindings/home_binding.dart
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
```

### 4.2 Controller — ViewModel (Logic)

```dart
// lib/modules/home/controllers/home_controller.dart
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Reactive state
  final RxBool isLoading = false.obs;
  final RxList kpiList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    // TODO: gọi Repository
    isLoading.value = false;
  }
}
```

### 4.3 View — UI (Không chứa logic)

```dart
// lib/modules/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/values/app_colors.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(child: Text('Content here'));
      }),
    );
  }
}
```

---

## 5. Quản Lý Routes

**File:** `lib/routes/app_routes.dart`

```dart
abstract class AppRoutes {
  static const home      = '/home';
  static const kpiDetail = '/kpi-detail';
}
```

**File:** `lib/routes/app_pages.dart`

```dart
import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
```

---

## 6. Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # State management, routing, DI
  get: ^4.6.6

  # SVG support
  flutter_svg: ^2.0.10

  # Modern fonts
  google_fonts: ^6.2.1

  # Progress bar cho KPI
  percent_indicator: ^4.2.3
```

Chạy lệnh sau để cài:

```bash
flutter pub get
```

---

## 7. Quy Trình Giảm Conflict Cho Team (3 Nguyên Tắc Vàng)

| # | Nguyên tắc | Chi tiết |
|---|------------|----------|
| 1 | **Tách nhỏ Widget** | Không viết View > 300 dòng. Mỗi Card, Header tách ra file riêng trong `views/widgets/` của module |
| 2 | **Dùng Bindings** | Quản lý khởi tạo Controller qua Bindings — tách hoàn toàn Logic khỏi UI |
| 3 | **Localize Strings** | Tất cả văn bản tiếng Việt vào file ngôn ngữ `vi_VN.dart`, không hard-code vào UI |

---

## 8. Quy Ước Đặt Tên (Naming Convention)

| Loại | Quy ước | Ví dụ |
|------|---------|-------|
| File | `snake_case` | `home_controller.dart` |
| Class | `PascalCase` | `HomeController` |
| Variable | `camelCase` | `isLoading` |
| Constant | `camelCase` | `AppColors.primaryBlue` |
| Route | `kebab-case` | `/kpi-detail` |

---
