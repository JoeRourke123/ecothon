import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserScreen({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserScreenState();
  }
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
  	print(widget.user);
    return Container(
        child: ListView(children: <Widget>[
      SizedBox(height: 30),
      Container(
        height: 150.0,
        width: 150.0,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: Offset(2, 2),
                spreadRadius: 2,
                blurRadius: 4)
          ],
          image: DecorationImage(
            image: AssetImage('assets/images/shrek.jpg'),
            fit: BoxFit.contain,
          ),
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(height: 20),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                widget.user["user"]["first_name"] +
                    " " +
                    widget.user["user"]["last_name"],
                style: TextStyle(fontSize: 32)),
            Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text("@" + widget.user["user"]["username"],
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Column(children: [
              Icon(
                Icons.park,
                color: Colors.green.shade600,
                size: 32,
              ),
              Text(widget.user["user"]["points"].toString(),
                  style: TextStyle(fontSize: 24, color: Colors.green.shade600))
            ]),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          ),
        ),
        Expanded(
            child: FlatButton(
                onPressed: () {},
                color: Colors.green.shade800,
                height: 58,
                textColor: Colors.white,
                child: Column(
                    children: [Icon(Icons.person_add), Text("Follow")]))),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Column(children: [
              Icon(
                Icons.people,
                color: Colors.green.shade600,
                size: 32,
              ),
              Text(widget.user["user"]["followers"].length.toString(),
                  style: TextStyle(fontSize: 24, color: Colors.green.shade600))
            ]),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          ),
        ),
      ]),
      SizedBox(height: 10),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 0,
        itemBuilder: (c, i) {
          return Container();
        },
      )
    ]));
  }
}
