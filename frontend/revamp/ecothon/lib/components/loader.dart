import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EcothonLoader extends StatelessWidget {
	@override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
			color: Colors.green.shade600,
			size: 48,
		);
  }
}
