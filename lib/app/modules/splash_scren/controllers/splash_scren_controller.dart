import 'dart:async';
import 'package:get/get.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../routes/app_pages.dart';

class SplashScrenController extends GetxController {
  String payload = "";
  bool isFromPayload = false;
  @override
  void onInit() {
    if (Get.arguments != null) {
      payload = Get.arguments[ArgumentConstant.Payload];
      isFromPayload = Get.arguments[ArgumentConstant.isFromPayload];
    }
    Timer(Duration(seconds: 3), () {
      (!isNullEmptyOrFalse(box.read(ArgumentConstant.isPermissionDone)))
          ? Get.offAndToNamed(
              Routes.LOCK_SCREEN,
              arguments: {
                ArgumentConstant.Payload: payload,
                ArgumentConstant.isFromPayload: isFromPayload,
              },
            )
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
