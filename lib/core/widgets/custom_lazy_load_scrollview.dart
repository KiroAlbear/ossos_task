import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class CustomLazyLoadingScrollView extends StatelessWidget {
  final Widget Function(int) builder;
  final int childCount;
  final bool isEndOfList;
  final ScrollPhysics? physics;
  final void Function() getMoreFunction;

  const CustomLazyLoadingScrollView({
    Key? key,
    required this.builder,
    required this.childCount,
    required this.isEndOfList,
    required this.getMoreFunction,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LazyLoadScrollView(
      onEndOfPage: () {
        if (isEndOfList == false) {
          getMoreFunction();
        }
      },
      child: CustomScrollView(
        shrinkWrap: true,
        physics: physics,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: childCount,
              (BuildContext context, int index) {
                if (index == childCount - 1 && isEndOfList == false) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return builder(index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
