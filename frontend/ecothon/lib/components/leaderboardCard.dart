import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecothon/components/userScreen.dart';
import 'package:ecothon/feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../generalStore.dart';
import 'achievementScreen.dart';
import 'package:http/http.dart' as http;


class LeaderboardCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const LeaderboardCard({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LeaderboardCardState();
  }
}

class _LeaderboardCardState extends State<LeaderboardCard> {
  double offset = 2.0;
  int distance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          try {
            http.Response res = await http.get(
                'https://ecothon.space/api/user/' + widget.data["username"] + '/profile',
                headers: {
                  "Authorization": "Bearer " +
                      Provider.of<GeneralStore>(context, listen: false).token
                });
            if (res.statusCode == 200) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Scaffold(
                      body: UserScreen(
                        user: jsonDecode(res.body),
                      )
                  )));
            } else {
              try {
                dynamic decoded = jsonDecode(res.body);
                if (decoded is Map && decoded["error"] != null) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(decoded["error"])));
                }
              } catch (_) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(res.reasonPhrase)));
              }
            }
          } catch (Exception) {
            print("Breaking here: " + Exception.toString());
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Failed to fetch user data. Please retry")));
          }
        },
        child: Container(
        height: 100,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: widget.data["profile_picture"] != ""
                          ? CachedNetworkImage(
                              imageUrl: widget.data["profile_picture"],
                              fit: BoxFit.contain)
                          : FittedBox(child: Icon(Icons.person))
                  ),
                  width: 50,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(offset, offset),
                        blurRadius: 4,
                        spreadRadius: 4)
                  ], borderRadius: BorderRadius.circular(20)),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text("@" + widget.data["username"],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ))),
              ]),
              Container(
                alignment: Alignment.center,
                child: Row(children: [
                  Icon(Icons.park, color: Colors.white.withOpacity(0.8)),
                  Text(widget.data["points"].toString(),
                      style: TextStyle(color: Colors.white))
                ]),
                decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(360)),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              )
            ])));
  }
}
