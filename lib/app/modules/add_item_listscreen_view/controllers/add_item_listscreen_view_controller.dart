import 'package:get/get.dart';
import '../../../../constants/api_constants.dart';
import '../../../models/categoriesModels.dart';

class AddItemListscreenViewController extends GetxController {
  dataModels? addItemListview;
  List<String> expireDate = [];
  List<String> purchasedDate = [];
  @override
  void onInit() {
    if (Get.arguments != null) {
      addItemListview = Get.arguments[ArgumentConstant.additemListview];
    }
    expireDate = addItemListview!.expiredDate.toString().split(" ");
    purchasedDate = addItemListview!.Date.toString().split(" ");
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
