import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class CustomFieldSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  const CustomFieldSurface({
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            GenericColors.getColors(context, GenericColors.textFieldBackground),
        borderRadius: BorderRadius.circular(AppDimensions.w(borderRadius)),
        border: Border.all(
          color:
              borderColor ??
              GenericColors.getColors(context, GenericColors.textFieldBorder),
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}
