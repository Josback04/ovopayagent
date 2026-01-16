import 'package:get/get.dart';
import 'package:ovopayagent/app/components/preview_image.dart';
import 'package:ovopayagent/app/screens/add_money/views/add_money_history_screen.dart';
import 'package:ovopayagent/app/screens/add_money/views/add_money_webview/my_webview_screen.dart';
import 'package:ovopayagent/app/screens/add_money/views/add_money_screen.dart';
import 'package:ovopayagent/app/screens/auth/biometric/setup_biometric_screen.dart';
import 'package:ovopayagent/app/screens/auth/email_verification_page/views/email_verification_screen.dart';
import 'package:ovopayagent/app/screens/auth/forget_pin/views/forget_pin_screen.dart';
import 'package:ovopayagent/app/screens/auth/kyc/views/kyc_screen.dart';
import 'package:ovopayagent/app/screens/auth/login/views/login_screen.dart';
import 'package:ovopayagent/app/screens/auth/register/views/register_screen.dart';
import 'package:ovopayagent/app/screens/cash_in_screen_screen/views/cash_in_history_screen.dart';
import 'package:ovopayagent/app/screens/cash_in_screen_screen/views/cash_in_screen.dart';
import 'package:ovopayagent/app/screens/dashboard_screen/views/dashboard_screen.dart';
import 'package:ovopayagent/app/screens/faq/views/faq_screen.dart';
import 'package:ovopayagent/app/screens/inbox_screen/view/inbox_screen.dart';
import 'package:ovopayagent/app/screens/language/language_screen.dart';
import 'package:ovopayagent/app/screens/my_qr_code_screen/views/my_qr_code_screen.dart';
import 'package:ovopayagent/app/screens/my_qr_code_screen/views/qr_code_login_screen.dart';
import 'package:ovopayagent/app/screens/my_qr_code_screen/views/scan_qr_code_screen.dart';
import 'package:ovopayagent/app/screens/no_internet/no_internet_screen.dart';
import 'package:ovopayagent/app/screens/onboard/views/onboard_screen.dart';
import 'package:ovopayagent/app/screens/page_content_screen/views/maintenance_content_screen.dart';
import 'package:ovopayagent/app/screens/page_content_screen/views/page_content_screen.dart';
import 'package:ovopayagent/app/screens/profile_and_settings_screen/views/app_preferences_screen.dart';
import 'package:ovopayagent/app/screens/profile_and_settings_screen/views/change_pin_screen.dart';
import 'package:ovopayagent/app/screens/profile_and_settings_screen/views/delete_account_screen.dart';
import 'package:ovopayagent/app/screens/profile_and_settings_screen/views/notification_settings_screen.dart';
import 'package:ovopayagent/app/screens/profile_and_settings_screen/views/privacy_screen.dart';
import 'package:ovopayagent/app/screens/profile_and_settings_screen/views/profile_edit_screen.dart';
import 'package:ovopayagent/app/screens/profile_and_settings_screen/views/profile_information_screen.dart';
import 'package:ovopayagent/app/screens/profile_and_settings_screen/views/security_screen.dart';
import 'package:ovopayagent/app/screens/splash/views/splash_screen.dart';
import 'package:ovopayagent/app/screens/support_ticket/views/support_ticket_list_screen/support_ticket_list_screen.dart';
import 'package:ovopayagent/app/screens/support_ticket/views/new_ticket_screen/new_ticket_screen.dart';
import 'package:ovopayagent/app/screens/support_ticket/views/ticket_details_screen/ticket_details_screen.dart';
import 'package:ovopayagent/app/screens/two_factor/two_factor_setup_screen/two_factor_setup_screen.dart';
import 'package:ovopayagent/app/screens/two_factor/two_factor_verification_screen/two_factor_verification_screen.dart';
import 'package:ovopayagent/app/screens/withdraw_money/views/withdraw_money_add_new_account_screen.dart';
import 'package:ovopayagent/app/screens/withdraw_money/views/withdraw_money_edit_account_screen.dart';
import 'package:ovopayagent/app/screens/withdraw_money/views/withdraw_money_history_screen.dart';
import 'package:ovopayagent/app/screens/withdraw_money/views/withdraw_money_screen.dart';
import 'package:ovopayagent/core/data/models/user/user_model.dart';
import 'package:ovopayagent/core/data/services/service_exporter.dart';
import 'package:ovopayagent/core/utils/url_container.dart';

class RouteHelper {
  // Route names
  static const String splashScreen = "/splash_screen";
  static const String onboardScreen = "/onboard_screen";
  static const String loginScreen = "/login_screen";
  static const String registrationScreen = "/registration_screen";
  static const String dashboardScreen = "/dashboard_screen";
  static const String inboxScreen = "/inbox_screen";
  //Auth
  static const String forgotPinScreen = "/forgot_pin_screen";
  static const String pinChangeScreen = "/pin_change_screen";

