import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:ovopayagent/app/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:ovopayagent/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/app/components/card/custom_company_list_tile_card.dart';
import 'package:ovopayagent/app/components/card/custom_list_tile_card.dart';
import 'package:ovopayagent/app/components/card/my_custom_scaffold.dart';
import 'package:ovopayagent/app/components/image/my_asset_widget.dart';
import 'package:ovopayagent/app/components/image/my_network_image_widget.dart';
import 'package:ovopayagent/app/components/no_data.dart';
import 'package:ovopayagent/app/screens/withdraw_money/controller/withdraw_money_controller.dart';
import 'package:ovopayagent/app/screens/withdraw_money/views/widgets/withdraw_money_amount_page.dart';
import 'package:ovopayagent/app/screens/withdraw_money/views/widgets/withdraw_money_dynamic_form_page.dart';
import 'package:ovopayagent/app/screens/withdraw_money/views/widgets/withdraw_money_pin_page.dart';
import 'package:ovopayagent/core/data/models/withdraw/withdraw_methods_list_model.dart';
import 'package:ovopayagent/core/data/repositories/withdraw_money/withdraw_money_repo.dart';
import 'package:ovopayagent/core/route/route.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/util_exporter.dart';

class WithdrawMoneyScreen extends StatefulWidget {
  const WithdrawMoneyScreen({super.key});

  @override
  State<WithdrawMoneyScreen> createState() => _WithdrawMoneyScreenState();
}

