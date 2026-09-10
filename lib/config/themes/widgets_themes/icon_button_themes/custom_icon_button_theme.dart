import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

IconButtonThemeData customIconButtonTheme = IconButtonThemeData(
  style: ButtonStyle(
    elevation: WidgetStateProperty.all(.1),
    // backgroundColor: WidgetStateProperty.all<Color>(StaticColors.blue_7db),
    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
    textStyle: WidgetStateProperty.all<TextStyle>(iconButtonTextStyle),
    overlayColor: WidgetStateProperty.all<Color>(StaticColors.gray_5e5_74),
    iconSize: WidgetStateProperty.all(12),
    padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(1)),
    iconColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      return Colors.white; // Defer to the widgets's default.
    }),
    shape: iconButtonShape,
  ),
);

TextStyle iconButtonTextStyle = TextStyle(
  fontSize: AppFontSizes.size15,
  fontWeight: AppFontWeights.medium,
  color: Colors.white,
);

WidgetStateProperty<OutlinedBorder> iconButtonShape =
    WidgetStateProperty.all<RoundedRectangleBorder>(
      const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(50)),
        side: BorderSide(color: Colors.transparent),
      ),
    );