  // Additional screens
  static const String emailVerificationScreen = "/verify_email_screen";
  static const String twoFactorScreen = "/two-factor-screen";
  static const String twoFactorSetupScreen = "/two-factor-setup-screen";
  // Other routes...
  static const String profileInformationScreen = "/profile_information_screen";
  static const String profileEditScreen = "/profile_edit_screen";
  static const String deleteAccountScreen = "/delete_account_screen";
  static const String myQrCodeScreen = "/my_qr_code_screen";
  static const String scanQrCodeScreen = "/scan_qr_code_screen";
  static const String qrCodeLoginScreen = "/qr_code_login_screen";
  static const String securityScreen = "/security_screen";
  static const String notificationSettingsScreen = "/notification_settings_screen";
  static const String privacyScreen = "/privacy_screen";
  static const String pageContentScreen = "/page_content_screen";
  static const String appPreferencesScreen = "/app_preferences_screen";
  static const String kycScreen = "/kyc_screen";
  static const String faqScreen = "/faq-screen";
  static const String maintenanceScreen = "/maintenance-screen";
  static const String languageScreen = "/language-screen";
  static const String setupBioMetricScreen = "/setup_biometric_screen";
  //Support ticket
  static const String supportTicketScreen = '/all_ticket_screen';
  static const String ticketDetailsScreen = '/ticket_details_screen';
  static const String newTicketScreen = '/new_ticket_screen';
  static const String previewImageScreen = "/preview-image-screen";
  static const String noInternetScreen = "/no_internet_screen";

  //Module

  static const String cashInScreen = "/cash_in_screen";
  static const String cashInHistoryScreen = "/cash_in_history_screen";

  static const String addMoneyScreen = "/add_money_screen";
  static const String addMoneyWebViewScreen = '/add_money_webView';
  static const String addMoneyHistoryScreen = "/add_money_history_screen";
  static const String withdrawMoneyScreen = "/withdraw_money_screen";
  static const String withdrawMoneyHistoryScreen = "/withdraw_money_history_screen";
  static const String withdrawMoneyAddNewAccountScreen = "/withdraw_money_add_new_account_screen";
  static const String withdrawMoneyEditAccountScreen = "/withdraw_money_edit_account_screen";

