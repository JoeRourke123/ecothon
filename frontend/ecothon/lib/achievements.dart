import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecothon/components/achievementCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'generalStore.dart';

class AchievementsPage extends StatefulWidget {
  AchievementsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  Future<List<Map<String, dynamic>>> getAchievements() async {
    String token = Provider.of<GeneralStore>(context, listen: false).token;

    http.Response resp = await http.get(
        "https://ecothon.space/api/achievements/incomplete",
        headers: {"Authorization": "Bearer " + token});
    try {
      List<Map<String, dynamic>> achievements =
          List<Map<String, dynamic>>.from(jsonDecode(resp.body));

      print(achievements);
      return achievements;
    } catch (e) {
      print(e);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
          future: getAchievements(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
								padding: EdgeInsets.only(top: 20),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (c, i) => AchievementCard(achievement: snapshot.data[i],),
              );
            } else {
              return Center(child: Text("Loading"));
            }
          },
        ));
  }
}
