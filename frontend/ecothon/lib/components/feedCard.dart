import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecothon/feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:ecothon/generalStore.dart';
import 'achievementScreen.dart';

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
                  margin: EdgeInsets.only(bottom: 30),
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
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(widget.data.user,
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
                                    color: Colors.white.withOpacity(0.8)),
                                Text(widget.data.likedby.length.toString(),
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
                  headers: {"Authorization": "Bearer " + Provider.of<GeneralStore>(context, listen: false).token});
                  if (res.statusCode == 200) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(endpoint + "d post")));
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
