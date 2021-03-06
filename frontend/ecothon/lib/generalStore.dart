import 'package:ecothon/feed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong/latlong.dart';

class GeneralStore extends ChangeNotifier {
  final storage = new FlutterSecureStorage();
  String username;
  String token;
  List<FeedItemData> feedItemData;
  List<Map<String, dynamic>> achievementData = [];
  List<Map<String, dynamic>> leaderboardData;
  LatLng mapPos;
  double mapZoom;
  List<Marker> markers = [];

  List<double> coords;

  void setLoginData(String username, String token) {
    this.username = username;
    this.token = token;
  }

  void setAchievementData(List<Map<String, dynamic>> items) {
    achievementData = items;
    notifyListeners();
  }

  void setLeaderboardData(List<Map<String, dynamic>> items) {
    leaderboardData = items;
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
