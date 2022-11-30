import 'package:get/get.dart';

import '../controllers/add_item_listscreen_view_controller.dart';

class AddItemListscreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddItemListscreenViewController>(
      () => AddItemListscreenViewController(),
    );
  }
}
