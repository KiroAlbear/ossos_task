import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class CustomDateWidget extends StatelessWidget {
  final String notFormatedDate;
  final String prefixText;
  const CustomDateWidget({
    super.key,
    required this.notFormatedDate,
    this.prefixText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.remove_moderator_outlined),
        AppDimensions.w(6).pw,
        Text(
          "$prefixText${AppUtils.getLocalizedDate(notFormatedDate)}",
          style: AppTextStyles.create(
            context,
            fontSize: AppFontSizes.size18,
            fontWeight: AppFontWeights.semiBold,
            color: GenericColors.getColors(
              context,
              GenericColors.black_03E_white,
            ),
          ),
        ),
      ],
    );
  }
}
