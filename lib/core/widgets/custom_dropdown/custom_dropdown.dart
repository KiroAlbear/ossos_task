import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ossos_task/config/config.dart';
import 'package:ossos_task/core/widgets/input_label.dart';
import 'package:ossos_task/gen/assets.gen.dart';

class CustomDropdown2 extends StatelessWidget {
  final List<String> list;
  final String hintText;
  final String label;
  final Widget? labelWidget;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final SingleSelectController<String?>? controller;
  final FormFieldValidator<String>? validator;

  const CustomDropdown2({
    super.key,
    required this.list,
    required this.hintText,
    required this.label,
    this.prefixIcon,
    this.textStyle,
    this.labelWidget,
    this.controller,
    this.validator,
  });

  factory CustomDropdown2.withLabelWidget({
    required List<String> list,
    required String hintText,
    required String label,
    required Widget labelWidget,
    Widget? prefixIcon,
    TextStyle? textStyle,
    SingleSelectController<String?>? controller,
    FormFieldValidator<String>? validator,
  }) {
    return CustomDropdown2(
      list: list,
      hintText: hintText,
      label: label,
      labelWidget: labelWidget,
      controller: controller,
      validator: validator,
      textStyle: textStyle,
      prefixIcon: prefixIcon,
    );
  }

  factory CustomDropdown2.genderDropDown(
    BuildContext context, {
    SingleSelectController<String?>? controller,
    FormFieldValidator<String>? validator,
  }) {
    final List<String> list = [
      Loc.tr(LKeys.male, context),
      Loc.tr(LKeys.female, context),
    ];
    return CustomDropdown2(
      list: list,
      hintText: Loc.tr(LKeys.selectYourGender, context),
      label: Loc.tr(LKeys.gender, context),
      prefixIcon: SvgPicture.asset(Assets.svg.gender.path),
      controller: controller,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputLabel(
          label: label,
          labelWidget: labelWidget,
          textStyle: textStyle,
        ),
        8.ph,
        CustomDropdown<String>(
          controller: controller,
          hintText: hintText,
          items: list,
          initialItem: controller == null ? list[0] : null,
          validator: validator,
          hintBuilder: (context, hint, enabled) {
            return Text(
              hint,
              style: AppTextStyles.create(
                context,
                fontSize: AppFontSizes.size13,
                fontWeight: AppFontWeights.medium,
                color: GenericColors.getColors(
                  context,
                  GenericColors.black_white,
                ),
              ),
            );
          },
          hideSelectedFieldWhenExpanded: true,


          decoration: CustomDropdownDecoration(
            closedFillColor: Colors.transparent,
            errorStyle: AppTextStyles.create(
              context,
              fontSize: AppFontSizes.size16,
              fontWeight: AppFontWeights.regular,
              height: 1,
              color: StaticColors.red_808,
            ),
            closedErrorBorder: Border.all(color: Colors.transparent),
            prefixIcon: prefixIcon,
            headerStyle: AppTextStyles.create(
              context,
              fontSize: AppFontSizes.size13,
              fontWeight: AppFontWeights.medium,
              color: GenericColors.getColors(
                context,
                GenericColors.black_white,
              ),
            ),
            listItemStyle: AppTextStyles.create(
              context,
              fontSize: AppFontSizes.size16,
              fontWeight: AppFontWeights.semiBold,
              color: GenericColors.getColors(
                context,
                GenericColors.black_white,
              ),
            ),
            expandedSuffixIcon: SvgPicture.asset(
              Assets.svg.dropdownUpArrow.path,
            ),
            closedSuffixIcon: SvgPicture.asset(
              Assets.svg.dropdownDownArrow.path,
            ),
          ),

          excludeSelected: false,
          closedHeaderPadding: EdgeInsets.all(10),
          onChanged: (value) {
            // log('changing value to: $value');
          },
        ),
      ],
    );
  }
}
