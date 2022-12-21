import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yodo1mas/testmasfluttersdktwo.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../constants/text_field.dart';
import '../../../../main.dart';
import '../../../../utilities/buttons.dart';
import '../../../../utilities/timer_service.dart';
import '../../../models/categoriesModels.dart';
import '../../../routes/app_pages.dart';

class AddItemListscreenController extends GetxController {
  RxList<dataModels> addDataList = RxList<dataModels>([]);
  RxList<dataModels> addDataTempList = RxList<dataModels>([]);
  RxList<dataModels> expireDataList = RxList<dataModels>([]);
  String? CategoryName;
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.additemList))) {
      addDataList.value =
          (jsonDecode(box.read(ArgumentConstant.additemList)) as List)
              .toList()
              .map((e) => dataModels.fromJson(e))
              .toList();
    }
    Yodo1MAS.instance.setInterstitialListener((event, message) {
      switch (event) {
        case Yodo1MAS.AD_EVENT_OPENED:
          print('Interstitial AD_EVENT_OPENED');
          break;
        case Yodo1MAS.AD_EVENT_ERROR:
          print('Interstitial AD_EVENT_ERROR' + message);
          break;
        case Yodo1MAS.AD_EVENT_CLOSED:
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          getIt<TimerService>().verifyTimer();
          Get.offAndToNamed(Routes.HOME);
          break;
      }
    });
    if (Get.arguments != null) {
      CategoryName = Get.arguments[ArgumentConstant.Categoriename];
    }
    getFilterData();

    super.onInit();
  }

  getFilterData() {
    if (!isNullEmptyOrFalse(addDataList)) {
      addDataList.forEach((element) {
        if (element.categoriesName == CategoryName) {
          addDataTempList.add(element);
        }
      });
    }
    expireData();
  }

  expireData() {
    if (!isNullEmptyOrFalse(addDataTempList)) {
      addDataTempList.forEach((element) {
        if (getDateFromStringNew(element.expiredDate.toString(),
                formatter: 'dd/MM/yyyy')
            .isBefore(DateTime.now())) {
          expireDataList.add(element);
        }
      });
    }
    print(expireDataList);
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
