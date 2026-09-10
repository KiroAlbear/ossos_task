import 'package:flutter/material.dart';

import 'package:ossos_task/config/config.dart';

class AuthenticationDivider extends StatelessWidget {
  final String text;
  const AuthenticationDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: buildDivider(context)),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: AppDimensions.w(10),
          ),
          child: Text(
            text,
            style: AppTextStyles.create(
              context,
              fontSize: AppFontSizes.size12,
              color: GenericColors.getColors(
                context,
                GenericColors.blue148_opacity38_white_opacity36,
              ),
            ),
          ),
        ),
        Expanded(child: buildDivider(context)),
      ],
    );
  }

  Divider buildDivider(BuildContext context) => Divider(color: GenericColors.getColors(
    context,
    GenericColors.blue148_opacity38_white_opacity36,
  ));
}
