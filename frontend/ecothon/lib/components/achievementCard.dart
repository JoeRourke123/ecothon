import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'achievementScreen.dart';

class AchievementCard extends StatefulWidget {
  final Map<String, dynamic> achievement;

  const AchievementCard({Key key, this.achievement}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AchievementCardState();
  }
}

class _AchievementCardState extends State<AchievementCard> {
  double offset = 2.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                      imageUrl: widget.achievement["imageurl"],
                      fit: BoxFit.contain)),
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(offset, offset),
                    blurRadius: 4,
                    spreadRadius: 4)
              ], borderRadius: BorderRadius.circular(20))),
          GestureDetector(
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(offset, offset),
                            blurRadius: 8,
                            spreadRadius: 2)
                      ]),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(widget.achievement["title"],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ))),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(children: [
                                Icon(Icons.park,
                                    color: Colors.white.withOpacity(0.8)),
                                Text(widget.achievement["points"].toString(),
                                    style: TextStyle(color: Colors.white))
                              ]),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(360)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(Icons.chevron_right, size: 28),
                        )
                      ])),
              onTapDown: (t) {
                setState(() {
                  offset = 0.0;
                });
              },
              onTapUp: (t) {
								showMaterialModalBottomSheet(
									context: context,
									expand: false,
									builder: (context) => AchievementScreen(achievement: widget.achievement),
								);
                setState(() {
                  offset = 2.0;
                });
              })
        ]));
  }
}
