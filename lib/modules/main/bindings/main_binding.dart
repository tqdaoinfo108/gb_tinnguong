import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../map/controllers/map_controller.dart';
import '../../events/controllers/events_controller.dart';
import '../../news/controllers/news_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../account/controllers/account_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => GisMapController());
    Get.lazyPut(() => EventsController());
    Get.lazyPut(() => NewsController());
    Get.lazyPut(() => NotificationsController());
    Get.lazyPut(() => AccountController());
  }
}
