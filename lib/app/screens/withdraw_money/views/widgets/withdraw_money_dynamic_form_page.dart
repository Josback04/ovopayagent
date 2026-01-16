import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopayagent/app/components/card/amount_details_card.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/app/components/card/custom_contact_list_tile_card.dart';
import 'package:ovopayagent/app/components/custom_loader/custom_loader.dart';
import 'package:ovopayagent/app/components/image/my_network_image_widget.dart';
import 'package:ovopayagent/app/components/text/header_text_smaller.dart';
import 'package:ovopayagent/app/screens/global/controller/global_dynamic_form_controller.dart';
import 'package:ovopayagent/app/screens/global/views/dynamic_form_widget_view.dart';
import 'package:ovopayagent/app/screens/withdraw_money/controller/withdraw_money_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/util_exporter.dart';

class WithdrawMoneyDynamicFormPage extends StatefulWidget {
  const WithdrawMoneyDynamicFormPage({
    super.key,
    required this.context,
    required this.onSuccessCallback,
  });
  final VoidCallback onSuccessCallback;

  final BuildContext context;

  @override
  State<WithdrawMoneyDynamicFormPage> createState() => _WithdrawMoneyDynamicFormPageState();
}

class _WithdrawMoneyDynamicFormPageState extends State<WithdrawMoneyDynamicFormPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawMoneyController>(
      builder: (withdrawMoneyController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              if (withdrawMoneyController.selectedWithdrawMoneyMethod != null) ...[
                CustomAppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactTile(
                        withdrawMoneyController,
                        padding: EdgeInsetsDirectional.only(
                          bottom: Dimensions.space10,
                        ),
                      ),
                      spaceDown(Dimensions.space16),
                      _buildAmountDetailsCard(withdrawMoneyController),
                    ],
                  ),
                ),
              ],
              spaceDown(Dimensions.space16),
              CustomAppCard(
                width: double.infinity,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderTextSmaller(
                        textAlign: TextAlign.center,
                        text: "${MyStrings.withdrawInformation.tr} ",
                      ),
                      spaceDown(Dimensions.space24),
                      HtmlWidget(
                        withdrawMoneyController.selectedWithdrawMoneyMethod?.description ?? "",
                        textStyle: MyTextStyle.bodyTextStyle1.copyWith(
                          color: MyColor.getBodyTextColor(),
                        ),
                        onLoadingBuilder: (context, element, loadingProgress) => const Center(child: CustomLoader()),
                      ),
                      spaceDown(Dimensions.space24),
                      if (withdrawMoneyController.selectedWithdrawMoneyMethod != null) ...[
                        DynamicFormWidgetView(
                          formList: withdrawMoneyController.withdrawRequestResponseModelData?.data?.form?.list ?? [],
                          autoFillDataList: withdrawMoneyController.selectedAccountDynamicFormAutofillData ?? [],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              spaceDown(Dimensions.space15),
              AppMainSubmitButton(
                text: MyStrings.continueText,
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Get.find<GlobalDynamicFormController>().submitFormDataData(
                      widget.onSuccessCallback,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
}
