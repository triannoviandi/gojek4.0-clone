import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:gojekclone/tab_promos/promos_content.dart';
import 'package:rubber/rubber.dart';

class TabPromos extends StatefulWidget {
  final double rubberSheetPercentage;

  TabPromos({this.rubberSheetPercentage});

  @override
  _TabPromosState createState() => _TabPromosState();
}

class _TabPromosState extends State<TabPromos>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Size get size => MediaQuery.of(context).size;
  double get tabIndicatorHeigth => 70;
  double get rubberSheetHeight => size.height - tabIndicatorHeigth;

  ScrollController scrollController = ScrollController();
  double _dampingValue = DampingRatio.LOW_BOUNCY;
  double _stiffnessValue = Stiffness.LOW;
  double get pageViewWidth => MediaQuery.of(context).size.width * 1.02 * 3;

  double get pageWidth => MediaQuery.of(context).size.width;

  double get widthFactor => 1.02;

  double get tabPaddingHorizontal =>
      ((widthFactor * pageWidth) - pageWidth) / 2;

  RubberAnimationController _controller;

  bool slideBtnHideByScroll = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    _controller = RubberAnimationController(
        vsync: this,
        initialValue: 1,
        lowerBoundValue: AnimationControllerValue(pixel: 300),
        upperBoundValue:
            AnimationControllerValue(percentage: widget.rubberSheetPercentage),
        springDescription: SpringDescription.withDampingRatio(
            mass: 1, stiffness: _stiffnessValue, ratio: _dampingValue),
        duration: Duration(microseconds: 1));

    _controller.expand();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: tabPaddingHorizontal),
        child: RubberBottomSheet(
          scrollController: scrollController,
          animationController: _controller,
          lowerLayer: Container(
            color: Colors.transparent,
          ),
          upperLayer: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 25,
                      height: 3,
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ),
                Expanded(
                    child: PromosContent(
                  scrollController: scrollController,
                )),
              ],
            ),
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
