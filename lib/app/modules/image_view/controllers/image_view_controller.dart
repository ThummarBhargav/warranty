import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';


class ImageViewController extends GetxController {
  String? image;

  @override
  void onInit() {
    if (Get.arguments != null) {
      image = Get.arguments[ArgumentConstant.imageview];
    }
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
