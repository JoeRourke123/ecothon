import 'dart:convert';

import 'package:ecothon/components/userScreen.dart';
import 'package:ecothon/feed.dart';
import 'package:ecothon/generalStore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final FeedItemData post;

  const CommentScreen({Key key, this.post}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommentScreenState();
  }
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    print(widget.post.comments);
    for (Map<String, dynamic> comment in widget.post.comments) {
      if (comment["commented_at"] is String) {
        comment["commented_at"] = DateTime.parse(comment["commented_at"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Row(children: [
            FlatButton(
              child: Text("Go to @" + widget.post.user),
              onPressed: () async {
                try {
                  Loader.show(context,
                      progressIndicator: SpinKitFoldingCube(
                        color: Colors.green.shade800,
                      ));

                  http.Response resp = await http.get(
                      "https://ecothon.space/api/user/" +
                          widget.post.user +
                          "/profile",
                      headers: {
                        "Authorization": "Bearer " +
                            Provider.of<GeneralStore>(context, listen: false)
                                .token
                      });

                  Map<String, dynamic> user =
                      Map<String, dynamic>.from(jsonDecode(resp.body));

                  Loader.hide();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
												body: UserScreen(
													user: user,
												)
											)));
                } catch (e) {
                  print(e);
                }

                Loader.hide();
              },
            )
          ]),
          Expanded(
              child: ListView.separated(
                  itemCount: widget.post.comments.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (c, i) =>
                      Container(
												padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                Expanded(
																	child: Row(
																		mainAxisAlignment: MainAxisAlignment.start,
																		children: [
																			Text("@" + widget.post.comments[i]["user"], style: TextStyle(fontWeight: FontWeight.bold)),
																			Expanded(
																				child: Padding(
																					padding: EdgeInsets.only(left: 30),
																					child: Text(widget.post.comments[i]["comment"])
																				)
																			)
																		]
																	)
																),
                                Padding(
																	padding: EdgeInsets.only(left: 20),
																	child: Text(
																		timeago.format(
																			widget.post.comments[i]["commented_at"],
																			locale: 'en_short'),
																		style: TextStyle(color: Colors.grey))
																)
                        ]))),
					),
          Container(
              height: 100,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _commentController,
                    style: TextStyle(color: Colors.grey[700]),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText: "Your comment...",
                      filled: true,
                      fillColor: Colors.grey[300],
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter your first name";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      String comment = _commentController.text;
                      var data = {
                        "commented_at": DateTime.now(),
                        "comment": comment,
                        "user":
                            Provider.of<GeneralStore>(context, listen: false)
                                .username
                      };
                      await http.post(
                          "https://ecothon.space/api/posts/" +
                              widget.post.id +
                              "/comment",
                          body: jsonEncode({
														"comment": comment,
													}),
                          headers: {
                            "Authorization": "Bearer " +
                                Provider.of<GeneralStore>(context,
                                        listen: false)
                                    .token
                          });

                      setState(() {
                        widget.post.comments.add(data);
                      });
                    })
              ]))
        ]));
  }
}
