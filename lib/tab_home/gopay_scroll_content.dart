import 'package:flutter/material.dart';

Widget gopayScrollContent({ScrollController scrollController, int index}) {
  double itemHeight = 75;
  int currentIndex = index;
  double activeOffset = itemHeight * currentIndex;

  return AnimatedBuilder(
    animation: scrollController,
    builder: (ctx, child) {
      double opacity;
      if (scrollController.offset < activeOffset - 50)
        opacity = .5;
      else if (scrollController.offset < activeOffset) {
        opacity = 1 + ((scrollController.offset - activeOffset) / 100);
      } else if (scrollController.offset < activeOffset + 50) {
        opacity = 1 - ((scrollController.offset - activeOffset) / 100);
      } else
        opacity = .5;

      return Opacity(
        opacity: opacity,
        child: child,
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      height: itemHeight,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                'assets/icons/gopay.png',
                width: 12,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                index == 1 ? 'Gopay' : 'paylater',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              )
            ],
          ),
          SizedBox(
            height: 2,
          ),
          index == 1 ? secondItem() : firstItem()
        ],
      ),
    ),
  );
}

Widget firstItem() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Order now, pay by the end of month',
        style: TextStyle(
            fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w400),
      )
    ],
  );
}

Widget secondItem() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Rp3.637',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
      ),
      Text(
        'Tap to top up',
        style: TextStyle(
            fontSize: 12,
            color: Colors.green[700],
            fontWeight: FontWeight.w700),
      )
    ],
  );
}
