import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ossos_task/imports.dart';

class CustomImageAvatar extends StatelessWidget {
  const CustomImageAvatar({
    Key? key,
    this.backgroundColor,
    required this.radius,
    required this.showAssetImage,
    required this.iconUrl,
    this.imageColor,
    this.imageSize,
    this.applyMask = false,
  }) : super(key: key);
  final Color? backgroundColor;
  final double radius;
  final bool showAssetImage;
  final String? iconUrl;
  final Color? imageColor;
  final Size? imageSize;
  final bool applyMask;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Center(
        child: SizedBox(
          height: imageSize?.height ?? radius * 2 - 5,
          width: imageSize?.width ?? radius * 2 - 5,
          child: Builder(
            builder: (BuildContext context) {
              if (showAssetImage) {
                if (iconUrl == null) {
                  return const LoadingImageWidget();
                } else {
                  return Center(
                    child: SizedBox(
                      height: imageSize?.height ?? radius * 1.5 - 5,
                      width: imageSize?.width ?? radius * 1.5 - 5,
                      child: SvgPicture.asset(
                        iconUrl!,
                        color:
                            imageColor ??
                            (ThemeManager.isDarkMode(context)
                                ? Colors.white
                                : null),
                      ),
                    ),
                  );
                }
              } else {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints cons) {
                    return Center(
                      child: CustomCachedImage(
                        applyMask: applyMask,
                        imageSize: Size(radius * 1.3, radius * 1.2),
                        imageUrl: iconUrl,
                        fit: BoxFit.fill,

                        imageColor: imageColor,
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
