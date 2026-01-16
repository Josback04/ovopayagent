import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopayagent/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopayagent/core/data/models/authorization/authorization_response_model.dart';
import 'package:ovopayagent/core/data/models/global/charges/global_charge_model.dart';
import 'package:ovopayagent/core/data/models/global/response_model/response_model.dart';
import 'package:ovopayagent/core/data/models/modules/cash_in/cash_in_history_response_model.dart';
import 'package:ovopayagent/core/data/models/modules/cash_in/cash_in_response_model.dart';
import 'package:ovopayagent/core/data/models/user/user_model.dart';
import 'package:ovopayagent/core/data/repositories/modules/cash_in/cash_in_repo.dart';

import '../../../../core/utils/util_exporter.dart';

class CashInController extends GetxController {
  CashInRepo cashInRepo;
  CashInController({required this.cashInRepo});

  bool isPageLoading = true;

  TextEditingController phoneNumberOrUserNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  // Get Phone or username or Amount
  String get getPhoneOrUsername => phoneNumberOrUserNameController.text;
  String get getAmount => amountController.text;
  //Otp Type
  List<String> otpType = [];
  String selectedOtpType = "";
  //current balance
  double userCurrentBalance = 0.0;
  //Charge
  GlobalChargeModel? globalChargeModel;
  //Latest Cash in history
  List<LatestCashInHistoryData> latestCashInHistory = [];
  //Check user exist
  bool isUserExist = false;
  UserModel? existUserModel;
  //Cash in Success Model
  CashInSubmitInfo? cashInSubmitInfoModel;
  //Action ID
  String actionID = "";

  Future initController() async {
    isPageLoading = true;
    update();
    await loadCashInInfo();
    isPageLoading = false;
    update();
  }

  //Informations
  Future<void> loadCashInInfo() async {
    try {
      ResponseModel responseModel = await cashInRepo.cashInInfoData();
      if (responseModel.statusCode == 200) {
        final cashInResponseModel = cashInResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (cashInResponseModel.status == "success") {
          final data = cashInResponseModel.data;
          if (data != null) {
            userCurrentBalance = data.getCurrentBalance();

            otpType = data.otpType ?? [];
            globalChargeModel = data.cashInCharge;
            if (data.latestCashInHistory != null) {
              latestCashInHistory = data.latestCashInHistory ?? [];
            }
            update();
          }
        } else {
          CustomSnackBar.error(
            errorList: cashInResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    }
  }

  //Check if the user exists
  bool isCheckingUserLoading = false;
  Future<void> checkUserExist(
    VoidCallback onSuccessCallback, {
    String inputUserNameOrPhone = "",
  }) async {
    try {
      isCheckingUserLoading = true;
      update();
      // Use the provided input or default to the text in the controller
      final userInput = (inputUserNameOrPhone.isEmpty ? phoneNumberOrUserNameController.text : inputUserNameOrPhone).removeSpecialCharacters();

      // Determine if the input is a phone number or a username
      final processedInput = MyUtils.checkTextIsOnlyNumber(userInput) ? userInput.toFormattedPhoneNumber(digitsFromEnd: 100) : userInput;
      ResponseModel responseModel = await cashInRepo.checkUserExist(
        usernameOrPhone: processedInput,
      );
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel authorizationResponseModel = AuthorizationResponseModel.fromJson(responseModel.responseJson);

        if (authorizationResponseModel.status == "success") {
          existUserModel = authorizationResponseModel.data?.user;
          if (existUserModel != null) {
            isUserExist = true;
            onSuccessCallback();
          }
        } else {
          isUserExist = false;
          CustomSnackBar.error(
            errorList: authorizationResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isCheckingUserLoading = false;
      update();
    }
  }

  Future<void> setAgentFromQrScan(
    VoidCallback onSuccessCallback, {
    UserModel? userModel,
  }) async {
    try {
      isCheckingUserLoading = true;
      update();

      if (userModel != null) {
        existUserModel = userModel;

        isUserExist = true;
        onSuccessCallback();
      } else {
        isUserExist = false;
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isCheckingUserLoading = false;
      update();
    }
  }

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

  //Amount text changes
  void onChangeAmountControllerText(String value) {
    amountController.text = value;
    changeInfoWidget();
    update();
  }

  //Charge calculation

  double mainAmount = 0;
  String totalCharge = "";
  String payableAmountText = "";

  void changeInfoWidget() {
    mainAmount = double.tryParse(amountController.text) ?? 0.0;
    update();
    double percent = double.tryParse(globalChargeModel?.percentCharge ?? "0") ?? 0;
    double percentCharge = mainAmount * percent / 100;

    double fixedCharge = double.tryParse(globalChargeModel?.fixedCharge ?? "0") ?? 0;
    double tempTotalCharge = percentCharge + fixedCharge;

    double capAmount = double.tryParse(globalChargeModel?.cap ?? "0") ?? 0;

    if (capAmount != -1.0 && capAmount != 1 && tempTotalCharge > capAmount) {
      tempTotalCharge = capAmount;
    }

    totalCharge = AppConverter.formatNumber('$tempTotalCharge', precision: 2);
    double payable = tempTotalCharge + mainAmount;
    payableAmountText = payableAmountText.length > 5 ? AppConverter.roundDoubleAndRemoveTrailingZero(payable.toString()) : AppConverter.formatNumber(payable.toString());
    update();
  }
  //Charge calculation end

  //Submit

  bool isSubmitLoading = false;
  Future<void> submitThisProcess({
    void Function(CashInResponseModel)? onSuccessCallback,
  }) async {
    try {
      isSubmitLoading = true;
      update();
      ResponseModel responseModel = await cashInRepo.cashInRequest(
        user: existUserModel?.username ?? phoneNumberOrUserNameController.text,
        amount: amountController.text,
        pin: pinController.text,
        otpType: selectedOtpType,
      );
      if (responseModel.statusCode == 200) {
        CashInResponseModel cashInResponseModel = CashInResponseModel.fromJson(
          responseModel.responseJson,
        );

        if (cashInResponseModel.status == "success") {
          cashInSubmitInfoModel = cashInResponseModel.data?.cashIn;
          if (cashInSubmitInfoModel != null) {
            if (onSuccessCallback != null) {
              onSuccessCallback(cashInResponseModel);
            }
          }
        } else {
          CustomSnackBar.error(
            errorList: cashInResponseModel.message ?? [MyStrings.somethingWentWrong],
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

  //History

  int currentIndex = 0;
  void initialHistoryData() async {
    isHistoryLoading = true;
    page = 0;
    nextPageUrl = null;
    cashInHistoryList.clear();

    await getCashInHistoryDataList();
  }

  bool isHistoryLoading = false;
  int page = 1;
  String? nextPageUrl;
  List<LatestCashInHistoryData> cashInHistoryList = [];
  Future<void> getCashInHistoryDataList({bool forceLoad = true}) async {
    try {
      page = page + 1;
      isHistoryLoading = forceLoad;
      update();
      ResponseModel responseModel = await cashInRepo.cashInHistory(page);
      if (responseModel.statusCode == 200) {
        final cashInHistoryResponseModel = cashInHistoryResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (cashInHistoryResponseModel.status == "success") {
          nextPageUrl = cashInHistoryResponseModel.data?.latestCashinHistory?.nextPageUrl;
          cashInHistoryList.addAll(
            cashInHistoryResponseModel.data?.latestCashinHistory?.data ?? [],
          );
        } else {
          CustomSnackBar.error(
            errorList: cashInHistoryResponseModel.message ?? [MyStrings.somethingWentWrong],
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
}
