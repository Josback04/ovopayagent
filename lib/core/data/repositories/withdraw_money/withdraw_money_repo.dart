import 'dart:io';

import 'package:ovopayagent/core/data/models/global/formdata/dynamic_file_value_keeper_model.dart';
import 'package:ovopayagent/core/data/models/global/response_model/response_model.dart';
import 'package:ovopayagent/core/data/models/kyc/kyc_response_model.dart';

import '../../../utils/util_exporter.dart';
import '../../services/api_service.dart';

class WithdrawMoneyRepo {
  Future<dynamic> getAllWithdrawMethod() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawMethodUrl}';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<dynamic> getWithdrawConfirmScreenData(String trxId) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawConfirmScreenUrl}$trxId';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<dynamic> addWithdrawRequest({
    String methodCode = "-1",
    String amount = "",
  }) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.addWithdrawRequestUrl}';
    Map<String, dynamic> params = {'method_code': methodCode, 'amount': amount};

    ResponseModel responseModel = await ApiService.postRequest(url, params);
    return responseModel;
  }

  List<Map<String, String>> fieldValueList = [];
  List<DynamicFileValueKeeperModel> filesDataList = [];

  Future<ResponseModel> confirmWithdrawRequest({
    String trxNo = "",
    String pin = "",
    String otpType = "",
    required List<KycFormModel> dynamicFormList,
    String authenticationCode = "",
  }) async {
    fieldValueList.clear();
    await modelToMap(dynamicFormList);
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawRequestConfirm}';

    //Field value map
    Map<String, String> finalFieldValueMap = {};
    finalFieldValueMap["trx"] = trxNo;
    finalFieldValueMap["pin"] = pin;
    finalFieldValueMap["otp_type"] = otpType;
    finalFieldValueMap["authenticator_code"] = authenticationCode;
    for (var element in fieldValueList) {
      finalFieldValueMap.addAll(element);
    }
    //Attachments file list
    Map<String, File> attachmentFiles = filesDataList.asMap().map(
          (index, value) => MapEntry(value.key, value.value),
        );
    printX(finalFieldValueMap);
    ResponseModel response = await ApiService.postMultiPartRequest(
      url,
      finalFieldValueMap,
      attachmentFiles,
    );

    return response;
  }

  Future<ResponseModel> getAllWithdrawHistory({
    int page = 0,
    String searchText = "",
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.withdrawHistoryUrl}?page=$page&search=$searchText";
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<dynamic> modelToMap(List<KycFormModel> list) async {
    for (var e in list) {
      if (e.type == 'checkbox') {
        if (e.cbSelected != null && e.cbSelected!.isNotEmpty) {
          for (int i = 0; i < e.cbSelected!.length; i++) {
            fieldValueList.add({'${e.label}[$i]': e.cbSelected![i]});
          }
        }
      } else if (e.type == 'file') {
        if (e.imageFile != null) {
          filesDataList.add(
            DynamicFileValueKeeperModel(e.label!, e.imageFile!),
          );
        }
      } else if (e.type == 'select') {
        if (e.selectedValue != null && e.selectedValue.toString() != MyStrings.selectOne) {
          fieldValueList.add({e.label ?? '': e.selectedValue});
        }
      } else {
        if (e.selectedValue != null && e.selectedValue.toString().isNotEmpty) {
          fieldValueList.add({e.label ?? '': e.selectedValue});
        }
      }
    }
  }

  Future<ResponseModel> deleteSavedAccount(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawSavedAccountDeleteUrl}/$id';
    final response = await ApiService.postRequest(url, {});
    return response;
  }

  Future<ResponseModel> saveWithdrawAccountRequest({
    String? accountID,
    String uniqueID = "",
    String methodId = "",
    required List<KycFormModel> dynamicFormList,
  }) async {
    fieldValueList.clear();
    await modelToMap(dynamicFormList);
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawSavedAccountStoreUrl}${accountID != null ? "/$accountID" : ""}';

    //Field value map
    Map<String, String> finalFieldValueMap = {};
    for (var element in fieldValueList) {
      finalFieldValueMap.addAll(element);
    }
    finalFieldValueMap["name"] = uniqueID;
    finalFieldValueMap["method_id"] = methodId;

    //Attachments file list
    Map<String, File> attachmentFiles = filesDataList.asMap().map(
          (index, value) => MapEntry(value.key, value.value),
        );
    printX(finalFieldValueMap);

    ResponseModel response = await ApiService.postMultiPartRequest(
      url,
      finalFieldValueMap,
      attachmentFiles,
    );

    printW(response.responseJson);

    return response;
  }
}
