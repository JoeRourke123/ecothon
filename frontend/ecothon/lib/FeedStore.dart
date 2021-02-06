import 'package:ecothon/feed.dart';
import 'package:flutter/foundation.dart';

class FeedStore extends ChangeNotifier {
  List<FeedItemData> feedItemData = [
    FeedItemData("First"),
    FeedItemData("Second"),
    FeedItemData("Third"),
    FeedItemData("Fourth"),
    FeedItemData("Fifth"),
    FeedItemData("First"),
    FeedItemData("Second"),
    FeedItemData("Third"),
    FeedItemData("Fourth"),
    FeedItemData("Fifth"),
    FeedItemData("First"),
    FeedItemData("Second"),
    FeedItemData("Third"),
    FeedItemData("Fourth"),
    FeedItemData("Fifth"),
    FeedItemData("First"),
    FeedItemData("Second"),
    FeedItemData("Third"),
    FeedItemData("Fourth"),
    FeedItemData("Fifth"),
    FeedItemData("First"),
    FeedItemData("Second"),
    FeedItemData("Third"),
    FeedItemData("Fourth"),
    FeedItemData("Fifth"),
    FeedItemData("First"),
    FeedItemData("Second"),
    FeedItemData("Third"),
    FeedItemData("Fourth"),
    FeedItemData("Fifth"),
    FeedItemData("First"),
    FeedItemData("Second"),
    FeedItemData("Third"),
    FeedItemData("Fourth"),
    FeedItemData("Fifth"),
    FeedItemData("First"),
    FeedItemData("Second"),
    FeedItemData("Third"),
    FeedItemData("Fourth"),
    FeedItemData("Last"),
  ];

  void add(FeedItemData item) {
    feedItemData.add(item);
    notifyListeners();
  }

  void removeAll() {
    feedItemData.clear();
    notifyListeners();
  }
}