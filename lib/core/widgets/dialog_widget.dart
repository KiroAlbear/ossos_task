import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ossos_task/config/config.dart';
import 'package:ossos_task/core/core.dart';

class DialogWidget extends StatefulWidget {
  final String message;
  final String? confirmMessage;
  final String? cancelMessage;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isConfirmButtonPrimary;
  final bool hasBottomPadding;

  const DialogWidget({
    super.key,
    required this.message,
    this.confirmMessage,
    this.cancelMessage,
    this.onCancel,
    this.onConfirm,
    this.isConfirmButtonPrimary = false,
    this.hasBottomPadding = false,
  });

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) => _column;

  Widget get _column => Padding(
    padding: EdgeInsets.symmetric(horizontal: 17.w),
    child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 21.h),
            _message,
            SizedBox(height: 25.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.cancelMessage != null) ...[
                    _confirmButton,
                    SizedBox(height: 10.h),
                  ],

                  if (widget.confirmMessage != null) ...[
                    _cancelButton,
                    (widget.isConfirmButtonPrimary == false ||
                            widget.hasBottomPadding)
                        ? SizedBox(height: 28.h)
                        : SizedBox(),
                  ],
                ],
              ),
            ),

            widget.cancelMessage == null
                ? SizedBox(height: 28.h)
                : const SizedBox(),

          ],
        ),
      ],
    ),
  );

  Widget get _message => Text(
    widget.message,
    style: AppTextStyles.create(
      context,
      fontSize: AppFontSizes.size18,
      fontWeight: AppFontWeights.semiBold,
      color: GenericColors.getColors(context, GenericColors.black_03E_white),
    ),
    softWrap: true,
    maxLines: 4,
    textAlign: TextAlign.center,
  );

  Widget get _confirmButton => CustomElevatedButton(
    child: Text(widget.confirmMessage ?? ""),
    onPressed: () {
      if (widget.onConfirm != null) {
        widget.onConfirm!();
      }
      Navigator.pop(context);
    },
  );

  Widget get _cancelButton => CustomElevatedButton.outlined(
    text: widget.cancelMessage ?? "",context: context,
    // child: Text(widget.cancelMessage ?? ""),

    onPressed: () {
      if (widget.onCancel != null) {
        widget.onCancel!();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    },
  );
}
