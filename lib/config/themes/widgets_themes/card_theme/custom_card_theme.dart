import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class CustomCardTheme {
  static CardTheme getCardTheme(BuildContext context) {
    return CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        side: BorderSide(color: Colors.white, width: 1),
      ),
    );
  }
}
