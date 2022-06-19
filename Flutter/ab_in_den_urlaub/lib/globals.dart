import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:html';

/*
class LoginInfo extends StatefulWidget {
  int userid = -1;
  var tokens = 0;
  var currentAngebot = "";
  var cj = CookieJar();
  var serverIP = "http://81.169.152.56:5000";
  //var serverIP = "http://localhost:7199";
  bool vermieter = false;
  LoginInfo({Key? key}) : super(key: key);

  @override
  State<LoginInfo> createState() => _LoginInfoState();
}

class _LoginInfoState extends State<LoginInfo> {
  void fetchTokenstand() async {
    try {
      var response = await http.get(Uri.parse(
          LoginInfo.serverIP + '/api/Nutzer/' + widget.userid.toString()));

      if (response.statusCode != 200) {
      } else {
        final jsonData = jsonDecode(response.body) as List;
        print(jsonData);

        setState(() {
          var jsons = jsonData;
          var length = jsons.length;
          LoginInfo.tokens = jsons[0]['tokenstand'];
        });
        window.localStorage.containsKey('userId');
        window.localStorage.containsKey('tokenstand');
        window.localStorage.containsKey('angebotID');

        window.localStorage['userId'] = LoginInfo.userid.toString();
        window.localStorage['tokenstand'] = LoginInfo.tokens.toString();
        window.localStorage['angebotID'] =
            LoginInfo.currentAngebot.toString();
      }
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
*/

class LoginInfo {
  LoginInfo() {}
  static int userid = -1;
  static var tokens = 0;
  static var currentAngebot = "";
  static var cj = CookieJar();
  static var serverIP = "http://81.169.152.56:5000";
  //var serverIP = "http://localhost:7199";
  static bool vermieter = false;
  static loadToken() async {
    try {
      var response = await http.get(
          Uri.parse(LoginInfo.serverIP + '/api/Nutzer/' + userid.toString()));

      if (response.statusCode != 200) {
      } else {
        final jsonData = jsonDecode(response.body) as List;
        print(jsonData);
        var jsons = jsonData;
        var length = jsons.length;
        LoginInfo.tokens = jsons[0]['tokenstand'];
      }
    } catch (e) {}
  }
}
