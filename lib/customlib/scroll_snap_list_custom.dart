library scroll_snap_list;

import 'dart:math';

import 'package:flutter/material.dart';

///A ListView widget that able to "snap" or focus to an item whenever user scrolls.
///
///Allows unrestricted scroll speed. Snap/focus event done on every `ScrollEndNotification`.
///
///Contains `ScrollNotification` widget, so might be incompatible with other scroll notification.
class ScrollSnapList extends StatefulWidget {
  ///List background
  final Color background;

  ///Widget builder.
  final Widget Function(BuildContext, int) itemBuilder;

  ///Animation curve
  final Curve curve;

  ///Animation duration in milliseconds (ms)
  final int duration;

  ///Pixel tolerance to trigger onReachEnd.
  ///Default is itemSize/2
  final double endOfListTolerance;

  ///Focus to an item when user tap on it. Inactive if the list-item have its own onTap detector (use state-key to help focusing instead).
  final bool focusOnItemTap;

  ///Method to manually trigger focus to an item. Call with help of `GlobalKey<ScrollSnapListState>`.
  final void Function(int) focusToItem;

  ///Container's margin
  final EdgeInsetsGeometry margin;

  ///Number of item in this list
  final int itemCount;

  ///Composed of the size of each item + its margin/padding.
  ///Size used is width if `scrollDirection` is `Axis.horizontal`, height if `Axis.vertical`.
  ///
  ///Example:
  ///- Horizontal list
  ///- Card with `width` 100
  ///- Margin is `EdgeInsets.symmetric(horizontal: 5)`
  ///- itemSize is `100+5+5 = 110`
  final double itemSize;

  ///Global key that's used to call `focusToItem` method to manually trigger focus event.
  final Key key;

  ///Global key that passed to child ListView. Can be used for PageStorageKey
  final Key listViewKey;

  ///Callback function when list snaps/focuses to an item
  final void Function(int) onItemFocus;

  ///Callback function when user reach end of list.
  ///
  ///Can be used to load more data from database.
  final Function onReachEnd;

  ///Container's padding
  final EdgeInsetsGeometry padding;

  ///Reverse scrollDirection
  final bool reverse;

  ///Calls onItemFocus (if it exists) when ScrollUpdateNotification fires
  final bool updateOnScroll;

  ///An optional initial position which will not snap until after the first drag
  final double initialIndex;

  ///ListView's scrollDirection
  final Axis scrollDirection;

  ///Allows external controller
  final ScrollController listController;

  ///Scale item's size depending on distance to center
  final bool dynamicItemSize;

  ///Custom equation to determine dynamic item scaling calculation
  ///
  ///Input parameter is distance between item position and center of ScrollSnapList (Negative for left side, positive for right side)
  ///
  ///Output value is scale size (must be >=0, 1 is normal-size)
  ///
  ///Need to set `dynamicItemSize` to `true`
  final double Function(double distance) dynamicSizeEquation;

  ScrollSnapList(
      {this.background,
      @required this.itemBuilder,
      ScrollController listController,
      this.curve = Curves.ease,
      this.duration = 500,
      this.endOfListTolerance,
      this.focusOnItemTap = true,
      this.focusToItem,
      this.itemCount,
      @required this.itemSize,
      this.key,
      this.listViewKey,
      this.margin,
      @required this.onItemFocus,
      this.onReachEnd,
      this.padding,
      this.reverse = false,
      this.updateOnScroll,
      this.initialIndex,
      this.scrollDirection = Axis.horizontal,
      this.dynamicItemSize = false,
      this.dynamicSizeEquation})
      : listController = listController ?? ScrollController(),
        super(key: key);

  @override
  ScrollSnapListState createState() => ScrollSnapListState();
}

