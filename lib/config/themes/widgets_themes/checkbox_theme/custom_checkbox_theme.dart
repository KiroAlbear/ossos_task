import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

CheckboxThemeData customCheckBoxLightTheme = CheckboxThemeData(
  overlayColor: WidgetStateProperty.all<Color>(
    StaticColors.orange_aia.withOpacity(0.2),
  ),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
  checkColor: WidgetStateProperty.all<Color>(StaticColors.black_e00),
  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
    return states.contains(WidgetState.selected)
        ? StaticColors.orange_aia
        : StaticColors.white;
  }),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  side: WidgetStateBorderSide.resolveWith(
    (Set<WidgetState> states) => BorderSide(
      width: 1.5,
      color: states.contains(WidgetState.selected)
          ? StaticColors.orange_aia
          : Colors.grey[400]!,
    ),
  ),
);

CheckboxThemeData customCheckBoxDarkTheme = CheckboxThemeData(
  overlayColor: WidgetStateProperty.all<Color>(
    StaticColors.orange_aia.withOpacity(0.2),
  ),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
  checkColor: WidgetStateProperty.all<Color>(StaticColors.black_e00),
  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
    return states.contains(WidgetState.selected)
        ? StaticColors.orange_aia
        : StaticColors.transparent_000;
  }),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  side: WidgetStateBorderSide.resolveWith(
        (Set<WidgetState> states) => BorderSide(
      width: 1.5,
      color: states.contains(WidgetState.selected)
          ? StaticColors.orange_aia
          : StaticColors.white_opacity38,
    ),
  ),
);
