import 'package:flutter/material.dart';
import 'package:ecothon/FeedStore.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Feed"),
        ),
        body: ListView.builder(
          itemCount: Provider.of<FeedStore>(context).feedItemData.length,
            itemBuilder: (context, index) {
          return Consumer<FeedStore>(
            builder: (context, feed, child) {
              String text = feed.feedItemData[index].text;
              return FeedItem(text: text);
            },
          );
        }));
  }
}

class FeedItem extends StatelessWidget {
  final String text;
  FeedItem({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(this.text),
    );
  }
}

@immutable
class FeedItemData {
  final String text;

  FeedItemData(this.text) {}
}
