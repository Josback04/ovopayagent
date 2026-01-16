// To parse this JSON data, do
//
//     final withdrawRequestResponseModel = withdrawRequestResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopayagent/core/data/models/kyc/kyc_response_model.dart';

WithdrawRequestResponseModel withdrawRequestResponseModelFromJson(String str) => WithdrawRequestResponseModel.fromJson(json.decode(str));

String withdrawRequestResponseModelToJson(WithdrawRequestResponseModel data) => json.encode(data.toJson());

class WithdrawRequestResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  WithdrawRequestResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory WithdrawRequestResponseModel.fromJson(Map<String, dynamic> json) => WithdrawRequestResponseModel(
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
  String? trx;
  WithdrawData? withdrawData;
  KycFormData? form;
  String? authenticator;
  Data({this.trx, this.withdrawData, this.form, this.authenticator});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        trx: json["trx"],
        withdrawData: json["withdraw_data"] == null ? null : WithdrawData.fromJson(json["withdraw_data"]),
        form: json["form"] == null ? null : KycFormData.fromJson(json["form"]),
        authenticator: json["authenticator"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "trx": trx,
        "withdraw_data": withdrawData?.toJson(),
        "form": form?.toJson(),
        "authenticator": authenticator,
      };
}

class WithdrawData {
  String? methodId;
  String? agentId;
  String? amount;
  String? currency;
  String? rate;
  String? charge;
  String? finalAmount;
  String? afterCharge;
  String? trx;
  String? updatedAt;
  String? createdAt;
  int? id;

  WithdrawData({
    this.methodId,
    this.agentId,
    this.amount,
    this.currency,
    this.rate,
    this.charge,
    this.finalAmount,
    this.afterCharge,
    this.trx,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory WithdrawData.fromJson(Map<String, dynamic> json) => WithdrawData(
        methodId: json["method_id"]?.toString(),
        agentId: json["agent_id"]?.toString(),
        amount: json["amount"]?.toString(),
        currency: json["currency"]?.toString(),
        rate: json["rate"]?.toString(),
        charge: json["charge"]?.toString(),
        finalAmount: json["final_amount"]?.toString(),
        afterCharge: json["after_charge"]?.toString(),
        trx: json["trx"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "method_id": methodId,
        "agent_id": agentId,
        "amount": amount,
        "currency": currency,
        "rate": rate,
        "charge": charge,
        "final_amount": finalAmount,
        "after_charge": afterCharge,
        "trx": trx,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "id": id,
      };
}
