import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ecothon/FeedStore.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Feed"),
        ),
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: ListView.separated(
              padding: EdgeInsets.all(8),
              itemCount: Provider.of<FeedStore>(context).feedItemData.length,
              itemBuilder: (context, index) {
                return Consumer<FeedStore>(
                  builder: (context, feed, child) {
                    return FeedItem(
                        text: feed.feedItemData[index].text,
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
    // Get new feed here by making request to http endpoint then create list
    // of FeedItemData in items
    List<FeedItemData> items = [
      FeedItemData("New item 1"),
      FeedItemData("New item 2"),
      FeedItemData("New item 3"),
      FeedItemData("New item 4"),
    ];
    Provider.of<FeedStore>(context, listen: false).setFeedItems(items);
  }

  @override
  bool get wantKeepAlive => true;
}

class FeedItem extends StatelessWidget {
  final int index;
  final String text;
  final rng = new Random();

  List colors = Colors.primaries;

  FeedItem({Key key, this.text, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int rand = rng.nextInt(colors.length);
    return Container(
      padding: EdgeInsets.all(8),
      child: Center(child: Text("\n\n" + this.text + "\n\n")),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [this.colors[rand][100], this.colors[rand][900]])
      ),
    );
  }
}

@immutable
class FeedItemData {
  final String text;

  FeedItemData(this.text) {}
}
