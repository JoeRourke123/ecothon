import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EcothonAppBar extends StatelessWidget  with PreferredSizeWidget {
	@override
	final Size preferredSize;

	EcothonAppBar(
		{ Key key,}) : preferredSize = Size.fromHeight(50.0),
			super(key: key);

  @override
  Widget build(BuildContext context) {
  	return AppBar(
			elevation: 0.0,
			backgroundColor: Colors.transparent,
			centerTitle: true,
			title: Padding(
				padding: EdgeInsets.only(top: 10),
				child: Image.asset("assets/logo.png", width: 35,)
			)
		);
  }
}
