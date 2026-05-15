import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../map/controllers/map_controller.dart';
import '../../events/controllers/events_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.lazyPut(() => GisMapController());
    Get.lazyPut(() => EventsController());
  }
}
