import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget slidingContent(ScrollController controller) {
  return Container(
    child: Column(
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            controller: controller,
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Your Favorites',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 1, color: Colors.green[700])),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w900),
                    ),
                  )
                ],
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
                  Container(
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
                  Container(
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
            ],
          ),
        ),
      ],
    ),
  );
}
