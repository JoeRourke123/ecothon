import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
	final String text;

  const TitleText([this.text, Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
  	return Text(text, style:  TextStyle(
			fontSize: 28,
			fontWeight: FontWeight.w900,
			color: Colors.blueGrey.shade800
		));
  }
}
