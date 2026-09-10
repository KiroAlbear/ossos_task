import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ossos_task/config/colors/generic_colors.dart';

class SvgThemeSwitcher extends StatelessWidget {
  final String svgPath;
  final double? width;
  final double? height;

  const SvgThemeSwitcher({super.key, required this.svgPath, this.width,this.height});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      width: width,
      height: height,
      svgPath,
      colorFilter: ColorFilter.mode(
        GenericColors.getColors(context, GenericColors.blue148_white),
        BlendMode.srcIn,
      ),
    );
  }
}
