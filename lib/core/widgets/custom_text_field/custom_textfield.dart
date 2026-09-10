import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ossos_task/config/config.dart';
import 'package:ossos_task/core/widgets/custom_text_field/country_picker_values.dart';
import 'package:ossos_task/core/widgets/custom_text_field/custom_textfield_type.dart';
import 'package:ossos_task/core/widgets/input_label.dart';
import 'package:ossos_task/gen/assets.gen.dart';

import '../icons_widgets/password_icon_widget.dart';
import '../theme_switcher/widget_theme_switcher.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final Widget? labelWidget;
  final String? hintText;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final CustomTextfieldType type;
  final String initialCountryCode;
  final List<String> favoriteCountryCodes;
  final TextStyle? textStyle;
  final int? minLines;
  final int? maxLines;
  final FormFieldValidator<String>? validator;

  final ValueChanged<CountryCode>? onCountryCodeChanged;

  const CustomTextField({
    required this.label,
    this.labelWidget,
    this.hintText,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.type = CustomTextfieldType.text,
    this.initialCountryCode = 'AU',
    this.favoriteCountryCodes = const ['AU'],
    this.validator,
    this.textStyle,
    this.minLines,
    this.maxLines = 1,
    this.onCountryCodeChanged,
    super.key,
  });

  factory CustomTextField.withLabelWidget({
    required String label,
    required Widget labelWidget,
    required TextEditingController controller,
    TextStyle? textStyle,
    String? hintText,
    FormFieldValidator<String>? validator,
    Widget? prefixIcon,
    Widget? suffixIcon,
    CustomTextfieldType type = CustomTextfieldType.text,
    int? minLines,
    int? maxLines = 1,
  }) {
    return CustomTextField(
      label: label,
      labelWidget: labelWidget,
      hintText: hintText,
      controller: controller,
      validator: validator,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      textStyle: textStyle,
      type: type,
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  factory CustomTextField.withCountryCodePicker(
    BuildContext context, {
    required TextEditingController textController,
    required TextEditingController countryCodeController,
    FormFieldValidator<String>? validator,
  }) {
    countryCodeController.text = CountryPickerValues.initialCountryCode;
    return CustomTextField(
      label: Loc.tr(LKeys.PhoneNumber, context),
      hintText: "XXX-XXX-XXX",
      initialCountryCode: CountryPickerValues.initialCountryLetter,
      favoriteCountryCodes: CountryPickerValues.favouriteCountries,
      controller: textController,
      validator: validator,
      onCountryCodeChanged: (value) {
        countryCodeController.text = value.dialCode ?? "";
      },
      type: CustomTextfieldType.phone,
    );
  }

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.type == CustomTextfieldType.password;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputLabel(
          label: widget.label,
          labelWidget: widget.labelWidget,
          textStyle: widget.textStyle,
        ),
        8.ph,
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: isPassword && _obscurePassword,
          minLines: widget.minLines,
          maxLines: isPassword ? 1 : widget.maxLines,
          keyboardType: _keyboardType,
          inputFormatters: [
            if (widget.type == CustomTextfieldType.phone)
              FilteringTextInputFormatter.allow(RegExp(r'^\+?\d*')),
          ],
          style: AppTextStyles.create(
            context,
            fontSize: AppFontSizes.size16,
            fontWeight: AppFontWeights.medium,
            color: GenericColors.getColors(
              context,
              GenericColors.blue148_white,
            ),
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsetsDirectional.only(
              start: 0,
              end: AppDimensions.w(14),
              top: AppDimensions.h(13),
              bottom: AppDimensions.h(13),
            ),
            prefixIcon: widget.type == CustomTextfieldType.phone
                ? _getCountryPickerPrefix()
                : _prefixWrapper(
                    child: isPassword
                        ? PasswordIconWidget()
                        : widget.prefixIcon,
                  ),
            prefixIconConstraints: widget.type == CustomTextfieldType.phone
                ? null
                : BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                    maxWidth: 40,
                    maxHeight: 70,
                  ),
            suffixIcon: isPassword
                ? _passwordIconWrapper(
                    child: _suffixWrapper(child: _passwordVisibilityIcon()),
                  )
                : _suffixWrapper(child: widget.suffixIcon),
            hintText: widget.hintText,
          ),
        ),
      ],
    );
  }

  TextInputType get _keyboardType {
    if (widget.type == CustomTextfieldType.phone) {
      return TextInputType.phone;
    }

    if ((widget.maxLines ?? 1) > 1) {
      return TextInputType.multiline;
    }

    return TextInputType.text;
  }

  Widget _getCountryPickerPrefix() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        14.pw,
        WidgetThemeSwitcher(
          lightWidget: Assets.png.phoneLight.image(),
          darkWidget: Assets.png.phoneDark.image(),
        ),
        12.pw,
        // CountryCodePicker(
        //   onChanged: widget.onCountryCodeChanged,
        //   // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        //   initialSelection: widget.initialCountryCode,
        //   favorite: widget.favoriteCountryCodes,
        //
        //   builder: (CountryCode? code) {
        //     return Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         ClipOval(
        //           child: Image.asset(
        //             code!.flagUri!,
        //             package: 'country_code_picker',
        //             width: 28,
        //             height: 28,
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //         8.pw,
        //         SvgPicture.asset(
        //           Assets.svg.arrowDown.path,
        //           width: 10,
        //           height: 6,
        //         ),
        //         6.pw,
        //         Text(code.dialCode!),
        //       ],
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _suffixWrapper({required Widget? child}) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: SizedBox(width: 12, height: 12, child: child),
    );
  }

  Widget _passwordIconWrapper({required Widget? child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          radius: 100,
          onTap: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          child: child,
        ),
      ),
    );
  }

  Widget _passwordVisibilityIcon() {
    return SvgPicture.asset(
      _obscurePassword ? Assets.svg.eyeClosed.path : Assets.svg.eyeOpen.path,
    );
  }

  Widget _prefixWrapper({required Widget? child}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: child == null ? 0.0 : 12.0,
        end: 12.0,
      ),
      child: child,
    );
  }
}
