import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopayagent/app/components/buttons/hold_to_confirm_button.dart';
import 'package:ovopayagent/app/components/image/my_asset_widget.dart';
import 'package:ovopayagent/app/components/text/header_text.dart';
import 'package:ovopayagent/app/components/text/header_text_smaller.dart';
import 'package:ovopayagent/app/components/will_pop_widget.dart';
import 'package:ovopayagent/core/route/route.dart';
import 'package:lottie/lottie.dart';
import '../../../core/utils/util_exporter.dart';

class AppDialogs {
  static Future confirmDialog(
    BuildContext context, {
    required Function onFinish,
    Function? onWaiting,
    required String title,
    required Widget userDetailsWidget,
    required Widget cashDetailsWidget,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
      builder: (_) {
        return WillPopWidget(
          nextRoute: "",
          action: () {},
          child: Dialog(
            surfaceTintColor: MyColor.transparentColor,
            insetPadding: EdgeInsets.all(Dimensions.space16.w),
            backgroundColor: MyColor.transparentColor,
            insetAnimationCurve: Curves.easeIn,
            insetAnimationDuration: const Duration(milliseconds: 100),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return Container(
                  padding: EdgeInsetsDirectional.all(Dimensions.space16.w),
                  decoration: BoxDecoration(
                    color: MyColor.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.w)),
                    border: Border.all(
                      color: MyColor.transparentColor,
                      width: 0.6,
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraint.maxHeight / 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          //TITLE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Title
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HeaderText(
                                    text: MyStrings.confirmTo.tr,
                                    textStyle: MyTextStyle.headerH3.copyWith(
                                      color: MyColor.getBodyTextColor(),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  HeaderText(
                                    text: title.tr,
                                    textStyle: MyTextStyle.headerH3.copyWith(
                                      color: MyColor.getPrimaryColor(),
                                    ),
                                  ),
                                ],
                              ),

                              //Close Button
                              IconButton(
                                padding: EdgeInsets.all(Dimensions.space3.w),
                                style: IconButton.styleFrom(),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: MyAssetImageWidget(
                                  color: MyColor.getPrimaryColor(),
                                  isSvg: true,
                                  assetPath: MyIcons.closeButton,
                                  width: Dimensions.space40.w,
                                  height: Dimensions.space40.w,
                                ),
                              ),
                            ],
                          ),

                          spaceDown(Dimensions.space30),
                          //body
                          userDetailsWidget,
                          spaceDown(Dimensions.space15),
                          cashDetailsWidget,
                          spaceDown(Dimensions.space30),

                          HoldToConfirmButton(
                            zoomScale: false,
                            onProgressChange: (value) {
                              // printX(value);
                            },
                            onProgressCompleted: () async {
                              printX("Completed");
                            },
                            onApiCall: () async {
                              await onFinish();
                            },
                            hapticFeedback: true,
                            border: Border.all(color: MyColor.getBorderColor()),
                            backgroundColor: MyColor.getScreenBgColor(),
                            fillColor: MyColor.getPrimaryColor().withValues(
                              alpha: 0.8,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  static Future successDialog(
    BuildContext context, {
    required String title,
    required Widget userDetailsWidget,
    required Widget cashDetailsWidget,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
      builder: (_) {
        return WillPopWidget(
          nextRoute: "",
          action: () {},
          child: Dialog(
            surfaceTintColor: MyColor.transparentColor,
            insetPadding: EdgeInsets.all(Dimensions.space16.w),
            backgroundColor: MyColor.transparentColor,
            insetAnimationCurve: Curves.fastOutSlowIn,
            insetAnimationDuration: const Duration(milliseconds: 100),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    vertical: Dimensions.space32.w,
                    horizontal: Dimensions.space16.w,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.w)),
                    border: Border.all(
                      color: MyColor.transparentColor,
                      width: 0.6,
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraint.maxHeight / 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          //TITLE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //Close Button
                              MyAssetImageWidget(
                                color: MyColor.getPrimaryColor(),
                                isSvg: true,
                                assetPath: MyIcons.verifyIcon,
                                width: Dimensions.space32.w,
                                height: Dimensions.space32.w,
                              ),
                              spaceSide(Dimensions.space10),
                              //Title
                              Expanded(
                                child: HeaderText(
                                  text: title,
                                  textStyle: MyTextStyle.sectionTitle.copyWith(
                                    color: MyColor.getBodyTextColor(),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          spaceDown(Dimensions.space30),
                          //body
                          userDetailsWidget,
                          spaceDown(Dimensions.space15),
                          cashDetailsWidget,
                          spaceDown(Dimensions.space30),

                          CustomElevatedBtn(
                            radius: Dimensions.largeRadius.r,
                            bgColor: MyColor.getPrimaryColor(),
                            text: MyStrings.backToHome.tr,
                            onTap: () {
                              Get.offAllNamed(RouteHelper.dashboardScreen);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  static Future successDialogForAll(
    BuildContext context, {
    required String title,
    required String subTitle,
    String buttonTitle = MyStrings.continueText,
    required VoidCallback onTap,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
      builder: (_) {
        return Dialog(
          surfaceTintColor: MyColor.transparentColor,
          insetPadding: EdgeInsets.all(Dimensions.space16.w),
          backgroundColor: MyColor.transparentColor,
          insetAnimationCurve: Curves.fastOutSlowIn,
          insetAnimationDuration: const Duration(milliseconds: 100),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return Container(
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: Dimensions.space32.w,
                  horizontal: Dimensions.space16.w,
                ),
                decoration: BoxDecoration(
                  color: MyColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                  border: Border.all(
                    color: MyColor.transparentColor,
                    width: 0.6,
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 150.w,
                          height: 150.w,
                          child: Lottie.asset(
                            MyIcons.successLottieIcon,
                            repeat: false,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.contain,
                            width: 150.w,
                            height: 150.w,
                          ),
                        ),
                        spaceDown(Dimensions.space30),
                        HeaderText(
                          text: title,
                          textStyle: MyTextStyle.headerH3.copyWith(
                            color: MyColor.getDarkColor(),
                          ),
                        ),
                        spaceDown(Dimensions.space4),
                        HeaderTextSmaller(
                          text: subTitle,
                          textAlign: TextAlign.center,
                          textStyle: MyTextStyle.sectionBodyTextStyle.copyWith(
                            color: MyColor.getBodyTextColor(),
                          ),
                        ),
                        spaceDown(Dimensions.space30),
                        CustomElevatedBtn(
                          radius: Dimensions.largeRadius.r,
                          bgColor: MyColor.getPrimaryColor(),
                          text: buttonTitle.tr,
                          onTap: onTap,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Future globalAppDialogForAll(
    BuildContext context, {
    required String title,
    required String subTitle,
    String buttonTitle = MyStrings.continueText,
    OvoDialogTypeType type = OvoDialogTypeType.error,
    required VoidCallback onTap,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
      builder: (_) {
        return Dialog(
          surfaceTintColor: MyColor.transparentColor,
          insetPadding: EdgeInsets.all(Dimensions.space16.w),
          backgroundColor: MyColor.transparentColor,
          insetAnimationCurve: Curves.fastOutSlowIn,
          insetAnimationDuration: const Duration(milliseconds: 100),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return Container(
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: Dimensions.space32.w,
                  horizontal: Dimensions.space16.w,
                ),
                decoration: BoxDecoration(
                  color: MyColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                  border: Border.all(
                    color: MyColor.transparentColor,
                    width: 0.6,
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 150.w,
                          height: 150.w,
                          child: Lottie.asset(
                            type == OvoDialogTypeType.error
                                ? MyIcons.errorLottieIcon
                                : type == OvoDialogTypeType.warning
                                    ? MyIcons.warningLottieIcon
                                    : type == OvoDialogTypeType.success
                                        ? MyIcons.successLottieIcon
                                        : MyIcons.warningLottieIcon,
                            repeat: false,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.contain,
                            width: 150.w,
                            height: 150.w,
                          ),
                        ),
                        spaceDown(Dimensions.space30),
                        HeaderText(
                          text: title,
                          textStyle: MyTextStyle.headerH3.copyWith(
                            color: MyColor.getDarkColor(),
                          ),
                        ),
                        spaceDown(Dimensions.space4),
                        HeaderTextSmaller(
                          text: subTitle,
                          textAlign: TextAlign.center,
                          textStyle: MyTextStyle.sectionBodyTextStyle.copyWith(
                            color: MyColor.getBodyTextColor(),
                          ),
                        ),
                        spaceDown(Dimensions.space30),
                        CustomElevatedBtn(
                          radius: Dimensions.largeRadius.r,
                          bgColor: MyColor.getPrimaryColor(),
                          text: buttonTitle.tr,
                          onTap: onTap,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Future confirmDialogForAll(
    BuildContext context, {
    String? title,
    String? subTitle,
    String buttonTitle = MyStrings.yes,
    required VoidCallback onConfirmTap,
    bool isConfirmLoading = false,
    VoidCallback? onCancelTap,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
      builder: (_) {
        return Dialog(
          surfaceTintColor: MyColor.transparentColor,
          insetPadding: EdgeInsets.all(Dimensions.space16.w),
          backgroundColor: MyColor.transparentColor,
          insetAnimationCurve: Curves.fastOutSlowIn,
          insetAnimationDuration: const Duration(milliseconds: 100),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return Container(
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: Dimensions.space32.w,
                  horizontal: Dimensions.space16.w,
                ),
                decoration: BoxDecoration(
                  color: MyColor.getWhiteColor(),
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                  border: Border.all(
                    color: MyColor.transparentColor,
                    width: 0.6,
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: Dimensions.space60.w,
                          height: Dimensions.space60.w,
                          child: Lottie.asset(
                            MyIcons.warningLottieIcon,
                            repeat: false,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.contain,
                            width: Dimensions.space60.w,
                            height: Dimensions.space60.w,
                          ),
                        ),
                        spaceDown(Dimensions.space10),
                        HeaderText(
                          text: title ?? MyStrings.pleaseConfirm.tr,
                          textStyle: MyTextStyle.headerH3.copyWith(
                            color: MyColor.getDarkColor(),
                          ),
                        ),
                        spaceDown(Dimensions.space4),
                        HeaderTextSmaller(
                          text: subTitle ?? MyStrings.sureToDoThis.tr,
                          textAlign: TextAlign.center,
                          textStyle: MyTextStyle.sectionBodyTextStyle.copyWith(
                            color: MyColor.getBodyTextColor(),
                          ),
                        ),
                        spaceDown(Dimensions.space30),
                        Row(
                          children: [
                            Expanded(
                              child: CustomElevatedBtn(
                                radius: Dimensions.largeRadius.r,
                                bgColor: MyColor.getWhiteColor(),
                                borderColor: MyColor.getBodyTextColor(),
                                textColor: MyColor.getBodyTextColor(),
                                text: MyStrings.cancel,
                                onTap: () {
                                  if (onCancelTap == null) {
                                    Navigator.of(context).maybePop();
                                  } else {
                                    onCancelTap();
                                  }
                                },
                              ),
                            ),
                            spaceSide(Dimensions.space10),
                            Expanded(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return CustomElevatedBtn(
                                    isLoading: isConfirmLoading,
                                    radius: Dimensions.largeRadius.r,
                                    bgColor: MyColor.getPrimaryColor(),
                                    text: buttonTitle.tr,
                                    onTap: () {
                                      setState(() {
                                        isConfirmLoading = true;
                                        onConfirmTap();
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
