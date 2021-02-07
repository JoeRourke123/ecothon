import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'components/userScreen.dart';
import 'generalStore.dart';

enum WidgetMarker { posts, followers, following }

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Map<String, dynamic>> getUser() async {
  	try {
			String username = Provider.of<GeneralStore>(context, listen: false).username;
			String token = Provider.of<GeneralStore>(context, listen: false).token;
			http.Response resp = await http.get("https://ecothon.space/api/user/" + username + "/profile", headers: {
				"Authorization": "Bearer " + token
			});

			Map<String, dynamic> user = Map<String, dynamic>.from(jsonDecode(resp.body));
			print(user);
			return user;
		} catch(e) {
  		print(e);
  		return {};
		}
	}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
			future: getUser(),
			builder: (context, snapshot) {
				if(snapshot.connectionState == ConnectionState.done) {
					return UserScreen(user: snapshot.data);
				} else {
					return Center(
						child: SpinKitFoldingCube(
							color: Colors.green.shade300
						)
					);
				}
			});
  }
}