class ScrollSnapListState extends State<ScrollSnapList> {
  //true if initialIndex exists and first drag hasn't occurred
  bool isInit = true;
  //to avoid multiple onItemFocus when using updateOnScroll
  int previousIndex = -1;
  //Current scroll-position in pixel
  double currentPixel = 0;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialIndex != null) {
        //set list's initial position
        focusToInitialPosition();
      } else {
        isInit = false;
      }
    });

    ///After initial jump, set isInit to false
    Future.delayed(Duration(milliseconds: 10), () {
      if (this.mounted) {
        setState(() {
          isInit = false;
        });
      }
    });
  }

  ///Scroll list to an offset
  void _animateScroll(double location) {
    Future.delayed(Duration.zero, () {
      widget.listController.animateTo(
        location,
        duration: new Duration(milliseconds: widget.duration),
        curve: widget.curve,
      );
    });
  }

  ///Calculate scale transformation for dynamic item size
  double calculateScale(int index) {
    //scroll-pixel position for index to be at the center of ScrollSnapList
    double intendedPixel = index * widget.itemSize;
    double difference = intendedPixel - currentPixel;

    if (widget.dynamicSizeEquation != null) {
      //force to be >= 0
      double scale = widget.dynamicSizeEquation(difference);
      return scale < 0 ? 0 : scale;
    }

    //default equation
    return 1 - min(difference.abs() / 500, 0.4);
  }

  Widget _buildListItem(BuildContext context, int index) {
    Widget child;
    if (widget.dynamicItemSize) {
      child = Transform.scale(
        scale: calculateScale(index),
        child: widget.itemBuilder(context, index),
      );
    } else {
      child = widget.itemBuilder(context, index);
    }

    if (widget.focusOnItemTap)
      return GestureDetector(
        onTap: () => focusToItem(index),
        child: child,
      );

    return child;
  }

  ///Calculates target pixel for scroll animation
  ///
  ///Then trigger `onItemFocus`
  double _calcCardLocation(
      {double pixel, @required double itemSize, int index}) {
    //current pixel: pixel
    //listPadding is not considered as moving pixel by scroll (0.0 is after padding)
    //substracted by itemSize/2 (to center the item)
    //divided by pixels taken by each item
    int cardIndex =
        index != null ? index : ((pixel - itemSize / 2) / itemSize).ceil();

    //trigger onItemFocus
    if (widget.onItemFocus != null && cardIndex != previousIndex) {
      previousIndex = cardIndex;
      widget.onItemFocus(cardIndex);
    }

    //target position
    return (cardIndex * itemSize);
  }

  /// Trigger focus to an item inside the list
  /// Will trigger scoll animation to focused item
  void focusToItem(int index) {
    double targetLoc =
        _calcCardLocation(index: index, itemSize: widget.itemSize);
    _animateScroll(targetLoc);
  }

  ///Determine location if initialIndex is set
  void focusToInitialPosition() {
    widget.listController.jumpTo((widget.initialIndex * widget.itemSize));
  }

  ///Trigger callback on reach end-of-list
  void _onReachEnd() {
    if (widget.onReachEnd != null) widget.onReachEnd();
  }

  @override
  void dispose() {
    // widget.listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraint) {
          double _listPadding = (widget.scrollDirection == Axis.horizontal
                      ? constraint.maxWidth
                      : constraint.maxHeight) /
                  2 -
              widget.itemSize / 2;
          return GestureDetector(
            //by catching onTapDown gesture, it's possible to keep animateTo from removing user's scroll listener
            onTapDown: (_) {},
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification) {
                  // dont snap until after first drag
                  if (isInit) {
                    return true;
                  }

                  double tolerance =
                      widget.endOfListTolerance ?? (widget.itemSize / 2);
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - tolerance) {
                    _onReachEnd();
                  }

                  //snap the selection
                  double offset = _calcCardLocation(
                    pixel: scrollInfo.metrics.pixels,
                    itemSize: widget.itemSize,
                  );

                  //only animate if not yet snapped (tolerance 0.01 pixel)
                  if ((scrollInfo.metrics.pixels - offset).abs() > 0.01) {
                    _animateScroll(offset);
                  }
                } else if (scrollInfo is ScrollUpdateNotification) {
                  //save pixel position for scale-effect
                  if (widget.dynamicItemSize) {
                    setState(() {
                      currentPixel = scrollInfo.metrics.pixels;
                    });
                  }

                  if (widget.updateOnScroll == true) {
                    // dont snap until after first drag
                    if (isInit) {
                      return true;
                    }

                    if (widget.onItemFocus != null && isInit == false) {
                      _calcCardLocation(
                        pixel: scrollInfo.metrics.pixels,
                        itemSize: widget.itemSize,
                      );
                    }
                  }
                }
                return true;
              },
              child: ListView.builder(
                key: widget.listViewKey,
                controller: widget.listController,
                padding: widget.scrollDirection == Axis.horizontal
                    ? EdgeInsets.symmetric(horizontal: _listPadding)
                    : EdgeInsets.symmetric(
                        vertical: _listPadding,
                      ),
                reverse: widget.reverse,
                scrollDirection: widget.scrollDirection,
                itemBuilder: _buildListItem,
                itemCount: widget.itemCount,
              ),
            ),
          );
        },
      ),
    );
  }
}
