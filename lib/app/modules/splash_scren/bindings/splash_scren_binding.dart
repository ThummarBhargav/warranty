import 'package:get/get.dart';

import '../controllers/splash_scren_controller.dart';

class SplashScrenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScrenController>(
      () => SplashScrenController(),
    );
  }
}
