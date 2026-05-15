import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/localization/app_translations.dart';
import 'core/network/dio_client.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await DioClient().getToken();
  final initialRoute = token != null ? AppRoutes.main : AppRoutes.login;
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Tín Ngưỡng GIS',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: initialRoute,
          getPages: AppPages.pages,
          locale: const Locale('vi', 'VN'),
          fallbackLocale: const Locale('vi', 'VN'),
          translations: AppTranslations(),
          defaultTransition: Transition.fadeIn,
          builder: (context, widget) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: widget!,
          ),
        );
      },
    );
  }
}
