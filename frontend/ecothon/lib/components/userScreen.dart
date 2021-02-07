import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecothon/components/editProfile.dart';
import 'package:ecothon/components/feedCard.dart';
import 'package:ecothon/generalStore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../feed.dart';

class UserScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserScreen({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserScreenState();
  }
}

class _UserScreenState extends State<UserScreen> {
  String username;
  bool isMine;
  bool isFollowing;
  File image;

  @override
  void initState() {
    super.initState();

    username = Provider.of<GeneralStore>(context, listen: false).username;
    isMine = username == widget.user["user"]["username"];
    isFollowing = widget.user["following"];
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user["user"]);
    return Container(
        child: ListView(children: <Widget>[
      SizedBox(height: 30),
      Container(
        height: 150.0,
        width: 150.0,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: Offset(2, 2),
                spreadRadius: 2,
                blurRadius: 4)
          ],
          image: DecorationImage(
            image: (widget.user["user"]["profile_picture"] == "" ||
                    widget.user["user"]["profile_picture"] == null
                ? AssetImage("assets/images/shrek.png")
                : CachedNetworkImageProvider(widget.user["user"]["profile_picture"])),
            fit: BoxFit.cover,
          ),
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                widget.user["user"]["first_name"] +
                    " " +
                    widget.user["user"]["last_name"],
                style: TextStyle(fontSize: 32)),
            Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text("@" + widget.user["user"]["username"],
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Column(children: [
              Icon(
                Icons.park,
                color: Colors.green.shade600,
                size: 32,
              ),
              Text(widget.user["user"]["points"].toString(),
                  style: TextStyle(fontSize: 24, color: Colors.green.shade600))
            ]),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          ),
        ),
        Expanded(
            child: isMine
                ? FlatButton(
                    onPressed: () {
                      showMaterialModalBottomSheet(
                          context: context,
                          expand: false,
                          builder: (context) => EditProfileMenu());
                    },
                    color: Colors.green.shade800,
                    height: 58,
                    textColor: Colors.white,
                    child: Column(
                        children: [Icon(Icons.edit), Text("Edit Profile")]))
                : (isFollowing
                    ? FlatButton(
                        onPressed: () async {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("You've unfollowed " +
                                  widget.user["user"]["first_name"])));
                          await http.post(
                              "https://ecothon.space/api/user/" +
                                  widget.user["user"]["username"] +
                                  "/unfollow",
                              headers: {
                                "Authorization": "Bearer " +
                                    Provider.of<GeneralStore>(context,
                                            listen: false)
                                        .token
                              });

                          setState(() {
                            (widget.user["user"]["followers"] as List)
                                .remove(username);
                            isFollowing = false;
                          });
                        },
                        color: Colors.green.shade800,
                        height: 58,
                        textColor: Colors.white,
                        child: Column(children: [
                          Icon(Icons.person_remove),
                          Text("Unfollow")
                        ]))
                    : FlatButton(
                        onPressed: () async {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("You've followed " +
                                  widget.user["user"]["first_name"])));
                          await http.post(
                              "https://ecothon.space/api/user/" +
                                  widget.user["user"]["username"] +
                                  "/follow",
                              headers: {
                                "Authorization": "Bearer " +
                                    Provider.of<GeneralStore>(context,
                                            listen: false)
                                        .token
                              });

                          setState(() {
                            (widget.user["user"]["followers"] as List)
                                .add(username);
                            isFollowing = true;
                          });
                        },
                        color: Colors.green.shade800,
                        height: 58,
                        textColor: Colors.white,
                        child: Column(children: [
                          Icon(Icons.person_add),
                          Text("Follow")
                        ])))),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Column(children: [
              Icon(
                Icons.people,
                color: Colors.green.shade600,
                size: 32,
              ),
              Text(widget.user["user"]["followers"].length.toString(),
                  style: TextStyle(fontSize: 24, color: Colors.green.shade600))
            ]),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          ),
        ),
      ]),
      SizedBox(height: 10),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.user["posts"].length,
        itemBuilder: (c, i) {
          return FeedCard(data: FeedItemData.fromJson(widget.user["posts"][i]));
        },
      )
    ]));
  }
}
