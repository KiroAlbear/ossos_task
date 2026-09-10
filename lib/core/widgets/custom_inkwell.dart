import 'package:flutter/material.dart';

///you should provide the child color, as the child mustn't have color so the splash color be visible
class CustomInkWell extends StatelessWidget {
  final Function()? onTap;
  final double? borderRadiusValue;
  final Widget child;
  final Color? childColor;
  final EdgeInsetsGeometry? edgeInsets;
  const CustomInkWell({
    Key? key,
    this.onTap,
    this.borderRadiusValue,
    required this.child,
    this.childColor,
    this.edgeInsets,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: childColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadiusValue ?? 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadiusValue ?? 0),
        onTap: onTap,
        splashColor: Colors.grey[350],
        child: Ink(
          padding: edgeInsets ?? EdgeInsets.all(10),
          child: Container(
            child: child,
          ),
        ),
      ),
    );
  }
}
