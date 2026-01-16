// To parse this JSON data, do
//
//     final cashInHistoryResponseModel = cashInHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopayagent/core/data/models/user/user_model.dart';

CashInHistoryResponseModel cashInHistoryResponseModelFromJson(String str) => CashInHistoryResponseModel.fromJson(json.decode(str));

String cashInHistoryResponseModelToJson(CashInHistoryResponseModel data) => json.encode(data.toJson());

class CashInHistoryResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CashInHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory CashInHistoryResponseModel.fromJson(Map<String, dynamic> json) => CashInHistoryResponseModel(
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
  LatestCashInHistory? latestCashinHistory;

  Data({this.latestCashinHistory});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        latestCashinHistory: json["latest_cashin_history"] == null ? null : LatestCashInHistory.fromJson(json["latest_cashin_history"]),
      );

  Map<String, dynamic> toJson() => {
        "latest_cashin_history": latestCashinHistory?.toJson(),
      };
}

class LatestCashInHistory {
  List<LatestCashInHistoryData>? data;

  String? nextPageUrl;
  String? path;

  LatestCashInHistory({this.data, this.nextPageUrl, this.path});

  factory LatestCashInHistory.fromJson(Map<String, dynamic> json) => LatestCashInHistory(
        data: json["data"] == null
            ? []
            : List<LatestCashInHistoryData>.from(
                json["data"]!.map((x) => LatestCashInHistoryData.fromJson(x)),
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

class LatestCashInHistoryData {
  int? id;
  String? userId;
  String? agentId;
  String? amount;
  String? commission;
  String? userPostBalance;
  String? agentPostBalance;
  String? trx;
  String? userDetails;
  String? agentDetails;
  String? createdAt;
  String? updatedAt;
  UserModel? receiverUser;

  LatestCashInHistoryData({
    this.id,
    this.userId,
    this.agentId,
    this.amount,
    this.commission,
    this.userPostBalance,
    this.agentPostBalance,
    this.trx,
    this.userDetails,
    this.agentDetails,
    this.createdAt,
    this.updatedAt,
    this.receiverUser,
  });

  factory LatestCashInHistoryData.fromJson(Map<String, dynamic> json) => LatestCashInHistoryData(
        id: json["id"],
        userId: json["user_id"]?.toString(),
        agentId: json["agent_id"]?.toString(),
        amount: json["amount"]?.toString(),
        commission: json["commission"]?.toString(),
        userPostBalance: json["user_post_balance"]?.toString(),
        agentPostBalance: json["agent_post_balance"]?.toString(),
        trx: json["trx"]?.toString(),
        userDetails: json["user_details"]?.toString(),
        agentDetails: json["agent_details"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        receiverUser: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "agent_id": agentId,
        "amount": amount,
        "commission": commission,
        "user_post_balance": userPostBalance,
        "agent_post_balance": agentPostBalance,
        "trx": trx,
        "user_details": userDetails,
        "agent_details": agentDetails,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": receiverUser?.toJson(),
      };
}
