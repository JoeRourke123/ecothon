import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';

class EcothonTabs extends StatefulWidget {
  final TabController controller;
  final List<IconData> icons;
  final List<String> texts;
  final List<LinearGradient> gradients;
  final List<Function(int)> onPresseds;
  final int initial;

  const EcothonTabs(
      {Key key, this.controller, this.icons, this.texts, this.gradients, this.onPresseds, this.initial: 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EcothonTabState();
}

class _EcothonTabState extends State<EcothonTabs>
    with TickerProviderStateMixin {
  int _selected = 0;
  List<Animation<Color>> _colors;
  List<AnimationController> _controllers;
  List<LinearGradient> _gradients;
  List<Function(int)> _callbacks;

  @override
  void initState() {
    super.initState();

    _gradients = (widget.gradients == null ? [] : widget.gradients);
    _callbacks = (widget.onPresseds == null ? [] : widget.onPresseds);

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

    _selected = widget.initial;
    _controllers[_selected].value = 1.0;
    widget.controller.addListener(() {
      _controllers[_selected].animateBack(0);
      _selected = widget.controller.index;
      _controllers[_selected].animateTo(1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: widget.icons.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) =>
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    child: Stack(alignment: Alignment.center, children: [
                      AnimatedOpacity(
                          curve: Curves.easeInOut,
                          opacity: _selected == index ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Row(children: [
                              if (widget.icons[index] != null) Icon(widget
                                  .icons[index], color: Colors.transparent),
                              if (widget.texts[index] != null) Text(widget
                                  .texts[index],
                                  style: TextStyle(color: Colors.transparent)),
                            ]),
                            decoration: BoxDecoration(
                              gradient: _gradients.isNotEmpty ? widget
                                  .gradients[index] : FlutterGradients
                                  .grownEarly(),
                              boxShadow: [
                                BoxShadow(color: Colors.blueGrey.shade800
                                    .withOpacity(0.25), offset: Offset(0, 0), blurRadius: 2.0, spreadRadius: 0.75)
                              ],
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )),
                      Row(children: [
                        if (widget.icons[index] != null) Icon(
                            widget.icons[index], color: _colors[index].value),
                        if (widget.icons[index] != null) SizedBox(width: 5,),
                        if (widget.texts[index] != null) Text(
                            widget.texts[index],
                            style: TextStyle(color: _colors[index].value)),
                      ])
                    ]),
                    onTap: () {
                      if (_callbacks.isNotEmpty && _callbacks[index] != null) {
                        _callbacks[index](index);
                      } else {
                        widget.controller.index = index;
                      }
                    },
                  )
              ),
        ));
  }
}
