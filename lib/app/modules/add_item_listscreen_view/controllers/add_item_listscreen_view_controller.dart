import 'package:get/get.dart';
import '../../../../constants/api_constants.dart';
import '../../../models/categoriesModels.dart';

class AddItemListscreenViewController extends GetxController {
  dataModels? addItemListview;
  @override
  void onInit() {
    if (Get.arguments != null) {
      addItemListview = Get.arguments[ArgumentConstant.additemListview];
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
