import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final double? height;
  CustomBottomSheet({required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 14),
          Container(
            height: 8,
            width: 50,
            decoration: BoxDecoration(
              color: StaticColors.gray_b1b,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: child,
            // height: MediaQuery.sizeOf(context).height * .3,
            // child: Column(
            //   children: [
            //     Expanded(child: child),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}
