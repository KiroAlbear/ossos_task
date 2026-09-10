import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppDimensions.w(96),
                  height: AppDimensions.w(96),
                  decoration: BoxDecoration(
                    color: StaticColors.orange_aia.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: AppDimensions.w(44),
                    color: StaticColors.orange_aia,
                  ),
                ),
                SizedBox(height: AppDimensions.h(28)),
                Text(
                  'No internet connection',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.create(
                    context,
                    fontSize: AppFontSizes.size25,
                    fontWeight: AppFontWeights.extraBold,
                    color: GenericColors.getColors(
                      context,
                      GenericColors.black_white,
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.h(12)),
                Text(
                  'Please check your connection and try again.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.create(
                    context,
                    fontSize: AppFontSizes.size16,
                    color: GenericColors.getColors(
                      context,
                      GenericColors.gray_lightGray,
                    ),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
