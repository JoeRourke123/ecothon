import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecothon/feed.dart';
import 'package:ecothon/generalStore.dart';
import 'package:ecothon/main.dart';
import 'package:ecothon/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
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
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Expanded(
						child: ListView.builder(itemCount: widget.post.comments.length,
							itemBuilder: (c, i) => Container(
								child: Text(widget.post.comments[i].toString())
							))
					),
					Container(
						height: 100,

					)
        ]));
  }
}
