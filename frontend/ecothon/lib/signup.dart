import 'dart:convert';
import 'package:ecothon/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecothon/generalStore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();
  final storage = new FlutterSecureStorage();

  void _createUser() async {
    if (_formKey.currentState.validate()) {
      if (_password1Controller.text == _password2Controller.text) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Processing")));
        try {
          http.Response res =
              await http.post("https://ecothon.space/api/auth/create-user",
                  body: jsonEncode({
                    "firstname": _firstnameController.text,
                    "lastname": _lastnameController.text,
                    "username": _usernameController.text,
                    "email": _emailController.text,
                    "password": _password1Controller.text
                  }));
          _scaffoldKey.currentState.hideCurrentSnackBar();
          if (res.statusCode == 200) {
          	print(res.body);
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
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text(err)));
          } else {
            try {
              dynamic decoded = jsonDecode(res.body);
              if (decoded is Map && decoded["error"] != null) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(decoded["error"])));
              }
            } catch (_) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(res.reasonPhrase)));
            }
          }
        } catch (Exception) {
          print(Exception);
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Failed to create user please try again")));
        }
      } else {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Passwords do not match")));
      }
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Invalid credentials")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green[100], Colors.green[800]],
            ),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(50),
          child: Form(
            key: _formKey,
            child: Center(
                child: ListView(
                  shrinkWrap: true,
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.grey[700]),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.grey[300],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          BorderSide(color: Colors.grey[700], width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
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
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.grey[700]),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Username",
                    filled: true,
                    fillColor: Colors.grey[300],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          BorderSide(color: Colors.grey[700], width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a username";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _firstnameController,
                  style: TextStyle(color: Colors.grey[700]),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: "First Name",
                    filled: true,
                    fillColor: Colors.grey[300],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          BorderSide(color: Colors.grey[700], width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter your first name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _lastnameController,
                  style: TextStyle(color: Colors.grey[700]),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Last Name",
                    filled: true,
                    fillColor: Colors.grey[300],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          BorderSide(color: Colors.grey[700], width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter your last name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _password1Controller,
                  obscureText: true,
                  style: TextStyle(color: Colors.grey[700]),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.grey[300],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          BorderSide(color: Colors.grey[700], width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  validator: (value) {
                    RegExp regExp = new RegExp(
                        r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$",
                        caseSensitive: true,
                        multiLine: false);
                    if (!regExp.hasMatch(value) || value.isEmpty) {
                      return "Password should have\n* Uppercase and Lowercase letters\n* At least 1 number";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _password2Controller,
                  obscureText: true,
                  style: TextStyle(color: Colors.grey[700]),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Repeat Password",
                    filled: true,
                    fillColor: Colors.grey[300],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          BorderSide(color: Colors.grey[700], width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  validator: (value) {
                    RegExp regExp = new RegExp(
                        r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$",
                        caseSensitive: true,
                        multiLine: false);
                    if (!regExp.hasMatch(value) || value.isEmpty) {
                      return "Password should have\n* Uppercase and Lowercase letters\n* At least 1 number";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  child: Text("Create user"),
                  onPressed: _createUser,
                  textColor: Colors.white,
                  color: Colors.grey[700],
                ),
              ],
            )),
          )),
    );
  }
}
