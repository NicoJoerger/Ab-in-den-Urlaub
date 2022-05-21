import 'dart:collection';

import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'appBars.dart';

class TestAPI extends StatefulWidget {
  TestAPI({Key? key}) : super(key: key);
  @override
  _TestAPIState createState() => _TestAPIState();
}

class _TestAPIState extends State<TestAPI> {
  String url = 'https://localhost:7077/api/Nutzer';
  var jsons = [];
  var response;
  void fetchUser() async {
    try {
      response = await http.get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        jsons = jsonData;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void postUser() async {
    try {
      response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode((<String, String>{
            'username': "BastianDerKappen",
            "nachname": "Huber",
            "vorname": "Bastian",
            "password": "mylittlepony123",
            "email": "emailtest",
            "tokenstand": 0.toString(),
            "vermieter": false.toString(),
            "admin": true.toString(),
            "user": "1Penis"
          })));
      //final jsonData = jsonDecode(response.body) as List;
      //setState(() {
      //  jsons = jsonData;
      //});
      print(response.body);
    } catch (err) {
      print(err.toString());
    }
  }

  void httpget() async {
    var response;
    try {
      response = await http.get(Uri.parse(url));
      final jsonData = jsonDecode(response.body);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: Text("test"), //response.body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (err) {}

    //print('Response status: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: AppBarBrowser(),
        ),
        body: Column(
          children: [
            ElevatedButton(
              child: Text("TestGet"),
              onPressed: fetchUser,
            ),
            ElevatedButton(
              child: Text("TestPost"),
              onPressed: postUser,
            ),
            TextField(),
            Container(
              height: 500,
              child: ListView.builder(
                itemCount: jsons.length,
                itemBuilder: (context, i) {
                  final json = jsons[i];
                  return Text(
                      "userid = ${json["userId"]}, username = ${json["username"]}, nachname = ${json["nachname"]}, vorname = ${json["vorname"]},  email = ${json["email"]}, tokens = ${json["tokenstand"]},");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
