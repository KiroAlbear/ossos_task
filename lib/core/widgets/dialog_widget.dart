import 'package:flutter/material.dart';
import 'package:ossos_task/config/config.dart';
import 'package:ossos_task/core/core.dart';

class DialogWidget extends StatefulWidget {
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isConfirmButtonPrimary;
  final bool hasBottomPadding;

  const DialogWidget({
    super.key,
    required this.message,
    this.confirmText,
    this.cancelText,
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
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 25,horizontal: 30),
      content: Text(
        widget.message,
        style: AppTextStyles.create(context, fontSize: 16,height: 1.2),
        overflow: TextOverflow.visible,
      ),
      actions: [
        widget.confirmText!=null?TextButton(
          onPressed: ()  {
            widget.onConfirm;
            Navigator.pop(context);
          },
          child: Text(
            widget.confirmText!,
            style: AppTextStyles.create(
              context,
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ):SizedBox(),

        widget.cancelText!=null?TextButton(
          onPressed: ()  {
            widget.onCancel;
            Navigator.pop(context);
          },
          child: Text(
            widget.cancelText!,
            style: AppTextStyles.create(
              context,
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ):SizedBox(),
      ],
    );
  }

  Widget get _column => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 200),
    child: Material(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 21),
        _message,
          const SizedBox(height: 25),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.cancelText != null) ...[
                  _confirmButton,
                  const SizedBox(height: 10),
              ],

                if (widget.confirmText != null) ...[
                  _cancelButton,
                  (widget.isConfirmButtonPrimary == false ||
                          widget.hasBottomPadding)
                      ? const SizedBox(height: 28)
                    : SizedBox(),
                ],
              ],
            ),
          ),

          widget.cancelText == null
              ? const SizedBox(height: 28)
            : const SizedBox(),

        ],
      ),
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
    child: Text(widget.confirmText ?? ""),
    onPressed: () {
      if (widget.onConfirm != null) {
        widget.onConfirm!();
      }
      Navigator.pop(context);
    },
  );

  Widget get _cancelButton => CustomElevatedButton.outlined(
    text: widget.cancelText ?? "",context: context,
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
