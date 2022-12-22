import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../models/categoriesModels.dart';

class HomeController extends GetxController {
  Rx<TextEditingController> categoryNameController =
      TextEditingController().obs;
  Rx<TextEditingController> editCategoryNameController =
      TextEditingController().obs;
  RxList<categoriesModel> categoryDataList = RxList<categoriesModel>([]);
  RxList<dataModels> addItemList = RxList<dataModels>([]);
  var connectivityResult;
  RxBool isSetting = false.obs;
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.warrenty_manager.warrentytracker',
    appStoreIdentifier: '1491556149',
  );
  @override
  void onInit() async {
    categoryDataList.value =
        (jsonDecode(box.read(ArgumentConstant.categoriesList)) as List)
            .toList()
            .map((e) => categoriesModel.fromJson(e))
            .toList();
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.additemList))) {
      addItemList.value =
          (jsonDecode(box.read(ArgumentConstant.additemList)) as List)
              .toList()
              .map((e) => dataModels.fromJson(e))
              .toList();
    }
    connectivityResult = await Connectivity().checkConnectivity();
    box.write(ArgumentConstant.isFirstTime, true);
    super.onInit();
  }

  addCategory(categoriesModel c) {
    categoryDataList.add(
      c,
    );
    box.write(ArgumentConstant.categoriesList, jsonEncode(categoryDataList));
  }
}
