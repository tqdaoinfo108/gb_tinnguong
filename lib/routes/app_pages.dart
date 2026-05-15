import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/facilities/views/facility_detail_screen.dart';
import '../modules/clergy/views/clergy_detail_screen.dart';
import '../modules/stats/views/stats_screen.dart';
import '../modules/album/views/album_screen.dart';

class AppPages {
  AppPages._();
  static const initial = AppRoutes.login;

  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.facilityDetail,
      page: () => const FacilityDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.clergyDetail,
      page: () => const ClergyDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.stats,
      page: () => const StatsScreen(),
    ),
    GetPage(
      name: AppRoutes.album,
      page: () => const AlbumScreen(),
    ),
  ];
}
