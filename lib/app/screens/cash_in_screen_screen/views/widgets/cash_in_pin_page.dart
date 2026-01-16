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
import 'package:ovopayagent/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopayagent/app/components/text-field/rounded_text_field.dart';
import 'package:ovopayagent/app/screens/cash_in_screen_screen/controller/cash_in_controller.dart';

import '../../../../../core/data/services/service_exporter.dart';
import '../../../../../core/utils/util_exporter.dart';

class CashInPinVerificationPage extends StatelessWidget {
  const CashInPinVerificationPage({super.key, required this.context});

  final BuildContext context;

  // Reusable Contact List Tile
  Widget _buildContactTile(
    CashInController controller, {
    bool showBorder = true,
    EdgeInsetsGeometry? padding,
  }) {
    return CustomContactListTileCard(
      leading: MyNetworkImageWidget(
        width: Dimensions.space40.w,
        height: Dimensions.space40.w,
        isProfile: true,
        imageUrl: '${controller.existUserModel?.getUserImageUrl()}',
        imageAlt: '${controller.existUserModel?.getFullName()}',
      ),
      padding: padding ?? EdgeInsetsDirectional.zero,
      imagePath: controller.existUserModel?.getUserImageUrl(),
      title: controller.existUserModel?.getFullName(),
      subtitle: "+${controller.existUserModel?.getUserMobileNo(withCountryCode: true)}",
      showBorder: showBorder,
    );
  }

  // Reusable Amount Details Card
  Widget _buildAmountDetailsCard(CashInController controller) {
    return AmountDetailsCard(
      amount: MyUtils.getUserAmount(controller.mainAmount.toString()),
      charge: '+${MyUtils.getUserAmount(controller.totalCharge.toString())}',
      total: MyUtils.getUserAmount(controller.payableAmountText.toString()),
    );
  }

  // Reusable Confirm Dialog
  Future<void> _showConfirmDialog(CashInController controller) async {
    MyUtils.clearAllTypeFocusNodes();
    if (controller.pinController.text.toString().length < SharedPreferenceService.getMaxPinNumberDigit()) {
      CustomSnackBar.error(errorList: [MyStrings.kPinMaxNumberError.tr]);
      return;
    }
    await AppDialogs.confirmDialog(
      context,
      title: MyStrings.cashIn,
      userDetailsWidget: CustomAppCard(
        radius: Dimensions.largeRadius.r,
        child: _buildContactTile(controller, showBorder: false),
      ),
      cashDetailsWidget: CustomAppCard(
        radius: Dimensions.largeRadius.r,
        child: _buildAmountDetailsCard(controller),
      ),
      onFinish: () async {
        await controller.submitThisProcess(
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
                      body: value.data?.cashIn?.trx ?? "",
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
    return GetBuilder<CashInController>(
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
              spaceDown(Dimensions.space16),
              RoundedTextField(
                showLabelText: false,
                controller: controller.pinController,
                forceShowSuffixDesign: true,
                labelText: MyStrings.pin,
                hintText: MyStrings.enterYourPinCode,
                fillColor: MyColor.getWhiteColor(),
                isPassword: true,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
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
