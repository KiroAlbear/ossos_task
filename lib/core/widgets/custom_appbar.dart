import 'package:flutter/material.dart';
import 'package:ossos_task/config/config.dart';

class CustomAppar extends StatelessWidget implements PreferredSizeWidget {
  final bool withBackArrow;
  final String title;
  final String? subtitle;
  final void Function()? onBackArrowTap;

  CustomAppar({
    required this.title,
    this.subtitle,
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
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: EdgeInsetsDirectional.only(start: 20.0),
        child: withBackArrow
            ? IconButton(
                onPressed:
                    onBackArrowTap ??
                    () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                icon: const Icon(Icons.arrow_back, size: 25),
              )
            : const SizedBox.shrink(),
      ),
      titleSpacing: 0,
      centerTitle: false,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.create(
              context,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null)
            Text(subtitle!, style: AppTextStyles.create(context, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
