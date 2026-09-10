import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class AuthenticationAccountSwitch extends StatelessWidget {
  final String normalText;
  final String clickableText;
  final VoidCallback onPressed;

  AuthenticationAccountSwitch({
    required this.onPressed,
    required this.normalText,
    required this.clickableText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          normalText,
          style: AppTextStyles.create(
            context,
            fontSize: AppFontSizes.size13,
            color: GenericColors.getColors(
              context,
              GenericColors.blue148_opacity64_white_opacity68,
            ),
          ),
        ),
        CustomInkWell(
          onTap: onPressed,
          edgeInsets: EdgeInsetsDirectional.symmetric(
            vertical: AppDimensions.h(5),
          ),
          child: Text(
            clickableText,
            style: AppTextStyles.create(
              context,
              fontSize: AppFontSizes.size13,
              fontWeight: AppFontWeights.bold,
              color: GenericColors.getColors(
                context,
                GenericColors.orange_aia_orange_aia,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
