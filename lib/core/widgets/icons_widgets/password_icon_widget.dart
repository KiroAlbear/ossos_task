import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ossos_task/core/core.dart';

import '../../../gen/assets.gen.dart';

class PasswordIconWidget extends StatelessWidget {
  const PasswordIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgThemeSwitcher(svgPath:Assets.svg.passwordLight.path);
  }
}
