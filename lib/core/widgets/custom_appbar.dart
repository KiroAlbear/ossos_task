import 'package:flutter/material.dart';
import 'package:ossos_task/gen/assets.gen.dart';
import 'package:ossos_task/imports.dart';

class CustomAppar extends StatelessWidget implements PreferredSizeWidget {
  final bool withBackArrow;
  final String title;
  final void Function()? onBackArrowTap;

  CustomAppar({
    required this.title,
    required this.withBackArrow,
    this.onBackArrowTap,

    super.key,
  }) {
    if (withBackArrow == false && onBackArrowTap != null) {
      throw Exception(
        "In Egypost Custom Appar,to use attribute onBackArrowTap, make withBackArrow = true",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: EdgeInsetsDirectional.only(start: AppDimensions.screenPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            withBackArrow
                ? CustomElevatedButton(
                    width: AppDimensions.w(34),
                    height: AppDimensions.h(34),
                    padding: EdgeInsets.zero,
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor: GenericColors.getColors(context, GenericColors.textFieldBackground),
                    side: WidgetStateProperty.all(
                      const BorderSide(color: StaticColors.blue_148_opactiy14),
                    ),
                    onPressed:
                        onBackArrowTap ??
                        () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                    child: SvgThemeSwitcher(svgPath:  Assets.svg.arrowBack.path,   width: AppDimensions.w(6),
                      height: AppDimensions.h(9),)
                  )
                // SizedBox(
                //         child: InkWell(
                //           borderRadius: BorderRadius.circular(100),
                //           onTap:
                //               onBackArrowTap ??
                //               () {
                //                 if (Navigator.canPop(context)) {
                //                   Navigator.pop(context);
                //                 }
                //               },
                //           child: Padding(
                //             padding: const EdgeInsets.symmetric(
                //               horizontal: 0.0,
                //               vertical: 12,
                //             ),
                //             child: SvgPicture.asset(Assets.svg.backArrow.path),
                //           ),
                //         ),
                //       )
                : 40.ph,
            12.pw,
            Text(
              title,
              style: AppTextStyles.create(
                context,
                fontSize: AppFontSizes.size16,
                fontWeight: AppFontWeights.weight800,
                fontFamily: FontFamilyConstants.ARCHIVO,
                color: GenericColors.getColors(
                  context,
                  GenericColors.blue148_white,
                ),
              ),
            ),
          ],
        ),
      ),
      leadingWidth: AppDimensions.fw(),
      backgroundColor: Colors.transparent,
      toolbarHeight: AppDimensions.appBarHeight,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppDimensions.appBarHeight);
}
