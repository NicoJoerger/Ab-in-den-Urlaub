import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'appBars.dart';

class sApartments extends StatefulWidget {
  sApartments({Key? key}) : super(key: key);
  @override
  _sApartmentsState createState() => _sApartmentsState();
}

class _sApartmentsState extends State<sApartments> {
  var jsons = [];
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
                      ElevatedButton(
                        onPressed: () => selectREnde(context),
                        child: const Text('Abreise bis'),
                      ),
                      ElevatedButton(
                        onPressed: () => _showTokenInputDialog(),
                        child: const Text('Tokengrenze'),
                      ),
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
