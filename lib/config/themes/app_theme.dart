import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

ThemeData appTheme(ThemeMode? mode, BuildContext context) =>
    _appTheme(mode, context);

ThemeData _appTheme(ThemeMode? mode, BuildContext context) {
  if (mode == ThemeMode.light) {
    return lightTheme(context);
  } else if (mode == ThemeMode.dark) {
    return darkTheme(context);
  } else if (mode == ThemeMode.system &&
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark) {
    return darkTheme(context);
  } else {
    return lightTheme(context);
  }
}
