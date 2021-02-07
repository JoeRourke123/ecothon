import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

enum WidgetMarker { posts, followers, following }

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin<ProfilePage> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.posts;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 50),
        Container(
          height: 200.0,
          width: 200.0,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/shrek.jpg'),
              fit: BoxFit.contain,
            ),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Text('Shrek Shrek',
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: 2.0)),
        ),
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
                    setState(() {
                      selectedWidgetMarker = WidgetMarker.posts;
                    });
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
                    setState(() {
                      selectedWidgetMarker = WidgetMarker.followers;
                    });
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
                    setState(() {
                      selectedWidgetMarker = WidgetMarker.following;
                    });
                  }),
            )
          ],
        ),
        FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return getCustomContainer();
          },
        )
      ],
    );
  }

  Widget getCustomContainer() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.posts:
        return getPostContainer();
      case WidgetMarker.followers:
        return getFollowersContainer();
      case WidgetMarker.following:
        return getFollowingContainer();
    }
    return getPostContainer();
  }

  Widget getPostContainer() {
    return Container(
      color: Colors.red,
      height: 100,
    );
  }

  Widget getFollowersContainer() {
    return Container(
      color: Colors.green,
      height: 400,
    );
  }

  Widget getFollowingContainer() {
    return Container(
      color: Colors.blue,
      height: 1600,
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
