import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yodo1mas/Yodo1MasBannerAd.dart';
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
                        PopupMenuButton(
                          offset: Offset(0, MySize.getHeight(50)),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  child: InkWell(
                                onTap: () {
                                  controller.rateMyApp.init().then((value) {
                                    controller.rateMyApp.showRateDialog(
                                      context,
                                      title:
                                          'Rate this app', // The dialog title.0
                                      message:
                                          'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
                                      rateButton:
                                          'RATE', // The dialog "rate" button text.
                                      noButton:
                                          'NO THANKS', // The dialog "no" button text.
                                      laterButton:
                                          'MAYBE LATER', // The dialog "later" button text.
                                      listener: (button) {
                                        // The button click listener (useful if you want to cancel the click event).
                                        switch (button) {
                                          case RateMyAppDialogButton.rate:
                                            print('Clicked on "Rate".');
                                            break;
                                          case RateMyAppDialogButton.later:
                                            print('Clicked on "Later".');
                                            break;
                                          case RateMyAppDialogButton.no:
                                            print('Clicked on "No".');
                                            break;
                                        }

                                        return true; // Return false if you want to cancel the click event.
                                      },
                                      ignoreNativeDialog: Platform
                                          .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
                                      dialogStyle:
                                          const DialogStyle(), // Custom dialog styles.
                                      onDismissed: () => controller.rateMyApp
                                          .callEvent(RateMyAppEventType
                                              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
                                    );
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: MySize.getWidth(5),
                                    ),
                                    Text("Rate us")
                                  ],
                                ),
                              )),
                              PopupMenuItem(
                                  child: InkWell(
                                onTap: () {
                                  Share.share(
                                      'check out my website https://play.google.com/store/apps/details?id=com.warrenty_manager.warrentytracker');
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.share,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: MySize.getWidth(5),
                                    ),
                                    Text("Share App")
                                  ],
                                ),
                              )),
                            ];
                          },
                          child: Container(
                            height: MySize.getHeight(60),
                            width: MySize.getWidth(60),
                            child: Icon(
                              Icons.settings,
                              size: MySize.getHeight(30.0),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                    )),
              ],
            ),
            body: Center(
                child: Column(
              children: [
                (controller.connectivityResult == ConnectionState.none)
                    ? SizedBox()
                    : Yodo1MASBannerAd(
                        size: BannerSize.Banner,
                      ),
                Expanded(
                    flex: 12,
                    child: (isNullEmptyOrFalse(controller.categoryDataList))
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: SvgPicture.asset(
                                  "image/Nodata.svg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: MySize.getHeight(10),
                              ),
                              Center(
                                child: Text("Click on + icon to add new items",
                                    style: GoogleFonts.lexend(
                                        color: Colors.grey,
                                        fontSize: MySize.getHeight(15))),
                              ),
                            ],
                          )
                        : GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: MySize.getWidth(10),
                                vertical: MySize.getHeight(10)),
                            itemCount: controller.categoryDataList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: MySize.getHeight(10.0),
                                    mainAxisSpacing: MySize.getHeight(10.0)),
                            itemBuilder: (context, index) {
                              String valueString = controller
                                  .categoryDataList[index].color!
                                  .split('(0x')[1]
                                  .split(')')[0]; // kind of hacky..
                              int value = int.parse(valueString, radix: 16);
                              Color backColor = new Color(value);
                              return getCategoriesWidget(
                                EditPress: () {
                                  Navigator.of(context).pop();
                                  EditDilogBox(context, Index: index);
                                },
                                onLongPress: () {
                                  Navigator.of(context).pop();
                                  deletDialogBox(
                                    context,
                                    onPressed1: () {
                                      Get.back();
                                      controller.addItemList.removeWhere(
                                          (element) =>
                                              (element.categoriesName ==
                                                  controller
                                                      .categoryDataList[index]
                                                      .categoriesName));
                                      controller.categoryDataList
                                          .removeAt(index);
                                      box.write(
                                          ArgumentConstant.categoriesList,
                                          jsonEncode(
                                              controller.categoryDataList));
                                      box.write(ArgumentConstant.additemList,
                                          jsonEncode(controller.addItemList));
                                    },
                                  );
                                },
                                color: backColor,
                                image:
                                    controller.categoryDataList[index].Image!,
                                Counter:
                                    controller.categoryDataList[index].Counter!,
                                Name: controller
                                    .categoryDataList[index].categoriesName!,
                              );
                            },
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
                      FocusScope.of(context).unfocus();
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
    VoidCallback? EditPress,
  }) {
    int count = 0;
    controller.addItemList.forEach((element) {
      if (element.categoriesName == Name) {
        count++;
      }
    });
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.ADD_ITEM_LISTSCREEN,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Spacer(),
                        Container(
                          height: MySize.getHeight(20),
                          width: MySize.getWidth(80),
                          child: Center(
                            child: Text(
                              Name,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lexend(
                                fontWeight: FontWeight.w400,
                                fontSize: MySize.getHeight(15),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        PopupMenuButton(
                          offset: Offset(0, 30),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  child: Row(
                                children: [
                                  InkWell(
                                      onTap: EditPress,
                                      child: Container(
                                          width: MySize.getWidth(200),
                                          child: Text("Edit"))),
                                ],
                              )),
                              PopupMenuItem(
                                  child: Row(
                                children: [
                                  InkWell(
                                      onTap: onLongPress,
                                      child: Container(
                                          width: MySize.getWidth(200),
                                          child: Text("Delete"))),
                                ],
                              )),
                            ];
                          },
                          child: Icon(Icons.more_vert),
                        )
                      ],
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
                    Padding(
                      padding: EdgeInsets.only(
                          right: MySize.getWidth(8), left: MySize.getWidth(8)),
                      child: Row(
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
                                width: MySize.getWidth(110),
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
            contentPadding: EdgeInsets.all(0),
            content: StatefulBuilder(
              builder: (BuildContext context, setter) {
                return Container(
                  width: MySize.getWidth(420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: MySize.getHeight(8.0),
                                left: MySize.getHeight(15.0)),
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
                        padding: EdgeInsets.only(
                          top: MySize.getHeight(8.0),
                          left: MySize.getHeight(15.0),
                          right: MySize.getHeight(15.0),
                        ),
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
                            textCapitalization: TextCapitalization.words,
                            hintText: "Category",
                            borderColor: Colors.transparent,
                            size: 40,
                            isFilled: true,
                            fillColor: Colors.white,
                            textEditingController:
                                controller.categoryNameController.value,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MySize.getHeight(5),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0, left: 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    await EditIconBox(context, setter);
                                    setter(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: appTheme.yellowPrimaryTheme,
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        "Choices Icon",
                                        style: GoogleFonts.lexend(
                                            fontWeight: FontWeight.w400,
                                            fontSize: MySize.getHeight(15),
                                            color: Colors.white),
                                      ),
                                    ),
                                  )),
                              Container(
                                height: MySize.getHeight(50),
                                width: MySize.getWidth(50),
                                child: SvgPicture.asset(
                                    imagePath + "${controller.editIcon.value}"),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MySize.getHeight(8),
                            bottom: MySize.getHeight(8),
                            right: MySize.getHeight(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  controller.categoryNameController.value
                                      .clear();
                                  controller.editIcon.value = "";
                                  Get.back();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: appTheme.yellowPrimaryTheme),
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
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
                              width: MySize.getWidth(3.0),
                            ),
                            TextButton(
                                onPressed: () {
                                  bool isCopy = false;
                                  if (controller.categoryNameController.value
                                      .text.isNotEmpty) {
                                    controller.categoryDataList
                                        .forEach((element) {
                                      if (element.categoriesName!
                                              .toLowerCase() ==
                                          controller
                                              .categoryNameController.value.text
                                              .trim()
                                              .toLowerCase()
                                              .trim()) {
                                        isCopy = true;
                                      } else {}
                                    });
                                    if (isCopy == false &&
                                        controller
                                            .categoryNameController.value.text
                                            .trim()
                                            .isNotEmpty) {
                                      controller.addCategory(
                                        categoriesModel(
                                            categoriesName: controller
                                                .categoryNameController
                                                .value
                                                .text
                                                .trim(),
                                            color: Color(
                                                    (Random().nextDouble() *
                                                            0xFFFFFF)
                                                        .toInt())
                                                .withOpacity(0.2)
                                                .toString(),
                                            Image: controller.editIcon.value,
                                            Counter: "0"),
                                      );
                                    }
                                  }
                                  Get.back();
                                  controller.editIcon.value = "";
                                  controller.categoryNameController.value
                                      .clear();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: appTheme.yellowPrimaryTheme,
                                      border: Border.all(
                                          color: appTheme.yellowPrimaryTheme),
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        top: MySize.getHeight(10),
                                        bottom: MySize.getHeight(10),
                                        right: MySize.getWidth(25),
                                        left: MySize.getWidth(25),
                                      ),
                                      child: Text(
                                        "ADD",
                                        style: GoogleFonts.lexend(
                                            fontWeight: FontWeight.w400,
                                            fontSize: MySize.getHeight(15),
                                            color: Colors.white),
                                      )),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  EditDilogBox(BuildContext context, {required int? Index}) {
    controller.editCategoryNameController.value.text =
        "${controller.categoryDataList[Index!].categoriesName}";
    controller.editIcon.value = "${controller.categoryDataList[Index].Image}";
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: StatefulBuilder(
              builder: (BuildContext context, setter) {
                return Container(
                  width: MySize.getWidth(420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: MySize.getHeight(8.0),
                                left: MySize.getHeight(15.0)),
                            child: Text(
                              "Edit category",
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
                        padding: EdgeInsets.only(
                          top: MySize.getHeight(8.0),
                          left: MySize.getHeight(15.0),
                          right: MySize.getHeight(15.0),
                        ),
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
                            textCapitalization: TextCapitalization.words,
                            hintText: "Edit category",
                            borderColor: Colors.transparent,
                            size: 40,
                            isFilled: true,
                            fillColor: Colors.white,
                            textEditingController:
                                controller.editCategoryNameController.value,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MySize.getHeight(5),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0, left: 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    await EditIconBox(context, setter);
                                    setter(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: appTheme.yellowPrimaryTheme,
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        "Edit Icon",
                                        style: GoogleFonts.lexend(
                                            fontWeight: FontWeight.w400,
                                            fontSize: MySize.getHeight(15),
                                            color: Colors.white),
                                      ),
                                    ),
                                  )),
                              Container(
                                height: MySize.getHeight(50),
                                width: MySize.getWidth(50),
                                child: SvgPicture.asset(
                                    imagePath + "${controller.editIcon.value}"),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MySize.getHeight(8),
                            bottom: MySize.getHeight(8),
                            right: MySize.getHeight(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  controller.editCategoryNameController.value
                                      .clear();
                                  controller.editIcon.value = "";
                                  Get.back();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: appTheme.yellowPrimaryTheme),
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
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
                              width: MySize.getWidth(3.0),
                            ),
                            TextButton(
                                onPressed: () {
                                  bool isCopy = false;
                                  if (controller.editCategoryNameController
                                      .value.text.isNotEmpty) {
                                    controller.categoryDataList
                                        .forEach((element) {
                                      if (element.categoriesName!
                                              .toLowerCase() ==
                                          controller.editCategoryNameController
                                              .value.text
                                              .trim()
                                              .toLowerCase()
                                              .trim()) {
                                        isCopy = true;
                                      } else {}
                                    });
                                    if (isCopy == false) {
                                      controller.addItemList.value
                                          .forEach((element) {
                                        if (element.categoriesName ==
                                            controller.categoryDataList[Index]
                                                .categoriesName) {
                                          element.categoriesName = controller
                                              .editCategoryNameController
                                              .value
                                              .text;
                                        }
                                      });
                                      box.write(ArgumentConstant.additemList,
                                          jsonEncode(controller.addItemList));
                                      controller.categoryDataList[Index]
                                              .categoriesName =
                                          controller.editCategoryNameController
                                              .value.text;
                                      controller.categoryDataList[Index].Image =
                                          controller.editIcon.value;
                                      box.write(
                                          ArgumentConstant.categoriesList,
                                          jsonEncode(
                                              controller.categoryDataList));
                                      controller.categoryDataList.refresh();
                                      Navigator.pop(context);
                                    } else {
                                      controller.categoryDataList[Index].Image =
                                          controller.editIcon.value;
                                      box.write(
                                          ArgumentConstant.categoriesList,
                                          jsonEncode(
                                              controller.categoryDataList));
                                      controller.categoryDataList.refresh();
                                      Navigator.pop(context);
                                    }
                                  }
                                  Get.back();
                                  controller.editIcon.value = "";
                                  controller.categoryNameController.value
                                      .clear();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: appTheme.yellowPrimaryTheme,
                                      border: Border.all(
                                          color: appTheme.yellowPrimaryTheme),
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        top: MySize.getHeight(10),
                                        bottom: MySize.getHeight(10),
                                        right: MySize.getWidth(25),
                                        left: MySize.getWidth(25),
                                      ),
                                      child: Text(
                                        "Edit",
                                        style: GoogleFonts.lexend(
                                            fontWeight: FontWeight.w400,
                                            fontSize: MySize.getHeight(15),
                                            color: Colors.white),
                                      )),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  EditCatagoriesDialodBox(BuildContext context, {required int? Index}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: MySize.getWidth(420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MySize.getHeight(8.0),
                            left: MySize.getHeight(15.0)),
                        child: Text(
                          "Edit category",
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
                    padding: EdgeInsets.only(
                      top: MySize.getHeight(8.0),
                      left: MySize.getHeight(15.0),
                      right: MySize.getHeight(15.0),
                    ),
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
                        textCapitalization: TextCapitalization.words,
                        hintText: "Edit Category",
                        borderColor: Colors.transparent,
                        size: 40,
                        isFilled: true,
                        fillColor: Colors.white,
                        textEditingController:
                            controller.editCategoryNameController.value,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MySize.getHeight(8),
                        bottom: MySize.getHeight(8),
                        right: MySize.getHeight(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              controller.editCategoryNameController.value
                                  .clear();
                              Get.back();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: appTheme.yellowPrimaryTheme),
                                  borderRadius: BorderRadius.circular(2)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
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
                          width: MySize.getWidth(3.0),
                        ),
                        TextButton(
                            onPressed: () {
                              bool isCopy = false;
                              if (controller.editCategoryNameController.value
                                  .text.isNotEmpty) {
                                controller.categoryDataList.forEach((element) {
                                  if (element.categoriesName!.toLowerCase() ==
                                      controller
                                          .editCategoryNameController.value.text
                                          .trim()
                                          .toLowerCase()
                                          .trim()) {
                                    isCopy = true;
                                  } else {}
                                });
                                if (isCopy == false &&
                                    controller
                                        .editCategoryNameController.value.text
                                        .trim()
                                        .isNotEmpty) {
                                  controller.categoryDataList[Index!]
                                          .categoriesName =
                                      controller.editCategoryNameController
                                          .value.text;
                                  controller.editCategoriesName.value =
                                      controller.editCategoryNameController
                                          .value.text;
                                  // box.write(ArgumentConstant.categoriesList,
                                  //     jsonEncode(controller.categoryDataList));
                                }
                              }
                              // controller.categoryDataList.refresh();
                              Get.back();
                              controller.editCategoryNameController.value
                                  .clear();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: appTheme.yellowPrimaryTheme,
                                  border: Border.all(
                                      color: appTheme.yellowPrimaryTheme),
                                  borderRadius: BorderRadius.circular(2)),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                    top: MySize.getHeight(10),
                                    bottom: MySize.getHeight(10),
                                    right: MySize.getWidth(25),
                                    left: MySize.getWidth(25),
                                  ),
                                  child: Text(
                                    "Edit",
                                    style: GoogleFonts.lexend(
                                        fontWeight: FontWeight.w400,
                                        fontSize: MySize.getHeight(15),
                                        color: Colors.white),
                                  )),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  EditIconBox(BuildContext context, setter) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Column(
              children: [
                Container(
                  height: MySize.getHeight(650),
                  width: MySize.getWidth(420),
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: MySize.getWidth(10),
                        vertical: MySize.getHeight(10)),
                    itemCount: controller.iconList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: MySize.getHeight(10.0),
                        mainAxisSpacing: MySize.getHeight(10.0)),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          controller.editIcon.value =
                              controller.iconList[index];
                          setter(() {});
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: SvgPicture.asset(
                              imagePath + "${controller.iconList[index]}"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
