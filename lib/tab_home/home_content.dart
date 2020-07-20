import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gojekclone/customlib/scroll_snap_list_custom.dart';
import 'package:gojekclone/tab_home/gopay_scroll_content.dart';
import 'package:gojekclone/tab_home/item_list_indicator.dart';
import 'package:line_icons/line_icons.dart';

class HomeContent extends StatelessWidget {
  final ScrollController controller;

  HomeContent({this.controller});

  GlobalKey<ScrollSnapListState> sslKey = GlobalKey();
  ScrollController gopayScrollCtrl;

  final itemListIndex = new ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    gopayScrollCtrl = ScrollController();
    return Column(
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
            child: ListView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[search(), profileButton()],
              ),
            ),
            gopay(context),
            topPicks(),
            content(context),
            SizedBox(
              height: 900,
            ),
          ],
        )),
      ],
    );
  }

  Widget content(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/icons/gojek.png',
                  width: 70,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'This is a Content',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
              ],
            ),
          ),
          Container(
            height: 230,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    height: 225,
                    width: MediaQuery.of(context).size.width - 40,
                    child: Align(
                      child: Card(
                        margin: EdgeInsets.only(
                            left: index == 0 ? 20 : 10, right: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8))),
                              height: 120,
                            ),
                            Container(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'This is a Content',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget topPicks() {
    var selectedIndex = new ValueNotifier(0);

    List<String> category = [
      'All',
      'COVID-19',
      'Donation',
      'Entertainment',
      'Food',
      'J3K',
      'Lifestyle',
      'Payments',
      'Promos',
      'Shopping'
    ];

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Top picks for you',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
          AnimatedBuilder(
            animation: selectedIndex,
            builder: (context, child) => Container(
              height: 30,
              margin: EdgeInsets.only(top: 16),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: category.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () => selectedIndex.value = index,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin:
                          EdgeInsets.only(left: index == 0 ? 20 : 4, right: 4),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: index == selectedIndex.value
                                  ? Colors.green[700]
                                  : Colors.grey[400],
                              width: 1),
                          borderRadius: BorderRadius.circular(15),
                          color: index == selectedIndex.value
                              ? Colors.green[700]
                              : Colors.white),
                      child: Center(
                        child: Text(
                          category[index],
                          style: TextStyle(
                              color: index == selectedIndex.value
                                  ? Colors.white
                                  : Colors.grey[800],
                              fontSize: 14),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget gopay(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
          color: Color(0xff02ACD3), borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: <Widget>[
          AnimatedBuilder(
            animation: itemListIndex,
            builder: (context, child) => ItemListIndicator(
              total: 2,
              currentIndex: itemListIndex.value,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 100,
            child: ScrollSnapList(
              onItemFocus: (index) {
                itemListIndex.value = index;
              },
              itemSize: 75,
              itemBuilder: (ctx, index) {
                return Container(
                  child: gopayScrollContent(
                      index: index, scrollController: gopayScrollCtrl),
                );
              },
              itemCount: 2,
              duration: 100,
              initialIndex: 1,
              key: sslKey,
              listController: gopayScrollCtrl,
              dynamicItemSize: true,
              scrollDirection: Axis.vertical,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    Icons.arrow_upward,
                    size: 16,
                    color: Color(0xff02ACD3),
                  )),
              SizedBox(
                height: 6,
              ),
              Text(
                'Pay',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              )
            ],
          )),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: Color(0xff02ACD3),
                  )),
              SizedBox(
                height: 6,
              ),
              Text(
                'Top Up',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              )
            ],
          )),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    Icons.menu,
                    size: 16,
                    color: Color(0xff02ACD3),
                  )),
              SizedBox(
                height: 6,
              ),
              Text(
                'More',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              )
            ],
          )),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget profileButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.green[700]),
      child: Align(
        child: SvgPicture.asset(
          'assets/icons/icon_profile.svg',
          width: 24,
        ),
      ),
    );
  }

  Widget search() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 20),
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey.withOpacity(.05),
            border: Border.all(color: Colors.grey.withOpacity(.5), width: .5)),
        child: Row(
          children: <Widget>[
            Center(child: Icon(Icons.search)),
            SizedBox(
              width: 8,
            ),
            Text(
              'Order the best nasgor in town...',
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
