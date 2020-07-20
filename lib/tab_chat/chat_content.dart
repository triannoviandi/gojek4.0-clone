import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gojekclone/colors.dart';
import 'package:line_icons/line_icons.dart';

class ChatContent extends StatelessWidget {
  final ScrollController scrollController;

  ChatContent({this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      controller: scrollController,
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        Text(
          'Quick actions',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.orange[700]),
                      child: Icon(
                        Icons.mail,
                        color: Colors.white,
                        size: 20,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Inbox',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.green[600]),
                      child: Icon(
                        Icons.people,
                        color: Colors.white,
                        size: 24,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'New group',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: GojekColors.blue),
                      child: Icon(
                        Icons.call_split,
                        color: Colors.white,
                        size: 20,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Split bill',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: GojekColors.blue),
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 20,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Pay',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          'Your chats',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        SizedBox(
          height: 20,
        ),
        chat('Trian Noviandi', 'Hai, this is gojek clone animation', '09.00 PM')
      ],
    );
  }

  Widget chat(String contact, String message, String time) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: Text(
                '#',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  contact,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  softWrap: true,
                )
              ],
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Container(
            child: Text(
              time,
              style: TextStyle(color: Colors.grey[400]),
            ),
          )
        ],
      ),
    );
  }
}
