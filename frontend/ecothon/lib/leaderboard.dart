import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecothon/generalStore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'components/leaderboardCard.dart';

class LeaderboardPage extends StatefulWidget {
  LeaderboardPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool following = false;

  Future<List<Map<String, dynamic>>> _getLeaderboard() async {
    List<Map<String, dynamic>> json = [];
    try {
      http.Response res = await http.get(
          'https://ecothon.space/api/leaderboard' +
              (this.following ? "/following" : ""),
          headers: {
            "Authorization": "Bearer " +
                Provider
                    .of<GeneralStore>(context, listen: false)
                    .token
          });
      json = List<Map<String, dynamic>>.from(jsonDecode(res.body));
    } catch (Exception) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(Exception)));
    }
    return json;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            FlatButton.icon(
              onPressed: () {
                setState(() {
                  this.following = false;
                });
              },
              color: !following
                  ? Colors.green.shade800.withOpacity(0.7)
                  : Colors.white,
              icon: Icon(Icons.people),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text("All"),
              textColor: !following
                  ? Colors.white
                  : Colors.green.shade800.withOpacity(0.7),
            ),
            FlatButton.icon(
              onPressed: () {
                setState(() {
                  this.following = true;
                });
              },
              color: !following
                  ? Colors.white
                  : Colors.green.shade800.withOpacity(0.7),
              icon: Icon(Icons.people_outline),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              label: Text("Following"),
              textColor: !following
                  ? Colors.green.shade800.withOpacity(0.7)
                  : Colors.white,
            ),
          ]),
          Expanded(
              child: FutureBuilder(
                  future: _getLeaderboard(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return LeaderboardCard(
                                    data: snapshot.data[index]);
                              });
                    } else {
                      return SpinKitFoldingCube(color: Colors.green.shade400);
                    }
                  }))
        ]));
  }
}
