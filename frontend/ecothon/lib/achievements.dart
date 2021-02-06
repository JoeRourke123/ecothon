import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'generalStore.dart';

class AchievementsPage extends StatefulWidget {
	AchievementsPage({Key key, this.title}) : super(key: key);
	final String title;

	@override
	_AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {

	Future<List<Map<String, dynamic>>> getAchievements() async {
		String token = Provider
			.of<GeneralStore>(context, listen: false)
			.token;

		http
			.Response
		resp = await http.get("https://ecothon.space/api/achievements/incomplete", headers: {
			"Authorization": "Bearer " + token
		});
		print(resp.statusCode);
		List<Map<String, dynamic>> achievements = jsonDecode(resp.body);
		return achievements;
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			child: FutureBuilder(
				future: getAchievements(),
				builder: (context, snapshot) {
					if(snapshot.connectionState == ConnectionState.done) {
						print(snapshot.data);
						return ListView.builder(
							shrinkWrap: true,
							itemCount: 0,
							itemBuilder: (i, c) => Container(
								child: Text(snapshot.data[i]["title"])
							),
						);
					} else {
						return Center(
							child: Text("Loading")
						);
					}
				},
			));
	}
}
