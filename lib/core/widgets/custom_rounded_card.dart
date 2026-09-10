import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';
// import 'package:ossos_task/config/colors/index.dart';
// import 'package:ossos_task/config/dimensions/index.dart';

class CustomRoundedCard extends StatelessWidget {
  final Widget child;
  double? height;
  double? width;
  CustomRoundedCard({super.key, required this.child, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: child,
    );
  }
}
