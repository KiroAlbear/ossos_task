import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ossos_task/config/config.dart';


class CustomCheckbox extends StatelessWidget {
  final bool value;
  final String title;
  final ValueChanged<bool?> onChange;

  const CustomCheckbox({
    required this.value,
    required this.title,
    required this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(value: value, onChanged: onChange),
        Gap(8.w),
        Text(
          title,
          style: AppTextStyles.create(
            context,
            fontSize: AppFontSizes.size12,
            color: GenericColors.getColors(
              context,
              GenericColors.blue148_opacity64_white_opacity68,
            ),
          ),
        ),
      ],
    );
  }
}
