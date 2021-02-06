import 'dart:convert';
import 'dart:math';
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();

  void _login() async {
    if (_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Processing")));
      try {
        http.Response res = await http
            .post("https://ecothon.space/api/auth/login", body: {
          "email": _emailController.text,
          "password": _passwordController.text
        });
        Scaffold.of(context).hideCurrentSnackBar();
        if (res.statusCode == 200) {
          var data = json.decode(res.body);
          String username = data["user"]["username"];
          String token = data["token"];

          storage.write(key: "username", value: username);
          storage.write(key: "token", value: token);
          setState(() {
            Provider.of<GeneralStore>(context, listen: false).setLoginData(username, token);
          });
        } else if (res.statusCode == 403) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Incorrect login details")));
        } else {
          print(res.statusCode);
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("Failed to login please try again")));
        }
      } catch (Exception) {
        print(Exception);
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("Failed to login please try again")));
      }
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Incorrect login details")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ));
  }
}
