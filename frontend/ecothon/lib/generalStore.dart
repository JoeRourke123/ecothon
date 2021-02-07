import 'package:ecothon/feed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong/latlong.dart';

class GeneralStore extends ChangeNotifier {
  final storage = new FlutterSecureStorage();
  String username;
  String token;
  List<FeedItemData> feedItemData = [];
  LatLng mapPos;double mapZoom;

  void setLoginData(String username, String token) {
    this.username = username;
    this.token = token;
  }

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