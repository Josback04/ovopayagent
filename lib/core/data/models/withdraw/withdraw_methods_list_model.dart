// To parse this JSON data, do
//
//     final withdrawMethodsListResponseModel = withdrawMethodsListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopayagent/core/data/models/global/formdata/dynamic_fom_submitted_value_model.dart';
import 'package:ovopayagent/core/data/models/global/formdata/dynamic_forms_map.dart';
import 'package:ovopayagent/core/data/models/user/user_model.dart';
import 'package:ovopayagent/core/utils/url_container.dart';

WithdrawMethodsListResponseModel withdrawMethodsListResponseModelFromJson(
  String str,
) =>
    WithdrawMethodsListResponseModel.fromJson(json.decode(str));

String withdrawMethodsListResponseModelToJson(
  WithdrawMethodsListResponseModel data,
) =>
    json.encode(data.toJson());

class WithdrawMethodsListResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  WithdrawMethodsListResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory WithdrawMethodsListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      WithdrawMethodsListResponseModel(
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
  List<WithdrawMethod>? withdrawMethods;
  List<String>? otpType;
  UserModel? agent;
  String? balance;
  Data({this.withdrawMethods, this.otpType, this.agent, this.balance});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        withdrawMethods: json["withdraw_methods"] == null
            ? []
            : List<WithdrawMethod>.from(
                json["withdraw_methods"]!.map((x) => WithdrawMethod.fromJson(x)),
              ),
        otpType: json["otp_type"] == null ? [] : List<String>.from(json["otp_type"]!.map((x) => x)),
        agent: json["agent"] == null ? null : UserModel.fromJson(json["agent"]),
        balance: json["balance"]?.toString() ?? '0.0',
      );

  Map<String, dynamic> toJson() => {
        "withdraw_methods": withdrawMethods == null ? [] : List<dynamic>.from(withdrawMethods!.map((x) => x.toJson())),
        "otp_type": otpType == null ? [] : List<dynamic>.from(otpType!.map((x) => x)),
        "agent": agent?.toJson(),
        "balance": balance,
      };

  double getCurrentBalance() {
    try {
      return double.tryParse(balance.toString()) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}

class WithdrawMethod {
  int? id;
  String? formId;
  String? name;
  String? image;
  String? minLimit;
  String? maxLimit;
  String? fixedCharge;
  String? rate;
  String? percentCharge;
  String? merchantFixedCharge;
  String? merchantPercentCharge;
  String? merchantMinLimit;
  String? merchantMaxLimit;
  String? currency;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<SaveAccountModel>? saveAccounts;
  DynamicFormsMap? form;
  WithdrawMethod({
    this.id,
    this.formId,
    this.name,
    this.image,
    this.minLimit,
    this.maxLimit,
    this.fixedCharge,
    this.rate,
    this.percentCharge,
    this.merchantFixedCharge,
    this.merchantPercentCharge,
    this.merchantMinLimit,
    this.merchantMaxLimit,
    this.currency,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.saveAccounts,
    this.form,
  });

  factory WithdrawMethod.fromJson(Map<String, dynamic> json) => WithdrawMethod(
        id: json["id"],
        formId: json["form_id"]?.toString(),
        name: json["name"]?.toString(),
        image: json["image"]?.toString(),
        minLimit: json["min_limit"]?.toString(),
        maxLimit: json["max_limit"]?.toString(),
        fixedCharge: json["fixed_charge"]?.toString(),
        rate: json["rate"]?.toString(),
        percentCharge: json["percent_charge"]?.toString(),
        merchantFixedCharge: json["merchant_fixed_charge"]?.toString(),
        merchantPercentCharge: json["merchant_percent_charge"]?.toString(),
        merchantMinLimit: json["merchant_min_limit"]?.toString(),
        merchantMaxLimit: json["merchant_max_limit"]?.toString(),
        currency: json["currency"]?.toString(),
        description: json["description"]?.toString(),
        status: json["status"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        saveAccounts: json["save_accounts"] == null
            ? []
            : List<SaveAccountModel>.from(
                json["save_accounts"]!.map((x) => SaveAccountModel.fromJson(x)),
              ),
        form: json["form"] == null ? null : DynamicFormsMap.fromJson(json["form"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "form_id": formId,
        "name": name,
        "image": image,
        "min_limit": minLimit,
        "max_limit": maxLimit,
        "fixed_charge": fixedCharge,
        "rate": rate,
        "percent_charge": percentCharge,
        "merchant_fixed_charge": merchantFixedCharge,
        "merchant_percent_charge": merchantPercentCharge,
        "merchant_min_limit": merchantMinLimit,
        "merchant_max_limit": merchantMaxLimit,
        "currency": currency,
        "description": description,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "save_accounts": saveAccounts == null ? [] : List<dynamic>.from(saveAccounts!.map((x) => x.toJson())),
        "form": form?.toJson(),
      };

  String? getImageUrl() {
    if (image == null) {
      return null;
    } else {
      var imageUrl = '${UrlContainer.withDrawImagePath}/$image';
      return imageUrl;
    }
  }
}

class SaveAccountModel {
  int? id;
  String? name;
  String? agentId;
  String? merchantId;
  String? withdrawMethodId;
  List<UsersDynamicFormSubmittedDataModel>? data;
  String? createdAt;
  String? updatedAt;

  SaveAccountModel({
    this.id,
    this.name,
    this.agentId,
    this.merchantId,
    this.withdrawMethodId,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  factory SaveAccountModel.fromJson(Map<String, dynamic> json) => SaveAccountModel(
        id: json["id"],
        name: json["name"]?.toString(),
        agentId: json["agent_id"]?.toString(),
        merchantId: json["merchant_id"]?.toString(),
        withdrawMethodId: json["withdraw_method_id"]?.toString(),
        data: json["data"] == null
            ? []
            : List<UsersDynamicFormSubmittedDataModel>.from(
                json["data"]!.map(
                  (x) => UsersDynamicFormSubmittedDataModel.fromJson(x),
                ),
              ),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "agent_id": agentId,
        "merchant_id": merchantId,
        "withdraw_method_id": withdrawMethodId,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
