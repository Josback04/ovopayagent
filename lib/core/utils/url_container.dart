import 'package:ovopayagent/environment.dart';

class UrlContainer {
  static const String domainUrl = Environment.MAIN_API_URL;
  static const String baseUrl = '$domainUrl/api/';

  static const String socialLoginEndPoint = 'agent/social-login';
  static const String dashBoardEndPoint = 'agent/dashboard';

  static const String accountDisable = 'agent/delete-account';

  static const String notificationEndPoint = 'agent/push-notifications';
  static const String notificationSettingsEndPoint = 'agent/notification/settings';

  static const String authenticationEndPoint = 'agent/authentication';
  static const String logoutUrl = 'agent/logout';
  static const String deleteAccountEndPoint = 'agent/delete-account';

  static const String forgetPasswordEndPoint = 'agent/password/mobile';
  static const String passwordVerifyEndPoint = 'agent/password/verify-code';
  static const String resetPasswordEndPoint = 'agent/password/reset';
  static const String verify2FAUrl = 'agent/verify-g2fa';

  static const String otpVerify = 'agent/otp-verify';
  static const String otpResend = 'agent/otp-resend';

  static const String verifyEmailEndPoint = 'agent/verify-email';
  static const String verifySmsEndPoint = 'agent/verify-mobile';
  static const String resendVerifyCodeEndPoint = 'agent/resend-verify/';
  static const String authorizationCodeEndPoint = 'agent/authorization';

  static const String dashBoardUrl = 'agent/dashboard';
  static const String transactionEndpoint = 'agent/transactions';
  static const String statementsEndpoint = 'agent/statements';

  static const String addWithdrawRequestUrl = 'agent/withdraw-request';
  static const String withdrawMethodUrl = 'agent/withdraw-method';
  static const String withdrawRequestConfirm = 'agent/withdraw-request/confirm';
  static const String withdrawHistoryUrl = 'agent/withdraw/history';

  static const String withdrawStoreUrl = 'agent/withdraw/store/';
  static const String withdrawConfirmScreenUrl = 'agent/withdraw/preview/';
  static const String withdrawSavedAccountStoreUrl = 'agent/withdraw/account/save-data';
  static const String withdrawSavedAccountDeleteUrl = 'agent/withdraw/account/delete';

  static const String kycFormUrl = 'agent/kyc-form';
  static const String kycSubmitUrl = 'agent/kyc-submit';
  static const String agentVerificationFormUrl = 'agent/verification-form';
  static const String agentVerificationFormSubmitUrl = 'agent/verification-submit';

  static const String generalSettingEndPoint = 'general-setting';
  static const String moduleSettingEndPoint = 'module-setting';
  static const String privacyPolicyEndPoint = 'policies';
  static const String faqEndPoint = 'faq';

  static const String getProfileEndPoint = 'agent/user-info';
  static const String updateProfileEndPoint = 'agent/profile-setting';
  static const String profileCompleteEndPoint = 'agent/data-submit';

  static const String changePasswordEndPoint = 'agent/change-password';
  static const String countryEndPoint = 'get-countries';

  static const String deviceTokenEndPoint = 'agent/add-device-token';
  static const String languageUrl = 'language/';

  static const String twoFactor = 'agent/twofactor';
  static const String twoFactorEnable = 'agent/twofactor/enable';
  static const String twoFactorDisable = 'agent/twofactor/disable';

  static const String communityGroupsEndPoint = 'agent/community-groups';
  static const String pinValidate = 'agent/pin/validate';

  static const String supportMethodsEndPoint = 'agent/support/method';
  static const String supportListEndPoint = 'agent/ticket';
  static const String storeSupportEndPoint = 'agent/ticket/create';
  static const String supportViewEndPoint = 'agent/ticket/view';
  static const String supportReplyEndPoint = 'agent/ticket/reply';
  static const String supportCloseEndPoint = 'agent/ticket/close';
  static const String supportDownloadEndPoint = 'agent/ticket/download';
  static const String countryFlagImageLink = 'https://flagpedia.net/data/flags/h24/{countryCode}.webp';

  //Qr Code
  static const String myQrCodeEndPoint = 'agent/qr-code';
  static const String myQrCodeDownloadEndPoint = 'agent/qr-code/download';
  static const String myQrCodeRemoveEndPoint = 'agent/qr-code/remove';
  static const String qrCodeScanEndPoint = 'agent/qr-code/scan';
  static const String qrCodeLoginEndPoint = 'agent/login-with/qr-code';

  static const String userExistEndPoint = 'agent/check-user';
  static const String merchantExistEndPoint = 'agent/merchant/exist';

  //Module
  ///Add Money
  static const String depositHistoryUrl = 'agent/add-money/history';
  static const String depositMethodUrl = 'agent/add-money/methods';
  static const String depositInsertUrl = 'agent/add-money/insert';

  ///Add Money End

  ///Make Payment
  static const String makePaymentEndPoint = 'agent/make-payment';
  static const String makePaymentHistoryEndPoint = 'agent/make-payment/history';

  ///Make Payment End
  ///Cash IN
  static const String cashInEndPoint = 'agent/cash-in/create';
  static const String cashInSubmitEndPoint = 'agent/cash-in/submit';
  static const String cashInHistoryEndPoint = 'agent/cash-in/history';
  //Cash IN End

  static const String supportImagePath = '$domainUrl/assets/support/';
  static const String languageImagePath = '$domainUrl/assets/images/language/';
  static const String withDrawImagePath = '$domainUrl/assets/images/withdraw_method/';
  static const String userImagePath = '$domainUrl/assets/images/user/profile/';
  static const String agentImagePath = '$domainUrl/assets/images/agent/profile/';
  static const String merchantImagePath = '$domainUrl/assets/images/merchant/profile/';
  static const String maintenanceImagePath = '$domainUrl/assets/images/maintenance/';
}
