import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';

import '../../../../utilities/progress_dialog_utils.dart';
import '../../../routes/app_pages.dart';

import '../controllers/add_item_listscreen_view_controller.dart';

class AddItemListscreenViewView
    extends GetWidget<AddItemListscreenViewController> {
  const AddItemListscreenViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Get.offAndToNamed(Routes.ADD_ITEM_LISTSCREEN, arguments: {
            ArgumentConstant.Categoriename:
                controller.addItemListview!.categoriesName.toString(),
          });
          return await true;
        },
        child: Scaffold(
            body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap:
                    (!isNullEmptyOrFalse(controller.addItemListview!.Image) &&
                            controller.addItemListview!.Image != "null")
                        ? () {
                            Get.toNamed(Routes.IMAGE_VIEW, arguments: {
                              ArgumentConstant.imageview:
                                  controller.addItemListview!.Image.toString()
                            });
                          }
                        : null,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(MySize.getHeight(40)))),
                      height: MySize.getHeight(350),
                      width: MySize.getWidth(360),
                      child: Center(
                        child: (!isNullEmptyOrFalse(
                                    controller.addItemListview!.Image) &&
                                controller.addItemListview!.Image != "null")
                            ? Image.file(
                                File(controller.addItemListview!.Image
                                    .toString()),
                                width: MySize.getWidth(250),
                                height: MySize.getHeight(250),
                              )
                            : Image.asset(
                                imagePath + "camera.png",
                                width: MySize.getWidth(100),
                                height: MySize.getHeight(100),
                              ),
                      ),
                    ),
                    Positioned(
                      top: MySize.getHeight(55),
                      left: MySize.getHeight(20),
                      child: GestureDetector(
                        onTap: () {
                          Get.offAndToNamed(Routes.ADD_ITEM_LISTSCREEN,
                              arguments: {
                                ArgumentConstant.Categoriename: controller
                                    .addItemListview!.categoriesName
                                    .toString(),
                              });
                        },
                        child: Container(
                          height: MySize.getHeight(35),
                          width: MySize.getHeight(35),
                          child: SvgPicture.asset("image/backArrow.svg",
                              fit: BoxFit.none),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          if (controller.addItemListview!.Bill == null) {
                          } else {
                            try {
                              OpenFilex.open(controller.addItemListview!.Bill)
                                  .then((value) {
                                if (value.message ==
                                    "No APP found to open this file。") {
                                  getIt<CustomDialogs>().getDialog(
                                    title: "No App Found",
                                    desc: value.message,
                                  );
                                }
                                print(value);
                              }).catchError((e) {});
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: Container(
                          height: MySize.getHeight(54),
                          width: MySize.getWidth(205),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(MySize.getHeight(40)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MySize.getWidth(19.83),
                                height: MySize.getHeight(28.33),
                                child: SvgPicture.asset("image/billyellow.svg",
                                    color: appTheme.yellowPrimaryTheme,
                                    fit: BoxFit.contain),
                              ),
                              SizedBox(
                                width: MySize.getWidth(13.08),
                              ),
                              Text(
                                "Receipt",
                                style: GoogleFonts.lexend(
                                    color: Colors.black,
                                    fontSize: MySize.getHeight(15),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MySize.getHeight(38),
                      right: MySize.getHeight(23),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.ADD_ITEM, arguments: {
                            ArgumentConstant.Categoriename:
                                controller.addItemListview!.categoriesName,
                            ArgumentConstant.isFromHome: false,
                            ArgumentConstant.isFromEdit: true,
                            ArgumentConstant.isFromInnerScreen: true,
                            ArgumentConstant.additemListview:
                                controller.addItemListview,
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: MySize.getHeight(8),
                                spreadRadius: MySize.getHeight(2),
                              ),
                            ],
                          ),
                          height: MySize.getHeight(35),
                          width: MySize.getWidth(35),
                          child: SvgPicture.asset("image/pencil.svg",
                              fit: BoxFit.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(MySize.getWidth(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: MySize.safeWidth! - MySize.getWidth(30),
                                child: Text(
                                  controller.addItemListview!.ItemName
                                      .toString(),
                                  style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w600,
                                      color: appTheme.appbarTheme,
                                      fontSize: MySize.getHeight(22)),
                                ),
                              ),
                              SizedBox(height: MySize.getHeight(10)),
                              Text(
                                "Last updated On:-" +
                                    controller.purchasedDate[0].toString(),
                                style: GoogleFonts.lexend(
                                    color: appTheme.textGrayColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(12)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(MySize.getHeight(15)),
                    child: Column(
                      children: [
                        getDataWidget(
                            name: "Category :",
                            Data:
                                "${controller.addItemListview!.categoriesName.toString()}"),
                        getDataWidget(
                            name: "Purchase date :",
                            Data: "${controller.purchasedDate[0].toString()}"),
                        getDataWidget(
                            name: "Expire date :",
                            Data: "${controller.expireDate[0].toString()}"),
                        getDataWidget(
                            name: "Validity duration :",
                            Data:
                                "${controller.addItemListview!.Duration.toString()} Days"),
                        getDataWidget(
                            name: "Details :",
                            Data:
                                "${controller.addItemListview!.Ditails.toString()} Days"),
                        getDataWidget(
                            name: "Days left :",
                            Data:
                                "${int.parse(controller.addItemListview!.Duration.toString())}"),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        )),
      ),
    );
  }

  getDataWidget({required String name, required String Data}) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${name}",
                style: GoogleFonts.lexend(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: MySize.getHeight(14),
                ),
              ),
              Spacing.width(MySize.getWidth(10)),
              Wrap(
                children: [
                  SizedBox(
                    width: MySize.getWidth(200),
                    child: Text(
                      "${Data}",
                      style: GoogleFonts.lexend(
                        color: appTheme.dateTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: MySize.getHeight(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          (MySize.isMini)
              ? Spacing.height(MySize.getHeight(1.2))
              : Spacing.height(MySize.getHeight(4)),
          Divider(color: Color(0xff87878714)),
        ],
      ),
    );
  }
}
