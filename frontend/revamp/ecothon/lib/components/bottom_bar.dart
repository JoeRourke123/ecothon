import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';

class EcothonBottomBar extends StatefulWidget {
  final List<IconData> icons;
  final Function(int) onPressed;
  final PageController controller;

  EcothonBottomBar({Key key, this.icons, this.onPressed, this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EcothonBottomBarState();
}

class _EcothonBottomBarState extends State<EcothonBottomBar>
    with TickerProviderStateMixin {
  int _selected;
  List<Animation<Color>> _colors;
  List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();

    _colors = [];
    _controllers = [];
    for (int i = 0; i < widget.icons.length; i++) {
      _controllers.add(AnimationController(
          duration: const Duration(milliseconds: 200), vsync: this));
      _colors.add(ColorTween(begin: Colors.blueGrey.shade800, end: Colors.white)
          .animate(_controllers[i])
            ..addListener(() {
              setState(() {
                // The state that has changed here is the animation object’s value.
              });
            }));
    }

    _selected = 0;
    _controllers[_selected].value = 1.0;
    widget.controller.addListener(() {
      _controllers[_selected].animateBack(0);
      _selected = widget.controller.page.ceil();
      _controllers[_selected].animateTo(1.0);
    });
  }

  Widget buildIconButton(int index) {
    return GestureDetector(
      child: Stack(alignment: Alignment.center, children: [
        AnimatedOpacity(
          opacity: _selected == index ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                gradient: FlutterGradients.grownEarly(),
                borderRadius: BorderRadius.circular(360),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade100,
                    offset: Offset(0, 2),
                    blurRadius: 2.0,
                    spreadRadius: 2.0,
                  )
                ]),
            height: 50,
            width: 50,
          ),
        ),
        Icon(
          widget.icons[index],
          color: _colors[index].value,
        )
      ]),
      onTap: () {
        widget.onPressed(index);
      },
    );
  }

  List<Widget> get buildButtons {
    List<Widget> buttons = [];
    for (int i = 0; i < widget.icons.length; i++) {
      buttons.add(buildIconButton(i));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      decoration: BoxDecoration(
				color: Colors.white,
				gradient: FlutterGradients.cloudyKnoxville(radius: 0.8),
				boxShadow: [BoxShadow(
					color: Colors.blueGrey.shade800.withOpacity(0.25),
					offset: Offset(0, 4),
					blurRadius: 20.0,
					spreadRadius: 1.0
				)],
				borderRadius: BorderRadius.only(
					topLeft: Radius.circular(40),
					topRight: Radius.circular(40),
				)
			),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buildButtons,
      ),
    );
  }
}
