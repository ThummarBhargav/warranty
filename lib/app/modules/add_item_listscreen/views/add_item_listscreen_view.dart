import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/buttons.dart';
import '../../../../utilities/progress_dialog_utils.dart';
import '../../../routes/app_pages.dart';
import '../controllers/add_item_listscreen_controller.dart';

class AddItemListscreenView extends GetWidget<AddItemListscreenController> {
  const AddItemListscreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAndToNamed(Routes.HOME);
        return await true;
      },
      child: Obx(() {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                Expanded(
                  child: Container(
                    color: appTheme.appbarTheme,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(MySize.getHeight(8.0)),
                          child: GestureDetector(
                            onTap: () {
                              Get.offAndToNamed(Routes.HOME);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: Text(
                              controller.CategoryName.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lexend(
                                  fontWeight: FontWeight.w400,
                                  fontSize: MySize.getHeight(20),
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: (isNullEmptyOrFalse(controller.addDataTempList))
                ? Center(
                    child: SvgPicture.asset(
                      "image/Nodata.svg",
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: MySize.safeHeight,
                    width: MySize.safeWidth,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return (getDateFromStringNew(
                                            controller.addDataTempList[index]
                                                .expiredDate
                                                .toString(),
                                            formatter: 'dd/MM/yyyy')
                                        .isBefore(DateTime.now()))
                                    ? Container()
                                    : addDatawidget(
                                        onTap: () {
                                          Get.offAndToNamed(
                                              Routes.ADD_ITEM_LISTSCREEN_VIEW,
                                              arguments: {
                                                ArgumentConstant
                                                        .additemListview:
                                                    controller
                                                        .addDataTempList[index]
                                              });
                                        },
                                        bill: () {
                                          OpenFile.open(controller
                                                  .addDataTempList[index].Bill)
                                              .then((value) {
                                            if (value.message ==
                                                "No APP found to open this file。") {
                                              getIt<CustomDialogs>().getDialog(
                                                title: "No App Found",
                                                desc: value.message,
                                              );
                                            }
                                          });
                                        },
                                        delete: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                  contentPadding:
                                                      EdgeInsets.all(0.0),
                                                  content: Container(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  top: MySize
                                                                      .getHeight(
                                                                          20.0),
                                                                  left: MySize
                                                                      .getHeight(
                                                                          20.0)),
                                                              child: Text(
                                                                "Are You Sure?",
                                                                style:
                                                                    GoogleFonts
                                                                        .lexend(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: MySize
                                                                      .getHeight(
                                                                          20),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              MySize.getHeight(
                                                                  20),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: MySize
                                                                      .getHeight(
                                                                          50),
                                                                  width: MySize
                                                                      .getWidth(
                                                                          115),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: appTheme
                                                                              .yellowPrimaryTheme),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "CANCEL",
                                                                      style: GoogleFonts.lexend(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize: MySize.getHeight(
                                                                              18),
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              width: MySize
                                                                  .getHeight(
                                                                      3.0),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                  controller
                                                                      .addDataList
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element
                                                                            .id ==
                                                                        controller
                                                                            .addDataTempList[index]
                                                                            .id) {
                                                                      controller
                                                                          .addDataList
                                                                          .remove(
                                                                              element);
                                                                      controller
                                                                          .addDataTempList
                                                                          .remove(
                                                                              element);
                                                                      box.write(
                                                                          ArgumentConstant
                                                                              .additemList,
                                                                          jsonEncode(
                                                                              controller.addDataList));
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: MySize
                                                                      .getHeight(
                                                                          50),
                                                                  width: MySize
                                                                      .getWidth(
                                                                          115),
                                                                  decoration: BoxDecoration(
                                                                      color: appTheme
                                                                          .yellowPrimaryTheme,
                                                                      border: Border.all(
                                                                          color: appTheme
                                                                              .yellowPrimaryTheme),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "DELETE",
                                                                      style: GoogleFonts.lexend(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize: MySize.getHeight(
                                                                              18),
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              MySize.getHeight(
                                                                  10),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        edit: () {
                                          Get.offAndToNamed(Routes.ADD_ITEM,
                                              arguments: {
                                                ArgumentConstant.Categoriename:
                                                    controller.CategoryName,
                                                ArgumentConstant.isFromHome:
                                                    false,
                                                ArgumentConstant.isFromEdit:
                                                    true,
                                                ArgumentConstant
                                                    .isFromInnerScreen: false,
                                                ArgumentConstant
                                                        .additemListview:
                                                    controller
                                                        .addDataTempList[index],
                                              });
                                        },
                                        context: context,
                                        Index: index,
                                        Purchaseddate: controller
                                            .addDataTempList[index].Date
                                            .toString(),
                                        expireddate: controller
                                            .addDataTempList[index].expiredDate
                                            .toString(),
                                        days: getDateFromStringNew(
                                                    controller
                                                        .addDataTempList[index]
                                                        .expiredDate
                                                        .toString(),
                                                    formatter: 'dd/MM/yyyy')
                                                .difference(
                                                    getDateFromStringNew(
                                                        controller
                                                            .addDataTempList[
                                                                index]
                                                            .Date
                                                            .toString(),
                                                        formatter:
                                                            'dd/MM/yyyy'))
                                                .inDays ??
                                            1,
                                        Name: controller
                                            .addDataTempList[index].ItemName
                                            .toString(),
                                        image: controller
                                            .addDataTempList[index].Image
                                            .toString(),
                                        isFromExprired: false,
                                      );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 5,
                                );
                              },
                              itemCount: controller.addDataTempList.length),
                          (!isNullEmptyOrFalse(controller.expireDataList))
                              ? Center(
                                  child: Text(
                                  "Expired items",
                                  style: TextStyle(color: Colors.red),
                                ))
                              : Container(),
                          ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return addDatawidget(
                                  isFromExprired: true,
                                  onTap: () {
                                    Get.offAndToNamed(
                                        Routes.ADD_ITEM_LISTSCREEN_VIEW,
                                        arguments: {
                                          ArgumentConstant.additemListview:
                                              controller.expireDataList[index]
                                        });
                                  },
                                  context: context,
                                  Index: index,
                                  edit: () {
                                    Get.offAndToNamed(Routes.ADD_ITEM,
                                        arguments: {
                                          ArgumentConstant.Categoriename:
                                              controller.CategoryName,
                                          ArgumentConstant.isFromHome: false,
                                          ArgumentConstant.isFromEdit: true,
                                          ArgumentConstant.isFromInnerScreen:
                                              false,
                                          ArgumentConstant.additemListview:
                                              controller.expireDataList[index],
                                        });
                                  },
                                  Purchaseddate: controller
                                      .expireDataList[index].Date
                                      .toString(),
                                  expireddate: controller
                                      .expireDataList[index].expiredDate
                                      .toString(),
                                  days: getDateFromStringNew(
                                              controller.expireDataList[index]
                                                  .expiredDate
                                                  .toString(),
                                              formatter: 'dd/MM/yyyy')
                                          .difference(getDateFromStringNew(
                                              controller
                                                  .expireDataList[index].Date
                                                  .toString(),
                                              formatter: 'dd/MM/yyyy'))
                                          .inDays ??
                                      1,
                                  bill: () {
                                    OpenFile.open(controller
                                            .expireDataList[index].Bill)
                                        .then((value) {
                                      if (value.message ==
                                          "No APP found to open this file。") {
                                        getIt<CustomDialogs>().getDialog(
                                          title: "No App Found",
                                          desc: value.message,
                                        );
                                      }
                                    });
                                  },
                                  Name: controller
                                      .expireDataList[index].ItemName
                                      .toString(),
                                  image: controller.expireDataList[index].Image
                                      .toString(),
                                  delete: () {
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: MySize
                                                                    .getHeight(
                                                                        20.0),
                                                                left: MySize
                                                                    .getHeight(
                                                                        20.0)),
                                                        child: Text(
                                                          "Are You Sure?",
                                                          style: GoogleFonts
                                                              .lexend(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: MySize
                                                                .getHeight(20),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MySize.getHeight(20),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Container(
                                                            height: MySize
                                                                .getHeight(50),
                                                            width:
                                                                MySize.getWidth(
                                                                    115),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: appTheme
                                                                        .yellowPrimaryTheme),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                            child: Center(
                                                              child: Text(
                                                                "CANCEL",
                                                                style: GoogleFonts.lexend(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize: MySize
                                                                        .getHeight(
                                                                            18),
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: MySize.getHeight(
                                                            3.0),
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                            controller
                                                                .addDataTempList
                                                                .forEach(
                                                                    (element) {
                                                              if (element.id ==
                                                                  controller
                                                                      .expireDataList[
                                                                          index]
                                                                      .id) {
                                                                controller
                                                                    .addDataList
                                                                    .remove(
                                                                        element);
                                                                controller
                                                                    .expireDataList
                                                                    .remove(
                                                                        element);
                                                                controller
                                                                    .addDataTempList
                                                                    .remove(
                                                                        element);
                                                                box.write(
                                                                    ArgumentConstant
                                                                        .additemList,
                                                                    jsonEncode(
                                                                        controller
                                                                            .addDataList));
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            height: MySize
                                                                .getHeight(50),
                                                            width:
                                                                MySize.getWidth(
                                                                    115),
                                                            decoration: BoxDecoration(
                                                                color: appTheme
                                                                    .yellowPrimaryTheme,
                                                                border: Border.all(
                                                                    color: appTheme
                                                                        .yellowPrimaryTheme),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                            child: Center(
                                                              child: Text(
                                                                "DELETE",
                                                                style: GoogleFonts.lexend(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: MySize
                                                                        .getHeight(
                                                                            18),
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MySize.getHeight(10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 5,
                                );
                              },
                              itemCount: controller.expireDataList.length),
                        ],
                      ),
                    ),
                  ),
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
                elevation: 0,
                backgroundColor: appTheme.appbarTheme,
                onPressed: () {
                  Get.offAndToNamed(Routes.ADD_ITEM, arguments: {
                    ArgumentConstant.Categoriename: controller.CategoryName,
                    ArgumentConstant.isFromHome: false,
                    ArgumentConstant.isFromEdit: false,
                    ArgumentConstant.isFromInnerScreen: false,
                  });
                },
                child: Icon(Icons.add)),
          ),
        );
      }),
    );
  }

  addDatawidget({
    required BuildContext context,
    String Name = "",
    String image = "",
    String Purchaseddate = "",
    String expireddate = "",
    VoidCallback? onTap,
    VoidCallback? delete,
    VoidCallback? edit,
    VoidCallback? bill,
    bool? isFromExprired,
    VoidCallback? onPressed,
    VoidCallback? onPressed1,
    int days = 1,
    int Index = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(MySize.getHeight(20)),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffE8F9FF),
            borderRadius: BorderRadius.circular(MySize.getHeight(10)),
          ),
          child: Row(children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Container(
                      height: MySize.getHeight(150),
                      width: MySize.getHeight(100),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(MySize.getHeight(10)),
                      ),
                      alignment: Alignment.center,
                      child: (!isNullEmptyOrFalse(image) && image != "null")
                          ? Container(
                              child: Image.file(
                                fit: BoxFit.fitWidth,
                                File(image),
                              ),
                            )
                          : Container(
                              height: MySize.getHeight(150),
                              width: MySize.getHeight(100),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius:
                                    BorderRadius.circular(MySize.getHeight(10)),
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                child: SvgPicture.asset(
                                  "image/photo.svg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.all(MySize.getHeight(8.0)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Name,
                        maxLines: 2,
                        style: GoogleFonts.lexend(
                            fontWeight: FontWeight.w400,
                            fontSize: MySize.getHeight(20),
                            color: Colors.black),
                      ),
                      Space.height(MySize.getHeight(9)),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: "Purchased On:-",
                            style: GoogleFonts.lexend(
                                fontWeight: FontWeight.w400,
                                fontSize: MySize.getHeight(13),
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: "$Purchaseddate",
                            style: GoogleFonts.lexend(
                                fontSize: MySize.getHeight(13),
                                color: appTheme.textGrayColor),
                          )
                        ]),
                      ),
                      Space.height(MySize.getHeight(9)),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: "ExpiredDate On:-",
                            style: GoogleFonts.lexend(
                                fontWeight: FontWeight.w400,
                                fontSize: MySize.getHeight(13),
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: "$expireddate",
                            style: (days == 0)
                                ? GoogleFonts.lexend(
                                    fontSize: MySize.getHeight(13),
                                    color: appTheme.ErrorText)
                                : GoogleFonts.lexend(
                                    fontSize: MySize.getHeight(13),
                                    color: appTheme.textGrayColor),
                          )
                        ]),
                      ),
                      Space.height(MySize.getHeight(9)),
                      (days != 0)
                          ? Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: "Days Left:-",
                                  style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w400,
                                      fontSize: MySize.getHeight(13),
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text: "$days",
                                  style: GoogleFonts.lexend(
                                      fontSize: MySize.getHeight(13),
                                      color: appTheme.textGrayColor),
                                )
                              ]),
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 13, bottom: 15, right: 20),
                            child: InkWell(
                              onTap: delete,
                              child: Container(
                                height: MySize.getHeight(30),
                                width: MySize.getWidth(25),
                                child: SvgPicture.asset(
                                  "image/delete.svg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 13, bottom: 15, right: 20),
                            child: InkWell(
                              onTap: edit,
                              child: Container(
                                height: MySize.getHeight(30),
                                width: MySize.getWidth(25),
                                child: SvgPicture.asset(
                                  "image/edit.svg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          (isFromExprired!)
                              ? (!isNullEmptyOrFalse(controller
                                          .expireDataList[Index].Bill) &&
                                      controller.expireDataList[Index].Bill !=
                                          "null")
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 13, bottom: 15, right: 20),
                                      child: InkWell(
                                        onTap: bill,
                                        child: Container(
                                          height: MySize.getHeight(30),
                                          width: MySize.getWidth(25),
                                          child: SvgPicture.asset(
                                            "image/billview.svg",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                              : (!isNullEmptyOrFalse(controller
                                          .addDataTempList[Index].Bill) &&
                                      controller.addDataTempList[Index].Bill !=
                                          "null")
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 13, bottom: 15, right: 20),
                                      child: InkWell(
                                        onTap: bill,
                                        child: Container(
                                          height: MySize.getHeight(30),
                                          width: MySize.getWidth(25),
                                          child: SvgPicture.asset(
                                            "image/billview.svg",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                        ],
                      )
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
