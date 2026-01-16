import 'package:get/get.dart';
import 'package:ovopayagent/app/screens/splash/controller/splash_controller.dart';
import 'package:ovopayagent/core/data/controller/localization/localization_controller.dart';

Future<void> initDependency() async {
  Get.lazyPut(() => LocalizationController());
  Get.lazyPut(() => SplashController(repo: Get.find()));
}
