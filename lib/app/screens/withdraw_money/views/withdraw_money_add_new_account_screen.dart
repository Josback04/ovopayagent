import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopayagent/app/components/card/custom_card.dart';
import 'package:ovopayagent/app/components/card/my_custom_scaffold.dart';
import 'package:ovopayagent/app/components/text-field/rounded_text_field.dart';
import 'package:ovopayagent/app/components/text/header_text_smaller.dart';
import 'package:ovopayagent/app/screens/global/controller/global_dynamic_form_controller.dart';
import 'package:ovopayagent/app/screens/global/views/dynamic_form_widget_view.dart';
import 'package:ovopayagent/app/screens/withdraw_money/controller/withdraw_money_controller.dart';

import '../../../../../core/utils/util_exporter.dart';

class WithdrawMoneyAddAccountScreen extends StatefulWidget {
  const WithdrawMoneyAddAccountScreen({super.key});

  @override
  State<WithdrawMoneyAddAccountScreen> createState() => _WithdrawMoneyAddAccountScreenState();
}

class _WithdrawMoneyAddAccountScreenState extends State<WithdrawMoneyAddAccountScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      pageTitle: MyStrings.addAccount,
      body: GetBuilder<WithdrawMoneyController>(
        builder: (controller) {
          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                controller.clearSavedAccountData();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppCard(
                    width: double.infinity,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeaderTextSmaller(
                            textAlign: TextAlign.center,
                            text: "${MyStrings.accountInformation.tr} ",
                          ),
                          spaceDown(Dimensions.space24),
                          RoundedTextField(
                            isRequired: true,
                            controller: controller.uniqueIDController,
                            showLabelText: true,
                            labelText: MyStrings.uniqueID,
                            hintText: "",
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return MyStrings.fieldErrorMsg.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          spaceDown(Dimensions.space16),
                          DynamicFormWidgetView(
                            formList: controller.selectedWithdrawMoneyMethod == null ? controller.selectedWithdrawMoneyMethod?.form?.formData?.list ?? [] : controller.selectedWithdrawMoneyMethod?.form?.formData?.list ?? [],
                          ),
                        ],
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space15),
                  AppMainSubmitButton(
                    isLoading: controller.isSubmitSaveCompanyAccountLoading,
                    text: MyStrings.save,
                    onTap: () {
                      if (formKey.currentState?.validate() ?? false) {
                        GlobalDynamicFormController dynamicFormController = Get.find();
                        dynamicFormController.submitFormDataData(() {
                          controller.submitSaveAccountProcess(
                            dynamicFormList: dynamicFormController.formList,
                            onSuccessCallback: () {
                              Get.back(result: "success");
                            },
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
