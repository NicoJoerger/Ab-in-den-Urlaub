import 'package:ab_in_den_urlaub/globals.dart';
import 'package:flutter/material.dart';

import 'appBars.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String url = 'https://localhost:7077/api/Nutzer';
  var rechnungshistorie = [];
  var response;
  var Texth = 40.0;
  var Textw = 400.0;
  final emailRegCon = TextEditingController();
  final passRegCon = TextEditingController();
  final passRegCon2 = TextEditingController();
  final creditCon = TextEditingController();
  final cvvCon = TextEditingController();
  final usernameCon = TextEditingController();
  final nachnameCon = TextEditingController();
  final vornameCon = TextEditingController();

  String dropdownValue = 'Wähle Wohnung';

  void fetchHistory() async {
    try {
      response = await http.get(Uri.parse(
          "https://localhost:7077/api/Rechnungshistorieeintrag/" +
              LoginInfo().userid.toString()));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        rechnungshistorie = jsonData;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> _showWohnungInputDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Maximale Tokenkosten'),
          content: SingleChildScrollView(
            child: DropdownButton<String>(
              dropdownColor: Colors.blue,
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>[
                'Wähle Wohnung',
                'Deutschland',
                'Frankreich',
                'Spanien'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Bestätigen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void postUser() async {
    if (passRegCon.text == passRegCon2.text) {
      try {
        response = await http.post(
            Uri.parse("https://localhost:7077/api/Nutzer"),
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
                LoginInfo().tokens.toString() +
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
          //LoginInfo().tokens = startToken;
          Navigator.pushNamed(context, '/Profile');
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Visibility(
                  visible: LoginInfo().vermieter,
                  child: Container(
                    height: 50,
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/nAngebot'),
                          child: const Text('Neues Angebot erstellen'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              {Navigator.pushNamed(context, '/nWohnung')},
                          child: const Text('Neue Wohnung anlegen'),
                        ),
                        ElevatedButton(
                          onPressed: () => _showWohnungInputDialog,
                          child: const Text('Wohnung löschen'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: Textw,
                  height: Texth,
                  child:
                      Text("Profil bearbeiten", style: TextStyle(fontSize: 30)),
                ),
                const SizedBox(height: 10),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    controller: usernameCon,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    controller: nachnameCon,
                    decoration: InputDecoration(
                      labelText: 'Nachname',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    controller: vornameCon,
                    decoration: InputDecoration(
                      labelText: 'Vorname',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    controller: emailRegCon,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    controller: passRegCon,
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    controller: passRegCon2,
                    decoration: InputDecoration(
                      labelText: 'Passwort wiederholen',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Textw / 2,
                        child: TextField(
                          controller: creditCon,
                          decoration: InputDecoration(
                            labelText: 'Kreditkartennummer',
                          ),
                        ),
                      ),
                      Container(
                        width: Textw / 5,
                        child: TextField(
                          controller: cvvCon,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                          ),
                        ),
                      ),
                      Container(
                        width: Textw / 4,
                        height: Texth,
                        child: TextButton(
                            onPressed: () {
                              postUser();
                            },
                            child: Text("Speichern")),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: LoginInfo().vermieter,
                        onChanged: (val) {
                          setState(() {
                            LoginInfo().vermieter = val!;
                          });
                        }),
                    Text("Ich möchte Wohnungen vermieten.")
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Rechnungshistorie:",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: Text("Vermieter"),
                      ),
                      Container(
                        width: 150,
                        child: Text("Auktionsende"),
                      ),
                      Container(
                        width: 150,
                        child: Text("Angebotsname"),
                      ),
                      Container(
                        width: 150,
                        child: Text(""),
                      ),
                      Container(
                        width: 150,
                        child: Text(""),
                      ),
                      Container(
                        width: 150,
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ListView.builder(
                    itemCount: rechnungshistorie.length,
                    itemBuilder: (context, i) {
                      final json = rechnungshistorie[i];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            child: Text(json[""]),
                          ),
                          Container(
                            width: 150,
                            child: Text(json[""]),
                          ),
                          Container(
                            width: 150,
                            child: Text(json[""]),
                          ),
                          Container(
                            width: 150,
                            child: Text(json[""]),
                          ),
                          Container(
                            width: 150,
                            child: Text(json[""]),
                          ),
                          Container(
                            width: 150,
                            child: Text(json[""]),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: LoginInfo().vermieter,
                  child: Column(
                    children: [
                      Text(
                        "Laufende Auktionen:",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              child: Text("Vermieter"),
                            ),
                            Container(
                              width: 150,
                              child: Text("Auktionsende"),
                            ),
                            Container(
                              width: 150,
                              child: Text("Angebotsname"),
                            ),
                            Container(
                              width: 150,
                              child: Text(""),
                            ),
                            Container(
                              width: 150,
                              child: Text(""),
                            ),
                            Container(
                              width: 150,
                              child: Text(""),
                            ),
                          ],
                        ),
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
