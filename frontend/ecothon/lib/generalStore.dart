import 'package:ecothon/feed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong/latlong.dart';

class GeneralStore extends ChangeNotifier {
  final storage = new FlutterSecureStorage();
  String username;
  String token;
  List<FeedItemData> feedItemData = [];
  List<Map<String, dynamic>> achievementData = [];
  LatLng mapPos;
  double mapZoom;

  List<double> coords;

  void setLoginData(String username, String token) {
    this.username = username;
    this.token = token;
  }

  void setAchievementData(List<Map<String, dynamic>> items) {
    achievementData = items;
    notifyListeners();
  }

  void setFeedItems(List<FeedItemData> items) {
    feedItemData = items;
    notifyListeners();
  }

  void removeAllFeedData() {
    feedItemData.clear();
    notifyListeners();
  }
}
