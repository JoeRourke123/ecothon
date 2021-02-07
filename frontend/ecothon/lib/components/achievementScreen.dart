import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecothon/generalStore.dart';
import 'package:ecothon/main.dart';
import 'package:ecothon/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Stack(alignment: Alignment.bottomCenter, children: [
            Container(
              child: ClipRRect(
                  child: CachedNetworkImage(
                      imageUrl: widget.achievement["imageurl"],
                      fit: BoxFit.contain)),
              margin: EdgeInsets.only(bottom: 40),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
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
																color: Colors.green.shade400,
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
          Padding(padding: EdgeInsets.all(20), child: Text(widget.achievement["description"], style: TextStyle(
						fontSize: 16
					))),
					Expanded(
						child: Padding(
							padding: EdgeInsets.all(20),
							child: Row(
								crossAxisAlignment: CrossAxisAlignment.end,
								mainAxisAlignment: MainAxisAlignment.spaceAround,
								children: [
									MaterialButton(child: Text("Complete"), onPressed: () async {
										Loader.show(context, progressIndicator: CircularProgressIndicator(backgroundColor: Colors.green,));
										http.Response resp = await http.post("https://ecothon.space/api/achievements/" + widget.achievement["_id"] + "/done",
										headers: { "Authorization": "Bearer " + Provider.of<GeneralStore>(context, listen: false).token });

										Navigator.of(context).pop();
										Loader.hide();

										if(resp.statusCode == 200) {
											globalScaffold.currentState.showSnackBar(SnackBar(content: Text("Successfully completed!")));
										} else {
											globalScaffold.currentState.showSnackBar(SnackBar(content: Text("There was a problem when completing your achievement!")));
										}
									}, color: Colors.green.shade600, textColor: Colors.white,),
									MaterialButton(child: Text("Post"), onPressed: () {
										Navigator.of(context).push(
											MaterialPageRoute(
												builder: (context) => PostPage(achievement: widget.achievement,)
											)
										);
									}, color: Colors.green.shade800, textColor: Colors.white)
								]
							)
						)
					)
        ]));
  }
}
