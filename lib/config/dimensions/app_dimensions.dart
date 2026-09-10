import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimensions {
  static ScreenUtil screenUtil = ScreenUtil();

  static Size designSize = const Size(308, 690);
  static double? width;
  static double? height;
  static double textHeight = 1;

  static double tabletMinimumWidth = 700;
  static double get screenPadding => w(16.0);
  static double get buttonHeight => h(43);
  static double get appBarHeight => h(50);
  static double get navBarHeight => h(110);

  static double cardBorderRadius = 5;
  static double bottomSheetBorderRadius = 30;

  static double textFieldHeight(double helperTextFontSize) {
    return (58) + helperTextFontSize * textHeight;
  }

  static double h(double value) {
    return (value / designSize.height) * screenUtil.screenHeight;
  }

  static double w(double value) {
    return (value / designSize.width) * screenUtil.screenWidth;
  }

  static double fh() {
    return screenUtil.screenHeight;
  }

  static double fw() {
    return screenUtil.screenWidth;
  }

  static double deviceHeight(double mobileHeight, double tabletHeight) {
    return fw() > tabletMinimumWidth ? tabletHeight : mobileHeight;
  }

  double? availableScreenHeight(BuildContext context) {
    final Size media = MediaQuery.sizeOf(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    return (height ?? media.height) -
        (AppBar().preferredSize.height + padding.top);
  }
}
