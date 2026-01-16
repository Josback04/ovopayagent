import 'package:ovopayagent/core/data/models/global/response_model/response_model.dart';

import '../../../../utils/util_exporter.dart';
import '../../../services/service_exporter.dart';

class CashInRepo {
  Future<ResponseModel> checkUserExist({String usernameOrPhone = ""}) async {
    Map<String, String> params = {'user': usernameOrPhone};
    String url = '${UrlContainer.baseUrl}${UrlContainer.userExistEndPoint}';
    final response = await ApiService.postRequest(url, params);
    return response;
  }

  Future<ResponseModel> cashInInfoData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.cashInEndPoint}';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> cashInRequest({
    String amount = "",
    String user = "",
    String pin = "",
    String otpType = "",
  }) async {
    Map<String, String> params = {
      'amount': amount,
      'user': user,
      'pin': pin,
      'otp_type': otpType,
    };
    String url = '${UrlContainer.baseUrl}${UrlContainer.cashInSubmitEndPoint}';
    final response = await ApiService.postRequest(url, params);
    return response;
  }

  Future<ResponseModel> cashInHistory(int page) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.cashInHistoryEndPoint}?page=$page';
    final response = await ApiService.getRequest(url);
    return response;
  }
}
