import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class CustomInputDecoration {
  CustomInputDecoration._();

  static const BorderRadius _borderRadius = BorderRadius.all(
    Radius.circular(14),
  );
  static const double _borderWidth = 1;

  static InputDecorationTheme getInputDecoration(
    BuildContext context, {
    Brightness? brightness,
  }) {
    final Brightness effectiveBrightness =
        brightness ?? Theme.of(context).brightness;
    final Color borderColor = GenericColors.getColorsByBrightness(
      effectiveBrightness,
      GenericColors.textFieldBorder,
    );

    return InputDecorationTheme(

      filled: true,
      fillColor: GenericColors.getColorsByBrightness(
        effectiveBrightness,
        GenericColors.textFieldBackground,
      ),
      contentPadding: const EdgeInsets.all(14),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: _borderWidth,
          color: borderColor,
          style: BorderStyle.solid,
        ),
        borderRadius: _borderRadius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: _borderWidth,
          color: borderColor,
          style: BorderStyle.solid,
        ),
        borderRadius: _borderRadius,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: _borderWidth,
          color: borderColor,
          style: BorderStyle.solid,
        ),
        borderRadius: _borderRadius,
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: _borderWidth,
          color: StaticColors.red_808,
          style: BorderStyle.solid,
        ),
        borderRadius: _borderRadius,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: _borderWidth,
          color: borderColor,
          style: BorderStyle.solid,
        ),
        borderRadius: _borderRadius,
      ),
      errorStyle: AppTextStyles.create(
        context,
        fontSize: AppFontSizes.size12,
        fontWeight: AppFontWeights.regular,
        color: StaticColors.red_808,
      ),
      hintStyle: AppTextStyles.create(
        context,
        fontSize: AppFontSizes.size14,
        fontWeight: AppFontWeights.medium,
        color: GenericColors.getColorsByBrightness(
          effectiveBrightness,
          GenericColors.textFieldHint,
        ),
      ),
      counterStyle: const TextStyle(fontSize: 0, height: 0),
      helperStyle: AppTextStyles.create(
        context,
        fontSize: AppFontSizes.size15,
        fontWeight: AppFontWeights.regular,
        color: Colors.black,
      ),
    );
  }
}
