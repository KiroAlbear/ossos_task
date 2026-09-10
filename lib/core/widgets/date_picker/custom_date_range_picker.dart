import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDateRangePicker extends StatelessWidget {
  const CustomDateRangePicker({super.key, this.onSelectionChanged});
  final Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;
  @override
  Widget build(BuildContext context) {
    final TextStyle titleMediumStyle = AppTextStyles.create(
      context,
      fontSize: AppFontSizes.size18,
      fontWeight: AppFontWeights.semiBold,
      color: GenericColors.getColors(context, GenericColors.black_03E_white),
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: SfDateRangePicker(
        view: DateRangePickerView.month,
        allowViewNavigation: true,
        headerHeight: 56,
        todayHighlightColor: StaticColors.orange_aia,
        backgroundColor: Colors.white,
        yearCellStyle: DateRangePickerYearCellStyle(
          todayTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: AppFontWeights.extraBold,
          ),
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          textStyle: TextStyle(fontWeight: AppFontWeights.extraBold),
          todayTextStyle: titleMediumStyle,
          leadingDatesTextStyle: titleMediumStyle,
          trailingDatesTextStyle: titleMediumStyle,
        ),
        monthViewSettings: DateRangePickerMonthViewSettings(
          firstDayOfWeek: 6,
          viewHeaderHeight: 40,
          showTrailingAndLeadingDates: true,
          viewHeaderStyle: DateRangePickerViewHeaderStyle(
            textStyle: titleMediumStyle,
          ),
        ),
        headerStyle: DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          backgroundColor: StaticColors.gray_4f4,
          textStyle: titleMediumStyle,
        ),
        showNavigationArrow: true,
        selectionColor: StaticColors.orange_aia,
        selectionMode: DateRangePickerSelectionMode.single,
        minDate: DateTime(1999, 01, 01),
        maxDate: DateTime.now(),
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }
}
