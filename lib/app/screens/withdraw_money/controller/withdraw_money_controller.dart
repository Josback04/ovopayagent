import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopayagent/core/data/models/global/formdata/dynamic_fom_submitted_value_model.dart';
import 'package:ovopayagent/core/data/models/global/response_model/response_model.dart';
import 'package:ovopayagent/core/data/models/kyc/kyc_response_model.dart';
import 'package:ovopayagent/core/data/models/modules/global/module_transaction_model.dart';
import 'package:ovopayagent/core/data/models/withdraw/withdraw_history_list_model.dart';
import 'package:ovopayagent/core/data/models/withdraw/withdraw_methods_list_model.dart';
import 'package:ovopayagent/core/data/models/withdraw/withdraw_request_model.dart';
import 'package:ovopayagent/core/data/models/withdraw/withdraw_submit_response_model.dart';
import 'package:ovopayagent/core/data/repositories/withdraw_money/withdraw_money_repo.dart';
import 'package:ovopayagent/core/data/services/shared_pref_service.dart';

import '../../../../core/utils/util_exporter.dart';

class WithdrawMoneyController extends GetxController {
  WithdrawMoneyRepo withdrawMoneyRepo;
  WithdrawMoneyController({required this.withdrawMoneyRepo});

  bool isLoading = true;

  final TextEditingController selectedPaymentMethodController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController uniqueIDController = TextEditingController();
  // Get Phone or username or Amount
  String get getAmount => amountController.text;
  //Otp Type
  List<String> otpType = [];
  String selectedOtpType = "";
  //current balance
  double userCurrentBalance = 0.0;

  String selectedValue = "";
  String withdrawLimit = "";

  List<WithdrawMethod> methodList = [];
  List<WithdrawMethod> methods = [];
  WithdrawMethod? selectedWithdrawMoneyMethod = WithdrawMethod(
    name: MyStrings.selectOne,
    id: -1,
  );
  //Selected  saved account autofill data
  List<UsersDynamicFormSubmittedDataModel>? selectedAccountDynamicFormAutofillData;
  double rate = 1;
  double mainAmount = 0;

  // Success Model
  ModuleGlobalSubmitTransactionModel? moduleGlobalSubmitTransactionModel;

  //Action ID
  String actionID = "";
  //Select Otp type
  void selectAnOtpType(String otpType) {
    selectedOtpType = otpType;
    update();
  }

  String getOtpType(String value) {
    return value == "email"
        ? MyStrings.email.tr
        : value == "sms"
            ? MyStrings.phone.tr
            : "";
  }

  //Select payment method
  void setPaymentMethod(WithdrawMethod? method) {
    String amt = amountController.text.toString();
    mainAmount = amt.isEmpty ? 0 : double.tryParse(amt) ?? 0;
    selectedWithdrawMoneyMethod = method;

    withdrawLimit = '${AppConverter.formatNumber(method?.minLimit?.toString() ?? '-1')} - ${AppConverter.formatNumber(method?.maxLimit?.toString() ?? '-1')} $currency';
    changeInfoWidgetValue();
    update();
  }

  void setUniqueID(String value) {
    uniqueIDController.text = value;
    update();
  }

  //Select Dynamic Form autofill data
  void selectedAccountDynamicFormAutofillDataOnTap(
    List<UsersDynamicFormSubmittedDataModel>? value,
  ) {
    selectedAccountDynamicFormAutofillData = null;
    update();
    selectedAccountDynamicFormAutofillData = value;
    update();
  }

