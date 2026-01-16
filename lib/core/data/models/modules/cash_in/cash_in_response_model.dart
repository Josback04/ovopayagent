// To parse this JSON data, do
//
//     final cashInResponseModel = cashInResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopayagent/core/data/models/global/charges/global_charge_model.dart';
import 'package:ovopayagent/core/data/models/modules/cash_in/cash_in_history_response_model.dart';
import 'package:ovopayagent/core/data/models/user/user_model.dart';

CashInResponseModel cashInResponseModelFromJson(String str) => CashInResponseModel.fromJson(json.decode(str));

String cashInResponseModelToJson(CashInResponseModel data) => json.encode(data.toJson());

class CashInResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CashInResponseModel({this.remark, this.status, this.message, this.data});

  factory CashInResponseModel.fromJson(Map<String, dynamic> json) => CashInResponseModel(
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
  List<String>? otpType;
  String? currentBalance;
  GlobalChargeModel? cashInCharge;
  List<LatestCashInHistoryData>? latestCashInHistory;
  CashInSubmitInfo? cashIn;
  Data({
    this.otpType,
    this.currentBalance,
    this.cashInCharge,
    this.latestCashInHistory,
    this.cashIn,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        otpType: json["otp_type"] == null ? [] : List<String>.from(json["otp_type"]!.map((x) => x)),
        currentBalance: json["current_balance"]?.toString(),
        cashInCharge: json["cash_in_charge"] == null ? null : GlobalChargeModel.fromJson(json["cash_in_charge"]),
        latestCashInHistory: json["latest_cashin_history"] == null
            ? []
            : List<LatestCashInHistoryData>.from(
                json["latest_cashin_history"]!.map(
                  (x) => LatestCashInHistoryData.fromJson(x),
                ),
              ),
        cashIn: json["cash_in"] == null ? null : CashInSubmitInfo.fromJson(json["cash_in"]),
      );

  Map<String, dynamic> toJson() => {
        "otp_type": otpType == null ? [] : List<dynamic>.from(otpType!.map((x) => x)),
        "current_balance": currentBalance,
        "cash_in_charge": cashInCharge?.toJson(),
        "latest_cashin_history": latestCashInHistory == null ? [] : List<dynamic>.from(latestCashInHistory!.map((x) => x.toJson())),
        "cash_in": cashIn?.toJson(),
      };
  double getCurrentBalance() {
    try {
      return double.tryParse(currentBalance.toString()) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}

class CashInSubmitInfo {
  String? agentId;
  String? receiverId;
  String? beforeCharge;
  String? amount;
  String? postBalance;
  String? charge;
  String? chargeType;
  String? trxType;
  String? remark;
  String? details;
  String? receiverType;
  String? trx;
  String? updatedAt;
  String? createdAt;
  int? id;
  UserModel? receiverUser;

  CashInSubmitInfo({
    this.agentId,
    this.receiverId,
    this.beforeCharge,
    this.amount,
    this.postBalance,
    this.charge,
    this.chargeType,
    this.trxType,
    this.remark,
    this.details,
    this.receiverType,
    this.trx,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.receiverUser,
  });

  factory CashInSubmitInfo.fromJson(Map<String, dynamic> json) => CashInSubmitInfo(
        agentId: json["agent_id"]?.toString(),
        receiverId: json["receiver_id"]?.toString(),
        beforeCharge: json["before_charge"]?.toString(),
        amount: json["amount"]?.toString(),
        postBalance: json["post_balance"]?.toString(),
        charge: json["charge"]?.toString(),
        chargeType: json["charge_type"]?.toString(),
        trxType: json["trx_type"]?.toString(),
        remark: json["remark"]?.toString(),
        details: json["details"]?.toString(),
        receiverType: json["receiver_type"]?.toString(),
        trx: json["trx"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        id: json["id"],
        receiverUser: json["receiver_user"] == null ? null : UserModel.fromJson(json["receiver_user"]),
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
        "receiver_id": receiverId,
        "before_charge": beforeCharge,
        "amount": amount,
        "post_balance": postBalance,
        "charge": charge,
        "charge_type": chargeType,
        "trx_type": trxType,
        "remark": remark,
        "details": details,
        "receiver_type": receiverType,
        "trx": trx,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "id": id,
        "receiver_user": receiverUser?.toJson(),
      };
}
