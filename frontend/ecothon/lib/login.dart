import 'dart:convert';
import 'package:ecothon/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecothon/generalStore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();

  void _login() async {
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Processing")));
      try {
        http.Response res = await http
            .post("http://ecothon.space/api/auth/login", body: jsonEncode({
          "email": _emailController.text,
          "password": _passwordController.text
        }));
        _scaffoldKey.currentState.hideCurrentSnackBar();
        if (res.statusCode == 200) {
          var data = jsonDecode(res.body);
          String username = data["user"]["username"];
          String token = data["auth"];
          await storage.write(key: "username", value: username);
          await storage.write(key: "token", value: token);

          Provider.of<GeneralStore>(context, listen: false)
              .setLoginData(username, token);

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return MyHomePage();
          }));
        } else if (res.statusCode == 403) {
          String err = json.decode(res.body)["error"];
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(err)));
        } else {
          String err;
          try {
            err = jsonDecode(res.body)["error"];
          } catch (Exception) {
            err = jsonDecode(res.reasonPhrase);
          } finally {
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(err)));
          }
        }
      } catch (Exception) {
        print(Exception);
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text("Failed to login please try again")));
      }
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Incorrect login details")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(2),
                    hintText: "Email",
                  ),
                  validator: (value) {
                    RegExp regExp = new RegExp(
                        r"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$",
                        caseSensitive: false,
                        multiLine: false);
                    if (!regExp.hasMatch(value) || value.isEmpty) {
                      return "Invalid Email";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(2), hintText: "Password"),
                  validator: (value) {
                    /*RegExp regExp = new RegExp(
                      r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$",
                      caseSensitive: true,
                      multiLine: false);
                  if (!regExp.hasMatch(value) || value.isEmpty) {
                    return "Password should have\n* Uppercase and Lowercase letters\n* At least 1 number";
                  }*/
                    return null;
                  },
                ),
                MaterialButton(
                  child: Text("Login"),
                  onPressed: _login,
                )
              ],
            ),
          )),
    );
  }
}
