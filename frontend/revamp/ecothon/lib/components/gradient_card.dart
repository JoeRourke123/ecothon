import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  final double height;
  final Widget child;
  final Gradient gradient;

  const GradientCard({Key key, this.height: -1, this.gradient, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      height: (height > 0) ? height : 250,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.blueGrey.shade800.withOpacity(0.25), spreadRadius: 2.0, blurRadius: 4.0)]
      ),
    );
  }

}
