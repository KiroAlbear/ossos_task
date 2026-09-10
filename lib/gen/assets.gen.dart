// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/logo_auth_icon_dark.png
  AssetGenImage get logoAuthIconDark =>
      const AssetGenImage('assets/png/logo_auth_icon_dark.png');

  /// File path: assets/png/logo_auth_icon_light.png
  AssetGenImage get logoAuthIconLight =>
      const AssetGenImage('assets/png/logo_auth_icon_light.png');

  /// File path: assets/png/phone_dark.png
  AssetGenImage get phoneDark =>
      const AssetGenImage('assets/png/phone_dark.png');

  /// File path: assets/png/phone_light.png
  AssetGenImage get phoneLight =>
      const AssetGenImage('assets/png/phone_light.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    logoAuthIconDark,
    logoAuthIconLight,
    phoneDark,
    phoneLight,
  ];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/arrow_back.svg
  SvgGenImage get arrowBack => const SvgGenImage('assets/svg/arrow_back.svg');

  /// File path: assets/svg/dropdown_down_arrow.svg
  SvgGenImage get dropdownDownArrow =>
      const SvgGenImage('assets/svg/dropdown_down_arrow.svg');

  /// File path: assets/svg/dropdown_up_arrow.svg
  SvgGenImage get dropdownUpArrow =>
      const SvgGenImage('assets/svg/dropdown_up_arrow.svg');

  /// File path: assets/svg/eye_closed.svg
  SvgGenImage get eyeClosed => const SvgGenImage('assets/svg/eye_closed.svg');

  /// File path: assets/svg/eye_open.svg
  SvgGenImage get eyeOpen => const SvgGenImage('assets/svg/eye_open.svg');

  /// File path: assets/svg/gender.svg
  SvgGenImage get gender => const SvgGenImage('assets/svg/gender.svg');

  /// File path: assets/svg/logo_text.svg
  SvgGenImage get logoText => const SvgGenImage('assets/svg/logo_text.svg');

  /// File path: assets/svg/password_light.svg
  SvgGenImage get passwordLight =>
      const SvgGenImage('assets/svg/password_light.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    arrowBack,
    dropdownDownArrow,
    dropdownUpArrow,
    eyeClosed,
    eyeOpen,
    gender,
    logoText,
    passwordLight,
  ];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/app_en.json
  String get appEn => 'assets/translations/app_en.json';

  /// List of all assets
  List<String> get values => [appEn];
}

class Assets {
  const Assets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
