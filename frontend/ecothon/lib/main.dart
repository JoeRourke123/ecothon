import 'package:ecothon/generalStore.dart';
import 'package:ecothon/login.dart';
import 'package:flutter/material.dart';
import 'package:ecothon/achievements.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:ecothon/feed.dart';
import 'map.dart';
import 'settings.dart';

GlobalKey<ScaffoldState> globalScaffold = GlobalKey<ScaffoldState>();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GeneralStore store = GeneralStore();
  final storage = new FlutterSecureStorage();

  bool isLoggedIn = await storage.containsKey(key: "username") &&
      await storage.containsKey(key: "token");
  if (isLoggedIn) {
    String username = await storage.read(key: "username");
    String token = await storage.read(key: "token");
    store.setLoginData(username, token);
  }

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
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.map),
      label: 'Map',
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
				key: globalScaffold,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.fitHeight,
            width: 32,
          ),
          centerTitle: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          toolbarHeight: 64,
          elevation: 6.0,
        ),
        body: PageView(
          controller: _controller,
          onPageChanged: _onPagedChanged,
          children: [
            FeedPage(),
            AchievementsPage(),
            ProfilePage(),
            MapPage(),
          ],
        ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
            ]),
            child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: GNav(
                        gap: 8,
                        activeColor: Colors.black,
                        iconSize: 24,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        duration: Duration(milliseconds: 400),
                        tabBackgroundColor: Colors.grey[100],
                        tabs: [
                          GButton(
                            icon: Icons.view_day,
                            text: 'Feed',
                            backgroundColor:
                                Colors.green.shade800.withOpacity(0.75),
                            textColor: Colors.white,
                            iconActiveColor: Colors.white,
                          ),
                          GButton(
                            icon: Icons.stars_rounded,
                            text: 'Achievements',
                            backgroundColor:
                                Colors.green.shade800.withOpacity(0.75),
                            textColor: Colors.white,
                            iconActiveColor: Colors.white,
                          ),
                          GButton(
                            icon: Icons.face_rounded,
                            text: 'Profile',
                            backgroundColor:
                                Colors.green.shade800.withOpacity(0.75),
                            textColor: Colors.white,
                            iconActiveColor: Colors.white,
                          ),
                          GButton(
                            icon: Icons.map,
                            text: 'Map',
                            backgroundColor:
                            Colors.green.shade800.withOpacity(0.75),
                            textColor: Colors.white,
                            iconActiveColor: Colors.white,
                          ),
                        ],
                        selectedIndex: _selectedIndex,
                        onTabChange: (index) {
													_controller.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
												})))),
      ),
    );
  }
}
