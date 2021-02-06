import 'package:ecothon/generalStore.dart';
import 'package:ecothon/login.dart';
import 'package:flutter/material.dart';
import 'package:ecothon/achievements.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:ecothon/feed.dart';
import 'settings.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GeneralStore store = GeneralStore();
  final storage = new FlutterSecureStorage();

  bool isLoggedIn = await storage.containsKey(key: "username") &&
      await storage.containsKey(key: "token");

  String username = await storage.read(key: "username");
  String token = await storage.read(key: "token");
  store.setLoginData(username, token);

  runApp(ChangeNotifierProvider(
    create: (context) => store,
    child: MyApp(isLoggedIn: isLoggedIn),
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key key, this.isLoggedIn}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecothon',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: (isLoggedIn ? MyHomePage() : LoginPage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
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
      _controller.jumpToPage(index);
    });
  }

  void _onPagedChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_selectedIndex != 1) {
            _onItemTapped(1);
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
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: _navBarItems,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green[800],
            onTap: _onItemTapped,
          ),
        ));
  }
}
