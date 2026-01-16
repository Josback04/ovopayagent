import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/app/components/card/custom_contact_list_tile_card.dart';
import 'package:ovopayagent/app/components/card/my_custom_scaffold.dart';
import 'package:ovopayagent/app/components/image/my_asset_widget.dart';
import 'package:ovopayagent/app/components/image/my_network_image_widget.dart';
import 'package:ovopayagent/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopayagent/app/components/text/header_text.dart';
import 'package:ovopayagent/app/components/text-field/rounded_text_field.dart';
import 'package:ovopayagent/app/screens/cash_in_screen_screen/controller/cash_in_controller.dart';
import 'package:ovopayagent/app/screens/cash_in_screen_screen/views/widgets/cash_in_amount_page.dart';
import 'package:ovopayagent/app/screens/cash_in_screen_screen/views/widgets/cash_in_pin_page.dart';
import 'package:ovopayagent/core/data/models/global/qr_code/scan_qr_code_response_model.dart';
import 'package:ovopayagent/core/data/models/user/user_model.dart';
import 'package:ovopayagent/core/data/repositories/modules/cash_in/cash_in_repo.dart';
import 'package:ovopayagent/core/route/route.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/util_exporter.dart';

class CashInScreen extends StatefulWidget {
  const CashInScreen({super.key, this.toUserInformation});
  final UserModel? toUserInformation;
  @override
  State<CashInScreen> createState() => _CashInScreenState();
}

