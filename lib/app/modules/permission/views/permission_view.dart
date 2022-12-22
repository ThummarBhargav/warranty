import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/buttons.dart';
import '../../../routes/app_pages.dart';

import '../controllers/permission_controller.dart';

class PermissionView extends GetView<PermissionController> {
  const PermissionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.appbarTheme,
        title: Text(
          'Permission',
          style: GoogleFonts.lexend(
            fontWeight: FontWeight.w600,
            fontSize: MySize.getHeight(22),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MySize.safeWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacing.height(MySize.getHeight(51)),
            SvgPicture.asset("image/permission.svg"),
            Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Text(
                  "This permission allows warranty manager to access your images docs of your device.",
                  style: GoogleFonts.lexend(
                    fontWeight: FontWeight.bold,
                    fontSize: MySize.getHeight(14),
                  ),
                ),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () async {
                if (await Permission.storage.request().isGranted) {
                  controller.isPermissionDone.value = true;
                  box.write(ArgumentConstant.isPermissionDone,
                      controller.isPermissionDone.value);
                  Get.offAndToNamed(Routes.LOCK_SCREEN);
                } else {
                  openAppSettings();
                }
              },
              child: getButton(
                title: "Allow",
                fontWeight: FontWeight.w700,
                textSize: MySize.getHeight(22),
              ),
            ),
            Spacing.height(MySize.getHeight(75))
          ],
        ),
      ),
    );
  }
}
