import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ecothon/FeedStore.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: ListView.separated(
              padding: EdgeInsets.all(8),
              itemCount: Provider.of<FeedStore>(context).feedItemData.length,
              itemBuilder: (context, index) {
                return Consumer<FeedStore>(
                  builder: (context, feed, child) {
                    return FeedItem(
                      data: feed.feedItemData[index],
                      index: index,
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
    http.Response res = await http.get('http://ecothon.space/api/all');
    if (res.statusCode == 200) {
      var decoded = json.decode(res.body);
      for (var i in decoded) {
        items.add(FeedItemData.fromJson(i));
      }
      Provider.of<FeedStore>(context, listen: false).setFeedItems(items);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch feed. Please retry")));
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class FeedItem extends StatelessWidget {
  final int index;
  final FeedItemData data;
  final rng = new Random();

  List colors = Colors.primaries;

  FeedItem({Key key, this.data, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int rand = rng.nextInt(colors.length);
    return Container(
      padding: EdgeInsets.all(8),
      child: Center(child: Text(this.data.user + "\n" + this.data.achievement)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [this.colors[rand][100], this.colors[rand][900]])),
    );
  }
}

@immutable
class FeedItemData {
  final String user;
  final String achievement;
  final String type;
  final String comments;
  final String likedBy;
  final String location;
  final String details;
  final DateTime createdAt;

  FeedItemData(
      {this.user,
      this.achievement,
      this.type,
      this.comments,
      this.likedBy,
      this.location,
      this.details,
      this.createdAt});

  factory FeedItemData.fromJson(Map<String, dynamic> json) {
    return FeedItemData(
        user: json["user"],
        achievement: json["achievement"],
        type: json["type"],
        comments: json["comments"],
        likedBy: json["liked_by"],
        location: json["geolocation"],
        details: json["details"],
        createdAt: json["created_at"]);
  }
}
