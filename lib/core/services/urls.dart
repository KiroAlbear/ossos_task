class Urls {
  Urls._();
  static const String demoUrl = "";
  static const String testUrl = "";
  static const String liveUrl = "https://aspreal1.azurewebsites.net";
  static String baseUrl = liveUrl;
  static String appLanguage = "ar-eg";

  static const String getLocalizationStrings = "";

  // TODO: Replace with the real store-list endpoint.
  static const String getStores =
      "https://mocki.io/v1/879eac91-5d8f-4ef2-b746-3daa509bf21e";

  // TODO: Replace with the real products endpoint.
  static const String getProducts = 'dummyurl';

  // Supply the backend submission URL with --dart-define.
  static const String submitInventorySession = String.fromEnvironment(
    'INVENTORY_SESSION_ENDPOINT',
  );

  static String get getRegions {
    return "$baseUrl/api/mobile/regions";
  }

  static String get register {
    return "$baseUrl/api/mobile/auth/register";
  }

  static String get login {
    return "$baseUrl/api/mobile/auth/login";
  }

  static String get verifyPhoneOtp {
    return "$baseUrl/api/mobile/auth/register/verify-otp";
  }

  static String get verifyEmailOtp {
    return "$baseUrl/api/mobile/auth/register/verify-email";
  }

  static String get resendPhoneOtp {
    return "$baseUrl/api/mobile/auth/register/resend-otp";
  }

  static String get resendEmailOtp {
    return "$baseUrl/api/mobile/auth/register/resend-email";
  }
}
