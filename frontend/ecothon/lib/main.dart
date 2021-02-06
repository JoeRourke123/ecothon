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
        primarySwatch: Colors.green,
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

  int _selectedIndex = 0;
  int _number = 0;
  var _navBarItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.messenger_rounded),
      label: 'Feed',
      backgroundColor: Colors.blue,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star),
      label: 'Achievements',
      backgroundColor: Colors.amber,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
      backgroundColor: Colors.amber,
    ),
  ];

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _number = index;
      _controller.jumpToPage(index);
    });
  }

  void _onPagedChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _number = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_number != 0) {
            _onItemTapped(0);
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(_navBarItems[_selectedIndex].label),
          ),
          body: PageView(
            controller: _controller,
            onPageChanged: _onPagedChanged,
            children: [
              FeedPage(),
              AchievementsPage(),
              SettingsPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: _navBarItems,
            currentIndex: _selectedIndex,
            //selectedItemColor: Colors.green[800],
            onTap: _onItemTapped,
          ),
        ));
  }
}
