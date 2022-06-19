import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'appBars.dart';
import 'globals.dart';
import 'dart:html';
import 'package:cookie_jar/cookie_jar.dart';

class Registrierung extends StatefulWidget {
  Registrierung({Key? key}) : super(key: key);
  @override
  _RegistrierungState createState() => _RegistrierungState();
}

class _RegistrierungState extends State<Registrierung> {
  var Containerh = 40.0;
  var Containerw = 400.0;
  var startToken = 420;
  final passwortLoginController = TextEditingController();
  final usernameLoginController = TextEditingController();
  final emailRegCon = TextEditingController();
  final passRegCon = TextEditingController();
  final passRegCon2 = TextEditingController();
  final creditCon = TextEditingController();
  final cvvCon = TextEditingController();
  final usernameCon = TextEditingController();
  final nachnameCon = TextEditingController();
  final vornameCon = TextEditingController();
  var response;
  var jsons = [];
  RegExp regexEmail = RegExp(
      r'[a-zA-Z0-9.!#$%&’*+=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)');
  RegExp regexVisa = RegExp(r'4[0-9]{12}(?:[0-9]{3})?');
  RegExp regexMasterCard = RegExp(
      r'(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}');

  void postUser() async {
    if (regexEmail.hasMatch(emailRegCon.text)) {
      if (regexVisa.hasMatch(creditCon.text) ||
          regexMasterCard.hasMatch(creditCon.text)) {
        if (cvvCon.text.length == 3) {
          if (passRegCon.text == passRegCon2.text) {
            try {
              response = await http.post(
                  Uri.parse(LoginInfo.serverIP + "/api/Nutzer"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8'
                  },
                  body: """ {
    "username": \"""" +
                      usernameCon.text +
                      """\",
    "nachname": \"""" +
                      nachnameCon.text +
                      """\",
    "vorname": \"""" +
                      vornameCon.text +
                      """\",
    "password": \"""" +
                      passRegCon.text +
                      """\",
    "email": \"""" +
                      emailRegCon.text +
                      """\",
    "tokenstand": """ +
                      startToken.toString() +
                      """,
                 "kreditkartendatens": [
      {
        
        "kartennummer": """ +
                      creditCon.text +
                      """,
        "cvv": """ +
                      cvvCon.text +
                      """
      }
    ]
    
    
  }""");
              if (response.statusCode == 200) {
                LoginInfo.tokens = startToken;
                try {
                  response = await http.get(Uri.parse(LoginInfo.serverIP +
                      '/login?email=' +
                      emailRegCon.text +
                      '&password=' +
                      passRegCon.text));

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
                      LoginInfo.userid = jsons[0]['userId'];
                      LoginInfo.tokens = jsons[0]['tokenstand'];
                    });
                    window.localStorage.containsKey('userId');
                    window.localStorage.containsKey('tokenstand');
                    window.localStorage.containsKey('angebotID');

                    window.localStorage['userId'] = LoginInfo.userid.toString();
                    window.localStorage['tokenstand'] =
                        LoginInfo.tokens.toString();
                    print('New added Message ${window.localStorage['userId']}');
                    Navigator.pushNamed(context, '/Profile');
                  }
                } catch (err) {
                  print(err.toString());
                }
                //Navigator.pushNamed(context, '/Profile');
              } else if (response.statusCode == 400) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Registrierung Fehlgeschlagen'),
                    content: Text(response.body),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Registrierung Fehlgeschlagen'),
                    content: Text('Fehler'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
              print(response.body);
            } catch (err) {
              print(err.toString());
            }
          } else {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Registrierung Fehlgeschlagen'),
                content: Text('Passwörter stimmen nicht überein.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Registrierung Fehlgeschlagen'),
              content: Text('CVV ist ungültig.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registrierung Fehlgeschlagen'),
            content: Text(
                'Ungültige Kreditkartennummer (Es wird nur MasterCard und Visa akzeptiert).'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Registrierung Fehlgeschlagen'),
          content: Text('Ungültige E-Mail Adresse.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void fetchUser() async {
    try {
      response = await http.get(Uri.parse(LoginInfo.serverIP +
          '/login?email=' +
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
          LoginInfo.userid = jsons[0]['userId'];
          LoginInfo.tokens = jsons[0]['tokenstand'];
        });
        window.localStorage.containsKey('userId');
        window.localStorage.containsKey('tokenstand');
        window.localStorage.containsKey('angebotID');

        window.localStorage['userId'] = LoginInfo.userid.toString();
        window.localStorage['tokenstand'] = LoginInfo.tokens.toString();
        print('New added Message ${window.localStorage['userId']}');
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
                    controller: usernameCon,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    controller: nachnameCon,
                    decoration: InputDecoration(
                      labelText: 'Nachname',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    controller: vornameCon,
                    decoration: InputDecoration(
                      labelText: 'Vorname',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    controller: emailRegCon,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    controller: passRegCon,
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                    ),
                  ),
                ),
                Container(
                  width: Containerw,
                  height: Containerh,
                  child: TextField(
                    controller: passRegCon2,
                    decoration: InputDecoration(
                      labelText: 'Passwort wiederholen',
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
                          controller: creditCon,
                          decoration: InputDecoration(
                            labelText: 'Kreditkartennummer',
                          ),
                        ),
                      ),
                      Container(
                        width: Containerw / 5,
                        child: TextField(
                          controller: cvvCon,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                          ),
                        ),
                      ),
                      Container(
                        width: Containerw / 4,
                        height: Containerh,
                        child: TextButton(
                            onPressed: () {
                              postUser();
                            },
                            child: Text("Registrieren")),
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
