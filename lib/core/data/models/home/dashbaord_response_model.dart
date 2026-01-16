// To parse this JSON data, do
//
//     final dashboardResponseModel = dashboardResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopayagent/core/data/models/global/formdata/dynamic_fom_submitted_value_model.dart';
import 'package:ovopayagent/core/data/models/user/user_model.dart';

DashboardResponseModel dashboardResponseModelFromJson(String str) => DashboardResponseModel.fromJson(json.decode(str));

String dashboardResponseModelToJson(DashboardResponseModel data) => json.encode(data.toJson());

class DashboardResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  DashboardResponseModel({this.remark, this.status, this.message, this.data});

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) => DashboardResponseModel(
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
  UserModel? agent;
  List<UsersDynamicFormSubmittedDataModel>? kycData;

  Data({this.agent, this.kycData});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        agent: json["agent"] == null ? null : UserModel.fromJson(json["agent"]),
        kycData: json["kyc_data"] == null
            ? []
            : List<UsersDynamicFormSubmittedDataModel>.from(
                json["kyc_data"]!.map(
                  (x) => UsersDynamicFormSubmittedDataModel.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "agent": agent?.toJson(),
        "kyc_data": kycData == null ? [] : List<dynamic>.from(kycData!.map((x) => x.toJson())),
      };
}
