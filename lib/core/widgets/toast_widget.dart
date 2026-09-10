import 'package:flutter/material.dart';
import 'package:ossos_task/config/config.dart';

class ToastWidget extends StatelessWidget {
  const ToastWidget({
    required this.message,
    this.backgroundColor = StaticColors.red_808,
    super.key,
  });

  final String message;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 18),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 520),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: StaticColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.priority_high_rounded,
                      color: backgroundColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.create(
                        context,
                        color: StaticColors.white,
                        fontSize: AppFontSizes.size16,
                        fontWeight: AppFontWeights.semiBold,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
