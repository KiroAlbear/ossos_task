import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class ParentPage extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? appbarWidget;
  final Widget? backgroundImage;
  final Widget? bottomSheet;
  final bool containPadding;

  ParentPage({
    required this.child,
    this.appBar,
    this.appbarWidget,
    this.backgroundImage,
    this.bottomSheet,
    this.containPadding = true,
  }) {
    if (appBar != null && appbarWidget != null) {
      throw Exception(
        "You can't use both appbar and appbarWidget at the same time",
      );
    }
  }

  Widget _buildWidgetTree(BuildContext context) {
    if (appBar == null && appbarWidget != null) {
      return Column(
        children: [
          appbarWidget!,
          Expanded(child: child),
        ],
      );
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            color: StaticColors.white_7f4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                backgroundImage != null
                    ? Expanded(child: backgroundImage!)
                    : Icon(Icons.remove_moderator_outlined),
              ],
            ),
          ),
          Scaffold(
            appBar: appBar,
            bottomSheet: bottomSheet,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: containPadding ? AppDimensions.screenPadding : 0,
              ),
              child: _buildWidgetTree(context),
            ),
          ),
        ],
      ),
    );
  }
}
