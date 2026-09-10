import 'package:flutter/material.dart';

class CustomCardTheme {
  static CardTheme getCardTheme(BuildContext context) {
    return CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: Colors.white, width: 1),
      ),
    );
  }
}
