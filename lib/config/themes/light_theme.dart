import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

ThemeData lightTheme(BuildContext context) => ThemeData(
  colorScheme: ThemeData().colorScheme.copyWith(brightness: Brightness.light),
  scaffoldBackgroundColor: StaticColors.white_7f4,
  textTheme: TextTheme(
    titleMedium: AppTextStyles.create(
      context,
      fontSize: AppFontSizes.size18,
      fontWeight: AppFontWeights.semiBold,
      color: GenericColors.getColors(context, GenericColors.black_03E_white),
    ),
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: StaticColors.gray_5e5),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: StaticColors.orange_aia,
    selectionHandleColor: StaticColors.orange_aia,
    selectionColor: StaticColors.orange_aia.withOpacity(0.4),
  ),
  cardTheme: CustomCardTheme.getCardTheme(
    context,
  ).copyWith(color: StaticColors.black_858).data,
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all<Color>(StaticColors.orange_aia),
  ),
  inputDecorationTheme: CustomInputDecoration.getInputDecoration(
    context,
    brightness: Brightness.light,
  ),
  progressIndicatorTheme: customProgressIndicatorTheme,
  elevatedButtonTheme: customElevatedButtonTheme,
  textButtonTheme: customTextButtonTheme,
  iconButtonTheme: customIconButtonTheme,
  switchTheme: customSwitchLightTheme,
  checkboxTheme: customCheckBoxLightTheme,
);
