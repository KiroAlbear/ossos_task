import 'package:flutter/material.dart';

import 'app_font_sizes.dart';
import 'app_font_weights.dart';
import 'app_text_styles.dart';

abstract final class AppTypography {
  static TextStyle archivo28Bold(BuildContext context, {Color? color}) {
    return AppTextStyles.create(
      context,
      color: color,
      fontSize: AppFontSizes.size28,
      fontWeight: AppFontWeights.extraBold,
      fontFamily: FontFamilyConstants.ARCHIVO,
    );
  }
}
