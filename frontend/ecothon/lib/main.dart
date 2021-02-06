import 'package:ecothon/FeedStore.dart';
import 'package:flutter/material.dart';
import 'package:ecothon/achievements.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import 'package:flutter/foundation.dart';
import 'package:ecothon/feed.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => FeedStore(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        FeedPage(),
        AchievementsPage(),
        SettingsPage(),
      ],
    );
  }
}
