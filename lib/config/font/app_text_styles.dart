import 'package:flutter/material.dart';

import '../colors/generic_colors.dart';
import 'app_font_weights.dart';
import 'font_family_constants.dart';

export 'font_family_constants.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle create(
    BuildContext context, {
    Color? color,
    double? height,
    double? fontSize,
    FontWeight fontWeight = AppFontWeights.regular,
    TextDecoration? decoration,
    String fontFamily = FontFamilyConstants.INTER,
  }) {
    return TextStyle(
      color:
          color ?? GenericColors.getColors(context, GenericColors.black_white),
      fontSize: fontSize,
      height: height ?? 1,
      fontFamily: fontFamily,
      decoration: decoration,
      decorationColor: color,
      fontWeight: fontWeight,
      overflow: TextOverflow.ellipsis,
    );
  }
}
