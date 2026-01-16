import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopayagent/app/components/card/amount_details_card.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/app/components/card/custom_contact_list_tile_card.dart';
import 'package:ovopayagent/app/components/column_widget/card_column.dart';
import 'package:ovopayagent/app/components/dialog/app_dialog.dart';
import 'package:ovopayagent/app/components/image/my_asset_widget.dart';
import 'package:ovopayagent/app/components/image/my_network_image_widget.dart';
import 'package:ovopayagent/app/components/otp_field_widget/otp_field_widget.dart';
import 'package:ovopayagent/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopayagent/app/components/text-field/rounded_text_field.dart';
import 'package:ovopayagent/app/components/text/header_text.dart';
import 'package:ovopayagent/app/screens/global/controller/global_dynamic_form_controller.dart';
import 'package:ovopayagent/app/screens/withdraw_money/controller/withdraw_money_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/data/services/service_exporter.dart';
import '../../../../../core/utils/util_exporter.dart';

class WithdrawMoneyPinVerificationPage extends StatelessWidget {
  const WithdrawMoneyPinVerificationPage({super.key, required this.context});

  final BuildContext context;

  // Reusable Contact List Tile
  Widget _buildContactTile(
    WithdrawMoneyController controller, {
    bool showBorder = true,
    EdgeInsetsGeometry? padding,
  }) {
    return CustomContactListTileCard(
      leading: Skeleton.replace(
        replace: true,
        replacement: Bone.square(size: Dimensions.space48.h),
        child: MyNetworkImageWidget(
          radius: Dimensions.radiusMax.r,
          imageUrl: "${controller.selectedWithdrawMoneyMethod?.getImageUrl()}",
          isProfile: true,
          width: Dimensions.space48.w,
          height: Dimensions.space48.w,
          imageAlt: controller.selectedWithdrawMoneyMethod?.name ?? "",
        ),
      ),
      padding: padding ?? EdgeInsetsDirectional.zero,
      title: controller.selectedWithdrawMoneyMethod?.name ?? "",
      subtitle: controller.selectedWithdrawMoneyMethod?.currency ?? "",
      showBorder: showBorder,
    );
  }

  // Reusable Amount Details Card
  Widget _buildAmountDetailsCard(WithdrawMoneyController controller) {
    return AmountDetailsCard(
      amount: MyUtils.getUserAmount(controller.mainAmount.toString()),
      amountBody: '-${MyUtils.getUserAmount(controller.charge.toString())}',
      total: MyUtils.getUserAmount(controller.receivable.toString()),
      totalBody: "${controller.selectedWithdrawMoneyMethod?.currency ?? ""} ${MyUtils.getUserAmount(controller.inMethodReceivable.toString(), showOnlyAmount: true)}",
    );
  }

  // Reusable Confirm Dialog
  Future<void> _showConfirmDialog(WithdrawMoneyController controller) async {
    if (controller.pinController.text.toString().length < SharedPreferenceService.getMaxPinNumberDigit()) {
      CustomSnackBar.error(errorList: [MyStrings.kPinMaxNumberError.tr]);
      return;
    } else if (controller.isNeedTwoFactorAuthentication == "true" && controller.current2faText.trim().length != 6) {
      CustomSnackBar.error(
        errorList: [(MyStrings.googleAuthenticatorCodeRequired.tr)],
      );
      return;
    }
    await AppDialogs.confirmDialog(
      context,
      title: MyStrings.withdraw,
      userDetailsWidget: CustomAppCard(
        radius: Dimensions.largeRadius.r,
        child: _buildContactTile(controller, showBorder: false),
      ),
      cashDetailsWidget: CustomAppCard(
        radius: Dimensions.largeRadius.r,
        child: _buildAmountDetailsCard(controller),
      ),
      onFinish: () async {
        GlobalDynamicFormController dynamicFormController = Get.find();
        await controller.submitThisProcess(
          dynamicFormList: dynamicFormController.formList,
          onSuccessCallback: (value) async {
            // Handle the completed progress here
            Navigator.pop(context);
            await AppDialogs.successDialog(
              context,
              title: value.message?.first ?? "",
              userDetailsWidget: CustomAppCard(
                radius: Dimensions.largeRadius.r,
                child: _buildContactTile(controller, showBorder: false),
              ),
              cashDetailsWidget: CustomAppCard(
                radius: Dimensions.largeRadius.r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAmountDetailsCard(controller),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: MyColor.getBorderColor(),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    CardColumn(
                      headerTextStyle: MyTextStyle.caption1Style.copyWith(
                        color: MyColor.getBodyTextColor(),
                      ),
                      header: MyStrings.transactionId.tr,
                      isCopyable: true,
                      body: value.data?.withdraw?.trx ?? "",
                      space: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawMoneyController>(
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactTile(
                      controller,
                      padding: EdgeInsetsDirectional.only(
                        bottom: Dimensions.space10,
                      ),
                    ),
                    spaceDown(Dimensions.space16),
                    _buildAmountDetailsCard(controller),
                  ],
                ),
              ),
              if (controller.isNeedTwoFactorAuthentication == "true") ...[
                spaceDown(Dimensions.space15),
                //Code Verification
                CustomAppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: HeaderText(
                          textAlign: TextAlign.center,
                          text: MyStrings.verify2Fa.tr,
                          textStyle: MyTextStyle.headerH3.copyWith(
                            color: MyColor.getHeaderTextColor(),
                          ),
                        ),
                      ),
                      spaceDown(Dimensions.space8),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: HeaderText(
                          textAlign: TextAlign.center,
                          text: MyStrings.twoFactorMsg.tr,
                          textStyle: MyTextStyle.sectionSubTitle1,
                        ),
                      ),
                      spaceDown(Dimensions.space35),
                      OTPFieldWidget(onChanged: controller.onOtpBoxValueChange),
                      spaceDown(Dimensions.space10),
                    ],
                  ),
                ),
              ],
              spaceDown(Dimensions.space16),
              RoundedTextField(
                showLabelText: false,
                controller: controller.pinController,
                labelText: MyStrings.pin,
                hintText: MyStrings.enterYourPinCode,
                fillColor: MyColor.getWhiteColor(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                isPassword: true,
                forceShowSuffixDesign: true,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                    SharedPreferenceService.getMaxPinNumberDigit(),
                  ),
                ],
                prefixIcon: Container(
                  margin: const EdgeInsetsDirectional.only(
                    start: Dimensions.space15,
                    end: Dimensions.space8,
                  ),
                  child: MyAssetImageWidget(
                    color: MyColor.getPrimaryColor(),
                    width: 22.sp,
                    height: 16.sp,
                    boxFit: BoxFit.contain,
                    assetPath: MyIcons.lock,
                    isSvg: true,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () => _showConfirmDialog(controller),
                  icon: MyAssetImageWidget(
                    color: MyColor.getPrimaryColor(),
                    width: 20.sp,
                    height: 20.sp,
                    boxFit: BoxFit.contain,
                    assetPath: MyIcons.arrowForward,
                    isSvg: true,
                  ),
                ),
              ),
              spaceDown(Dimensions.space15),
              AppMainSubmitButton(
                text: MyStrings.confirm,
                onTap: () {
                  _showConfirmDialog(controller);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
