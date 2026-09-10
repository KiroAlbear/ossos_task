class AppConfigs {
  static const DEV_ENVIRONMENT_ENUM DEV_ENVIRONMENT = DEV_ENVIRONMENT_ENUM.TEST;

  static bool isProductionEnv() {
    return AppConfigs.DEV_ENVIRONMENT == DEV_ENVIRONMENT_ENUM.PRODUCTION;
  }
}

// ignore: camel_case_types
enum DEV_ENVIRONMENT_ENUM { TEST, PRODUCTION }
