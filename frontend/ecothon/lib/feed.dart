import 'dart:convert';
import 'dart:math';
import 'package:ecothon/components/feedCard.dart';
import 'package:flutter/material.dart';
import 'package:ecothon/generalStore.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin<FeedPage> {
  bool err = false;

  @override
  void initState() {
    super.initState();
    _pullRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: ListView.separated(
              padding: EdgeInsets.all(8),
              itemCount: Provider.of<GeneralStore>(context).feedItemData.length,
              itemBuilder: (context, index) {
                return Consumer<GeneralStore>(
                  builder: (context, feed, child) {
                    return FeedCard(
                      data: feed.feedItemData[index],
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            )));
  }

  Future<void> _pullRefresh() async {
    List<FeedItemData> items = [];
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      Position position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      Provider.of<GeneralStore>(context, listen: false).coords = [position.longitude, position.latitude];
      http.Response res = await http.post('https://ecothon.space/api/posts',
          body: jsonEncode({
            "type": "Point",
            "coordinates": [position.longitude, position.latitude]
          }),
          headers: {
            "Authorization": "Bearer " +
                Provider.of<GeneralStore>(context, listen: false).token
          });

      if (res.statusCode == 200) {
        var decoded = List<Map<String, dynamic>>.from(jsonDecode(res.body));
        print(decoded);
        for (Map<String, dynamic> i in decoded) {
          items.add(FeedItemData.fromJson(i));
        }
        Provider.of<GeneralStore>(context, listen: false).setFeedItems(items);
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
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch feed. Please retry")));
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class FeedItemData {
  final String id;
  final String user;
  final Map<String, dynamic> achievement;
  final String type;
  final List<Map<String, dynamic>> comments;
  final Map<String, dynamic> location;
  final Map<String, dynamic> details;
  final DateTime createdAt;
  List<String> likedby;
  final String picture;
  bool isLiked;

  FeedItemData(
      {this.id,
      this.user,
      this.achievement,
      this.type,
      this.comments,
      this.location,
      this.details,
      this.createdAt,
      this.likedby,
      this.picture,
      this.isLiked});

  factory FeedItemData.fromJson(Map<String, dynamic> json) {
    return FeedItemData(
        id: json["_id"],
        user: json["user"],
        achievement: Map<String,dynamic>.from(json["achievement"]),
        type: json["type"],
        comments: List<Map<String, dynamic>>.from(json["comments"]),
        location: json["geolocation"],
        details: json["details"],
        createdAt: DateTime.parse(json["created_at"]),
        likedby: List<String>.from(json["liked_by"]),
        picture: json["picture"],
        isLiked: json["is_liked"]);
  }
}
