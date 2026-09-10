import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

TextButtonThemeData customTextButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    elevation: WidgetStateProperty.all(.1),
    // backgroundColor: WidgetStateProperty.all<Color>(StaticColors.blue_7db),
    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
    textStyle: WidgetStateProperty.all<TextStyle>(textButtonTextStyle),
    overlayColor: WidgetStateProperty.all<Color>(StaticColors.gray_5e5_74),
    iconSize: WidgetStateProperty.all(12),
    padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(1)),
    iconColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      return Colors.white; // Defer to the widgets's default.
    }),
    shape: testButtonShape,
  ),
);

TextStyle textButtonTextStyle = TextStyle(
  fontSize: AppFontSizes.size15,
  fontWeight: AppFontWeights.medium,
  color: Colors.white,
);

WidgetStateProperty<OutlinedBorder> testButtonShape =
    WidgetStateProperty.all<RoundedRectangleBorder>(
      const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
        side: BorderSide(color: Colors.transparent),
      ),
    );
