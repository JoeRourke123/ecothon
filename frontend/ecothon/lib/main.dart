import 'package:ecothon/generalStore.dart';
import 'package:ecothon/login.dart';
import 'package:flutter/material.dart';
import 'package:ecothon/achievements.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import 'package:flutter/foundation.dart';
import 'package:ecothon/feed.dart';

main() {
  runApp(ChangeNotifierProvider(
    create: (context) => GeneralStore(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecothon',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loggedIn = false;
  int _selectedIndex = 0;
  int _number = 0;
  var _navBarItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.messenger_rounded),
      label: 'Feed',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star),
      label: 'Achievements',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
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
  void initState() {
    super.initState();
    loggedIn(); //running initialisation code; getting prefs etc.
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
        child: _loggedIn
            ? Scaffold(
                appBar: AppBar(
                  title: Text(_navBarItems[_selectedIndex].label),
                ),
                body: PageView(
                  controller: _controller,
                  onPageChanged: _onPagedChanged,
                  children: [
                    FeedPage(),
                    AchievementsPage(),
                    ProfilePage(),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: _navBarItems,
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.green[800],
                  onTap: _onItemTapped,
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text("Login"),
                ),
                body: LoginPage()));
  }

  Future<void> loggedIn() async {
    final storage = new FlutterSecureStorage();
    if (await storage.containsKey(key: "username") &&
        await storage.containsKey(key: "token")) {
      String username = await storage.read(key: "username");
      String token = await storage.read(key: "token");
      Provider.of<GeneralStore>(context).setLoginData(username, token);
      setState(() {
        _loggedIn = true;
      });
      return;
    }
    setState(() {
      _loggedIn = false;
    });
  }
}