class _WithdrawMoneyScreenState extends State<WithdrawMoneyScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Get.put(WithdrawMoneyRepo());
    final controller = Get.put(
      WithdrawMoneyController(withdrawMoneyRepo: Get.find()),
    );
    // Add listener to track page changes
    _pageController.addListener(_pageChangeListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getWithdrawMethod();
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
      pageTitle: MyStrings.withdraw,
      onBackButtonTap: () {
        if (_currentPage != 0) {
          _previousPage();
        } else {
          Get.back();
        }
      },
      actionButton: [
        CustomAppCard(
          onPressed: () {
            Get.toNamed(RouteHelper.withdrawMoneyHistoryScreen);
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
          _buildPaymentGatewayPage(),
          WithdrawMoneyAmountPage(
            context: context,
            onPaymentGatewayClick: () {
              _previousPage(goToPage: 0);
            },
            nextStep: () {
              _nextPage(goToPage: 2);
            },
          ),
          WithdrawMoneyDynamicFormPage(
            context: context,
            onSuccessCallback: () {
              _nextPage(goToPage: 3);
            },
          ),
          WithdrawMoneyPinVerificationPage(context: context),
        ],
      ),
    );
  }

  //Payment gateway Widget
  Widget _buildPaymentGatewayPage() {
    return GetBuilder<WithdrawMoneyController>(
      builder: (controller) {
        return Skeletonizer(
          enabled: controller.isLoading,
          child: controller.isLoading
              ? ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return CustomAppCard(
                      margin: EdgeInsetsDirectional.symmetric(
                        vertical: Dimensions.space4.h,
                      ),
                      radius: Dimensions.largeRadius.r,
                      child: CustomListTileCard(
                        imagePath: "",
                        title: "-----------------",
                        showBorder: false,
                      ),
                      onPressed: () {},
                    );
                  },
                )
              : controller.methodList.isEmpty
                  ? NoDataWidget(text: MyStrings.noWithdrawMethodToShow.tr)
                  : RefreshIndicator(
                      color: MyColor.getPrimaryColor(),
                      onRefresh: () async {
                        controller.getWithdrawMethod();
                      },
                      child: ListView.builder(
                        itemCount: controller.methodList.length,
                        itemBuilder: (context, index) {
                          var item = controller.methodList[index];
                          return CustomAppCard(
                            margin: EdgeInsetsDirectional.symmetric(
                              vertical: Dimensions.space4.h,
                            ),
                            radius: Dimensions.largeRadius.r,
                            child: CustomListTileCard(
                              imagePath: "${item.getImageUrl()}",
                              title: "${item.name}",
                              subtitle: item.saveAccounts?.isEmpty == true ? null : "${item.saveAccounts?.length ?? "0"} ${MyStrings.savedAccount.tr}",
                              showBorder: false,
                              subtitleStyle: MyTextStyle.sectionSubTitle1.copyWith(color: MyColor.getBodyTextColor()),
                            ),
                            onPressed: () {
                              if (controller.methodList[index].id != -1) {
                                // controller.selectedPaymentMethodController.text = controller.methodList[index].name ?? '';
                                // controller.setPaymentMethod(controller.methodList[index]);
                                // _nextPage(goToPage: 1);

                                controller.selectedPaymentMethodController.text = controller.methodList[index].name ?? '';
                                controller.setPaymentMethod(
                                  controller.methodList[index],
                                );
                                // billPayController.selectedUtilityCompanyOnTap(item);
                                // billPayController.selectedUtilityCompanyAutofillDataOnTap([]);
                                CustomBottomSheetPlus(
                                  child: SafeArea(
                                    child: buildSaveAccountAddBottomSheet(
                                      method: item,
                                      onWithdrawButtonClick: () {
                                        controller.selectedPaymentMethodController.text = controller.methodList[index].name ?? '';
                                        controller.setPaymentMethod(
                                          controller.methodList[index],
                                        );
                                        _nextPage(goToPage: 1);
                                      },
                                    ),
                                  ),
                                ).show(context);
                              }
                            },
                          );
                        },
                      ),
                    ),
        );
      },
    );
  }

  Widget buildSaveAccountAddBottomSheet({
    required WithdrawMethod method,
    required VoidCallback onWithdrawButtonClick,
  }) {
    return PopScope(
      canPop: true,
      child: GetBuilder<WithdrawMoneyController>(
        builder: (controller) {
          var selectedMethod = controller.methodList.firstWhereOrNull(
            (value) => value.id == method.id,
          );
          var dataList = selectedMethod?.saveAccounts ?? [];
          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              maxHeight: ScreenUtil().screenHeight / 1.2,
            ),
            child: Column(
              children: [
                BottomSheetHeaderRow(header: MyStrings.selectSavedAccount),
                spaceDown(Dimensions.space10),
                CustomCompanyListTileCard(
                  padding: EdgeInsetsDirectional.symmetric(
                    vertical: Dimensions.space10.w,
                    horizontal: Dimensions.space10.w,
                  ),
                  leading: CustomAppCard(
                    width: Dimensions.space45.w,
                    height: Dimensions.space45.w,
                    radius: Dimensions.largeRadius.r,
                    padding: EdgeInsetsDirectional.zero,
                    child: MyNetworkImageWidget(
                      radius: Dimensions.largeRadius.r,
                      boxFit: BoxFit.scaleDown,
                      imageUrl: method.getImageUrl() ?? "",
                      isProfile: false,
                      width: Dimensions.space40.w,
                      height: Dimensions.space40.w,
                    ),
                  ),
                  showBorder: false,
                  imagePath: method.getImageUrl() ?? "",
                  title: "${method.name}",
                ),
                spaceDown(Dimensions.space10),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: MyColor.getBorderColor(),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
                spaceDown(Dimensions.space10),
                if (dataList.isNotEmpty) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(dataList.length, (index) {
                          var item = dataList[index];
                          bool isLastIndex = index == dataList.length - 1;
                          return CustomListTileCard(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.space20.h,
                              horizontal: Dimensions.space20.w,
                            ),
                            leading: CustomAppCard(
                              width: Dimensions.space40.w,
                              height: Dimensions.space40.w,
                              radius: Dimensions.largeRadius.r,
                              padding: EdgeInsetsDirectional.all(
                                Dimensions.space4.w,
                              ),
                              child: MyNetworkImageWidget(
                                boxFit: BoxFit.scaleDown,
                                imageUrl: method.getImageUrl() ?? "",
                                isProfile: false,
                                radius: Dimensions.largeRadius.r,
                                width: Dimensions.space30.w,
                                height: Dimensions.space30.w,
                              ),
                            ),
                            subtitleStyle: MyTextStyle.sectionSubTitle1.copyWith(color: MyColor.getBodyTextColor()),
                            imagePath: "",
                            title: item.name ?? "",
                            // subtitle: (item.name ?? ""),
                            showBorder: !isLastIndex,
                            trailing: IntrinsicWidth(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.setUniqueID(item.name ?? "");
                                      controller.selectedAccountDynamicFormAutofillDataOnTap(
                                        item.data ?? [],
                                      );
                                      Get.toNamed(
                                        RouteHelper.withdrawMoneyEditAccountScreen,
                                        arguments: item.id?.toString(),
                                      )?.then((v) {
                                        controller.getWithdrawMethod(
                                          forceLoad: false,
                                        );
                                      });
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: MyColor.getPrimaryColor(),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (controller.isDeleteSaveAccountIDLoading == "-1") {
                                        controller.deleteSavedAccount(
                                          accountID: item.id?.toString() ?? "",
                                        );
                                      }
                                    },
                                    icon: (controller.isDeleteSaveAccountIDLoading == item.id?.toString())
                                        ? SizedBox(
                                            width: Dimensions.space20.w,
                                            height: Dimensions.space20.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: MyColor.getPrimaryColor(),
                                            ),
                                          )
                                        : Icon(
                                            Icons.close,
                                            color: MyColor.redLightColor,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              controller.selectedAccountDynamicFormAutofillDataOnTap(
                                item.data ?? [],
                              );
                              onWithdrawButtonClick();
                              Get.back();
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.space10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.link,
                            color: MyColor.getPrimaryColor(),
                            size: Dimensions.space30.w,
                          ),
                          spaceSide(Dimensions.space10),
                          Expanded(
                            child: Text(
                              MyStrings.addWithdrawAccountMsg.tr,
                              style: MyTextStyle.sectionSubTitle1.copyWith(
                                color: MyColor.getBodyTextColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                spaceDown(Dimensions.space20),
                CustomElevatedBtn(
                  radius: Dimensions.largeRadius.r,
                  borderColor: MyColor.getPrimaryColor(),
                  bgColor: MyColor.getWhiteColor(),
                  textColor: MyColor.getPrimaryColor(),
                  text: MyStrings.withdrawNow,
                  icon: Icon(
                    Icons.account_balance,
                    color: MyColor.getPrimaryColor(),
                  ),
                  onTap: () {
                    controller.selectedAccountDynamicFormAutofillDataOnTap([]);
                    onWithdrawButtonClick();
                    Get.back();
                  },
                ),
                spaceDown(Dimensions.space10),
                CustomElevatedBtn(
                  radius: Dimensions.largeRadius.r,
                  bgColor: MyColor.getPrimaryColor(),
                  text: MyStrings.addAccount,
                  icon: Icon(Icons.add, color: MyColor.getWhiteColor()),
                  onTap: () {
                    Get.toNamed(
                      RouteHelper.withdrawMoneyAddNewAccountScreen,
                    )?.then((v) {
                      controller.getWithdrawMethod(forceLoad: false);
                    });
                  },
                ),
                spaceDown(Dimensions.space20),
              ],
            ),
          );
        },
      ),
    );
  }
}
