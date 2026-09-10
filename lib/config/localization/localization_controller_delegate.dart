import 'package:flutter/material.dart';

import 'package:ossos_task/imports.dart';

class LocalizationControllerDelegate
    extends LocalizationsDelegate<LocalizationController> {
  const LocalizationControllerDelegate();

  @override
  bool isSupported(Locale locale) {
    return LocalizationController.supportedLocales.contains(
      Locale(locale.languageCode),
    );
  }

  @override
  Future<LocalizationController> load(Locale locale) async {
    LocalizationController localizationsController =
        LocalizationController.getInstance();
    await LocalizationController.getInstance().setup(locale);
    return localizationsController;
  }

  @override
  bool shouldReload(LocalizationControllerDelegate old) => false;
}
