import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecothon/feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:ecothon/generalStore.dart';
import 'achievementScreen.dart';
import 'commentScreen.dart';

class FeedCard extends StatefulWidget {
  final FeedItemData data;

  const FeedCard({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FeedCardState();
  }
}

class _FeedCardState extends State<FeedCard> {
  double offset = 2.0;
  int distance;

  int calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a))).ceil();
  }

  @override
  void initState() {
    super.initState();

    List<double> coords =
        Provider.of<GeneralStore>(context, listen: false).coords;
    distance = calculateDistance(
        coords[1],
        coords[0],
        widget.data.location["coordinates"][1],
        widget.data.location["coordinates"][0]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          widget.data.picture != null
              ? Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                          imageUrl: widget.data.picture, fit: BoxFit.contain)),
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(offset, offset),
                        blurRadius: 4,
                        spreadRadius: 4)
                  ], borderRadius: BorderRadius.circular(20)))
              : null,
          // TODO: This will probs cause errors lmao
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
                  child: Column(children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Text("@" + widget.data.user,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ))),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(children: [
                                  Icon(Icons.thumb_up,
                                      color: widget.data.isLiked
                                          ? Colors.white
                                          : Colors.blueGrey),
                                  Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                          widget.data.likedby.length.toString(),
                                          style: TextStyle(
                                              color: widget.data.isLiked
                                                  ? Colors.white
                                                  : Colors.blueGrey)))
                                ]),
                                decoration: BoxDecoration(
                                    color: widget.data.isLiked
                                        ? Colors.green.shade400
                                        : Colors.white,
                                    border: widget.data.isLiked
                                        ? Border.all(
                                            width: 2.0,
                                            color: Colors.green.shade400)
                                        : Border.all(
                                            width: 2.0, color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(360)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(Icons.more_horiz_rounded, size: 28),
                          )
                        ]),
                    SizedBox(height: 5),
                    Row(children: [Text(widget.data.details["caption"])]),
                    if (widget.data.achievement != null)
                      InkWell(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 30),
                            child: Row(children: [
                              Expanded(
                                  child: Text(widget.data.achievement["title"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic))),
                              Container(
                                alignment: Alignment.center,
                                child: Row(children: [
                                  Icon(Icons.park,
                                      size: 16, color: Colors.white),
                                  Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                          widget.data.achievement["points"]
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)))
                                ]),
                                decoration: BoxDecoration(
                                    color: Colors.green.shade400,
                                    borderRadius: BorderRadius.circular(360)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                              ),
                              IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {},
                              )
                            ]),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: Offset(1, 1),
                                      blurRadius: 4,
                                      spreadRadius: 1)
                                ])),
                        onTap: () {
                          showMaterialModalBottomSheet(
                            context: context,
                            expand: false,
                            builder: (context) => AchievementScreen(
                                achievement: widget.data.achievement),
                          );
                        },
                      ),
                    SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(timeago.format(widget.data.createdAt),
                              style: TextStyle(color: Colors.grey)),
                          Text("~" + distance.toString() + "m away",
                              style: TextStyle(color: Colors.grey)),
                        ])
                  ])),
              onTapDown: (t) {
                setState(() {
                  offset = 0.0;
                });
              },
              onTapUp: (t) {
              	setState(() {
              	  offset = 2.0;
              	});
              	showMaterialModalBottomSheet(context: context, useRootNavigator: true, expand: false, builder: (context) => CommentScreen(post: widget.data));
							},
              onDoubleTap: () async {
                String endpoint;
                setState(() {
                  if (widget.data.isLiked) {
                    widget.data.likedby.remove(
                        Provider.of<GeneralStore>(context, listen: false)
                            .username);
                    widget.data.isLiked = false;
                    endpoint = "unlike";
                  } else {
                    widget.data.likedby.add(
                        Provider.of<GeneralStore>(context, listen: false)
                            .username);
                    widget.data.isLiked = true;
                    endpoint = "like";
                  }
                });
                try {
                  http.Response res = await http.post(
                      "https://ecothon.space/api/posts/" +
                          widget.data.id +
                          "/" +
                          endpoint,
                      headers: {
                        "Authorization": "Bearer " +
                            Provider.of<GeneralStore>(context, listen: false)
                                .token
                      });
                  if (res.statusCode == 200) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text((widget.data.isLiked ? "Post has been liked!" : "You've unliked this post :("))));
                  } else {
                    try {
                      dynamic decoded = jsonDecode(res.body);
                      if (decoded is Map && decoded["error"] != null) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(decoded["error"])));
                      }
                    } catch (_) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text(res.reasonPhrase)));
                    }
                  }
                } catch (Exception) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(Exception.toString())));
                }
              })
        ]));
  }
}
