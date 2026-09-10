import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDateRangePickerDialog extends StatelessWidget {
  const CustomDateRangePickerDialog({
    super.key,
    required this.onSelectionChanged,
  });
  final Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dialogTheme: DialogTheme(
          // actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ).data,
      ),
      child: AlertDialog(
        contentPadding: EdgeInsets.only(bottom: AppDimensions.w(0)),
        insetPadding: EdgeInsets.symmetric(horizontal: AppDimensions.w(16)),
        content: CustomDateRangePicker(onSelectionChanged: onSelectionChanged),
      ),
    );
  }
}
