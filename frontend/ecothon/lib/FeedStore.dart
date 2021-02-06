import 'package:ecothon/feed.dart';
import 'package:flutter/foundation.dart';

class FeedStore extends ChangeNotifier {
  List<FeedItemData> feedItemData = [];

  void setFeedItems(List<FeedItemData> items) {
    feedItemData = items;
    notifyListeners();
  }

  void add(FeedItemData item) {
    feedItemData.add(item);
    notifyListeners();
  }

  void removeAll() {
    feedItemData.clear();
    notifyListeners();
  }
}