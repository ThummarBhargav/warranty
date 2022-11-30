import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../constants/text_field.dart';
import '../../../../main.dart';
import '../../../models/categoriesModels.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                Expanded(
                    flex: 1,
                    child: Container(
                      color: appTheme.appbarTheme,
                      child: Row(children: [
                        Padding(
                            padding:
                                EdgeInsets.only(left: MySize.getHeight(8.0)),
                            child: Text(
                              "Categories",
                              style: GoogleFonts.lexend(
                                fontWeight: FontWeight.w400,
                                fontSize: MySize.getHeight(20),
                              ),
                            )),
                        Spacer(),
                        Padding(
                          padding:
                              EdgeInsets.only(right: MySize.getHeight(8.0)),
                          child: Icon(
                            Icons.settings,
                            size: MySize.getHeight(30.0),
                            color: Colors.white,
                          ),
                        )
                      ]),
                    )),
              ],
            ),
            body: Center(
                child: Column(
              children: [
                Expanded(
                    flex: 12,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(MySize.getHeight(8.0)),
                            child: Container(
                              padding:
                                  EdgeInsets.only(bottom: MySize.getHeight(9)),
                              height: MySize.safeHeight! -
                                  AppBar().preferredSize.height,
                              child: GridView.builder(
                                padding: EdgeInsets.only(bottom: 10),
                                itemCount: controller.categoryDataList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing:
                                            MySize.getHeight(10.0),
                                        mainAxisSpacing:
                                            MySize.getHeight(10.0)),
                                itemBuilder: (context, index) {
                                  String valueString = controller
                                      .categoryDataList[index].color!
                                      .split('(0x')[1]
                                      .split(')')[0]; // kind of hacky..
                                  int value = int.parse(valueString, radix: 16);
                                  Color backColor = new Color(value);
                                  return getCategoriesWidget(
                                    onLongPress: () {
                                      deletDialogBox(
                                        context,
                                        onPressed1: () {
                                          Get.back();
                                          controller.addItemList.removeWhere(
                                              (element) => (element
                                                      .categoriesName ==
                                                  controller
                                                      .categoryDataList[index]
                                                      .categoriesName));
                                          controller.categoryDataList
                                              .removeAt(index);
                                          box.write(
                                              ArgumentConstant.categoriesList,
                                              jsonEncode(
                                                  controller.categoryDataList));
                                          box.write(
                                              ArgumentConstant.additemList,
                                              jsonEncode(
                                                  controller.addItemList));
                                        },
                                      );
                                    },
                                    color: backColor,
                                    image: controller
                                        .categoryDataList[index].Image!,
                                    Counter: controller
                                        .categoryDataList[index].Counter!,
                                    Name: controller.categoryDataList[index]
                                        .categoriesName!,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            )),
            floatingActionButton: SpeedDial(
              elevation: 0,
              activeIcon: Icons.close,
              icon: Icons.add,
              backgroundColor: appTheme.appbarTheme,
              overlayOpacity: 0.0,
              children: [
                SpeedDialChild(
                    child: Icon(
                      Icons.category,
                      color: Colors.white,
                      size: MySize.getHeight(30.0),
                    ),
                    label: "Add Item",
                    onTap: () {
                      Get.offAndToNamed(Routes.ADD_ITEM, arguments: {
                        ArgumentConstant.isFromHome: true,
                        ArgumentConstant.isFromEdit: false,
                        ArgumentConstant.isFromInnerScreen: false,
                      });
                    },
                    backgroundColor: appTheme.appbarTheme,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appTheme.appbarTheme,
                        fontSize: MySize.getHeight(20))),
                SpeedDialChild(
                    child: Icon(
                      Icons.list,
                      color: Colors.white,
                      size: MySize.getHeight(30.0),
                    ),
                    label: "Add Category",
                    onTap: () {
                      dialogBox(context);
                    },
                    backgroundColor: appTheme.appbarTheme,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appTheme.appbarTheme,
                        fontSize: MySize.getHeight(20))),
              ],
            ));
      }),
    );
  }

  getCategoriesWidget({
    String Counter = "0",
    String image = "Defo.png",
    String Name = "",
    Color? color,
    VoidCallback? onLongPress,
  }) {
    int count = 0;
    controller.addItemList.forEach((element) {
      if (element.categoriesName == Name) {
        count++;
      }
    });
    return GestureDetector(
      onTap: () {
        Get.offAndToNamed(Routes.ADD_ITEM_LISTSCREEN,
            arguments: {ArgumentConstant.Categoriename: Name});
      },
      onLongPress: onLongPress,
      child: Container(
        height: MySize.getHeight(150.0),
        width: MySize.getHeight(150.0),
        decoration: BoxDecoration(
            color: color,
            // border: Border.all(color: appTheme.primaryTheme),
            borderRadius: BorderRadius.circular(MySize.getHeight(10.0))),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(MySize.getHeight(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      child: Text(
                    count.toString(),
                    style: GoogleFonts.lexend(
                        fontWeight: FontWeight.w400,
                        fontSize: MySize.getHeight(20),
                        color: appTheme.ErrorText),
                  )),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: MySize.getHeight(100.0),
                    width: MySize.getHeight(100.0),
                    child: (image == "")
                        ? SvgPicture.asset(
                            imagePath + "defolt.svg",
                            fit: BoxFit.contain,
                          )
                        : SvgPicture.asset(
                            imagePath + image,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                SizedBox(
                  height: MySize.getHeight(10.0),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text(
                      Name,
                      maxLines: 3,
                      style: GoogleFonts.lexend(
                        fontWeight: FontWeight.w400,
                        fontSize: MySize.getHeight(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  deletDialogBox(BuildContext context, {VoidCallback? onPressed1}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Container(
            child: AlertDialog(
              contentPadding: EdgeInsets.all(0.0),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MySize.getHeight(20.0),
                              left: MySize.getHeight(20.0)),
                          child: Text(
                            "Are You Sure?",
                            style: GoogleFonts.lexend(
                              fontWeight: FontWeight.bold,
                              fontSize: MySize.getHeight(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MySize.getHeight(20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Container(
                              height: MySize.getHeight(50),
                              width: MySize.getWidth(115),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: appTheme.yellowPrimaryTheme),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Center(
                                child: Text(
                                  "CANCEL",
                                  style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySize.getHeight(18),
                                      color: Colors.black),
                                ),
                              ),
                            )),
                        SizedBox(
                          width: MySize.getHeight(3.0),
                        ),
                        TextButton(
                            onPressed: onPressed1,
                            child: Container(
                              height: MySize.getHeight(50),
                              width: MySize.getWidth(115),
                              decoration: BoxDecoration(
                                  color: appTheme.yellowPrimaryTheme,
                                  border: Border.all(
                                      color: appTheme.yellowPrimaryTheme),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Center(
                                child: Text(
                                  "DELETE",
                                  style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySize.getHeight(18),
                                      color: Colors.white),
                                ),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: MySize.getHeight(10),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  dialogBox(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(MySize.getHeight(8.0)),
                        child: Text(
                          "Add category",
                          style: GoogleFonts.lexend(
                            fontWeight: FontWeight.w400,
                            fontSize: MySize.getHeight(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MySize.getHeight(5),
                  ),
                  Padding(
                    padding: EdgeInsets.all(MySize.getHeight(9.0)),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 7),
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: MySize.getHeight(13),
                            spreadRadius: MySize.getHeight(2),
                          ),
                        ],
                      ),
                      child: getTextField(
                        hintText: "Category",
                        borderColor: Colors.transparent,
                        size: 70,
                        isFilled: true,
                        fillColor: Colors.white,
                        textEditingController:
                            controller.categoryNameController.value,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: appTheme.yellowPrimaryTheme),
                                borderRadius: BorderRadius.circular(2)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "CANCEL",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(15),
                                    color: Colors.black),
                              ),
                            ),
                          )),
                      SizedBox(
                        width: MySize.getHeight(3.0),
                      ),
                      TextButton(
                          onPressed: () {
                            bool isCopy = false;
                            if (controller
                                .categoryNameController.value.text.isNotEmpty) {
                              controller.categoryDataList.forEach((element) {
                                if (element.categoriesName!.toLowerCase() ==
                                    controller.categoryNameController.value.text
                                        .trim()
                                        .toLowerCase()
                                        .trim()) {
                                  isCopy = true;
                                } else {}
                              });
                              if (isCopy == false &&
                                  controller.categoryNameController.value.text
                                      .trim()
                                      .isNotEmpty) {
                                controller.addCategory(
                                  categoriesModel(
                                      categoriesName: controller
                                          .categoryNameController.value.text
                                          .trim(),
                                      color: Color(
                                              (Random().nextDouble() * 0xFFFFFF)
                                                  .toInt())
                                          .withOpacity(0.2)
                                          .toString(),
                                      Image: "",
                                      Counter: "0"),
                                );
                              }
                            }
                            Get.back();
                            controller.categoryNameController.value.clear();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: appTheme.yellowPrimaryTheme,
                                border: Border.all(
                                    color: appTheme.yellowPrimaryTheme),
                                borderRadius: BorderRadius.circular(2)),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8, right: 25, left: 25),
                                child: Text(
                                  "ADD",
                                  style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w400,
                                      fontSize: MySize.getHeight(15),
                                      color: Colors.white),
                                )),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
