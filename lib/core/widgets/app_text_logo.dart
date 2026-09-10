import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ossos_task/gen/assets.gen.dart';

import '../../config/config.dart';
import '../../imports.dart';

class AppTextLogo extends StatelessWidget {
  const AppTextLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // SvgThemeSwitcher(svgPath: Assets.svg.logo.path),
        SizedBox(
          width: AppDimensions.w(24),
          height: AppDimensions.h(24),
          child: WidgetThemeSwitcher(
            lightWidget: Assets.png.logoAuthIconDark.image(),
            darkWidget: Assets.png.logoAuthIconLight.image(),
          ),
        ),
        Gap(5),
        SvgThemeSwitcher(svgPath: Assets.svg.logoText.path),
      ],
    );
  }
}
