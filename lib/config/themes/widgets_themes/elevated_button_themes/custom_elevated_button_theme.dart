import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

ElevatedButtonThemeData customElevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    elevation: WidgetStateProperty.all(.1),
    backgroundColor: WidgetStateProperty.all<Color>(StaticColors.orange_aia),
    foregroundColor: WidgetStateProperty.all<Color>(StaticColors.black_e00),
    textStyle: WidgetStateProperty.all<TextStyle>(elevatedButtonTextStyle),
    overlayColor: WidgetStateProperty.all<Color>(StaticColors.gray_5e5_74),
    iconSize: WidgetStateProperty.all(12),
    iconColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      return Colors.white; // Defer to the widgets's default.
    }),
    shape: elevatedButtonShape,
  ),
);

TextStyle elevatedButtonTextStyle = TextStyle(
  fontSize: AppFontSizes.size15,
  fontWeight: AppFontWeights.extraBold,
  fontFamily: FontFamilyConstants.ARCHIVO,
  color: StaticColors.black_e00,
);

WidgetStateProperty<OutlinedBorder> elevatedButtonShape =
    WidgetStateProperty.all<RoundedRectangleBorder>(
      const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(14)),
        side: BorderSide(color: Colors.transparent),
      ),
    );
