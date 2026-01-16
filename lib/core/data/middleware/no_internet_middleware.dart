import 'package:get/get.dart';
import 'package:ovopayagent/core/data/middleware/app_middleware.dart';
import 'package:ovopayagent/core/route/route.dart';

class NoInetnetMiddleware implements AppMiddleware {
  @override
  void handleResponse(response) {
    if (Get.currentRoute != RouteHelper.noInternetScreen) {
      Get.offAllNamed(RouteHelper.noInternetScreen);
    }
  }
}
