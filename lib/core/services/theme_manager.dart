import 'package:flutter/material.dart';
import 'package:ossos_task/core/services/secure_storage/secure_storage_keys.dart';

import 'secure_storage/secure_storage_manager.dart';

class ThemeManager {
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static Future<void> initTheme() async {
    // ThemeMode themeMode =
    //     await SecureStorageManager.getInstance().getValue(
    //   SecureStorageKeys.themeModeKey,
    // ) ==
    //     ThemeMode.dark.index.toString()
    //     ? ThemeMode.dark
    //     : ThemeMode.light;
    _setThemeValues(ThemeMode.dark);
  }

  static Future<void> setThemeMode(ThemeMode value) async {
    _setThemeValues(value);
    await SecureStorageManager.getInstance().setValue(
      SecureStorageKeys.themeModeKey,
      value.index.toString(),
    );
  }

  static void _setThemeValues(ThemeMode value) {
    themeModeNotifier.value = value;
  }

  static bool isDarkMode(BuildContext context) {
    return themeModeNotifier.value == ThemeMode.dark;
  }
}
