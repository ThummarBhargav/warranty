import 'package:get/get.dart';

import '../controllers/add_item_listscreen_controller.dart';

class AddItemListscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddItemListscreenController>(
      () => AddItemListscreenController(),
    );
  }
}
