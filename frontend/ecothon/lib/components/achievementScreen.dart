import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecothon/generalStore.dart';
import 'package:ecothon/main.dart';
import 'package:ecothon/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AchievementScreen extends StatefulWidget {
  final Map<String, dynamic> achievement;

  const AchievementScreen({Key key, this.achievement}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AchievementScreenState();
  }
}

class _AchievementScreenState extends State<AchievementScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
			alignment: Alignment.topLeft,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: MediaQuery.removePadding(context: context, removeTop: true, child: ListView(children: [
					Container(
						child: Stack(alignment: Alignment.bottomCenter, children: [
							Container(
								child: ClipRRect(
									child: CachedNetworkImage(
										imageUrl: widget.achievement["imageurl"],
										fit: BoxFit.contain)),
								margin: EdgeInsets.only(bottom: 40),
							),
							Container(
								padding: EdgeInsets.all(20),
								width: MediaQuery.of(context).size.width * 0.85,
								decoration: BoxDecoration(
									color: Colors.white,
									borderRadius: BorderRadius.circular(20),
									boxShadow: [
										BoxShadow(
											color: Colors.black26,
											offset: Offset(2.0, 2.0),
											blurRadius: 8,
											spreadRadius: 2)
									]),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Padding(
											padding: EdgeInsets.only(bottom: 5),
											child: Text(widget.achievement["title"],
												textAlign: TextAlign.start,
												style: TextStyle(
													fontSize: 20,
													fontWeight: FontWeight.bold,
												)),
										),
										Row(
											mainAxisAlignment: MainAxisAlignment.start,
											children: [
												Padding(
													padding: EdgeInsets.only(top: 10, right: 20),
													child: Container(
														alignment: Alignment.center,
														child: Row(children: [
															Icon(Icons.park,
																color: Colors.white.withOpacity(0.8)),
															Text(widget.achievement["points"].toString(),
																style: TextStyle(color: Colors.white))
														]),
														decoration: BoxDecoration(
															color: Colors.green.shade800.withOpacity(0.75),
															borderRadius: BorderRadius.circular(360)),
														padding: EdgeInsets.symmetric(
															vertical: 8, horizontal: 10),
													)),
												Padding(
													padding: EdgeInsets.only(top: 10),
													child: Container(
														alignment: Alignment.center,
														child: Row(children: [
															Icon(Icons.thermostat_rounded,
																color: Colors.white.withOpacity(0.8)),
															Text(widget.achievement["carbonreduction"].toString() + "kg",
																style: TextStyle(color: Colors.white))
														]),
														decoration: BoxDecoration(
															color: Colors.lightBlue.shade400,
															borderRadius: BorderRadius.circular(360)),
														padding: EdgeInsets.symmetric(
															vertical: 8, horizontal: 10),
													)),
											]
										)
									])),
						]),
						alignment: Alignment.topCenter,
					),
					Padding(padding: EdgeInsets.all(20), child: Text(widget.achievement["description"], style: TextStyle(
						fontSize: 16
					))),
					if(widget.achievement["details"]["useful_links"] != null) Container(
						height: 120,
						child: ListView.builder(
							shrinkWrap: true,
							padding: EdgeInsets.all(20),
							itemCount: widget.achievement["details"]["useful_links"].length, scrollDirection: Axis.horizontal,itemBuilder: (context, i) {
							return InkResponse(
								child: Container(
									height: 40,
									width: 200,
									alignment: Alignment.center,
									margin: EdgeInsets.symmetric(horizontal: 20),
									padding: EdgeInsets.all(20),
									decoration: BoxDecoration(
										color: Colors.white,
										borderRadius: BorderRadius.circular(20),
										boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(2,2), spreadRadius: 2, blurRadius: 4)]
									),
									child: Text(widget.achievement["details"]["useful_links"][i], overflow: TextOverflow.ellipsis, style: TextStyle(
										color: Colors.green.shade800.withOpacity(0.75),
										fontStyle: FontStyle.italic
									))
								),
								onTap: () async {
									if (await canLaunch(widget.achievement["details"]["useful_links"][i])) {
										await launch(widget.achievement["details"]["useful_links"][i]);
									} else {
										Clipboard.setData(new ClipboardData(text: widget.achievement["details"]["useful_links"][i]));
										Scaffold.of(context).showSnackBar(SnackBar(content: Text("URL copied!")));
									}
								}
							);
						})
					),
					Padding(
						padding: EdgeInsets.all(20),
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.end,
							mainAxisAlignment: MainAxisAlignment.spaceAround,
							children: [
								FlatButton(child: Text("Complete", style: TextStyle(fontSize: 16)), onPressed: () async {
									Loader.show(context, progressIndicator: CircularProgressIndicator(backgroundColor: Colors.green.shade800.withOpacity(0.75),));
									http.Response resp = await http.post("https://ecothon.space/api/achievements/" + widget.achievement["_id"] + "/done",
										headers: { "Authorization": "Bearer " + Provider.of<GeneralStore>(context, listen: false).token });

									Navigator.of(context).pop();
									Loader.hide();
								}, color: Colors.green.shade800.withOpacity(0.75),
									shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
									textColor: Colors.white,),
								FlatButton(child: Text("Post", style: TextStyle(fontSize: 16)),
									onPressed: () {
										Navigator.of(context).push(
											MaterialPageRoute(
												builder: (context) => PostPage(achievement: widget.achievement,)
											)
										);

									}, color: Colors.green.shade800.withOpacity(0.75),
									shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
									textColor: Colors.white)
							]
						)
					)
				])));
  }
}
