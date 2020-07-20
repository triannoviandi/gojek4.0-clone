import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gojekclone/customlib/bubble_tab_indicator_custom.dart';
import 'package:gojekclone/sliding_content.dart';
import 'package:gojekclone/tab_chat/tab_chat.dart';
import 'package:gojekclone/tab_home/tab_home.dart';
import 'package:gojekclone/tab_promos/tab_promos.dart';
import 'package:rubber/rubber.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Size get size => MediaQuery.of(context).size;
  double get rubberSheetHeight => size.height - 70;
  double get sheetPercentage => rubberSheetHeight / size.height;

  double maxScreenHeight;

  TabController tabController;
  double get pageWidth => size.width;
  double get pageViewWidth => pageWidth * 1.02;
  double get widthFactor => 1.02;
  double get tabPaddingHorizontal =>
      ((widthFactor * pageWidth) - pageWidth) / 2;

  final bubleTabIndicator = BubbleTabIndicator(
    indicatorHeight: 34.0,
    indicatorColor: Color(0xff017893),
  );

  int activeTab = 1;

  PanelController panelController = PanelController();
  ScrollController sliderSheetScrollCtrl = ScrollController();

  final sliderPosition = new ValueNotifier(0.0);

  AnimationController sliderTransformController;
  Animation<double> sliderTransformAnimation;

  bool sliderShow = false;
  bool buttonShow = false;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: activeTab,
    );

    sliderTransformController =
        AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    sliderTransformAnimation =
        Tween(begin: 0.0, end: 130.0).animate(sliderTransformController);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrait) {
      maxScreenHeight = constrait.maxHeight;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: Scaffold(
            backgroundColor: Color(0xff02ACD3),
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  FractionallySizedBox(
                    widthFactor: widthFactor,
                    heightFactor: 1.0,
                    child: TabBarView(
                      controller: tabController,
                      children: <Widget>[
                        TabPromos(
                          rubberSheetPercentage: sheetPercentage,
                        ),
                        TabHome(
                          rubberSheetPercentage: sheetPercentage,
                          sliderShow: (show) {
                            if (show != sliderShow && show != null) {
                              sliderShow = show;
                              sliderShow
                                  ? sliderTransformController.reverse()
                                  : sliderTransformController.forward();
                            }
                          },
                        ),
                        TabChat(sheetPercentage),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 22),
                    child: TabBar(
                      controller: tabController,
                      indicator: bubleTabIndicator,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/icons/icon_promos.svg',
                                width: 22,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Promos',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/icons/icon_home.svg',
                                width: 22,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/icons/icon_chat.svg',
                                width: 22,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Chat',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  slidingSheetBuilder(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget slidingSheetBuilder() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        sliderPosition,
        sliderTransformController,
        tabController.animation,
      ]),
      builder: (ctx, child) {
        return Transform.translate(
            offset: Offset(
                (tabController.animation.value - 1) * pageViewWidth * -1,
                sliderTransformAnimation.value),
            child: slidingPanel());
      },
    );
  }

  Widget slidingPanel() {
    double margin = 24 * (-sliderPosition.value + 1);
    double marginFooter = sliderPosition.value * 48;
    double border = 50 * (-sliderPosition.value + 1);
    double footerOpacity() {
      if (sliderPosition.value == 0)
        return 1.0;
      else if (sliderPosition.value <= .20) {
        return 1 - (sliderPosition.value * 4);
      } else
        return 0.0;
    }

    return SlidingUpPanel(
      controller: panelController,
      onPanelSlide: (position) {
        sliderPosition.value = position;
      },
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          spreadRadius: 2,
          blurRadius: 12,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      header: Container(
        width: MediaQuery.of(context).size.width - 48 + marginFooter,
        height: 12,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 35,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
      ),
      footer: Opacity(
        opacity: footerOpacity(),
        child: Center(
          child: Container(
            height: 85,
            padding: EdgeInsets.symmetric(horizontal: 12),
            width: MediaQuery.of(context).size.width - 48 + marginFooter,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.green[600]),
                            child: Align(
                              child: SvgPicture.asset(
                                'assets/icons/icon_goride.svg',
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'GoRide',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.green[600]),
                          child: Align(
                            child: SvgPicture.asset(
                              'assets/icons/icon_gocar.svg',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'GoCar',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.red),
                          child: Align(
                            child: SvgPicture.asset(
                              'assets/icons/icon_gofood.svg',
                              width: 28,
                              height: 28,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'GoFood',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.red),
                          child: Align(
                            child: SvgPicture.asset(
                              'assets/icons/icon_gosend.svg',
                              width: 28,
                              height: 28,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'GoShop',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
          bottomLeft: Radius.circular(border),
          bottomRight: Radius.circular(border)),
      margin: EdgeInsets.all(margin),
      backdropColor: Colors.black,
      backdropEnabled: true,
      maxHeight: MediaQuery.of(context).size.height,
      minHeight: 95,
      panelBuilder: (scrollController) {
        return Opacity(
            opacity: sliderPosition.value < .20 ? 0.0 : sliderPosition.value,
            child: slidingContent(scrollController));
      },
    );
  }
}
