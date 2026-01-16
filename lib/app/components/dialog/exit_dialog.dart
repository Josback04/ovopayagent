import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/dialog/app_dialog.dart';
import 'package:ovopayagent/core/utils/my_strings.dart';

void showExitDialog(BuildContext context) {
  AppDialogs.confirmDialogForAll(
    context,
    onConfirmTap: () {
      // SystemNavigator.pop();
      Get.back();
    },
    title: MyStrings.exitTitle,
    subTitle: MyStrings.exitSubTitle,
  );
}
