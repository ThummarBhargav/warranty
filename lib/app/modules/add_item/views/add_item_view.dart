import 'dart:io';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:warranty_appp/utilities/buttons.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../constants/text_field.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../models/categoriesModels.dart';
import '../../../routes/app_pages.dart';
import '../controllers/add_item_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddItemView extends GetView<AddItemController> {
  const AddItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (getIt<TimerService>().is40SecCompleted) {
          await getIt<AdService>()
              .getAd(adType: AdService.interstitialAd)
              .then((value) {
            if (!value) {
              getIt<TimerService>().verifyTimer();
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              (controller.isFromHome)
                  ? Get.offAllNamed(Routes.HOME)
                  : Get.offAndToNamed(Routes.ADD_ITEM_LISTSCREEN, arguments: {
                      ArgumentConstant.Categoriename: controller.categoryName
                    });
            }
          });
          return await false;
        } else {
          (controller.isFromHome)
              ? Get.offAllNamed(Routes.HOME)
              : Get.offAndToNamed(Routes.ADD_ITEM_LISTSCREEN, arguments: {
                  ArgumentConstant.Categoriename: controller.categoryName
                });
          return await true;
        }
      },
      child: SafeArea(
        child: Obx(() {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
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
                              FocusScope.of(context).unfocus();
                              if (getIt<TimerService>().is40SecCompleted) {
                                await getIt<AdService>()
                                    .getAd(adType: AdService.interstitialAd)
                                    .then((value) {
                                  if (!value) {
                                    getIt<TimerService>().verifyTimer();
                                    SystemChrome.setEnabledSystemUIMode(
                                        SystemUiMode.edgeToEdge);
                                    (controller.isFromHome)
                                        ? Get.offAndToNamed(Routes.HOME)
                                        : Get.offAndToNamed(
                                            Routes.ADD_ITEM_LISTSCREEN,
                                            arguments: {
                                                ArgumentConstant.Categoriename:
                                                    controller.categoryName
                                              });
                                  }
                                });
                              } else {
                                (controller.isFromHome)
                                    ? Get.offAllNamed(Routes.HOME)
                                    : Get.offAndToNamed(
                                        Routes.ADD_ITEM_LISTSCREEN,
                                        arguments: {
                                            ArgumentConstant.Categoriename:
                                                controller.categoryName
                                          });
                              }
                            },
                            child: Container(
                              height: MySize.getHeight(50),
                              width: MySize.getWidth(60),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          (controller.isFromEdit) ? "Update Item" : "Add Item",
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(20),
                              color: Colors.white),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.all(MySize.getHeight(0)),
                          child: InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              if (controller.formKey.currentState!.validate()) {
                                if (controller.isNameEmpty.isFalse &&
                                    controller.isDurationEmpty.isFalse) {
                                  controller.expireDay.value =
                                      (getDateFromStringNew(
                                              controller.getExpiryDateString(),
                                              formatter: "dd/MM/yyyy HH:mm:ss")
                                          .difference(getDateFromStringNew(
                                              controller
                                                  .dateController.value.text
                                                  .toString(),
                                              formatter: "dd/MM/yyyy HH:mm:ss"))
                                          .inSeconds);
                                  controller.selectedExpireSec.value =
                                      ((controller.expireDay.value) -
                                          ((controller
                                                  .selectedExpireDay.value) *
                                              86400));
                                  controller.id.value = UniqueKey().hashCode;
                                  if (controller.isFromEdit) {
                                    controller.EditItem(dataModels(
                                        id: controller.id.value,
                                        selectedExpireDay: controller.selectedExpireDay.value
                                            .toString(),
                                        ItemName: controller
                                            .itemNameController.value.text,
                                        Date: controller
                                            .dateController.value.text,
                                        Image: (controller.files!.isNotEmpty)
                                            ? controller.files![0]
                                            : null,
                                        Bill: (controller.files1!.isNotEmpty)
                                            ? controller.files1![0]
                                            : null,
                                        expiredDate:
                                            controller.getExpiryDateString(),
                                        selectedExpireName: controller
                                            .selectedExpireName.value
                                            .toString(),
                                        Ditails: controller
                                            .detailsController.value.text,
                                        Duration: controller
                                            .durationController.value.text,
                                        pickedTime:
                                            controller.formattedTime.value,
                                        categoriesName: controller
                                            .dropDownController!
                                            .dropDownValue!
                                            .name
                                            .toString()));
                                  } else {
                                    controller.addItem(dataModels(
                                        id: controller.id.value,
                                        ItemName: controller
                                            .itemNameController.value.text,
                                        Date: controller
                                            .dateController.value.text,
                                        pickedTime:
                                            controller.formattedTime.value,
                                        Image: (controller.files!.isNotEmpty)
                                            ? controller.files![0]
                                            : null,
                                        Bill: (controller.files1!.isNotEmpty)
                                            ? controller.files1![0]
                                            : null,
                                        expiredDate:
                                            controller.getExpiryDateString(),
                                        selectedExpireName: controller
                                            .selectedExpireName.value
                                            .toString(),
                                        selectedExpireDay: controller
                                            .selectedExpireDay.value
                                            .toString(),
                                        Ditails: controller
                                            .detailsController.value.text,
                                        Duration: controller
                                            .durationController.value.text,
                                        categoriesName: controller
                                            .dropDownController!
                                            .dropDownValue!
                                            .name
                                            .toString()));
                                  }
                                }
                              } else {
                                if (controller
                                    .itemNameController.value.text.isEmpty) {
                                  controller.isNameEmpty.value = true;
                                }
                                if (controller
                                    .durationController.value.text.isEmpty) {
                                  controller.isDurationEmpty.value = true;
                                }
                              }
                              await (controller.durationController.value.text ==
                                      "0")
                                  ? SizedBox()
                                  : controller.service
                                      .showScheduledNotification(
                                      id: controller.id.value,
                                      title: "Warranty App",
                                      payload: "${controller.id.value}",
                                      body:
                                          "${controller.itemNameController.value.text} To ReNew",
                                      seconds:
                                          controller.selectedExpireSec.value,
                                    );
                            },
                            child: Container(
                              width: MySize.getWidth(70),
                              child: Center(
                                child: Text(
                                  (controller.isFromEdit) ? "UPDATE" : "SAVE",
                                  style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w400,
                                      fontSize: MySize.getHeight(15),
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MySize.getWidth(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacing.height(20),
                              Text(
                                "Item Name",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(13),
                                    color: Colors.black),
                              ),
                              Spacing.height(12),
                              Container(
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
                                  focusNode: controller.noteFocus,
                                  hintText: "Enter Item Name",
                                  borderColor: (controller.isNameEmpty.isTrue)
                                      ? appTheme.ErrorText
                                      : Colors.transparent,
                                  size: 70,
                                  textCapitalization: TextCapitalization.words,
                                  isFilled: true,
                                  validation: (value) {
                                    if (!isNullEmptyOrFalse(value)) {
                                      controller.isNameEmpty.value = false;
                                    } else {
                                      controller.isNameEmpty.value = true;
                                      controller.noteFocus
                                          .requestFocus(controller.noteFocus);
                                    }
                                    return null;
                                  },
                                  fillColor: Colors.white,
                                  textEditingController:
                                      controller.itemNameController.value,
                                ),
                              ),
                              Spacing.height(20),
                              Text(
                                "Category",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(13),
                                    color: Colors.black),
                              ),
                              Spacing.height(12),
                              Container(
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
                                child: DropDownTextField(
                                  controller: controller.dropDownController,
                                  isEnabled: controller.isFromHome,
                                  dropdownRadius: MySize.getHeight(10),
                                  textStyle: GoogleFonts.lexend(
                                      height: (MySize.isMini) ? 3 : 3,
                                      fontWeight: FontWeight.w400,
                                      fontSize: MySize.getHeight(13),
                                      color: Colors.black),
                                  clearOption: false,
                                  listTextStyle: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w400,
                                      fontSize: MySize.getHeight(13),
                                      color: Colors.black),
                                  textFieldDecoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(
                                          MySize.getHeight(10)),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      left: MySize.getWidth(20),
                                      right: MySize.getWidth(10),
                                    ),
                                  ),
                                  dropDownItemCount: 6,
                                  dropDownList: controller
                                      .homeController!.categoryDataList
                                      .map((element) => DropDownValueModel(
                                          name:
                                              element.categoriesName.toString(),
                                          value: element.categoriesName
                                              .toString()))
                                      .toList(),
                                ),
                              ),
                              Spacing.height(20),
                              Text(
                                "Purchase Date",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(13),
                                    color: Colors.black),
                              ),
                              Spacing.height(12),
                              Container(
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
                                    fontSize: MySize.getHeight(13),
                                    fillColor: Colors.white,
                                    isFilled: true,
                                    textEditingController:
                                        controller.selectDateController.value,
                                    labelColor: Colors.grey,
                                    readOnly: true,
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      colorScheme:
                                                          ColorScheme.light(
                                                        primary: appTheme
                                                            .yellowPrimaryTheme,
                                                      ),
                                                      textButtonTheme:
                                                          TextButtonThemeData(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor: Colors
                                                              .black, // button text color
                                                        ),
                                                      ),
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101));

                                        if (pickedDate != null) {
                                          DateTime now = DateTime.now();
                                          controller.dateController.value.text =
                                              DateFormat('dd/MM/yyyy HH:mm:ss')
                                                  .format(DateTime(
                                                      pickedDate.year,
                                                      pickedDate.month,
                                                      pickedDate.day,
                                                      now.hour,
                                                      now.minute,
                                                      now.second));
                                          controller.selectDateController.value
                                                  .text =
                                              DateFormat('dd/MM/yyyy').format(
                                                  DateTime(
                                                      pickedDate.year,
                                                      pickedDate.month,
                                                      pickedDate.day,
                                                      now.hour,
                                                      now.minute,
                                                      now.second));
                                          controller.selectedDate.value =
                                              pickedDate;
                                        } else {
                                          print("Date is not selected");
                                        }
                                      },
                                      child: Icon(
                                        Icons.date_range,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    textInputType: TextInputType.name),
                              ),
                              Spacing.height(20),
                              Text(
                                "Duration In Days",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(13),
                                    color: Colors.black),
                              ),
                              Spacing.height(12),
                              Container(
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
                                    focusNode: controller.noteFocus1,
                                    isFilled: true,
                                    fillColor: Colors.white,
                                    borderColor:
                                        (controller.isDurationEmpty.isTrue)
                                            ? appTheme.ErrorText
                                            : Colors.white,
                                    textEditingController:
                                        controller.durationController.value,
                                    hintText: "Duration In Days",
                                    validation: (value) {
                                      if (!isNullEmptyOrFalse(value)) {
                                        controller.isDurationEmpty.value =
                                            false;
                                      } else {
                                        controller.isDurationEmpty.value = true;
                                        controller.noteFocus1.requestFocus(
                                            controller.noteFocus1);
                                      }
                                      return null;
                                    },
                                    onChange: (value) {
                                      print(value);
                                      controller.durationController.refresh();
                                      controller.days.value =
                                          int.parse(value.toString());
                                    },
                                    labelColor: Colors.grey,
                                    textInputType: TextInputType.number),
                              ),
                              Spacing.height(20),
                              if (!isNullEmptyOrFalse(
                                  controller.durationController.value.text))
                                if (int.tryParse(controller
                                        .durationController.value.text)! >
                                    0)
                                  Text(
                                    "Schedule Notification",
                                    style: GoogleFonts.lexend(
                                        fontWeight: FontWeight.w400,
                                        fontSize: MySize.getHeight(13),
                                        color: Colors.black),
                                  ),
                              if (!isNullEmptyOrFalse(
                                  controller.durationController.value.text))
                                if (int.tryParse(controller
                                        .durationController.value.text)! >
                                    0)
                                  Spacing.height(12),
                              if (!isNullEmptyOrFalse(
                                  controller.durationController.value.text))
                                if (int.tryParse(controller
                                        .durationController.value.text)! >
                                    0)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(0, 7),
                                                color: Colors.black
                                                    .withOpacity(0.08),
                                                blurRadius:
                                                    MySize.getHeight(13),
                                                spreadRadius:
                                                    MySize.getHeight(2),
                                              ),
                                            ],
                                          ),
                                          child: DropDownTextField(
                                              textStyle: GoogleFonts.lexend(
                                                fontWeight: FontWeight.w400,
                                                height: (MySize.isMini) ? 3 : 3,
                                                fontSize: MySize.getHeight(13),
                                              ),
                                              clearOption: false,
                                              listTextStyle: GoogleFonts.lexend(
                                                fontWeight: FontWeight.w400,
                                                fontSize: MySize.getHeight(13),
                                              ),
                                              textFieldDecoration:
                                                  InputDecoration(
                                                floatingLabelAlignment:
                                                    FloatingLabelAlignment
                                                        .center,
                                                filled: true,
                                                fillColor: Colors.white,
                                                labelStyle: TextStyle(),
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent)),
                                                contentPadding: EdgeInsets.only(
                                                  left: MySize.getWidth(20),
                                                  right: MySize.getWidth(10),
                                                  //  bottom: size! / 2, // HERE THE IMPORTANT PART
                                                ),
                                              ),
                                              controller: controller
                                                  .notificationController,
                                              dropDownItemCount: 6,
                                              onChanged: (index) {
                                                DropDownValueModel
                                                    dropDownValue =
                                                    index as DropDownValueModel;
                                                controller.selectedExpireDay
                                                        .value =
                                                    int.parse(dropDownValue
                                                        .value
                                                        .toString());
                                                DropDownValueModel
                                                    dropDownValue1 = index;
                                                controller.selectedExpireName
                                                        .value =
                                                    "${dropDownValue1.name.toString()}";
                                              },
                                              dropDownList: List.generate(
                                                  (controller.days.value < 7 &&
                                                          controller
                                                                  .days.value !=
                                                              0)
                                                      ? controller.days.value
                                                      : controller
                                                          .notificationList
                                                          .length,
                                                  (index) => DropDownValueModel(
                                                      name: controller
                                                          .notificationList[
                                                              index]
                                                          .title,
                                                      value: controller
                                                          .notificationList[
                                                              index]
                                                          .value))),
                                        ),
                                      ),
                                      SizedBox(
                                        width: MySize.getWidth(10),
                                      ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () async {
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            initialTime: TimeOfDay.now(),
                                            context: context,
                                          );
                                          if (pickedTime != null) {
                                            DateTime parsedTime =
                                                DateFormat.jm().parse(pickedTime
                                                    .format(context)
                                                    .toString());
                                            controller.formattedTime.value =
                                                DateFormat('HH:mm:ss')
                                                    .format(parsedTime);
                                            controller.selectedTime.value =
                                                pickedTime;
                                          }
                                        },
                                        child: Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${controller.formattedTime}",
                                                    style: GoogleFonts.lexend(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          MySize.getHeight(13),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.alarm,
                                                      color: Colors.grey,
                                                      size:
                                                          MySize.getHeight(30),
                                                    ))
                                              ]),
                                          height: MySize.getHeight(50),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(0, 7),
                                                color: Colors.black
                                                    .withOpacity(0.08),
                                                blurRadius:
                                                    MySize.getHeight(13),
                                                spreadRadius:
                                                    MySize.getHeight(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                              Spacing.height(20),
                              Text(
                                "Detail",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(13),
                                    color: Colors.black),
                              ),
                              Spacing.height(12),
                              Container(
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
                                    minLine: 1,
                                    maxLine: 5,
                                    fillColor: Colors.white,
                                    isFilled: true,
                                    textInputAction: TextInputAction.newline,
                                    textEditingController:
                                        controller.detailsController.value,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    hintText: "Detail",
                                    labelColor: Colors.grey,
                                    textInputType: TextInputType.multiline),
                              ),
                              Spacing.height(MySize.getHeight(30)),
                              Row(
                                children: [
                                  getimageWidget(
                                    image: "camera.png",
                                    Name: "ATTACH IMAGE",
                                    file: "*jpg,png file only",
                                    onTap: () async {
                                      await imagePick(isBill: false);
                                    },
                                  ),
                                  // Spacing.width(MySize.getWidth(17)),
                                  Spacer(),
                                  getpdfWidget(
                                    image: "bill.png",
                                    Name: "ATTACH BILL",
                                    file: "*pdf,jpg,png file only",
                                    onTap: () async {
                                      await billPick(isBill: true);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void listenToNotification() => controller.service.onNotificationClick.stream
      .listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Get.toNamed(Routes.HOME);
    }
  }

  getimageWidget({
    String Counter = "0",
    String image = "pc.png",
    String Name = "",
    String file = "",
    VoidCallback? onTap,
  }) {
    return Container(
      height: (MySize.isMini) ? MySize.getHeight(250) : MySize.getHeight(200),
      width: (MySize.isMini) ? MySize.getHeight(183) : MySize.getHeight(148),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 7),
          color: Colors.black.withOpacity(0.03),
          blurRadius: MySize.getHeight(13),
          spreadRadius: MySize.getHeight(2),
        ),
      ], borderRadius: BorderRadius.circular(MySize.getHeight(10))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            "image/Rectangle 48.svg",
            fit: BoxFit.cover,
          ),
          Positioned(
              top: 17,
              child: Padding(
                padding: EdgeInsets.all(
                  MySize.getHeight(8.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: (MySize.isMini)
                          ? EdgeInsets.only(top: 15.0)
                          : EdgeInsets.only(top: 2),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            child: SvgPicture.asset(
                              "image/Rectangle 49.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            child: (controller.files!.isNotEmpty)
                                ? (controller.files![0] == "null")
                                    ? SvgPicture.asset(
                                        "image/photo.svg",
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: MySize.getHeight(70),
                                        child: Image.file(
                                            File(controller.files!.first)))
                                : SvgPicture.asset(
                                    "image/photo.svg",
                                    fit: BoxFit.cover,
                                  ),
                          )
                        ],
                      ),
                    ),
                    Spacing.height(10),
                    Center(
                        child: InkWell(
                      onTap: onTap,
                      child: Container(
                        height: MySize.getHeight(35),
                        width: MySize.getWidth(100),
                        child: Center(
                            child: Text(
                          "$Name",
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(10),
                              color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                            color: appTheme.yellowPrimaryTheme,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    )),
                    Spacing.height(7),
                    Container(
                        child: Center(
                            child: Text(
                      "$file",
                      style: GoogleFonts.lexend(
                          fontWeight: FontWeight.w400,
                          fontSize: MySize.getHeight(10),
                          color: appTheme.appbarTheme),
                    ))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  getpdfWidget({
    String Counter = "0",
    String image = "pc.png",
    String Name = "",
    String file = "",
    VoidCallback? onTap,
  }) {
    return Container(
      height: (MySize.isMini) ? MySize.getHeight(250) : MySize.getHeight(200),
      width: (MySize.isMini) ? MySize.getHeight(183) : MySize.getHeight(148),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 7),
          color: Colors.black.withOpacity(0.03),
          blurRadius: MySize.getHeight(13),
          spreadRadius: MySize.getHeight(2),
        ),
      ], borderRadius: BorderRadius.circular(MySize.getHeight(10))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            "image/Rectangle 48.svg",
            fit: BoxFit.cover,
          ),
          Positioned(
              top: 17,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: (MySize.isMini)
                          ? EdgeInsets.only(top: 15.0)
                          : EdgeInsets.only(top: 2),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            child: SvgPicture.asset(
                              "image/Rectangle 49.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            child: (controller.files1!.isNotEmpty)
                                ? (controller.files1![0] == "null")
                                    ? SvgPicture.asset(
                                        "image/bill.svg",
                                        fit: BoxFit.cover,
                                      )
                                    : ((controller.files1!.first.isPDFFileName))
                                        ? Container(
                                            height: MySize.getHeight(70),
                                            child: Image.asset(
                                              imagePath + "pdf.png",
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(
                                            height: MySize.getHeight(70),
                                            child: Image.file(
                                                File(controller.files1!.first)),
                                          )
                                : SvgPicture.asset(
                                    "image/bill.svg",
                                    fit: BoxFit.cover,
                                  ),
                          )
                        ],
                      ),
                    ),
                    Spacing.height(10),
                    Center(
                        child: InkWell(
                      onTap: onTap,
                      child: Container(
                        height: MySize.getHeight(35),
                        width: MySize.getWidth(100),
                        child: Center(
                            child: Text(
                          "$Name",
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(10),
                              color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                            color: appTheme.yellowPrimaryTheme,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    )),
                    Spacing.height(7),
                    Container(
                        child: Center(
                            child: Text(
                      "$file",
                      style: GoogleFonts.lexend(
                          fontWeight: FontWeight.w400,
                          fontSize: MySize.getHeight(10),
                          color: appTheme.appbarTheme),
                    ))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  imagePick({bool isBill = false}) async {
    final result = await FilePicker.platform
        .pickFiles(
      type: FileType.custom,
      allowedExtensions: (isBill) ? ['pdf', 'jpg', 'png'] : ['jpg', 'png'],
    )
        .then((value) {
      controller.files!.value =
          value!.files.map((e) => e.path).cast<String>().toList();
    });
    if (controller.files!.isEmpty) {
      return;
    }
  }

  billPick({bool isBill = false}) async {
    final result = await FilePicker.platform
        .pickFiles(
      type: FileType.custom,
      allowedExtensions: (isBill) ? ['pdf', 'jpg', 'png'] : ['jpg', 'png'],
    )
        .then((value) {
      controller.files1!.value =
          value!.files.map((e) => e.path).cast<String>().toList();
    });
    if (controller.files1!.isEmpty) {
      return;
    }
  }
}
