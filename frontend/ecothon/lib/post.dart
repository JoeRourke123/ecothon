import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecothon/generalStore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as path;

class PostPage extends StatefulWidget {
  final achievement;

  PostPage({Key key, this.achievement}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState(achievement: achievement);
}

class _PostPageState extends State<PostPage> {
  _PostPageState({this.achievement});

  final Map<String, dynamic> achievement;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  final storage = new FlutterSecureStorage();
  File image;

  Future<String> _getImageUrl() async {
    http.Response res =
        await http.post("https://ecothon.space/api/upload/image",
            headers: {
              "Authorization": "Bearer " +
                  Provider.of<GeneralStore>(context, listen: false).token,
              "Content-Type": "image/" + image.path.split('.').last
            },
            body: image.readAsBytesSync());
    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      return decoded["url"];
    } else {
      try {
        dynamic decoded = jsonDecode(res.body);
        if (decoded is Map && decoded["error"] != null) {
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Image upload: " + decoded["error"])));
        }
      } catch (_) {
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text("Image upload: " + res.reasonPhrase)));
      }
    }
    return null;
  }

  void _post() async {
    String token = Provider.of<GeneralStore>(context, listen: false).token;
    Map<String, dynamic> data = {};
    String type = "achievement";

    if (image != null) {
      type += " with a photo";
      String url = await _getImageUrl();
      if (url == null) return; // Failed to upload image so it returns
      data["picture"] = url;
    }

    data["type"] = type;
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Processing")));
      try {
        final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
        Position position = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);

        data["geolocation"] = {"type": "Point", "coordinates": [position.longitude, position.latitude]};
        data["details"] = {"caption": _detailsController.text};
        data["achievement"] = achievement["_id"];
        print(jsonEncode(data));
        http.Response res = await http.post(
            "https://ecothon.space/api/posts/create",
            body: jsonEncode(data),
            headers: {"Authorization": "Bearer " + token});
        _scaffoldKey.currentState.hideCurrentSnackBar();
        if (res.statusCode == 200) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          print("Error: " +
              res.body +
              " " +
              res.reasonPhrase +
              " " +
              res.statusCode.toString());
          try {
            dynamic decoded = jsonDecode(res.body);
            if (decoded is Map && decoded["error"] != null) {
              _scaffoldKey.currentState
                  .showSnackBar(SnackBar(content: Text(decoded["error"])));
            }
          } catch (_) {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text(res.reasonPhrase)));
          }
        }
      } catch (Exception) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(Exception.toString())));
      }
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Invalid entry")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Post Achievement"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(children: [
          Text(achievement["title"]),
          Row(
            children: [
              MaterialButton(
                onPressed: () async {
                  PickedFile file =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  image = File(file.path);
                },
                child: Text("Upload photo"),
              ),
              MaterialButton(
                onPressed: () async {
                  PickedFile file =
                      await ImagePicker().getImage(source: ImageSource.camera);
                  image = File(file.path);
                },
                child: Text("Take photo"),
              )
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _detailsController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(2),
                    hintText: "Details",
                  ),
                ),
                MaterialButton(
                  child: Text("Create post"),
                  onPressed: _post,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
