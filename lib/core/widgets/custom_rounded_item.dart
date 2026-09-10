import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class CustomRoundedItem extends StatelessWidget {
  final String title;
  final void Function(bool isEnabled) onClick;
  final bool isDefaultClicked;
  final TextStyle textStyle;
  final TextStyle clickedTextStyle;
  final Color borderColor;
  final Color clickedBorderColor;
  final Color backgroundColor;
  final Color clickedBackgroundColor;
  final double borderRadius;
  final double borderWidth;
  double horizontalPadding;
  double verticalPadding;
  ValueNotifier<bool> _clickNotifier = ValueNotifier(false);

  CustomRoundedItem({
    required this.title,
    required this.onClick,
    required this.backgroundColor,
    required this.clickedBackgroundColor,
    required this.textStyle,
    required this.clickedTextStyle,
    required this.borderColor,
    required this.clickedBorderColor,
    this.isDefaultClicked = false,
    this.horizontalPadding = 20,
    this.verticalPadding = 5,
    this.borderWidth = 1,
    this.borderRadius = 100,
  }) {
    _clickNotifier.value = isDefaultClicked;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _clickNotifier,
      builder: (context, icClicked, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: icClicked ? clickedBackgroundColor : backgroundColor,
            border: Border.all(
              color: icClicked ? clickedBorderColor : borderColor,
              width: borderWidth,
            ),
          ),
          child: CustomInkWell(
            borderRadiusValue: borderRadius,
            edgeInsets: EdgeInsets.zero,
            onTap: () {
              _clickNotifier.value = !_clickNotifier.value;
              onClick(_clickNotifier.value);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: icClicked ? clickedTextStyle : textStyle,
              ),
            ),
          ),
        );
      },
    );
  }
}
