import 'package:flutter/material.dart';
import 'package:gojekclone/tab_chat/chat_content.dart';
import 'package:rubber/rubber.dart';

class TabChat extends StatefulWidget {
  final double rubberSheetPercentage;

  TabChat(this.rubberSheetPercentage);

  @override
  _TabChatState createState() => _TabChatState();
}

class _TabChatState extends State<TabChat>
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
    return Stack(
      children: <Widget>[
        Container(
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
                        child: ChatContent(
                      scrollController: scrollController,
                    )),
                  ],
                ),
              ),
            )),
        AnimatedBuilder(
          animation: _controller,
          builder: (ctx, child) {
            var initial =
                _controller.upperBound / 1 * MediaQuery.of(context).size.height;
            var currentOffset =
                _controller.value / 1 * MediaQuery.of(context).size.height;

            return Positioned(
              right: 25,
              bottom: 25 - (initial - currentOffset),
              child: child,
            );
          },
          child: floatingMessageButton(),
        )
      ],
    );
  }

  Widget floatingMessageButton() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(3, 3), // changes position of shadow
          ),
        ],
      ),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.circular(50),
              splashColor: Colors.black26,
              highlightColor: Colors.black26,
              onTap: () {},
              child: Icon(Icons.message, color: Colors.white))),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
