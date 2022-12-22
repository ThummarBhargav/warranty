import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';

import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../controllers/image_view_controller.dart';

class ImageViewView extends GetView<ImageViewController> {
  const ImageViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                    width: MySize.safeWidth,
                    height: MySize.safeHeight,
                    child: Image.asset(
                      "image/background.png",
                      fit: BoxFit.cover,
                    )),
              ],
            ),
            Positioned(
                child: Column(
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: MySize.getHeight(40),
                            width: MySize.getWidth(40),
                            child: SvgPicture.asset("image/backArrow.svg",
                                fit: BoxFit.none),
                          ),
                        ),
                      ),
                      Space.width(MySize.getWidth(70)),
                      Text(
                        "Image view",
                        style: GoogleFonts.lexend(
                            fontWeight: FontWeight.w400,
                            fontSize: MySize.getHeight(25),
                            color: Colors.black),
                      ),
                    ],
                  ),
                )),
                Space.height(MySize.getHeight(20)),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 7),
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: MySize.getHeight(13),
                          spreadRadius: MySize.getHeight(2),
                        ),
                      ]),
                      child: SvgPicture.asset(
                        "image/viewbanner.svg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Positioned(
                        child: Container(
                            height: MySize.getHeight(330),
                            width: MySize.getWidth(400),
                            child: (!isNullEmptyOrFalse(controller.image) &&
                                    controller.image != "null")
                                ? Center(
                                    child: Image.file(
                                    File(
                                      controller.image.toString(),
                                    ),
                                    fit: BoxFit.cover,
                                  ))
                                : null))
                  ],
                ),
                Space.height(MySize.getHeight(20)),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      height: (MySize.isMini)
                          ? MySize.getHeight(90)
                          : MySize.getHeight(80),
                      width: MySize.getWidth(80),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await GallerySaver.saveImage(
                                  controller.image.toString());
                            },
                            child: Container(
                              height: MySize.getHeight(60),
                              width: MySize.getWidth(60),
                              child: CircleAvatar(
                                backgroundColor: appTheme.yellowPrimaryTheme,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "image/save.svg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Save",
                            style: GoogleFonts.lexend(
                                fontWeight: FontWeight.w400,
                                fontSize: MySize.getHeight(15),
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    Space.width(MySize.getWidth(40)),
                    Container(
                      height: (MySize.isMini)
                          ? MySize.getHeight(90)
                          : MySize.getHeight(80),
                      width: MySize.getWidth(80),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await Share.shareFiles(
                                  [controller.image.toString()]);
                            },
                            child: Container(
                              height: MySize.getHeight(60),
                              width: MySize.getWidth(60),
                              child: CircleAvatar(
                                backgroundColor: appTheme.yellowPrimaryTheme,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "image/share.svg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Share",
                            style: GoogleFonts.lexend(
                                fontWeight: FontWeight.w400,
                                fontSize: MySize.getHeight(15),
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ))
          ],
        )),
      ),
    );
  }
}
