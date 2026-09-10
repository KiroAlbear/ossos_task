import 'package:flutter/material.dart';

class WidgetThemeSwitcher extends StatelessWidget {
  final Widget lightWidget;
  final Widget darkWidget;
  const WidgetThemeSwitcher({
    super.key,
    required this.lightWidget,
    required this.darkWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightWidget
        : darkWidget;
  }
}
