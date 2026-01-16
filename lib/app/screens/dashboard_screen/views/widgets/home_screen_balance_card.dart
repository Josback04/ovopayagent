import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/app/components/image/my_asset_widget.dart';
import 'package:ovopayagent/app/components/shimmer/home_shimmer.dart';
import 'package:ovopayagent/app/screens/dashboard_screen/controller/home_controller.dart';
import 'package:ovopayagent/core/data/models/global/qr_code/scan_qr_code_response_model.dart';
import 'package:ovopayagent/core/data/services/service_exporter.dart';
import 'package:ovopayagent/core/utils/util_exporter.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/route/route.dart';

class HomeScreenBalanceCard extends StatelessWidget {
  const HomeScreenBalanceCard({super.key, required this.homeController});
  final HomeController homeController;
  @override
  Widget build(BuildContext context) {
    return homeController.isLoading
        ? HomeShimmer()
        : Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: MyColor.getPrimaryColor(),
              borderRadius: BorderRadius.circular(Dimensions.cardExtraRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: Dimensions.space12.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Wallet
                      Row(
                        children: [
                          MyAssetImageWidget(
                            isSvg: true,
                            assetPath: MyIcons.walletIcon,
                            width: Dimensions.space24.w,
                            height: Dimensions.space24.w,
                          ),
                          spaceSide(Dimensions.space8),
                          Text(
                            MyStrings.yourWalletBalance.tr,
                            style: MyTextStyle.bodyTextStyle1.copyWith(
                              color: MyColor.getWhiteColor(),
                            ),
                          ),
                        ],
                      ),

                      // QR Code with PopupMenuButton
                      PopupMenuButton<String>(
                        surfaceTintColor: Colors.transparent,
                        icon: MyAssetImageWidget(
                          // color: MyColor.getPrimaryColor(),
                          isSvg: true,
                          assetPath: MyIcons.walletQrCodeIcon,
                          width: Dimensions.space40.w,
                          height: Dimensions.space40.w,
                        ),
                        position: PopupMenuPosition.under,
                        color: MyColor.getScreenBgColor(),
                        // shadowColor: MyColor.transparentColor,
                        onSelected: (value) {
                          if (value == "scanQrCode") {
                            // Navigate to Scan QR Code Screen
                            Get.toNamed(RouteHelper.scanQrCodeScreen)?.then((v) {
                              ScanQrCodeResponseModel scanQrCodeResponseModel = v as ScanQrCodeResponseModel;
                              printE(scanQrCodeResponseModel.data?.userType);
                              printW(
                                scanQrCodeResponseModel.data?.userData?.username,
                              );
                              if (scanQrCodeResponseModel.data?.userType == AppStatus.USER_TYPE_USER) {
                                Get.toNamed(
                                  RouteHelper.cashInScreen,
                                  arguments: scanQrCodeResponseModel.data?.userData,
                                );
                              }
                            });
                          } else if (value == "myQrCode") {
                            // Navigate to My QR Code Screen
                            Get.toNamed(RouteHelper.myQrCodeScreen);
                          } else if (value == "qrCodeLogin") {
                            // Navigate to Qr code Login Screen
                            Get.toNamed(RouteHelper.qrCodeLoginScreen);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "myQrCode",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.qr_code, // Replace with your desired icon
                                  color: MyColor.getHeaderTextColor(),
                                ),
                                SizedBox(
                                  width: 8,
                                ), // Spacing between icon and text
                                Text(
                                  MyStrings.myQrCode,
                                  style: MyTextStyle.bodyTextStyle1.copyWith(
                                    color: MyColor.getHeaderTextColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: "scanQrCode",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.qr_code_scanner, // Replace with your desired icon
                                  color: MyColor.getHeaderTextColor(),
                                ),
                                SizedBox(
                                  width: 8,
                                ), // Spacing between icon and text
                                Text(
                                  MyStrings.scanQrCode,
                                  style: MyTextStyle.bodyTextStyle1.copyWith(
                                    color: MyColor.getHeaderTextColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (SharedPreferenceService.isSupportQrCodeLogin()) ...[
                            PopupMenuItem(
                              value: "qrCodeLogin",
                              child: Row(
                                children: [
                                  MyAssetImageWidget(
                                    isSvg: true,
                                    assetPath: MyIcons.walletQrCodeIcon,
                                    width: Dimensions.space22.w,
                                    height: Dimensions.space22.w,
                                    color: MyColor.getHeaderTextColor(),
                                  ),
                                  spaceSide(
                                    Dimensions.space8,
                                  ), // Spacing between icon and text
                                  Text(
                                    MyStrings.qrCodeLogin,
                                    style: MyTextStyle.bodyTextStyle1.copyWith(
                                      color: MyColor.getHeaderTextColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                spaceDown(Dimensions.space3),
                GetBuilder<HomeController>(
                  builder: (homeController) {
                    return InkWell(
                      onTap: () {
                        homeController.toggleBalanceVisibility();
                      },
                      child: Container(
                        height: Dimensions.space50,
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: Dimensions.space12.w,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Text(
                                homeController.isBalanceVisible ? "${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(homeController.accountBalanceFormatted, forceShowPrecision: true)}" : "•••••••••",
                                overflow: TextOverflow.ellipsis,
                                style: MyTextStyle.balanceCardTextStyle.copyWith(
                                  color: MyColor.getWhiteColor(),
                                  fontSize: homeController.isBalanceVisible ? Dimensions.space35.sp : Dimensions.space50.sp,
                                ),
                                maxLines: 1,
                              ),
                              spaceSide(Dimensions.space10),
                              CustomAppCard(
                                height: Dimensions.space40,
                                width: Dimensions.space40,
                                showBorder: false,
                                radius: Dimensions.radiusProMax,
                                backgroundColor: MyColor.getWhiteColor().withValues(alpha: 0.15),
                                padding: EdgeInsets.all(Dimensions.space8),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Icon(
                                    homeController.isBalanceVisible == true ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                                    color: MyColor.getWhiteColor(),
                                    size: Dimensions.space30,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (SharedPreferenceService.getModuleStatusByKey("add_money") || SharedPreferenceService.getModuleStatusByKey("cash_in")) ...[
                  spaceDown(Dimensions.space20),

                  // Action Icons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (SharedPreferenceService.getModuleStatusByKey(
                        "add_money",
                      )) ...[
                        Flexible(
                          child: buildBalanceCardActionIcon(
                            iconImage: MyIcons.walletAddIcon,
                            titleText: MyStrings.addMoney,
                            onTap: () {
                              Get.toNamed(RouteHelper.addMoneyScreen);
                            },
                          ),
                        ),
                      ],
                      if (SharedPreferenceService.getModuleStatusByKey(
                        "cash_in",
                      )) ...[
                        Flexible(
                          child: buildBalanceCardActionIcon(
                            iconImage: MyIcons.sendIcon,
                            titleText: MyStrings.cashIn,
                            onTap: () {
                              Get.toNamed(RouteHelper.cashInScreen);
                            },
                          ),
                        ),
                      ],
                      // if (SharedPreferenceService.getModuleStatusByKey("withdraw_money")) ...[
                      Flexible(
                        child: buildBalanceCardActionIcon(
                          iconImage: MyIcons.paymentIcon,
                          titleText: MyStrings.withdraw,
                          onTap: () {
                            Get.toNamed(RouteHelper.withdrawMoneyScreen);
                          },
                        ),
                      ),
                      // ],
                      Flexible(
                        child: buildBalanceCardActionIcon(
                          iconImage: MyIcons.historyIcon,
                          titleText: MyStrings.history,
                          onTap: () {
                            Get.toNamed(RouteHelper.inboxScreen);
                          },
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  spaceDown(Dimensions.space10),
                ],
              ],
            ),
          );
  }

  InkWell buildBalanceCardActionIcon({
    String iconImage = "",
    String titleText = "",
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Skeleton.replace(
            replace: true,
            replacement: Bone.square(size: Dimensions.space40.h),
            child: CustomAppCard(
              showBorder: false,
              backgroundColor: MyColor.white.withValues(alpha: 0.15),
              padding: EdgeInsets.all(Dimensions.space10),
              width: Dimensions.space40.h,
              height: Dimensions.space40.h,
              radius: Dimensions.space12,
              child: MyAssetImageWidget(
                isSvg: true,
                assetPath: iconImage,
                color: MyColor.getWhiteColor(),
                width: Dimensions.space24.h,
                height: Dimensions.space24.h,
              ),
            ),
          ),
          spaceDown(Dimensions.space4),
          Text(
            titleText.tr,
            textAlign: TextAlign.center,
            style: MyTextStyle.caption2Style.copyWith(
              color: MyColor.getWhiteColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final Random _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.1);

    for (int i = 0; i < 200; i++) {
      final dx = _random.nextDouble() * size.width;
      final dy = _random.nextDouble() * size.height;
      final radius = _random.nextDouble() * 4 + 1;

      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class RandomRectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Creating a rectangular path
    path.addRect(Rect.fromLTWH(0, 0, 20, 20));

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
