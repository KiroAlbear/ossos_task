import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class CustomCountText extends StatelessWidget {
  final int episodesCount;
  final String title;
  const CustomCountText({
    super.key,
    required this.episodesCount,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: AppDimensions.w(4)),
      child: Text(
        "$title ($episodesCount)",
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
    );
  }
}
