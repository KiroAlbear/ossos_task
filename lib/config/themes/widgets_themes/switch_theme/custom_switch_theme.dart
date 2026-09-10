import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

SwitchThemeData customSwitchLightTheme = SwitchThemeData(
  splashRadius: 10.0,
  // trackOutlineWidth: MaterialStateProperty.all<double>(22.0),
  thumbColor: WidgetStateProperty.all<Color>(Colors.white),
  trackColor: WidgetStateProperty.resolveWith(
    (Set<WidgetState> states) => states.contains(MaterialState.selected)
        ? StaticColors.green_55f
        : StaticColors.gray_3f5,
  ),
);
