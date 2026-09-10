import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as path;
import 'package:ossos_task/imports.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCachedImage extends StatelessWidget {
  final bool applyMask;
  final Color? imageColor;
  final String? imageUrl;
  final Size? imageSize;
  final Map<String, String>? httpHeaders;
  final ImageWidgetBuilder? imageBuilder;
  final PlaceholderWidgetBuilder? placeholder;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final Duration? fadeOutDuration;
  final Duration fadeInDuration;
  final Curve fadeInCurve;

  final BoxFit? fit;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;

  final bool useOldImageOnUrlChange;
  final Color? color;
  final BlendMode? colorBlendMode;
  final FilterQuality filterQuality;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final String? cacheKey;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final ValueChanged<Object>? errorListener;

  const CustomCachedImage({
    Key? key,
    this.applyMask = false,
    this.imageColor,
    required this.imageUrl,
    this.imageSize,
    this.httpHeaders,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.colorBlendMode,
    this.filterQuality = FilterQuality.low,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.errorListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || (imageUrl?.isEmpty ?? true)) {
      return const ErrorImageWidget();
    } else {
      String imageExtension = path.extension(imageUrl!);
      if (imageExtension == ".svg") {
        return SvgPicture.network(
          imageUrl!,
          height: imageSize?.height,
          width: imageSize?.width,
          color:
              imageColor ??
              (applyMask
                  ? ThemeManager.isDarkMode(context)
                        ? Colors.white
                        : null
                  : null),
          placeholderBuilder: (BuildContext context) {
            return placeHolderBuilder(context: context);
          },
        );
      } else {
        if (imageUrl == Constants.showErrorNetworkImage) {
          return const ErrorWidget();
        } else {
          return Center(
            child: SizedBox(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  imageColor ?? Colors.white,
                  applyMask
                      ? imageColor != null
                            ? BlendMode.srcIn
                            : ThemeManager.isDarkMode(context)
                            ? BlendMode.srcIn
                            : BlendMode.dst
                      : BlendMode.dst,
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl == Constants.showErrorNetworkImage
                      ? ""
                      : imageUrl!,
                  httpHeaders: httpHeaders,
                  imageBuilder: imageBuilder,
                  placeholder: (BuildContext context, String url) {
                    return placeHolderBuilder(context: context);
                  },
                  progressIndicatorBuilder: progressIndicatorBuilder,
                  errorWidget:
                      (BuildContext context, String url, Object error) {
                        return const ErrorWidget();
                      },
                  fadeOutDuration: fadeOutDuration,
                  fadeInDuration: fadeInDuration,
                  fadeInCurve: fadeInCurve,
                  height: imageSize?.height != null
                      ? imageSize!.height * 2
                      : null,
                  width: imageSize?.width != null ? imageSize!.width * 2 : null,
                  fit: fit,
                  alignment: alignment,
                  repeat: repeat,
                  matchTextDirection: matchTextDirection,
                  useOldImageOnUrlChange: useOldImageOnUrlChange,
                  color: color,
                  colorBlendMode: colorBlendMode,
                  filterQuality: filterQuality,
                  memCacheWidth: memCacheWidth,
                  memCacheHeight: memCacheHeight,
                  cacheKey: cacheKey,
                  maxWidthDiskCache: maxWidthDiskCache,
                  maxHeightDiskCache: maxHeightDiskCache,
                  errorListener: errorListener,
                ),
              ),
            ),
          );
        }
      }
    }
  }

  Widget placeHolderBuilder({required BuildContext context}) {
    return const Skeletonizer(enabled: true, child: LoadingImageWidget());
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.error, color: StaticColors.green_55f);
  }
}

class LoadingImageWidget extends StatelessWidget {
  const LoadingImageWidget({super.key, this.size});
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Skeletonizer.zone(
            child: Bone(
              height: constraints.maxHeight,
              width: constraints.maxHeight,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
          );
        },
      ),
    );
  }
}

class ErrorImageWidget extends StatelessWidget {
  const ErrorImageWidget({super.key, this.size});
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(6),
            child: Icon(Icons.remove_moderator_outlined),
          );
        },
      ),
    );
  }
}
