import 'dart:convert';

import 'package:ecothon/components/achievement_card.dart';
import 'package:ecothon/components/gradient_button.dart';
import 'package:ecothon/components/gradient_card.dart';
import 'package:ecothon/components/loader.dart';
import 'package:ecothon/components/tabs.dart';
import 'package:ecothon/components/titles.dart';
import 'package:ecothon/stores/auth_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ExplorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExplorePageState();
  }
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> tasks;
  TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 4, vsync: this);
  }

  Future<void> populateTasks() async {
    if (tasks == null) {
      tasks = [];
    } else {
      return;
    }

    AuthStore auth = Provider.of<AuthStore>(context, listen: false);
    http.Response postResp = await auth.makeGET("/achievements/incomplete");

    if (postResp.statusCode == 200) {
      tasks = List<Map<String, dynamic>>.from(jsonDecode(postResp.body));
    } else {
      print(postResp.statusCode);
      print(postResp.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(padding: EdgeInsets.fromLTRB(20, 20, 20, 0), children: [
      TitleText("Explore."),
      SizedBox(
        height: 30,
      ),
      Stack(
        children: [
          GradientCard(
            gradient:
                FlutterGradients.eternalConstance(tileMode: TileMode.clamp),
            height: 400,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(children: [
                Text(
                  "Trending Tasks",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ]))
        ],
      ),
      Container(
          height: 100,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListView(scrollDirection: Axis.horizontal, children: [
            SizedBox(
              width: 10,
            ),
            GradientButton(
              gradient: FlutterGradients.healthyWater(),
              icon: Icons.emoji_events_rounded,
              text: "Leaderboards",
              onTap: () {},
            ),
            SizedBox(
              width: 10,
            ),
            GradientButton(
              gradient: FlutterGradients.colorfulPeach(),
              icon: Icons.pin_drop_rounded,
              text: "Map",
              onTap: () {},
            ),
            SizedBox(
              width: 10,
            ),
            GradientButton(
              gradient: FlutterGradients.teenNotebook(),
              icon: Icons.message,
              text: "Forums",
              onTap: () {},
            ),
            SizedBox(
              width: 10,
            ),
          ])),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Complete a Task",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        FutureBuilder(
          future: populateTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                  width: MediaQuery.of(context).size.width * 2,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) => AchievementCard(
                      achievement: tasks[index],
                    ),
                  ));
            } else {
              return Center(
                child: EcothonLoader(),
                heightFactor: 100,
              );
            }
          },
        )
      ]),
    ]));
  }
}
