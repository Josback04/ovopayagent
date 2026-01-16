import 'package:ovopayagent/core/data/models/user/user_model.dart';
import 'package:ovopayagent/core/helper/string_format_helper.dart';

class AuthorizationResponseModel {
  AuthorizationResponseModel({
    String? remark,
    String? status,
    List<String>? message,
    Data? data,
  }) {
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
  }

  AuthorizationResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'];
    _message = json['message'] != null ? (json['message'] as List<dynamic>).toStringList() : [];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? _remark;
  String? _status;
  List<String>? _message;
  Data? _data;

  String? get remark => _remark;
  String? get status => _status;
  List<String>? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message;
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({String? actionId, UserModel? user}) {
    _actionId = actionId;
    _user = user;
  }

  Data.fromJson(dynamic json) {
    _actionId = json['action_id'] != null ? json['action_id'].toString() : '';
    _user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    _agent = json['agent'] != null ? UserModel.fromJson(json['agent']) : null;
    _merchant = json['merchant'] != null ? UserModel.fromJson(json['merchant']) : null;
  }

  String? _actionId;
  UserModel? _user;
  UserModel? _merchant;
  UserModel? _agent;

  String? get actionId => _actionId;
  UserModel? get user => _user;
  UserModel? get agent => _agent;
  UserModel? get merchant => _merchant;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['action_id'] = _actionId;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_agent != null) {
      map['agent'] = _agent?.toJson();
    }
    if (_merchant != null) {
      map['merchant'] = _merchant?.toJson();
    }
    return map;
  }
}
