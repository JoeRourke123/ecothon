import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Gradient gradient;
  final IconData icon;
  final String text;
  final Function() onTap;

  const GradientButton(
      {Key key, this.gradient, this.icon, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      InkWell(
          onTap: onTap,
          child: Container(
              decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey.shade800.withOpacity(0.25),
                        spreadRadius: 1.0,
                        blurRadius: 2.0)
                  ]),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                if (icon != null) Icon(icon, color: Colors.white),
                if (text != null)
                  Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(text,
                          style: TextStyle(fontSize: 16, color: Colors.white)))
              ])))
    ]);
  }
}
