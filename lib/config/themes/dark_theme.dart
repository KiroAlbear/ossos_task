import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

ThemeData darkTheme(BuildContext context) => ThemeData(
  colorScheme: ThemeData().colorScheme.copyWith(brightness: Brightness.dark),
  scaffoldBackgroundColor: StaticColors.blue_black_62e,
  textTheme: TextTheme(
    titleMedium: AppTextStyles.create(
      context,
      fontSize: AppFontSizes.size18,
      fontWeight: AppFontWeights.semiBold,
      color: GenericColors.getColors(context, GenericColors.black_03E_white),
    ),
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: StaticColors.black_f1f),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: StaticColors.orange_aia,
    selectionHandleColor: StaticColors.green_55f,
    selectionColor: StaticColors.green_55f.withOpacity(0.4),
  ),
  cardTheme: CustomCardTheme.getCardTheme(
    context,
  ).copyWith(color: StaticColors.black_858).data,
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.all<Color>(StaticColors.green_55f),
  ),
  inputDecorationTheme: CustomInputDecoration.getInputDecoration(
    context,
    brightness: Brightness.dark,
  ),
  progressIndicatorTheme: customProgressIndicatorTheme,
  elevatedButtonTheme: customElevatedButtonTheme,
  textButtonTheme: customTextButtonTheme,
  iconButtonTheme: customIconButtonTheme,
  switchTheme: customSwitchLightTheme,
  checkboxTheme: customCheckBoxDarkTheme,
);
