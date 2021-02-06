import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 50),
        Container(
          height: 200.0,
          width: 200.0,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/shrek.jpg'),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 20),
        Text('Shrek Shrek',
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: GFButton(
                  text: 'Posts',
                  icon: Icon(Icons.picture_in_picture),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TempLoginPage()),
                    );
                  }),
            ),
            Expanded(
              child: GFButton(
                  text: 'Followers',
                  icon: Icon(Icons.people),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TempLoginPage()),
                    );
                  }),
            ),
            Expanded(
              child: GFButton(
                  text: 'Following',
                  icon: Icon(Icons.person),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TempLoginPage()),
                    );
                  }),
            )
          ],
        ),
      ],
    );
  }
}

class TempLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
