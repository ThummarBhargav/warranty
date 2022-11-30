import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constants/api_constants.dart';
import '../../../../main.dart';
import '../../../models/categoriesModels.dart';
import '../../../routes/app_pages.dart';
import '../../add_item_listscreen/controllers/add_item_listscreen_controller.dart';
import '../../home/controllers/home_controller.dart';

class AddItemController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<TextEditingController> itemnamecontroller = TextEditingController().obs;
  Rx<TextEditingController> durationcontroller = TextEditingController().obs;
  Rx<TextEditingController> detailscontroller = TextEditingController().obs;
  Rx<TextEditingController> dateController = TextEditingController(
          text: DateFormat('dd/MM/yyyy').format(DateTime.now()))
      .obs;

  SingleValueDropDownController? dropDownController;
  HomeController? homeController;
  AddItemListscreenController? addItemListscreenController;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  bool isFromHome = false;
  RxBool isDurationEmpty = false.obs;
  RxBool isNameEmpty = false.obs;
  bool isFromEdit = false;
  bool isFromInnerScreen = false;
  String categoryName = "";
  dataModels? additemListview;
  RxList<String>? files = RxList<String>([]);
  RxList<String>? files1 = RxList<String>([]);
  @override
  void onInit() {
    Get.lazyPut(() => AddItemListscreenController());
    addItemListscreenController = Get.find<AddItemListscreenController>();
    Get.lazyPut(() => HomeController());
    homeController = Get.find<HomeController>();
    if (Get.arguments != null) {
      isFromHome = Get.arguments[ArgumentConstant.isFromHome];
      isFromEdit = Get.arguments[ArgumentConstant.isFromEdit];
      isFromInnerScreen = Get.arguments[ArgumentConstant.isFromInnerScreen];

      if (isFromEdit) {
        additemListview = Get.arguments[ArgumentConstant.additemListview];
        itemnamecontroller.value.text = additemListview!.ItemName.toString();
        durationcontroller.value.text = additemListview!.Duration.toString();
        detailscontroller.value.text = additemListview!.Ditails.toString();
        dateController.value.text = additemListview!.Date.toString();
        files!.value = additemListview!.Image.toString().split(" ");
        files1!.value = additemListview!.Bill.toString().split(" ");
        print(files);
      }

      if (isFromHome) {
        dropDownController = SingleValueDropDownController(
            data: DropDownValueModel(
                name: homeController!.categoryDataList
                    .map((element) => DropDownValueModel(
                        name: element.categoriesName.toString(),
                        value: element.categoriesName.toString()))
                    .toList()
                    .first
                    .name,
                value: homeController!.categoryDataList
                    .map((element) => DropDownValueModel(
                        name: element.categoriesName.toString(),
                        value: element.categoriesName.toString()))
                    .toList()
                    .first
                    .value));
      } else {
        categoryName = Get.arguments[ArgumentConstant.Categoriename];
        dropDownController = SingleValueDropDownController(
          data: DropDownValueModel(
            name: categoryName,
            value: categoryName,
          ),
        );
      }
    }

    super.onInit();
  }

  EditItem(dataModels c) {
    addItemListscreenController!.addDataList.asMap().forEach((index, value) {
      if (addItemListscreenController!.addDataList[index].id ==
          additemListview!.id) {
        addItemListscreenController!.addDataList[index] = c;
      }
    });

    Get.offAllNamed(Routes.ADD_ITEM_LISTSCREEN, arguments: {
      ArgumentConstant.Categoriename: categoryName,
    });
    box.write(ArgumentConstant.additemList,
        jsonEncode(addItemListscreenController!.addDataList));
  }

  addItem(dataModels c) {
    addItemListscreenController!.addDataList.add(
      c,
    );
    box.write(ArgumentConstant.additemList,
        jsonEncode(addItemListscreenController!.addDataList));
    (isFromHome)
        ? Get.offAndToNamed(Routes.HOME)
        : Get.offAndToNamed(Routes.ADD_ITEM_LISTSCREEN, arguments: {
            ArgumentConstant.Categoriename: categoryName,
          });
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
