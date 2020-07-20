import 'package:flutter/material.dart';

class ItemListIndicator extends StatelessWidget {
  final int total;
  final int currentIndex;

  ItemListIndicator({this.currentIndex, this.total});

  Widget item(bool active) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      height: 8,
      width: 2,
      decoration: BoxDecoration(
          color: active ? Colors.white : Colors.grey[400],
          borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < total; i++) item(i == currentIndex ? true : false)
        ],
      ),
    );
  }
}
