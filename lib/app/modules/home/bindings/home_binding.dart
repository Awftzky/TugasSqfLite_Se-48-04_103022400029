import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/material_form_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MaterialFormController>(
      () => MaterialFormController(onSave: Get.find<HomeController>().saveItem),
    );
  }
}
