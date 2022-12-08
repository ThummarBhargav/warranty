import 'dart:async';
import 'package:get/get.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../routes/app_pages.dart';

class SplashScrenController extends GetxController {
  @override
  void onInit() {
    Timer(Duration(seconds: 3), () {
      (!isNullEmptyOrFalse(box.read(ArgumentConstant.isPermissionDone)))
          ? Get.offAndToNamed(Routes.LOCK_SCREEN)
          : Get.offAndToNamed(Routes.PERMISSION);
    });

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
