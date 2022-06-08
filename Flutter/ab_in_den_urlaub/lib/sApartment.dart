import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:ab_in_den_urlaub/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'appBars.dart';

class sApartments extends StatefulWidget {
  sApartments({Key? key}) : super(key: key);
  @override
  _sApartmentsState createState() => _sApartmentsState();
}

class _sApartmentsState extends State<sApartments> {
  var jsons = [];
  var response;
  final mietPreis = TextEditingController();
  final tokenPreis = TextEditingController();

  TextStyle barstyle = TextStyle(color: Colors.white, fontSize: 17);
  String dropdownValue = 'Ohne';
  DateTime selectedRBeginn =
      DateTime.fromMicrosecondsSinceEpoch(1640901600000000);
  DateTime selectedREnde =
      DateTime.fromMicrosecondsSinceEpoch(1940901600000000);

  Future<void> selectRBeginn(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedRBeginn,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedRBeginn) {
      setState(() {
        print(picked.toString());
        selectedRBeginn = picked;
      });
    }
  }

  Future<void> selectREnde(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedREnde,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedREnde) {
      setState(() {
        selectedREnde = picked;
      });
    }
  }

  Future<void> _showTokenInputDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Maximale Tokenkosten'),
          content: SingleChildScrollView(
            child: TextField(
              controller: tokenPreis,
              decoration: new InputDecoration(labelText: "Preis"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
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

  Future<void> _showMietPreisDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Maximaler Mietpreis'),
          content: SingleChildScrollView(
            child: TextField(
              controller: mietPreis,
              decoration: new InputDecoration(labelText: "Preis"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
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

  void fetchAngebot() async {
    var land = dropdownValue.toString();
    var jsonLand;
    var start = selectedRBeginn.toString();
    var end = selectedREnde.toString();
    var mietPreisVal = mietPreis.text;
    var tokenPreisVal = tokenPreis.text;
    if (land == 'Ohne') {
      try {
        response = await http.get(Uri.parse(LoginInfo().serverIP +
            '/filtered?MietzeitraumStart=2010-05-25%2000%3A00%3A00.000&MietzeitraumEnde=2077-05-25%2000%3A00%3A00.000&Mietpreis=1000000&Tokenpreis=999999'));
        print(response.body);
        final jsonData = jsonDecode(response.body) as List;
        print(jsonData);
        setState(() {
          jsonLand = jsonData;
          print(jsonLand);
        });
      } catch (err) {
        print(err.toString());
      }
    } else {
      try {
        response = await http.get(Uri.parse(
            LoginInfo().serverIP + '/filtered?MietzeitraumStart=' +
                start +
                '&MietzeitraumEnde=' +
                end +
                '&Mietpreis=' +
                mietPreisVal +
                '&Tokenpreis=' +
                tokenPreisVal +
                '&Land=' +
                land));
        print(response.body);
        final jsonData = jsonDecode(response.body) as List;
        print(jsonData);
        setState(() {
          jsonLand = jsonData;
          print(jsonLand);
        });
      } catch (err) {
        print(err.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    tokenPreis.text = "999999";
    mietPreis.text = "999999";
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
            child: Container(
              child: Column(children: [
                Container(
                  height: 50,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Nach Land filtern: ",
                              style: barstyle,
                            ),
                            DropdownButton<String>(
                              dropdownColor: Colors.blue,
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>[
                                'Ohne',
                                'Deutschland',
                                'Frankreich',
                                'Großbritannien',
                                'Ungarn',
                                'Schweden',
                                'Spanien',
                                'Kanada',
                                'Nordkorea',
                                'Griechenland',
                                'Japan'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => selectRBeginn(context),
                        child: const Text('Anreise ab'),
                      ),
                      Text(selectedRBeginn.toString()),
                      ElevatedButton(
                        onPressed: () => selectREnde(context),
                        child: const Text('Abreise bis'),
                      ),
                      Text(selectedRBeginn.toString()),
                      ElevatedButton(
                        onPressed: () => _showTokenInputDialog(),
                        child: const Text('Tokengrenze'),
                      ),
                      ElevatedButton(
                        onPressed: () => _showMietPreisDialog(),
                        child: const Text('Mietpreis'),
                      ),
                      ElevatedButton(
                          onPressed: fetchAngebot, child: const Text('Suchen'))
                    ],
                  ),
                ),
                Container(
                  height: 500,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: jsons.length,
                    itemBuilder: (context, i) {
                      final json = jsons[i];
                      //  fetchFerienwohnungByID(json["fwId"].toString());
                      final wohnung = json["fw"];
                      return ApartmentCard(
                        anlagenName: wohnung["wohnungsname"],
                        bewertung: "",
                        text: wohnung["beschreibung"],
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
