import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/app/components/card/custom_contact_list_tile_card.dart';
import 'package:ovopayagent/app/components/chip/custom_chip.dart';
import 'package:ovopayagent/app/components/image/my_network_image_widget.dart';
import 'package:ovopayagent/app/components/text-field/rounded_text_field.dart';
import 'package:ovopayagent/app/components/text/header_text.dart';
import 'package:ovopayagent/app/screens/withdraw_money/controller/withdraw_money_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/util_exporter.dart';

class WithdrawMoneyAmountPage extends StatefulWidget {
  const WithdrawMoneyAmountPage({
    super.key,
    required this.context,
    required this.onPaymentGatewayClick,
    required this.nextStep,
  });

  final BuildContext context;
  final Function() onPaymentGatewayClick;
  final Function() nextStep;

  @override
  State<WithdrawMoneyAmountPage> createState() => _WithdrawMoneyAmountPageState();
}

class _WithdrawMoneyAmountPageState extends State<WithdrawMoneyAmountPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawMoneyController>(
      builder: (withdrawMoneyController) {
        return SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomAppCard(
                  onPressed: () {
                    widget.onPaymentGatewayClick();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomContactListTileCard(
                        leading: Skeleton.replace(
                          replace: true,
                          replacement: Bone.square(size: Dimensions.space48.h),
                          child: MyNetworkImageWidget(
                            radius: Dimensions.radiusMax.r,
                            imageUrl: "${withdrawMoneyController.selectedWithdrawMoneyMethod?.getImageUrl()}",
                            isProfile: true,
                            width: Dimensions.space48.w,
                            height: Dimensions.space48.w,
                            imageAlt: withdrawMoneyController.selectedWithdrawMoneyMethod?.name ?? "",
                          ),
                        ),
                        padding: EdgeInsetsDirectional.zero,
                        title: withdrawMoneyController.selectedWithdrawMoneyMethod?.name ?? "",
                        subtitle: withdrawMoneyController.selectedWithdrawMoneyMethod?.currency ?? "",
                        showBorder: false,
                      ),
                    ],
                  ),
                ),
                spaceDown(Dimensions.space16),
                CustomAppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: MyStrings.enterAmount.tr,
                        textStyle: MyTextStyle.headerH3.copyWith(
                          color: MyColor.getHeaderTextColor(),
                        ),
                      ),
                      spaceDown(Dimensions.space24),
                      RoundedTextField(
                        controller: withdrawMoneyController.amountController,
                        showLabelText: false,
                        labelText: MyStrings.enterAmount.tr,
                        hintText: '${MyStrings.available.tr}: ${withdrawMoneyController.userCurrentBalance}',
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textStyle: MyTextStyle.headerH3.copyWith(
                          color: MyColor.getHeaderTextColor(),
                        ),
                        focusBorderColor: MyColor.getPrimaryColor(),
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9.]'),
                          ), // Allows digits and a decimal point
                          FilteringTextInputFormatter.deny(
                            RegExp(r'(\.\d{30,})'),
                          ), // Limits decimal places (optional, adjust as needed)
                        ],
                        onChanged: (value) {
                          withdrawMoneyController.onChangeAmountControllerText(
                            value,
                          );
                        },
                        validator: (value) {
                          return MyUtils().validateAmountForm(
                            value: value ?? '0',
                            userCurrentBalance: 0,
                            showCurrentBalance: false,
                            minLimit: AppConverter.formatNumberDouble(
                              withdrawMoneyController.selectedWithdrawMoneyMethod?.minLimit ?? "0",
                            ),
                            maxLimit: AppConverter.formatNumberDouble(
                              withdrawMoneyController.selectedWithdrawMoneyMethod?.maxLimit ?? "0",
                            ),
                          );
                        },
                      ),
                      spaceDown(Dimensions.space8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${MyStrings.limit.tr}: ",
                              style: MyTextStyle.sectionBodyTextStyle.copyWith(
                                color: MyColor.getBodyTextColor(),
                              ),
                            ),
                            TextSpan(
                              text: withdrawMoneyController.withdrawLimit,
                              style: MyTextStyle.sectionBodyBoldTextStyle.copyWith(color: MyColor.getPrimaryColor()),
                            ),
                          ],
                        ),
                      ),
                      spaceDown(Dimensions.space24),
                      SingleChildScrollView(
                        clipBehavior: Clip.hardEdge,
                        scrollDirection: Axis.horizontal, // Allows horizontal scrolling
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: MyUtils()
                              .quickMoneyStringList(
                            AppConverter.formatNumberDouble(
                              withdrawMoneyController.selectedWithdrawMoneyMethod?.minLimit ?? "0",
                            ),
                            AppConverter.formatNumberDouble(
                              withdrawMoneyController.selectedWithdrawMoneyMethod?.maxLimit ?? "0",
                            ),
                          )
                              .map((value) {
                            return CustomAppChip(
                              isSelected: value == withdrawMoneyController.getAmount ? true : false,
                              text: value,
                              onTap: () {
                                withdrawMoneyController.onChangeAmountControllerText(
                                  value,
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                spaceDown(Dimensions.space15),
                AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 300,
                  ), // Duration for animation
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: withdrawMoneyController.mainAmount > 0
                      ? Column(
                          key: ValueKey(
                            'visibleWidget',
                          ), // Key to differentiate between states
                          children: [
                            buildChargeInfoWidget(withdrawMoneyController),
                            spaceDown(Dimensions.space15),
                          ],
                        )
                      : SizedBox(
                          key: ValueKey('hiddenWidget'),
                        ), // Empty widget when hidden
                ),
                AppMainSubmitButton(
                  isActive: withdrawMoneyController.amountController.text.trim().isNotEmpty,
                  text: MyStrings.continueText,
                  isLoading: withdrawMoneyController.isWithdrawRequestLoading,
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      withdrawMoneyController.withdrawRequest(
                        onSuccessCallback: () {
                          widget.nextStep();
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Charge Calculator
  Widget buildChargeInfoWidget(WithdrawMoneyController addMoneyController) {
    return CustomAppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildChargeRow(
            firstText: MyStrings.amount.tr,
            lastText: "${AppConverter.formatNumber(addMoneyController.mainAmount.toString(), precision: 2)} ${addMoneyController.currency}",
          ),
          buildChargeRow(
            firstText: MyStrings.charge.tr,
            lastText: "${addMoneyController.charge} ${addMoneyController.currency}",
          ),
          buildChargeRow(
            firstText: MyStrings.receivable,
            lastText: addMoneyController.receivableText,
          ),
          if (addMoneyController.currency.toLowerCase() != (addMoneyController.selectedWithdrawMoneyMethod?.currency ?? "").toLowerCase()) ...[
            buildChargeRow(
              firstText: MyStrings.conversionRate.tr,
              lastText: addMoneyController.conversionRate,
            ),
            buildChargeRow(
              firstText: "${MyStrings.in_.tr} ${addMoneyController.selectedWithdrawMoneyMethod?.currency ?? ""}",
              lastText: addMoneyController.inMethodReceivable,
            ),
          ],
        ],
      ),
    );
  }

  Widget buildChargeRow({required String firstText, required String lastText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.space5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              firstText.tr,
              style: MyTextStyle.sectionTitle3.copyWith(
                color: MyColor.getHeaderTextColor(),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Flexible(
            child: Text(
              lastText.tr,
              maxLines: 2,
              style: MyTextStyle.sectionTitle3.copyWith(
                color: MyColor.getBodyTextColor(),
                fontWeight: FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
