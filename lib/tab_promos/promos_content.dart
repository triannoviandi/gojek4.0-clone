import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gojekclone/colors.dart';
import 'package:line_icons/line_icons.dart';

class PromosContent extends StatelessWidget {
  final scrollController;

  PromosContent({this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        SizedBox(
          height: 14,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: headerCard('3', 'Vouchers', '1 Expiring Soon',
                      GojekColors.orangeGradient)),
              SizedBox(
                width: 12,
              ),
              Expanded(
                  flex: 1,
                  child: headerCard('0', 'Subscription', 'Active now',
                      GojekColors.blueGradient)),
              SizedBox(
                width: 12,
              ),
              Expanded(
                  flex: 1,
                  child: headerCard('0', 'Missions', 'In Progress',
                      GojekColors.purpleGradient)),
            ],
          ),
        ),
        SizedBox(
          height: 14,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              headerButton(
                  Icon(
                    Icons.stars,
                    size: 28,
                    color: Colors.yellow[700],
                  ),
                  'Got a promo code? Enter here'),
              headerButton(
                  Icon(
                    Icons.people,
                    size: 28,
                    color: GojekColors.blue,
                  ),
                  'Got a promo code? Enter here')
            ],
          ),
        ),
      ],
    );
  }

  Widget headerButton(Icon icon, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300], width: 1),
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: <Widget>[
          icon,
          SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
          Spacer(),
          Icon(
            CupertinoIcons.forward,
            size: 18,
            color: Colors.grey[700],
          )
        ],
      ),
    );
  }

  Widget headerCard(
      String number, String title, String desc, Gradient gradient) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Text(
              number,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Text(
              desc,
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
