import 'dart:convert';

import 'package:ecothon/components/achievement_card.dart';
import 'package:ecothon/components/loader.dart';
import 'package:ecothon/components/tabs.dart';
import 'package:ecothon/components/titles.dart';
import 'package:ecothon/stores/auth_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }

}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> posts;
  TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 4, vsync: this);
  }

  Future<void> populatePosts(BuildContext context) async {
    if(posts == null) {
      posts = [];
    } else {
      return;
    }

    AuthStore auth = Provider.of<AuthStore>(context, listen: false);
    http.Response postResp = await auth.makeGET("/achievements/all");

    if (postResp.statusCode == 200) {
      posts = List<Map<String, dynamic>>.from(jsonDecode(postResp.body));
    } else {
      print(postResp.statusCode);
      print(postResp.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(padding: EdgeInsets.fromLTRB(20, 20, 20, 0), children: [
          TitleText("Your feed."),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: EcothonTabs(
                controller: _controller,
                initial: 1,
                onPresseds: [(i) {
                  print("Open new post");
                }, null, null, null],
                icons: [Icons.add_circle_rounded, Icons.pin_drop_rounded, Icons.people_alt_rounded, Icons.trending_up_rounded],
                texts: ["Post", "Nearby", "Following", "Trending"],
                gradients: [FlutterGradients.ladyLips(), FlutterGradients.healthyWater(), FlutterGradients.happyMemories(), FlutterGradients.bigMango()],
              )
          ),
          FutureBuilder(
            future: populatePosts(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) => AchievementCard(achievement: posts[index],),
                );
              } else {
                return Center(child: EcothonLoader(), heightFactor: 100,);
              }
            },
          )
        ]));
  }
}
