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
  String dropdownValue = 'Wähle Wohnung';

  void fetchUser() async {
    try {
      response = await http.get(Uri.parse(url));
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
          child: Column(
            children: [
              Container(
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
                height: 500,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(value: false, onChanged: (bool? val) {}),
                  Text("Ich möchte Wohnungen vermieten.")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
