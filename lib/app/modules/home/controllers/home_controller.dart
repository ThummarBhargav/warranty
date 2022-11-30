import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../models/categoriesModels.dart';

class HomeController extends GetxController {
  Rx<TextEditingController> categoryNameController =
      TextEditingController().obs;
  RxList<categoriesModel> categoryDataList = RxList<categoriesModel>([]);
  RxList<dataModels> addItemList = RxList<dataModels>([]);

  @override
  void onInit() {
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
