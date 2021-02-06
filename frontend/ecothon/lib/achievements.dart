import 'dart:convert';

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
      return achievements;
    } catch (e) {
      print(e);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: getAchievements(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (c, i) => Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 8,
                              spreadRadius: 2)
                        ]),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Text(snapshot.data[i]["title"],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ))),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(children: [
                                  Icon(Icons.park, color: Colors.white.withOpacity(0.8)),
                                  Text(snapshot.data[i]["points"].toString(),
                                      style: TextStyle(color: Colors.white))
                                ]),
                                decoration: BoxDecoration(
                                    color: Colors.green.shade400,
                                    borderRadius: BorderRadius.circular(360)),
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(Icons.chevron_right, size: 28),
                          )
                        ])),
              );
            } else {
              return Center(child: Text("Loading"));
            }
          },
        ));
  }
}