  // Define your routes
  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboardScreen,
      page: () => const OnboardScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: registrationScreen,
      page: () => RegisterScreen(
        userModel: Get.arguments != null ? Get.arguments as UserModel : null,
      ),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: forgotPinScreen,
      page: () => const ForgotPinScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.rightToLeftWithFade,
    ),
    //Home Auth
    GetPage(
      name: dashboardScreen,
      page: () => const DashboardScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profileInformationScreen,
      page: () => const ProfileInformationScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profileEditScreen,
      page: () => ProfileEditScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: myQrCodeScreen,
      page: () => MyQrCodeScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: scanQrCodeScreen,
      page: () => ScanQrCodeScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: qrCodeLoginScreen,
      page: () => QrCodeLoginScreen(scanSubTitle: Get.arguments),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: pinChangeScreen,
      page: () => const ChangPineScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: deleteAccountScreen,
      page: () => const DeleteAccountScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: securityScreen,
      page: () => const SecurityScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: notificationSettingsScreen,
      page: () => const NotificationSettingsScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: privacyScreen,
      page: () => const PrivacyScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: maintenanceScreen,
      page: () => const MaintenanceContentScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: noInternetScreen,
      page: () => const NoInterNetScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: appPreferencesScreen,
      page: () => const AppPreferencesScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: languageScreen,
      page: () => const LanguageScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: inboxScreen,
      page: () => InboxScreen(isTransaction: Get.arguments ?? true),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: pageContentScreen,
      page: () => const PageContentScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: emailVerificationScreen,
      page: () => const EmailVerificationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: twoFactorSetupScreen,
      page: () => const TwoFactorSetupScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: setupBioMetricScreen,
      page: () => SetupFingerPrintScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: twoFactorScreen,
      page: () => const TwoFactorVerificationScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: kycScreen,
      page: () => const KycScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),

    //TICKET
    GetPage(
      name: supportTicketScreen,
      page: () => const SupportTicketListScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: ticketDetailsScreen,
      page: () => const TicketDetailsScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: newTicketScreen,
      page: () => const NewTicketScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: previewImageScreen,
      page: () => PreviewImage(url: Get.arguments),
    ),
    //TICKET END
    GetPage(
      name: faqScreen,
      page: () => const FaqScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.rightToLeft,
    ),
    //Modules

    //Cash out
    GetPage(
      name: cashInScreen,
      transitionDuration: const Duration(milliseconds: 400),
      page: () => CashInScreen(toUserInformation: Get.arguments),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cashInHistoryScreen,
      transitionDuration: const Duration(milliseconds: 400),
      page: () => const CashInHistoryScreen(),
      transition: Transition.fadeIn,
    ),

    //Add money
    GetPage(
      name: addMoneyScreen,
      transitionDuration: const Duration(milliseconds: 400),
      page: () => const AddMoneyScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addMoneyWebViewScreen,
      // transitionDuration: const Duration(milliseconds: 400),
      page: () {
        var arguments = Get.arguments as List?;
        return MyWebViewScreen(
          redirectUrl: arguments != null && arguments.isNotEmpty ? arguments[0] : "",
          successUrl: arguments != null && arguments.length > 1 ? arguments[1] : "",
          failedUrl: arguments != null && arguments.length > 2 ? arguments[2] : "",
        );
      },
      // transition: Transition.fadeIn,
    ),

    GetPage(
      name: addMoneyHistoryScreen,
      page: () => const AddMoneyHistoryScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    //Withdraw money
    GetPage(
      name: withdrawMoneyScreen,
      transitionDuration: const Duration(milliseconds: 400),
      page: () => const WithdrawMoneyScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: withdrawMoneyHistoryScreen,
      page: () => const WithdrawMoneyHistoryScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: withdrawMoneyAddNewAccountScreen,
      page: () => const WithdrawMoneyAddAccountScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: withdrawMoneyEditAccountScreen,
      page: () => WithdrawMoneyEditAccountScreen(accountId: Get.arguments),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
  ];

  static Future<void> checkUserStatusAndGoToNextStep(
    UserModel? user, {
    bool isRemember = true,
    String accessToken = "",
    String tokenType = "",
  }) async {
    bool needEmailVerification = user?.ev == "1" ? false : true;
    bool needSmsVerification = user?.sv == '1' ? false : true;
    bool isTwoFactorEnable = user?.tv == '1' ? false : true;
    bool isNeedKycVerification = user?.kv == '1' ? false : true;
    bool isNeedProfileCompleteEnable = user?.profileComplete == '0' ? true : false;

    if (isRemember) {
      await SharedPreferenceService.setRememberMe(true);
    } else {
      await SharedPreferenceService.setRememberMe(false);
    }

    await SharedPreferenceService.setString(
      SharedPreferenceService.userEmailKey,
      user?.email ?? '',
    );
    await SharedPreferenceService.setString(
      SharedPreferenceService.userPhoneNumberKey,
      user?.mobile ?? '',
    );
    await SharedPreferenceService.setString(
      SharedPreferenceService.userNameKey,
      user?.username ?? '',
    );
    await SharedPreferenceService.setString(
      SharedPreferenceService.userIdKey,
      user?.id.toString() ?? '-1',
    );
    await SharedPreferenceService.setString(
      SharedPreferenceService.userFullNameKey,
      user?.getFullName() ?? '',
    );

    String imageUrl = "";
    var imageData = user?.image == null ? '' : '${user?.image}';

    if (imageData.isNotEmpty && imageData != 'null') {
      imageUrl = '${UrlContainer.agentImagePath}$imageData';
    }

    await SharedPreferenceService.setString(
      SharedPreferenceService.userImageKey,
      imageUrl,
    );

    if (accessToken.isNotEmpty) {
      await SharedPreferenceService.setString(
        SharedPreferenceService.accessTokenKey,
        accessToken,
      );
      await SharedPreferenceService.setString(
        SharedPreferenceService.accessTokenType,
        tokenType,
      );
      await PushNotificationService().sendUserToken();
      SharedPreferenceService.setIsLoggedIn(true);
    }

    String targetRoute = '';

    if (isNeedProfileCompleteEnable || needSmsVerification) {
      targetRoute = RouteHelper.registrationScreen;
    } else if (needEmailVerification) {
      targetRoute = RouteHelper.emailVerificationScreen;
    } else if (isTwoFactorEnable) {
      targetRoute = RouteHelper.twoFactorScreen;
    } else if (isNeedKycVerification) {
      targetRoute = RouteHelper.kycScreen;
    } else {
      targetRoute = RouteHelper.dashboardScreen;
      Get.offAllNamed(targetRoute, arguments: [true]);
      return; // Exit early if going to the dashboard
    }
    // Check and navigate if current route is different
    if (Get.currentRoute != targetRoute) {
      Get.offAllNamed(targetRoute, arguments: user);
    }
  }
}
