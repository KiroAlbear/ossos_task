import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../gen/assets.gen.dart';

class EyeClosedIconWidget extends StatelessWidget {
  const EyeClosedIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.svg.eyeClosed.path);
  }
}
