import 'package:ecothon/components/app_bar.dart';
import 'package:ecothon/components/bottom_bar.dart';
import 'package:ecothon/main.dart';
import 'package:ecothon/pages/explore_page.dart';
import 'package:ecothon/pages/feed_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
  	return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
	PageController _pageController;

	FeedPage _feed;
	ExplorePage _explore;

	@override
  void initState() {
		_feed = FeedPage();
		_explore = ExplorePage();
		_pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
  	return Scaffold(
			body: PageView(
				controller: _pageController,
				children: [
					_feed,
					_explore,
					Text("Profile")
				],
			),
			bottomNavigationBar: EcothonBottomBar(
				controller: _pageController,
				icons: [Icons.view_day, Icons.compass_calibration, Icons.person],
				onPressed: (i) {
					_pageController.animateToPage(i, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
				},
			),
		);
  }
}
