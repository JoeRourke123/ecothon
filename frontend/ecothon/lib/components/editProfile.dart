import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../generalStore.dart';

class EditProfileMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfileMenu> {
  File image;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 25),
      if (image != null)
        Container(
          height: 100.0,
          width: 100.0,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.file(image).image,
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
          ),
        ),
      if (image != null) SizedBox(height: 25),
      Text("Select Profile Picture", style: TextStyle(fontSize: 18)),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
            child: Column(children: [Icon(Icons.photo), Text("From Gallery")])),
      ]),
      SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FlatButton(
          color: Colors.green.shade400,
          textColor: Colors.white,
          child: Text("Save"),
          onPressed: image == null
              ? null
              : () async {
                  http.Response res = await http.post(
                      "https://ecothon.space/api/upload/image",
                      headers: {
                        "Authorization": "Bearer " +
                            Provider.of<GeneralStore>(context, listen: false)
                                .token,
                        "Content-Type": "image/" + image.path.split('.').last
                      },
                      body: image.readAsBytesSync());

                  print(res.body);

                  if(res.statusCode == 200) {
                  	String url = jsonDecode(res.body)["url"];

                  	res = await http.put(
											"https://ecothon.space/api/user/profile-picture",
											body: jsonEncode({"profile_picture": url}),
											headers: {"Authorization": "Bearer " + Provider.of<GeneralStore>(context, listen: false).token}
										);

                  	print(res.statusCode);

                  	Navigator.of(context).pop();
									}
                },
        )
      ]),
      SizedBox(height: 25),
    ]);
  }
}
