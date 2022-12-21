import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:warranty_appp/main.dart';
import 'package:warranty_appp/utilities/timer_service.dart';
import 'package:yodo1mas/testmasfluttersdktwo.dart';
import '../../../../constants/api_constants.dart';
import '../../../models/categoriesModels.dart';
import '../../../routes/app_pages.dart';

class AddItemListscreenViewController extends GetxController {
  dataModels? addItemListview;
  List<String> expireDate = [];
  List<String> purchasedDate = [];
  @override
  void onInit() {
    Yodo1MAS.instance.setInterstitialListener((event, message) {
      switch (event) {
        case Yodo1MAS.AD_EVENT_OPENED:
          print('Interstitial AD_EVENT_OPENED');
          break;
        case Yodo1MAS.AD_EVENT_ERROR:
          print('Interstitial AD_EVENT_ERROR' + message);
          break;
        case Yodo1MAS.AD_EVENT_CLOSED:
          getIt<TimerService>().verifyTimer();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          Get.offAndToNamed(Routes.ADD_ITEM_LISTSCREEN, arguments: {
            ArgumentConstant.Categoriename:
                addItemListview!.categoriesName.toString(),
          });
          break;
      }
    });

    print(Get.arguments[ArgumentConstant.additemListview]);
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
