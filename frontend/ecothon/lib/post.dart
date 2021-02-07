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

        data["geolocation"] = {
          "type": "Point",
          "coordinates": [position.longitude, position.latitude]
        };
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
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fitHeight,
                width: 32,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, top: 2),
                  child: Text("New Post",
                      style: TextStyle(color: Colors.blueGrey)))
            ]),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        toolbarHeight: 64,
        elevation: 6.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(children: [
          if(achievement != null) Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 25),
              child: Row(children: [
                Expanded(
                    child: Text(achievement["title"],
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic))),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  alignment: Alignment.center,
                  child: Row(children: [
                    Icon(Icons.park, size: 16, color: Colors.white),
                    Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                            achievement["points"].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))
                  ]),
                  decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(360)),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                ),
              ]),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        spreadRadius: 1)
                  ])),
          SizedBox(height: 25),
					if(image != null) Container(
						margin: EdgeInsets.only(bottom: 20),
						height: 200.0,
						width: 200.0,
						alignment: Alignment.topCenter,
						decoration: BoxDecoration(
							image: DecorationImage(
								image: image != null
									? Image.file(image).image
									: AssetImage('assets/images/shrek.jpg'),
								fit: BoxFit.contain,
							),
							shape: BoxShape.rectangle,
						),
					),
          Row(
						mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
							FlatButton(
								padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
								onPressed: () async {
									PickedFile file =
									await ImagePicker().getImage(source: ImageSource.camera);
									setState(() {
										image = File(file.path);
									});
								},
								child: Column(
									children: [Icon(Icons.camera_alt), Text("From Camera")])),
							FlatButton(
								padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
								onPressed: () async {
									PickedFile file =
									await ImagePicker().getImage(source: ImageSource.gallery);
									setState(() {
										image = File(file.path);
									});
								},
								child: Column(children: [Icon(Icons.photo), Text("From Gallery")]))
            ],
          ),
					SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Material(
									child: TextFormField(
										controller: _detailsController,
										decoration: InputDecoration(
											contentPadding: EdgeInsets.all(12),
											hintText: "Caption",
											filled: true,
											fillColor: Colors.white,
											focusedBorder: OutlineInputBorder(
												borderRadius: BorderRadius.circular(15.0),
												borderSide:
												BorderSide(color: Colors.grey[700], width: 1.0),
											),
											enabledBorder: OutlineInputBorder(
												borderRadius: BorderRadius.circular(15.0),
												borderSide: BorderSide(
													color: Colors.transparent,
												),
											),
										),
										maxLines: 4,
										keyboardType: TextInputType.text,
										textCapitalization: TextCapitalization.sentences,
									),
									elevation: 4.0,
									shadowColor: Colors.black.withOpacity(0.5),
									borderRadius: BorderRadius.circular(20),
								),
								SizedBox(height: 25),
								FlatButton(
                  child: Text("Create", style: TextStyle(fontSize: 16)),
                  color: Colors.green.shade400,
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
