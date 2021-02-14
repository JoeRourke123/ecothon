import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String BASE_URL = "http://192.168.0.24:3000/api";

class AuthStore extends ChangeNotifier {
	String userID;
	Map<String, dynamic> user;
	String token;

	AuthStore([this.userID, this.token]);

	bool get isLoggedIn => user != null && token != null;

	Map<String, String> get _getHeaders => {
		"Authorization": "Bearer " + token
	};

	Future<void> getUserDetails() async {
		http.Response userResponse = await makeGET("/user/$userID/details");

		if(userResponse.statusCode == 200) {
			user = Map<String, dynamic>.from(jsonDecode(userResponse.body));
		} else {
			logout();
		}
	}

	void logout() {
		token = null;
		user = null;
		userID = null;
	}

	Future<http.Response> makeGET(String url) async {
		return await http.get(BASE_URL + url, headers: _getHeaders);
	}

	Future<http.Response> makePOST(String url, Map<String, dynamic> data) async {
		return await http.post(BASE_URL + url, body: jsonEncode(data), headers: _getHeaders);
	}

	Future<http.Response> makePATCH(String url, Map<String, dynamic> data) async {
		return await http.patch(BASE_URL + url, body: jsonEncode(data), headers: _getHeaders);
	}

	Future<http.Response> uploadImage(File image) async {

	}
}