class _CashInScreenState extends State<CashInScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    Get.put(CashInRepo());
    final controller = Get.put(CashInController(cashInRepo: Get.find()));

    super.initState();
    // Add listener to track page changes
    _pageController.addListener(_pageChangeListener);

    WidgetsBinding.instance.addPostFrameCallback((v) async {
      await controller.initController();
      if (widget.toUserInformation != null) {
        controller.setAgentFromQrScan(() {
          _nextPage(goToPage: 1);
        }, userModel: widget.toUserInformation);
      }
    });
  }

  void _pageChangeListener() {
    int newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
      });
    }
  }

  @override
  void dispose() {
    // Remove listener when the widget is disposed to avoid memory leaks
    _pageController.removeListener(_pageChangeListener);
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage({int? goToPage}) {
    setState(() {
      _pageController.animateToPage(
        goToPage ?? ++_currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  void _previousPage({int? goToPage}) {
    setState(() {
      _pageController.animateToPage(
        goToPage ?? --_currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      pageTitle: MyStrings.cashIn,
      onBackButtonTap: () {
        if (_currentPage != 0) {
          _previousPage();
        } else {
          Get.back();
        }
      },
      actionButton: [
        if (_currentPage == 0)
          CustomAppCard(
            onPressed: () {
              Get.toNamed(RouteHelper.cashInHistoryScreen);
            },
            width: Dimensions.space40.w,
            height: Dimensions.space40.w,
            padding: EdgeInsetsDirectional.all(Dimensions.space8.w),
            radius: Dimensions.largeRadius.r,
            child: MyAssetImageWidget(
              isSvg: true,
              assetPath: MyIcons.historyIcon,
              width: Dimensions.space24.w,
              height: Dimensions.space24.w,
              color: MyColor.getPrimaryColor(),
            ),
          ),
        spaceSide(Dimensions.space16.w),
      ],
      body: PageView(
        clipBehavior: Clip.none,
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildContactSelectPage(),
          CashOutAmountPage(
            onSuccessCallback: () {
              _nextPage(goToPage: 2);
            },
            context: context,
          ),
          CashInPinVerificationPage(context: context),
        ],
      ),
    );
  }

  //Contact Select Widget
  Widget _buildContactSelectPage() {
    return GetBuilder<CashInController>(
      builder: (cashInController) {
        return SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            children: [
              Skeletonizer(
                enabled: cashInController.isPageLoading,
                child: Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.space16.h),
                  child: CustomAppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderText(
                          textAlign: TextAlign.center,
                          text: MyStrings.user.tr,
                          textStyle: MyTextStyle.sectionTitle.copyWith(
                            color: MyColor.getHeaderTextColor(),
                          ),
                        ),
                        spaceDown(Dimensions.space8),
                        RoundedTextField(
                          controller: cashInController.phoneNumberOrUserNameController,
                          showLabelText: false,
                          labelText: MyStrings.usernameOrPhoneHint.tr,
                          hintText: MyStrings.usernameOrPhoneHint.tr,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (v) {
                            cashInController.checkUserExist(() {
                              _nextPage(goToPage: 1);
                            });
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              cashInController.checkUserExist(() {
                                _nextPage(goToPage: 1);
                              });
                            },
                            icon: MyAssetImageWidget(
                              color: MyColor.getPrimaryColor(),
                              width: 20.sp,
                              height: 20.sp,
                              boxFit: BoxFit.contain,
                              assetPath: MyIcons.arrowForward,
                              isSvg: true,
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                        if (cashInController.latestCashInHistory.isNotEmpty) ...[
                          spaceDown(Dimensions.space16),
                          HeaderText(
                            text: MyStrings.recent.tr,
                            textStyle: MyTextStyle.sectionTitle2.copyWith(
                              color: MyColor.getHeaderTextColor(),
                            ),
                          ),
                          spaceDown(Dimensions.space8),
                          ...List.generate(
                            cashInController.latestCashInHistory.length,
                            (index) {
                              var item = cashInController.latestCashInHistory[index];
                              bool isLastIndex = index == cashInController.latestCashInHistory.length - 1;
                              return CustomContactListTileCard(
                                leading: MyNetworkImageWidget(
                                  width: Dimensions.space40.w,
                                  height: Dimensions.space40.w,
                                  radius: Dimensions.radiusProMax.r,
                                  isProfile: true,
                                  imageUrl: item.receiverUser?.getUserImageUrl() ?? "",
                                  imageAlt: item.receiverUser?.getFullName(),
                                ),
                                showBorder: !isLastIndex,
                                imagePath: item.receiverUser?.getUserImageUrl(),
                                title: item.receiverUser?.getFullName(),
                                subtitle: "+${item.receiverUser?.getUserMobileNo(withCountryCode: true)}",
                                onPressed: () {
                                  cashInController.checkUserExist(
                                    () {
                                      _nextPage(goToPage: 1);
                                    },
                                    inputUserNameOrPhone: item.receiverUser?.username ?? "",
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              CustomElevatedBtn(
                elevation: 0,
                radius: Dimensions.largeRadius.r,
                bgColor: MyColor.getWhiteColor(),
                textColor: MyColor.getPrimaryColor(),
                text: MyStrings.tapToScanQRcode.tr,
                borderColor: MyColor.getPrimaryColor(),
                shadowColor: MyColor.getWhiteColor(),
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.space7.h),
                  child: MyAssetImageWidget(
                    width: Dimensions.space40.w,
                    height: Dimensions.space40.w,
                    boxFit: BoxFit.contain,
                    assetPath: MyIcons.scanQrCodeIconIcon,
                    color: MyColor.getPrimaryColor(),
                    isSvg: true,
                  ),
                ),
                onTap: () async {
                  Get.toNamed(RouteHelper.scanQrCodeScreen)?.then((v) {
                    ScanQrCodeResponseModel scanQrCodeResponseModel = v as ScanQrCodeResponseModel;
                    if (scanQrCodeResponseModel.data?.userType != AppStatus.USER_TYPE_USER) {
                      CustomSnackBar.error(
                        errorList: [MyStrings.pleaseScanUserQRCode],
                      );
                      return;
                    }
                    Get.find<CashInController>().checkUserExist(
                      inputUserNameOrPhone: scanQrCodeResponseModel.data?.userData?.username ?? "",
                      () {
                        _nextPage(goToPage: 1);
                      },
                    );
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
