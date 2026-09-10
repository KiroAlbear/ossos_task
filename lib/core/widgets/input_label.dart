import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;
import 'package:ossos_task/config/colors/generic_colors.dart';
import 'package:ossos_task/config/font/app_font_sizes.dart';
import 'package:ossos_task/config/font/app_font_weights.dart';
import 'package:ossos_task/config/font/app_text_styles.dart';

class InputLabel extends StatelessWidget {
  final String label;
  final Widget? labelWidget;
  final TextStyle? textStyle;
  const InputLabel({
    required this.label,
    this.labelWidget,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        labelWidget ?? SizedBox(),
        if (labelWidget != null) Gap(8),
        Text(
          label,
          style:
              textStyle ??
              AppTextStyles.create(
                context,
                fontSize: AppFontSizes.size12,
                fontWeight: AppFontWeights.semiBold,
                color: GenericColors.getColors(
                  context,
                  GenericColors.blue148_opacity38_white_opacity36,
                ),
              ),
        ),
      ],
    );
  }
}
