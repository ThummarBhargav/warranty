import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/sizeConstant.dart';
import '../controllers/splash_scren_controller.dart';

class SplashScrenView extends GetWidget<SplashScrenController> {
  const SplashScrenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MySize.safeHeight,
          width: MySize.safeWidth,
          child: Image.asset(
            "image/splash.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
