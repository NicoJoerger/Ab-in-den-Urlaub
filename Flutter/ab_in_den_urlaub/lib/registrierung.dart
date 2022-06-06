import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'appBars.dart';
import 'globals.dart';

class Registrierung extends StatefulWidget {
  Registrierung({Key? key}) : super(key: key);
  @override
  _RegistrierungState createState() => _RegistrierungState();
}

class _RegistrierungState extends State<Registrierung> {
  var Containerh = 40.0;
  var Containerw = 400.0;
  final passwortLoginController = TextEditingController();
  final usernameLoginController = TextEditingController();
  var response;
  var jsons = [];

  void fetchUser() async {
    try {
      response = await http.get(Uri.parse(
          'https://localhost:7077/login?email=' +
              usernameLoginController.text +
              '&password=' +
              passwortLoginController.text));

      if (response.statusCode != 200) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Login Fehlgeschlagen'),
            content: const Text('Username oder Passwort falsch'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        final jsonData = jsonDecode(response.body) as List;
        print(jsonData);
        setState(() {
          jsons = jsonData;
          var length = jsons.length;

          LoginInfo().userid = jsons[0]['userId'];
          LoginInfo().tokens = jsons[0]['tokenstand'];
        });
        Navigator.pushNamed(context, '/Profile');
      }
    } catch (err) {
      print(err.toString());
    }
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
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: Text("Login"),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    controller: usernameLoginController,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    controller: passwortLoginController,
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Passwort vergessen"),
                      Container(
                        height: Containerh,
                        child: TextButton(
                          onPressed: fetchUser,
                          child: Text("Login"),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 100,
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: Text("Registrierung"),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Passwort wiederholen',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Alter',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Containerw / 2,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Kreditkartennummer',
                          ),
                        ),
                      ),
                      Container(
                        width: Containerw / 5,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'CVV',
                          ),
                        ),
                      ),
                      Container(
                        width: Containerw / 4,
                        height: Containerh,
                        child: TextButton(
                            onPressed: () {}, child: Text("Registrieren")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
