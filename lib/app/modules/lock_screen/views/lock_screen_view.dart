import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../controllers/lock_screen_controller.dart';

class LockScreenView extends GetWidget<LockScreenController> {
  const LockScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.appbarTheme,
          title: Text(
            'passcode',
            style: GoogleFonts.lexend(
              fontWeight: FontWeight.w400,
              fontSize: MySize.getHeight(20),
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          return Container(
            height: MySize.safeHeight,
            width: MySize.safeWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                SvgPicture.asset(
                  "image/lock.svg",
                  height: MySize.getHeight(150),
                  width: MySize.getWidth(150),
                ),
                Spacer(),
                Text(
                  "Enter your of 4 digits passcode",
                  style: GoogleFonts.lexend(
                    fontWeight: FontWeight.w400,
                    fontSize: MySize.getHeight(14),
                  ),
                ),
                Spacer(),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    length: 4,
                    obscureText: true,
                    showCursor: false,
                    defaultPinTheme: PinTheme(
                      width: MySize.getHeight(50),
                      height: MySize.getHeight(50),
                      textStyle: TextStyle(
                          fontSize: MySize.getHeight(35),
                          color: appTheme.appbarTheme,
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.06),
                            blurStyle: BlurStyle.outer,
                            blurRadius: MySize.getHeight(13),
                            spreadRadius: MySize.getHeight(1),
                          ),
                        ],
                      ),
                    ),
                    controller: controller.passwordController.value,
                    readOnly: true,
                    onTap: null,
                  ),
                ),
                Spacer(),
                (isNullEmptyOrFalse(box.read(ArgumentConstant.isFirstTime)) &&
                        box.read(ArgumentConstant.isFirstTime) != true &&
                        controller.passwordController.value.text.length == 0)
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MySize.getHeight(10.0)),
                        child: Column(children: [
                          Text(
                            "your default passcode is",
                            style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(14),
                            ),
                          ),
                          Text(
                            " 1234 ",
                            style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(14),
                            ),
                          ),
                          Text(
                            "you can change it later from settings.",
                            style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(14),
                            ),
                          ),
                        ]),
                      )
                    : Container(),
                Spacer(),
                (controller.isIncorrect.value)
                    ? Text(
                        "Incorrect Password. Please try again.",
                        style: GoogleFonts.lexend(
                          fontWeight: FontWeight.w400,
                          color: appTheme.ErrorText,
                          fontSize: MySize.getHeight(12),
                        ),
                      )
                    : Container(
                        height: 10,
                      ),
                Spacer(),
                Container(
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          "image/numpad.svg",
                          width: MySize.screenWidth,
                          // fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: (MySize.isMini)
                            ? MySize.getHeight(100)
                            : MySize.getHeight(80),
                        // left: MySize.getWidth(75),
                        child: Container(
                          height: MySize.getHeight(280),
                          width: MySize.getWidth(280),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  getCustomButton(
                                    number: "1",
                                  ),
                                  getCustomButton(
                                    number: "2",
                                  ),
                                  getCustomButton(
                                    number: "3",
                                  )
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  getCustomButton(
                                    number: "4",
                                  ),
                                  getCustomButton(
                                    number: "5",
                                  ),
                                  getCustomButton(
                                    number: "6",
                                  )
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  getCustomButton(
                                    number: "7",
                                  ),
                                  getCustomButton(
                                    number: "8",
                                  ),
                                  getCustomButton(
                                    number: "9",
                                  )
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  getCustomButton(
                                    isIcon: true,
                                    isBackButton: true,
                                    icon: Icons.backspace_rounded,
                                  ),
                                  getCustomButton(
                                    number: "0",
                                  ),
                                  getCustomButton(
                                    isIcon: true,
                                    isSubmitButton: true,
                                    icon: Icons.check,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  getCustomButton({
    bool isIcon = false,
    bool isBackButton = false,
    bool isSubmitButton = false,
    String number = "0",
    IconData icon = Icons.add,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (isBackButton)
              ? () {
                  List<String> temp = controller.passwordController.value.text
                      .toString()
                      .split("");
                  temp.removeLast();
                  controller.passwordController.value.text = temp.join("");
                }
              : (isSubmitButton)
                  ? () {
                      if (controller.passwordController.value.text.length >=
                          3) {
                        controller.checkPassword();
                      } else {
                        controller.passwordController.value.clear();
                      }
                    }
                  : () {
                      if (controller.passwordController.value.text.length <=
                          3) {
                        controller.passwordController.value.text =
                            controller.passwordController.value.text + number;
                        controller.isIncorrect.value = false;
                      }
                      if (controller.passwordController.value.text.length ==
                          4) {
                        controller.checkPassword();
                      }
                    },
          child: Container(
            height: MySize.getHeight(60),
            child: (isIcon)
                ? Center(
                    child: Icon(
                      icon,
                      color: (isSubmitButton)
                          ? appTheme.yellowPrimaryTheme
                          : Colors.white,
                      size: MySize.getHeight(30),
                    ),
                  )
                : Center(
                    child: Text(
                      "${number}",
                      style: GoogleFonts.lexend(
                          color: Colors.white,
                          fontSize: MySize.getHeight(30),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
