import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';

class GradientChip extends StatelessWidget {
  final IconData icon;
  final String text;
  LinearGradient gradient;

  GradientChip({Key key, this.icon, this.text, this.gradient})
      : super(key: key) {
    if (gradient == null) {
      gradient = FlutterGradients.grownEarly();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: gradient,
					borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          if(icon != null) Icon(icon, color: Colors.white),
          if(text != null) Padding(padding: EdgeInsets.only(left: 5), child: Text(text,
					style: TextStyle(fontSize: 16, color: Colors.white)))
        ]));
  }
}
