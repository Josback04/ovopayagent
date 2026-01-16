// To parse this JSON data, do
//
//     final withdrawHistoryResponseModel = withdrawHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopayagent/core/data/models/global/formdata/dynamic_fom_submitted_value_model.dart';
import 'package:ovopayagent/core/data/models/withdraw/withdraw_methods_list_model.dart';

WithdrawHistoryResponseModel withdrawHistoryResponseModelFromJson(String str) => WithdrawHistoryResponseModel.fromJson(json.decode(str));

String withdrawHistoryResponseModelToJson(WithdrawHistoryResponseModel data) => json.encode(data.toJson());

class WithdrawHistoryResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  WithdrawHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory WithdrawHistoryResponseModel.fromJson(Map<String, dynamic> json) => WithdrawHistoryResponseModel(
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
  Withdrawals? withdrawals;

  Data({this.withdrawals});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        withdrawals: json["withdrawals"] == null ? null : Withdrawals.fromJson(json["withdrawals"]),
      );

  Map<String, dynamic> toJson() => {"withdrawals": withdrawals?.toJson()};
}

class Withdrawals {
  List<WithdrawalDataModel>? data;

  String? nextPageUrl;
  String? path;

  Withdrawals({this.data, this.nextPageUrl, this.path});

  factory Withdrawals.fromJson(Map<String, dynamic> json) => Withdrawals(
        data: json["data"] == null
            ? []
            : List<WithdrawalDataModel>.from(
                json["data"]!.map((x) => WithdrawalDataModel.fromJson(x)),
              ),
        nextPageUrl: json["next_page_url"]?.toString(),
        path: json["path"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
      };
}

class WithdrawalDataModel {
  int? id;
  String? methodId;
  String? userId;
  String? agentId;
  String? merchantId;
  String? amount;
  String? currency;
  String? rate;
  String? charge;
  String? trx;
  String? finalAmount;
  String? afterCharge;
  List<UsersDynamicFormSubmittedDataModel>? withdrawInformation;
  String? status;
  String? adminFeedback;
  String? createdAt;
  String? updatedAt;
  WithdrawMethod? method;

  WithdrawalDataModel({
    this.id,
    this.methodId,
    this.userId,
    this.agentId,
    this.merchantId,
    this.amount,
    this.currency,
    this.rate,
    this.charge,
    this.trx,
    this.finalAmount,
    this.afterCharge,
    this.withdrawInformation,
    this.status,
    this.adminFeedback,
    this.createdAt,
    this.updatedAt,
    this.method,
  });

  factory WithdrawalDataModel.fromJson(Map<String, dynamic> json) => WithdrawalDataModel(
        id: json["id"],
        methodId: json["method_id"]?.toString(),
        userId: json["user_id"]?.toString(),
        agentId: json["agent_id"]?.toString(),
        merchantId: json["merchant_id"]?.toString(),
        amount: json["amount"]?.toString(),
        currency: json["currency"]?.toString(),
        rate: json["rate"]?.toString(),
        charge: json["charge"]?.toString(),
        trx: json["trx"]?.toString(),
        finalAmount: json["final_amount"]?.toString(),
        afterCharge: json["after_charge"]?.toString(),
        withdrawInformation: json["withdraw_information"] == null
            ? []
            : List<UsersDynamicFormSubmittedDataModel>.from(
                json["withdraw_information"]!.map(
                  (x) => UsersDynamicFormSubmittedDataModel.fromJson(x),
                ),
              ),
        status: json["status"]?.toString(),
        adminFeedback: json["admin_feedback"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        method: json["method"] == null ? null : WithdrawMethod.fromJson(json["method"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method_id": methodId,
        "user_id": userId,
        "agent_id": agentId,
        "merchant_id": merchantId,
        "amount": amount,
        "currency": currency,
        "rate": rate,
        "charge": charge,
        "trx": trx,
        "final_amount": finalAmount,
        "after_charge": afterCharge,
        "withdraw_information": withdrawInformation == null ? [] : List<dynamic>.from(withdrawInformation!.map((x) => x.toJson())),
        "status": status,
        "admin_feedback": adminFeedback,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "method": method?.toJson(),
      };
}
