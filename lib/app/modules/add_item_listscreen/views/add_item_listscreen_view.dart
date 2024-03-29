import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:warranty_appp/utilities/timer_service.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
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
        if (getIt<TimerService>().is40SecCompleted) {
          await getIt<AdService>()
              .getAd(adType: AdService.interstitialAd)
              .then((value) {
            if (!value) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              getIt<TimerService>().verifyTimer();
              Get.offAllNamed(Routes.HOME);
            }
          });
          return await false;
        } else {
          Get.offAllNamed(Routes.HOME);
          return await true;
        }
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
                          padding: EdgeInsets.all(MySize.getHeight(0)),
                          child: InkWell(
                            onTap: () async {
                              if (getIt<TimerService>().is40SecCompleted) {
                                await getIt<AdService>()
                                    .getAd(adType: AdService.interstitialAd)
                                    .then((value) {
                                  if (!value) {
                                    SystemChrome.setEnabledSystemUIMode(
                                        SystemUiMode.edgeToEdge);
                                    getIt<TimerService>().verifyTimer();
                                    Get.offAndToNamed(Routes.HOME);
                                  }
                                });
                              } else {
                                Get.offAllNamed(Routes.HOME);
                              }
                            },
                            child: Container(
                              height: MySize.getHeight(60),
                              width: MySize.getWidth(60),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: Container(
                            width: MySize.getWidth(300),
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
                : Container(
                    height: MySize.safeHeight,
                    width: MySize.safeWidth,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(top: MySize.getHeight(20)),
                        child: Column(
                          children: [
                            ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  List<String> temp = controller
                                      .addDataTempList[index].expiredDate
                                      .toString()
                                      .split(" ");
                                  List<String> purchasedDate = controller
                                      .addDataTempList[index].Date
                                      .toString()
                                      .split(" ");
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
                                                              .addDataTempList[
                                                          index]
                                                });
                                          },
                                          bill: () {
                                            OpenFilex.open(controller
                                                    .addDataTempList[index]
                                                    .Bill)
                                                .then((value) {
                                              if (value.message ==
                                                  "No APP found to open this file。") {
                                                getIt<CustomDialogs>()
                                                    .getDialog(
                                                  title: "No App Found",
                                                  desc: "No APP found to open this file.",
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
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                right: MySize
                                                                    .getWidth(
                                                                        8),
                                                                left: MySize
                                                                    .getWidth(
                                                                        8)),
                                                            child: Row(
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
                                                                    style: GoogleFonts
                                                                        .lexend(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          MySize.getHeight(
                                                                              20),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: MySize
                                                                .getHeight(20),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                right: MySize
                                                                    .getWidth(
                                                                        8),
                                                                left: MySize
                                                                    .getWidth(
                                                                        8)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.back();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height: MySize
                                                                          .getHeight(
                                                                              50),
                                                                      width: MySize
                                                                          .getWidth(
                                                                              110),
                                                                      decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(color: appTheme.yellowPrimaryTheme),
                                                                          borderRadius: BorderRadius.circular(4)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "CANCEL",
                                                                          style: GoogleFonts.lexend(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: MySize.getHeight(18),
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  width: MySize
                                                                      .getHeight(
                                                                          3.0),
                                                                ),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.back();
                                                                      controller.addDataList.removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          controller
                                                                              .addDataTempList[index]
                                                                              .id);
                                                                      controller
                                                                          .addDataTempList
                                                                          .clear();
                                                                      controller
                                                                          .addDataList
                                                                          .forEach(
                                                                              (element) {
                                                                        controller
                                                                            .addDataTempList
                                                                            .add(element);
                                                                      });
                                                                      box.write(
                                                                          ArgumentConstant
                                                                              .additemList,
                                                                          jsonEncode(
                                                                              controller.addDataList));
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
                                                                          border:
                                                                              Border.all(color: appTheme.yellowPrimaryTheme),
                                                                          borderRadius: BorderRadius.circular(4)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
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
                                                            height: MySize
                                                                .getHeight(10),
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
                                                  ArgumentConstant
                                                          .Categoriename:
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
                                                              .addDataTempList[
                                                          index],
                                                });
                                          },
                                          context: context,
                                          Index: index,
                                          Purchaseddate:
                                              purchasedDate[0].toString(),
                                          expireddate: temp[0].toString(),
                                          days: getDateFromStringNew(
                                                  controller
                                                      .addDataTempList[index]
                                                      .expiredDate
                                                      .toString(),
                                                  formatter: 'dd/MM/yyyy')
                                              .difference(getDateFromStringNew(
                                                  controller
                                                      .addDataTempList[index]
                                                      .Date
                                                      .toString(),
                                                  formatter: 'dd/MM/yyyy'))
                                              .inDays,
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
                                  List<String> expiredDate = controller
                                      .expireDataList[index].expiredDate
                                      .toString()
                                      .split(" ");
                                  List<String> purchasedDate = controller
                                      .expireDataList[index].Date
                                      .toString()
                                      .split(" ");

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
                                                controller
                                                    .expireDataList[index],
                                          });
                                    },
                                    Purchaseddate: purchasedDate[0].toString(),
                                    expireddate: expiredDate[0].toString(),
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
                                        .inDays,
                                    bill: () {
                                      OpenFilex.open(controller
                                              .expireDataList[index].Bill)
                                          .then((value) {
                                        if (value.message ==
                                            "No APP found to open this file。") {
                                          getIt<CustomDialogs>().getDialog(
                                            title: "No App Found",
                                            desc:"No APP found to open this file.",
                                          );
                                        }
                                      });
                                    },
                                    Name: controller
                                        .expireDataList[index].ItemName
                                        .toString(),
                                    image: controller
                                        .expireDataList[index].Image
                                        .toString(),
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
                                                            style: GoogleFonts
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
                                                                      fontSize:
                                                                          MySize.getHeight(
                                                                              18),
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            )),
                                                        SizedBox(
                                                          width:
                                                              MySize.getHeight(
                                                                  3.0),
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              Get.back();
                                                              controller
                                                                  .addDataTempList
                                                                  .forEach(
                                                                      (element) {
                                                                if (element
                                                                        .id ==
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
                                                                      fontSize:
                                                                          MySize.getHeight(
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MySize.getHeight(20),
            right: MySize.getHeight(20),
            left: MySize.getHeight(20)),
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
                            text: "${expireddate}",
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
