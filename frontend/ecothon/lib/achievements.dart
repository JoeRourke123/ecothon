import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecothon/components/achievementCard.dart';
import 'package:ecothon/leaderboard.dart';
import 'package:ecothon/map.dart';
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

class _AchievementsPageState extends State<AchievementsPage>
    with AutomaticKeepAliveClientMixin<AchievementsPage> {
  Future<void> _getAchievements() async {
    String token = Provider.of<GeneralStore>(context, listen: false).token;

    http.Response resp = await http.get(
        "https://ecothon.space/api/achievements/incomplete",
        headers: {"Authorization": "Bearer " + token});
    try {
      List<Map<String, dynamic>> achievements =
          List<Map<String, dynamic>>.from(jsonDecode(resp.body));
      Provider.of<GeneralStore>(context, listen: false)
          .setAchievementData(achievements);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
      onRefresh: _getAchievements,
      child: ListView(
          padding: EdgeInsets.only(top: 20),
          shrinkWrap: true,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                          appBar: AppBar(
                            backgroundColor: Colors.white,
                            title: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.fitHeight,
                              width: 32,
                            ),
                            centerTitle: true,
                            shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            toolbarHeight: 64,
                            elevation: 6.0,
                          ),
                          body: LeaderboardPage()
                      )
                  ));
                },
                color: Colors.green.shade800.withOpacity(0.7),
								padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
								shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                icon: Icon(Icons.leaderboard_rounded),
                label: Text("Leaderboard"),
                textColor: Colors.white,
              ),
              FlatButton.icon(
                onPressed: () {
                	Navigator.of(context).push(MaterialPageRoute(
										builder: (context) => Scaffold(
											appBar: AppBar(
												backgroundColor: Colors.white,
												title: Image.asset(
													'assets/images/logo.png',
													fit: BoxFit.fitHeight,
													width: 32,
												),
												centerTitle: true,
												shape:
												RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
												toolbarHeight: 64,
												elevation: 6.0,
											),
											body: MapPage()
										)
									));
								},
                color: Colors.green.shade800.withOpacity(0.7),
                icon: Icon(Icons.map_rounded),
								padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
								shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
								label: Text("Map"),
                textColor: Colors.white,
              )
            ]),
            SizedBox(height: 10),
            ListView.builder(
              itemCount:
                  Provider.of<GeneralStore>(context).achievementData.length,
              itemBuilder: (context, index) {
                return Consumer<GeneralStore>(
                    builder: (context, achievement, child) {
                  return AchievementCard(
                      achievement: Provider.of<GeneralStore>(context)
                          .achievementData[index]);
                });
              },
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            )
          ]),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
