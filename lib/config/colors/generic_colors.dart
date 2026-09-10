import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class LightDarkColor {
  final Color lightColor;
  final Color darkColor;
  LightDarkColor({required this.lightColor, required this.darkColor});
}

class GenericColors {
  GenericColors._();

  static String black_white = "black_white";
  static String white_orange_aia = "white_orange_aia";
  static String orange_aia_white = "orange_aia_white";
  static String gray_lightGray = "gray_lightGray";
  static String black_03E_white = "black_03E_white";
  static String orange_aia_orange_aia = "orange_aia_orange_aia";
  static String blackE00BlackE00 = "blackE00BlackE00";
  static String blue148_white = "blue148_white";
  static String blue148Opacity36Blue148Opacity36 =
      "blue148Opacity36Blue148Opacity36";
  static String white_blue148 = "white_blue148";
  static String white_blueC33_scaffold_background =
      "white_blueC33_scaffold_background";
  static String blue148_opacity38_white_opacity36 =
      "blue148_opacity38_white_opacity38";

  static String blue148_opacity36_grey_e00_opacity55 =
      "blue148_opacity38_grey_e00_opacity55";

  static String blue148_opacity64_white_opacity68 =
      "blue148_opacity64_white_opacity68";
  static String textFieldBackground = "textFieldBackground";
  static String textFieldBorder = "textFieldBorder";
  static String textFieldHint = "textFieldHint";

  static final Map<String, LightDarkColor> _lightDarkColorsMap =
      <String, LightDarkColor>{
        black_white: LightDarkColor(
          lightColor: Colors.black,
          darkColor: Colors.white,
        ),
        black_03E_white: LightDarkColor(
          lightColor: StaticColors.blue_03e,
          darkColor: StaticColors.white,
        ),
        gray_lightGray: LightDarkColor(
          lightColor: StaticColors.gray_808,
          darkColor: StaticColors.gray_b1b,
        ),
        white_orange_aia: LightDarkColor(
          lightColor: Colors.white,
          darkColor: StaticColors.orange_aia,
        ),
        orange_aia_white: LightDarkColor(
          lightColor: StaticColors.orange_aia,
          darkColor: StaticColors.white,
        ),
        orange_aia_orange_aia: LightDarkColor(
          lightColor: StaticColors.orange_aia,
          darkColor: StaticColors.orange_aia,
        ),
        blackE00BlackE00: LightDarkColor(
          lightColor: StaticColors.black_e00,
          darkColor: StaticColors.black_e00,
        ),

        blue148_white: LightDarkColor(
          lightColor: StaticColors.blue_148,
          darkColor: StaticColors.white,
        ),

        white_blueC33_scaffold_background: LightDarkColor(
          lightColor: StaticColors.white,
          darkColor: StaticColors.blue_c33,
        ),

        blue148Opacity36Blue148Opacity36: LightDarkColor(
          lightColor: StaticColors.blue148Opacity36,
          darkColor: StaticColors.blue148Opacity36,
        ),
        white_blue148: LightDarkColor(
          lightColor: StaticColors.white,
          darkColor: StaticColors.blue_148,
        ),

        blue148_opacity38_white_opacity36: LightDarkColor(
          lightColor: StaticColors.blue_148_opactiy36,
          darkColor: StaticColors.white_opacity38,
        ),
        blue148_opacity36_grey_e00_opacity55: LightDarkColor(
          lightColor: StaticColors.blue_148_opactiy36,
          darkColor: StaticColors.grey_e00_opacity55,
        ),
        blue148_opacity64_white_opacity68: LightDarkColor(
          lightColor: StaticColors.blue_148_opactiy64,
          darkColor: StaticColors.white_opacity68,
        ),
        textFieldBackground: LightDarkColor(
          lightColor: StaticColors.textFieldLightBackground,
          darkColor: StaticColors.textFieldDarkBackground,
        ),
        textFieldBorder: LightDarkColor(
          lightColor: StaticColors.textFieldLightBorder,
          darkColor: StaticColors.textFieldDarkBorder,
        ),
        textFieldHint: LightDarkColor(
          lightColor: StaticColors.textFieldLightHint,
          darkColor: StaticColors.textFieldDarkHint,
        ),
      };

  static Color getColors(BuildContext context, String colorKey) {
    return getColorsByBrightness(Theme.of(context).brightness, colorKey);
  }

  static Color getColorsByBrightness(Brightness brightness, String colorKey) {
    if (brightness == Brightness.dark) {
      return _lightDarkColorsMap[colorKey]!.darkColor;
    } else {
      return _lightDarkColorsMap[colorKey]!.lightColor;
    }
  }
}
