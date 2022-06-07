import 'dart:collection';
import 'dart:typed_data';

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
  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Image test = Image(image: AssetImage("images/hallstatt.jpg"));
  String url = 'http://81.169.152.56:5000/api/Nutzer';
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

  void fetchImage() async {
    String urlImg = 'http://81.169.152.56:5000/api/Bilder';
    try {
      response = await http.get(Uri.parse(urlImg));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        jsons = jsonData;
        print("imageresponse: " + jsonData.toString());
        test = imageFromBase64String(jsons[1]['bild']);
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void postUser() async {
    try {
      response = await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      }, body: """ {
    "username": "niggotesterino",
    "nachname": "dsauhdiuashidushaiud",
    "vorname": "asdoiuhasiudshaiudhiuhciuewhbc",
    "password": "siauvbiushvruivbdiubvdiuvb",
    "email": "ascuiadshvieruvh349uhv9835hv9r",
    "tokenstand": 0,
    "vermieter": false,
    "admin": true
  }""");

      /**
           * (<String, String>{
            'username': "BastianDerlappen!1",
            "nachname": "dhfbdsuhzbu",
            "vorname": "asdhiabsdhua",
            "password": "asdhasbdhuasbdu",
            "email": "emailtest",
            "tokenstand": 0.toString(),
            "vermieter": false.toString(),
            "bewertungs": "[]",
            "ferienwohnungs": "[]",
            "gebots": "[]",
            "kreditkartendatens": "[]",
            "rechnungshistorieeintrags": "[]"
          })
           */
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
        body: SingleChildScrollView(
          child: Column(
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
              ElevatedButton(
                  child: Text("LoadImage"), onPressed: () => {fetchImage()}),
              test,
            ],
          ),
        ),
      ),
    );
  }
}
