// To parse this JSON data, do
//
//     final withdrawSubmitResponseModel = withdrawSubmitResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopayagent/core/data/models/global/formdata/dynamic_fom_submitted_value_model.dart';
import 'package:ovopayagent/core/data/models/modules/global/module_transaction_model.dart';

WithdrawSubmitResponseModel withdrawSubmitResponseModelFromJson(String str) => WithdrawSubmitResponseModel.fromJson(json.decode(str));

String withdrawSubmitResponseModelToJson(WithdrawSubmitResponseModel data) => json.encode(data.toJson());

class WithdrawSubmitResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  WithdrawSubmitResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory WithdrawSubmitResponseModel.fromJson(Map<String, dynamic> json) => WithdrawSubmitResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message": message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "data": data?.toJson(),
      };
}

class Data {
  ModuleGlobalSubmitTransactionModel? withdraw;
  List<UsersDynamicFormSubmittedDataModel>? withdrawInformation;

  Data({this.withdraw, this.withdrawInformation});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        withdraw: json["withdraw"] == null ? null : ModuleGlobalSubmitTransactionModel.fromJson(json["withdraw"]),
        withdrawInformation: json["withdraw_information"] == null
            ? []
            : List<UsersDynamicFormSubmittedDataModel>.from(
                json["withdraw_information"]!.map(
                  (x) => UsersDynamicFormSubmittedDataModel.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "withdraw": withdraw?.toJson(),
        "withdraw_information": withdrawInformation == null ? [] : List<dynamic>.from(withdrawInformation!.map((x) => x.toJson())),
      };
}
