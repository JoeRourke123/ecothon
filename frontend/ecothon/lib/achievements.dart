import 'package:flutter/material.dart';

class AchievementsPage extends StatefulWidget {
  AchievementsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text("This is the settings page"));
  }
}
