import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecothon/components/gradient_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';

class AchievementCard extends StatefulWidget {
  final Map<String, dynamic> achievement;

  const AchievementCard({Key key, this.achievement}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AchievementCardState();
  }
}

class _AchievementCardState extends State<AchievementCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.80,
        margin: EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blueGrey.shade800.withOpacity(0.25),
                      spreadRadius: 1.0,
                      blurRadius: 2.0)
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                      imageUrl: widget.achievement["image"],
                      fit: BoxFit.contain)),
            ),
            Container(
							width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey.shade800.withOpacity(0.25),
                        spreadRadius: 2.0,
                        blurRadius: 4.0)
                  ],
                  color: Colors.white,
									gradient: FlutterGradients.cloudyKnoxville(),
									borderRadius: BorderRadius.only(
										bottomLeft: Radius.circular(20),
										bottomRight: Radius.circular(20),
									)
                ),
                child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(widget.achievement["title"], style: TextStyle(
											fontSize: 16.0,
										)),
										SizedBox(height: 10,),
										Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        GradientChip(
                          icon: Icons.park,
                          text: widget.achievement["points"].toString(),
                        ),
                        SizedBox(width: 10),
                        GradientChip(
                          icon: Icons.stars_rounded,
                          gradient: FlutterGradients.orangeJuice(),
                          text: widget.achievement["achievement_count"].toString(),
                        ),
                        SizedBox(width: 10),
                        if(widget.achievement["completed"]) Icon(Icons.check_circle_rounded, color: Colors.blueGrey.shade800.withOpacity(0.4),)
                      ],
                    )
									]),
									Icon(Icons.chevron_right)
								]
								))
          ],
        ));
  }
}
