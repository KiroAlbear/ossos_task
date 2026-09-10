import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final bool isEnabled;
  final EdgeInsets? padding;
  final Color backgroundColor;
  final Color? textColor;
  final WidgetStateProperty<double?>? elevation;
  final WidgetStateProperty<BorderSide?>? side;
  final Widget? suffix;
  final void Function()? onPressed;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = StaticColors.orange_aia,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.suffix,
    this.isEnabled = true,
    this.elevation,
    this.side,
  });

  factory CustomElevatedButton.outlined({
    required VoidCallback? onPressed,
    required String text,
    required BuildContext context,
    Widget? suffix,
  }) {
    return CustomElevatedButton(
      onPressed: onPressed,
      elevation: WidgetStateProperty.all(0),
      side: WidgetStateProperty.all(
        BorderSide(color: GenericColors.getColors(
          context,
          GenericColors.textFieldBorder,
        )),
      ),
      suffix: suffix,
      backgroundColor: GenericColors.getColors(
        context,
        GenericColors.textFieldBackground,
      ),
      child: Text(
        text,
        style: AppTextStyles.create(
          context,
          fontSize: AppFontSizes.size12,
          fontFamily: FontFamilyConstants.ARCHIVO,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  factory CustomElevatedButton.iconOutlined({
    required VoidCallback? onPressed,
    required BuildContext context,
    required Widget child,
  }) {
    return CustomElevatedButton(
      onPressed: onPressed,
      elevation: WidgetStateProperty.all(0),
      padding: EdgeInsets.zero,
      side: WidgetStateProperty.all(
        BorderSide(color: GenericColors.getColors(
          context,
          GenericColors.textFieldBorder,
        )),
      ),
      backgroundColor: GenericColors.getColors(
        context,
        GenericColors.textFieldBackground,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ButtonStyle(
          elevation: elevation,
          backgroundColor: WidgetStateProperty.all(backgroundColor),
          side: side,
          padding: WidgetStateProperty.all(
            padding ?? EdgeInsets.symmetric(horizontal: 24),
          ),
          textStyle: textColor != null
              ? WidgetStateProperty.all(
                  elevatedButtonTextStyle.copyWith(color: textColor),
                )
              : null,
        ),
        child: suffix == null
            ? child
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [suffix!, 10.pw, child],
              ),
      ),
    );
  }
}
