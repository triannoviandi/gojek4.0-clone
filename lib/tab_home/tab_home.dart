import 'package:flutter/material.dart';
import 'package:gojekclone/tab_home/home_content.dart';
import 'package:rubber/rubber.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TabHome extends StatefulWidget {
  final Function(bool show) sliderShow;
  final Function(bool show) slideUpButtonShow;

  final double rubberSheetPercentage;

  TabHome(
      {this.rubberSheetPercentage, this.sliderShow, this.slideUpButtonShow});
  @override
  _TabHomeState createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  double get pageWidth => MediaQuery.of(context).size.width;
  double get widthFactor => 1.02;
  double get tabPaddingHorizontal =>
      ((widthFactor * pageWidth) - pageWidth) / 2;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  ScrollController rubberSheetScrollCtrl = ScrollController();
  ScrollController sliderSheetScrollCtrl = ScrollController();
  RubberAnimationController rubberSheetAnimationCtrl;
  PanelController panelController = PanelController();

  final sliderPosition = new ValueNotifier(0.0);

  AnimationController buttonSliderTransformController;
  Animation<double> buttonSliderTransformAnimation;

  bool rubberExpanded = true;
  bool slideBtnHideByScroll = true;
  bool buttonShow = false;

  double distanceScroll;
  double initialScroll;
  double endScroll;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    rubberSheetAnimationCtrl = RubberAnimationController(
        vsync: this,
        lowerBoundValue: AnimationControllerValue(pixel: 300),
        upperBoundValue:
            AnimationControllerValue(percentage: widget.rubberSheetPercentage),
        springDescription: SpringDescription.withDampingRatio(
            mass: 1, stiffness: Stiffness.LOW, ratio: DampingRatio.LOW_BOUNCY),
        duration: Duration(microseconds: 1));
    rubberSheetAnimationCtrl.expand();
    buttonSliderTransformController =
        AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    buttonSliderTransformAnimation =
        Tween(begin: 0.0, end: 130.0).animate(buttonSliderTransformController);

    rubberSheetScrollCtrl.addListener(() {
      hideSlider();
    });
    rubberSheetAnimationCtrl.addListener(() {
      hideSlider();
    });
  }

  void scrollUpBtnShow(bool show) {
    if (show != buttonShow) {
      buttonShow = show;
      show
          ? buttonSliderTransformController.forward()
          : buttonSliderTransformController.reverse();
    }
  }

  void hideSlider() {
    if (rubberSheetAnimationCtrl.animationState.value ==
            AnimationState.expanded &&
        rubberSheetScrollCtrl.offset == 0.0) {
      rubberExpanded = true;
      widget.sliderShow(true);
      scrollUpBtnShow(false);
    } else if (rubberSheetAnimationCtrl.animationState.value ==
        AnimationState.collapsed) {
      rubberExpanded = false;
      widget.sliderShow(false);
      scrollUpBtnShow(false);
    } else if (rubberSheetAnimationCtrl.animationState.value ==
        AnimationState.animating) {
      if (rubberExpanded) {
        widget.sliderShow(false);
        scrollUpBtnShow(false);
      } else {
        widget.sliderShow(true);
        scrollUpBtnShow(false);
      }
    } else if (distanceScroll >= 100) {
      widget.sliderShow(true);
      scrollUpBtnShow(false);
    } else if (distanceScroll <= -100) {
      widget.sliderShow(false);
      scrollUpBtnShow(true);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(horizontal: tabPaddingHorizontal),
            child: RubberBottomSheet(
              scrollController: rubberSheetScrollCtrl,
              animationController: rubberSheetAnimationCtrl,
              lowerLayer: Container(
                color: Colors.transparent,
              ),
              upperLayer: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: NotificationListener(
                  onNotification: (notif) {
                    if (notif is ScrollStartNotification) {
                      distanceScroll = 0;
                      initialScroll = rubberSheetScrollCtrl.offset;
                    } else if (notif is ScrollUpdateNotification) {
                      endScroll = rubberSheetScrollCtrl.offset;
                      distanceScroll = initialScroll - endScroll;
                      rubberSheetScrollCtrl.notifyListeners();
                    }
                    return true;
                  },
                  child: HomeContent(
                    controller: rubberSheetScrollCtrl,
                  ),
                ),
              ),
            )),
        scrollUpBtn()
      ],
    );
  }

  Widget scrollUpBtn() {
    return Positioned(
      bottom: 180,
      right: 32,
      child: AnimatedBuilder(
        animation: buttonSliderTransformController,
        builder: (ctx, child) {
          double opacity = buttonSliderTransformAnimation.value / 130;
          return Transform.translate(
            offset: Offset(0, buttonSliderTransformAnimation.value),
            child: Opacity(opacity: opacity, child: child),
          );
        },
        child: GestureDetector(
          onTap: () {
            rubberSheetScrollCtrl.animateTo(0,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          },
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey, width: .3)),
            child: Icon(
              Icons.arrow_upward,
              color: Colors.green,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
