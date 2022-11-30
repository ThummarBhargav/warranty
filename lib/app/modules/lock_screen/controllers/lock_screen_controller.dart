import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/progress_dialog_utils.dart';
import '../../../models/categoriesModels.dart';
import '../../../routes/app_pages.dart';

class LockScreenController extends GetxController {
  String Password = "1234";
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  RxBool isIncorrect = false.obs;
  RxList<BiometricType> availableBiometric = RxList<BiometricType>([]);
  final LocalAuthentication auth = LocalAuthentication();
  RxBool isAuth = false.obs;
  RxBool canCheckBiometric = false.obs;
  RxList<categoriesModel> dataList = RxList<categoriesModel>([]);
  @override
  Future<void> onInit() async {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.Password))) {
      Password = box.read(ArgumentConstant.Password);
    }
    box.write(ArgumentConstant.Password, Password);
    if (isNullEmptyOrFalse(box.read(ArgumentConstant.categoriesList))) {
      getCategoryData();
    }
    canCheckBiometric.value = await auth.canCheckBiometrics;
    checkAuth();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  getCategoryData() {
    Map<String, dynamic> categoriesdata = {
      "code": 200,
      "message": "Course subject lists.",
      "data": [
        {
          "categoriesName": "Electronics",
          "Image": "electronics.svg",
          "Counter": "0",
          "Color": Color(0xffADD8E6).toString()
        },
        {
          "categoriesName": "Sports",
          "Image": "sports.svg",
          "Counter": "0",
          "Color": Color(0xffFFD580).toString()
        },
        {
          "categoriesName": "Kitchen",
          "Image": "kitchen.svg",
          "Counter": "0",
          "Color": Color(0xffFFB6C6).toString()
        },
        {
          "categoriesName": "Fashion",
          "Image": "fashion.svg",
          "Counter": "0",
          "Color": Color(0xffCBC3E3).toString()
        },
        {
          "categoriesName": "Vehicles",
          "Image": "vehicles.svg",
          "Counter": "0",
          "Color": Color(0xffFFFFE0).toString()
        },
        {
          "categoriesName": "Mobile",
          "Image": "mobile.svg",
          "Counter": "0",
          "Color": Color(0xffC7F6B6).toString()
        },
      ],
    };
    if (categoriesdata['code'] == 200) {
      RxList<categoriesModel> tempDataList = RxList<categoriesModel>([]);
      categoriesdata['data'].forEach(
        (data) {
          tempDataList.add(
            categoriesModel(
                categoriesName: data["categoriesName"],
                Image: data["Image"],
                Counter: data["Counter"],
                color: data["Color"]),
          );
        },
      );
      print(tempDataList);
      dataList.addAll(tempDataList);
      box.write(ArgumentConstant.categoriesList, jsonEncode(dataList));
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

  checkAuth() async {
    try {
      await auth.getAvailableBiometrics().then((value) {
        if (!isNullEmptyOrFalse(value)) {
          availableBiometric.value = value;
        }
      });
    } on PlatformException catch (e) {}
    try {
      await auth
          .authenticate(
        localizedReason: 'Touch your finger on the sensor to login',
        options: AuthenticationOptions(
          biometricOnly: true,
        ),
      )
          .then((value) {
        if (!isNullEmptyOrFalse(value)) {
          isAuth.value = true;
          checkPassword();
        }
      });
    } catch (e) {
      PlatformException error = e as PlatformException;
      if (error.code != "auth_in_progress" && error.code != "NotAvailable") {
        getIt<CustomDialogs>()
            .getDialog(title: "Failed", desc: "${error.message}");
      }
      print(e);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  checkPassword() {
    if (box.read(ArgumentConstant.Password) == passwordController.value.text) {
      Get.offAndToNamed(Routes.HOME);
    } else if (isAuth.value) {
      Get.offAndToNamed(Routes.HOME);
    } else {
      isIncorrect.value = true;
      passwordController.value.clear();
    }
  }
}