  Future<void> getWithdrawMethod({bool forceLoad = true}) async {
    isLoading = forceLoad;
    update();
    currency = SharedPreferenceService.getCurrencySymbol(isFullText: true);
    selectedPaymentMethodController.text = selectedWithdrawMoneyMethod?.name ?? '';
    ResponseModel responseModel = await withdrawMoneyRepo.getAllWithdrawMethod();

    if (responseModel.statusCode == 200) {
      WithdrawMethodsListResponseModel methodsModel = WithdrawMethodsListResponseModel.fromJson(responseModel.responseJson);

      if (methodsModel.status == "success") {
        final data = methodsModel.data;
        if (data != null) {
          userCurrentBalance = data.getCurrentBalance();
          otpType = data.otpType ?? [];
          methodList = methodsModel.data?.withdrawMethods ?? [];
          update();
        }
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
      return;
    }

    isLoading = false;
    update();
  }

  //Withdraw request
  bool isWithdrawRequestLoading = false;
  WithdrawRequestResponseModel? withdrawRequestResponseModelData;
  String isNeedTwoFactorAuthentication = "";
  String current2faText = '';

  void onOtpBoxValueChange(String value) {
    current2faText = value;
    update();
  }

  Future<void> withdrawRequest({void Function()? onSuccessCallback}) async {
    if (selectedWithdrawMoneyMethod == null) {
      CustomSnackBar.error(errorList: [MyStrings.selectAWithdrawMethod]);
      return;
    }
    if (amountController.text.trim().isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
      return;
    }
    try {
      isWithdrawRequestLoading = true;
      update();
      ResponseModel response = await withdrawMoneyRepo.addWithdrawRequest(
        amount: getAmount,
        methodCode: "${selectedWithdrawMoneyMethod?.id ?? -1}",
      );

      if (response.statusCode == 200) {
        WithdrawRequestResponseModel withdrawRequestResponseModel = WithdrawRequestResponseModel.fromJson(response.responseJson);
        if (withdrawRequestResponseModel.status == AppStatus.SUCCESS) {
          withdrawRequestResponseModelData = withdrawRequestResponseModel;
          isNeedTwoFactorAuthentication = (withdrawRequestResponseModel.data?.authenticator ?? "");
          if (onSuccessCallback != null) {
            onSuccessCallback();
          }
        } else {
          CustomSnackBar.error(
            errorList: withdrawRequestResponseModel.message ?? [MyStrings.requestFail],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printE(e);
    } finally {
      isWithdrawRequestLoading = false;
      update();
    }
  }

  //Submit

  bool isSubmitLoading = false;
  Future<void> submitThisProcess({
    void Function(WithdrawSubmitResponseModel)? onSuccessCallback,
    required List<KycFormModel> dynamicFormList,
  }) async {
    try {
      isSubmitLoading = true;
      update();
      ResponseModel responseModel = await withdrawMoneyRepo.confirmWithdrawRequest(
        dynamicFormList: dynamicFormList,
        trxNo: withdrawRequestResponseModelData?.data?.trx ?? "",
        pin: pinController.text,
        otpType: selectedOtpType,
        authenticationCode: current2faText,
      );
      if (responseModel.statusCode == 200) {
        WithdrawSubmitResponseModel withdrawSubmitResponseModel = WithdrawSubmitResponseModel.fromJson(responseModel.responseJson);

        if (withdrawSubmitResponseModel.status == "success") {
          moduleGlobalSubmitTransactionModel = withdrawSubmitResponseModel.data?.withdraw;
          if (moduleGlobalSubmitTransactionModel != null) {
            if (onSuccessCallback != null) {
              onSuccessCallback(withdrawSubmitResponseModel);
            }
          }
        } else {
          CustomSnackBar.error(
            errorList: withdrawSubmitResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isSubmitLoading = false;
      update();
    }
  }
  //Submit end

  //Amount text changes
  void onChangeAmountControllerText(String value) {
    amountController.text = value;
    changeInfoWidgetValue();
    update();
  }

  //Charge calculation

  String charge = "";
  String receivable = "";
  String amount = "";
  String fixedCharge = "";
  String currency = '';
  String receivableText = '';
  String conversionRate = '';
  String inMethodReceivable = '';

  void changeInfoWidgetValue() {
    if (selectedWithdrawMoneyMethod?.id.toString() == '-1') {
      return;
    }

    mainAmount = double.tryParse(amountController.text) ?? 0.0;

    // mainAmount = amount;
    double percent = double.tryParse(selectedWithdrawMoneyMethod?.percentCharge ?? '0') ?? 0;
    double percentCharge = (mainAmount * percent) / 100;
    double temCharge = double.tryParse(selectedWithdrawMoneyMethod?.fixedCharge ?? '0') ?? 0;
    double totalCharge = percentCharge + temCharge;
    charge = AppConverter.formatNumber('$totalCharge');
    double withCharge = mainAmount - totalCharge;

    rate = double.tryParse(selectedWithdrawMoneyMethod?.rate ?? '0') ?? 0;
    conversionRate = '1 $currency = $rate ${selectedWithdrawMoneyMethod?.currency ?? ''}';
    inMethodReceivable = AppConverter.formatNumber('${withCharge * rate}');
    receivable = '$withCharge';
    receivableText = '$withCharge $currency';
    update();
    return;
  }

  void clearData() {
    withdrawLimit = '';
    charge = '';
    amountController.text = '';
    isLoading = false;
    methodList.clear();
  }

  bool isShowRate() {
    if (rate > 1 && currency.toLowerCase() != selectedWithdrawMoneyMethod?.currency?.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }

  //History

  int currentIndex = 0;
  void initialHistoryData() async {
    isHistoryLoading = true;
    page = 0;
    nextPageUrl = null;
    withdrawHistoryList.clear();

    await getDonationHistoryDataList();
  }

  bool isHistoryLoading = false;
  int page = 1;
  String? nextPageUrl;
  List<WithdrawalDataModel> withdrawHistoryList = [];

  Future<void> getDonationHistoryDataList({bool forceLoad = true}) async {
    try {
      page = page + 1;
      isHistoryLoading = forceLoad;
      update();
      ResponseModel responseModel = await withdrawMoneyRepo.getAllWithdrawHistory(page: page, searchText: "");
      if (responseModel.statusCode == 200) {
        final withdrawHistoryResponseModel = withdrawHistoryResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (withdrawHistoryResponseModel.status == "success") {
          nextPageUrl = withdrawHistoryResponseModel.data?.withdrawals?.nextPageUrl;
          withdrawHistoryList.addAll(
            withdrawHistoryResponseModel.data?.withdrawals?.data ?? [],
          );
        } else {
          CustomSnackBar.error(
            errorList: withdrawHistoryResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
        isHistoryLoading = false;
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    }
    isHistoryLoading = false;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  //History end

  //Save edit and delete Withdraw method

  //Save company account
  void clearSavedAccountData() {
    uniqueIDController.text = '';

    update();
  }

  bool isSubmitSaveCompanyAccountLoading = false;
  Future<void> submitSaveAccountProcess({
    required List<KycFormModel> dynamicFormList,
    VoidCallback? onSuccessCallback,
    String? accountID,
  }) async {
    try {
      isSubmitSaveCompanyAccountLoading = true;
      update();
      ResponseModel responseModel = await withdrawMoneyRepo.saveWithdrawAccountRequest(
        accountID: accountID,
        uniqueID: uniqueIDController.text.toString(),
        methodId: selectedWithdrawMoneyMethod?.id.toString() ?? "",
        dynamicFormList: dynamicFormList,
      );
      if (responseModel.statusCode == 200) {
        WithdrawHistoryResponseModel addNewAccountSubmitResponseModel = WithdrawHistoryResponseModel.fromJson(responseModel.responseJson);

        if (addNewAccountSubmitResponseModel.status == "success") {
          if (onSuccessCallback != null) {
            onSuccessCallback();
          }
          CustomSnackBar.success(
            successList: addNewAccountSubmitResponseModel.message ?? [MyStrings.requestSuccess],
          );
        } else {
          CustomSnackBar.error(
            errorList: addNewAccountSubmitResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isSubmitSaveCompanyAccountLoading = false;
      update();
    }
  }

  bool isDeleteSaveAccountLoading = false;
  String isDeleteSaveAccountIDLoading = "-1";
  Future<void> deleteSavedAccount({String accountID = ""}) async {
    try {
      isDeleteSaveAccountLoading = true;
      isDeleteSaveAccountIDLoading = accountID;
      update();
      ResponseModel responseModel = await withdrawMoneyRepo.deleteSavedAccount(
        accountID,
      );
      if (responseModel.statusCode == 200) {
        WithdrawHistoryResponseModel submitResponseModel = WithdrawHistoryResponseModel.fromJson(responseModel.responseJson);

        if (submitResponseModel.status == "success") {
          CustomSnackBar.success(
            successList: submitResponseModel.message ?? [MyStrings.requestSuccess],
          );
          getWithdrawMethod(forceLoad: false);
        } else {
          CustomSnackBar.error(
            errorList: submitResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isDeleteSaveAccountIDLoading = "-1";
      isDeleteSaveAccountLoading = false;
      update();
    }
  }
}
