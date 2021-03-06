import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:ab_in_den_urlaub/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'appBars.dart';
import 'dart:html';

class sApartments extends StatefulWidget {
  sApartments({Key? key}) : super(key: key);
  @override
  _sApartmentsState createState() => _sApartmentsState();
}

class _sApartmentsState extends State<sApartments> {
  var jsons = [];
  Map<int, Widget> Bilder = Map();
  var wohnungen = [];
  var jsonLand = [];
  var response;
  var wohnungenById;
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
        //    print(picked.toString());
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
              child: const Text('Best??tigen'),
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
              child: const Text('Best??tigen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getWohnungByID(int id) {
    //print("NEIN");
    // print("lala:" + wohnungen[45].toString());
    for (int i = 0; i < wohnungen.length; i++) {
      if (wohnungen[i]["fwId"].toString() == id.toString()) {
        wohnungenById = wohnungen[i];
        // print("JAWOHL");
      }
    }
    //print("lulul");
  }

  Future<void> getWohnungen() async {
    try {
      response =
          await http.get(Uri.parse(LoginInfo.serverIP + "/api/Ferienwohnung/"));
      final jsonData = jsonDecode(response.body) as List;
      for (int i = 0; i < jsonData.length; i++) {
        if (!jsonData[i]["deaktiviert"]) {
          setState(() {
            wohnungen.add(jsonData[i]);
          });
        }
      }

      for (int i = 0; i < wohnungen.length; i++) {
        //print("Wohnungen[" + i.toString() + "]: " + wohnungen[i].toString());
      }
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchImage() async {
    await getWohnungen();
    for (int i = 0; i < jsonLand.length; i++) {
      int fwID = jsonLand[i]["fwId"];

      getWohnungByID(fwID);
      //print("WOHNUNG ID:" + wohnungenById.toString());
      String urls = wohnungenById["bilderLinks"].toString();
      List<String> links = [];
      Image nBild;

      links = urls.split(";");
      links[0] = links[0].replaceAll(";", "");
      nBild = Image.network(links[0]);
      setState(() {
        Bilder[fwID] = nBild;
      });
    }
  }

  void fetchTokenstand() async {
    try {
      var response = await http.get(Uri.parse(
          LoginInfo.serverIP + '/api/Nutzer/' + LoginInfo.userid.toString()));

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
        window.localStorage['angebotID'] = LoginInfo.currentAngebot.toString();
      }
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  void initState() {
    loadCookies();
    super.initState();
    fetchTokenstand();
  }

  void loadCookies() async {
    LoginInfo.userid = int.parse(window.localStorage['userId'].toString());
    LoginInfo.currentAngebot = window.localStorage['angebotID'].toString();
    LoginInfo.tokens = int.parse(window.localStorage['tokenstand'].toString());
  }

  void fetchAngebot() async {
    var land = dropdownValue.toString();

    var start = selectedRBeginn.toString();
    var end = selectedREnde.toString();
    var mietPreisVal = mietPreis.text;
    var tokenPreisVal = tokenPreis.text;

    try {
      response = await http.get(Uri.parse(LoginInfo.serverIP +
          '/filtered?MietzeitraumStart=' +
          start +
          '&MietzeitraumEnde=' +
          end +
          '&Mietpreis=' +
          mietPreisVal +
          '&Tokenpreis=' +
          tokenPreisVal +
          '&Land=' +
          land));
      //    print(response.body);
      final jsonData = jsonDecode(response.body);
      //print("JsonData Angebot\n\n\n\n" + jsonData.toString());

      setState(() {
        jsonLand = jsonData;
        //print("\n jsonland: " + jsonLand.toString() + "\n");
      });
    } catch (err) {
      print(err.toString());
    }
    fetchImage();
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
                                'Gro??britannien',
                                'Ungarn',
                                'Schweden',
                                'Spanien',
                                'Kanada',
                                'Griechenland',
                                'Japan',
                                'Italien'
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
                      Text(
                          "" +
                              selectedRBeginn.day.toString() +
                              "-" +
                              selectedRBeginn.month.toString() +
                              "-" +
                              selectedRBeginn.year.toString(),
                          style: TextStyle(color: Colors.white)),
                      ElevatedButton(
                        onPressed: () => selectREnde(context),
                        child: const Text('Abreise bis'),
                      ),
                      Text(
                          "" +
                              selectedREnde.day.toString() +
                              "-" +
                              selectedREnde.month.toString() +
                              "-" +
                              selectedREnde.year.toString(),
                          style: TextStyle(color: Colors.white)),
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
                  height: MediaQuery.of(context).size.height,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 500,
                              childAspectRatio: 2 / 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemCount: jsonLand.length,
                      itemBuilder: (BuildContext context, i) {
                        final json = jsonLand[i];
                        final wohnung = json["fw"];
                        var startTime = json["mietzeitraumStart"];
                        startTime = DateTime.parse(startTime);
                        var endTime = json["mietzeitraumEnde"];
                        endTime = DateTime.parse(endTime);
                        return ApartmentCard(
                          von: "" +
                              startTime.day.toString() +
                              "-" +
                              startTime.month.toString() +
                              "-" +
                              startTime.year.toString() +
                              " ",
                          bis: "" +
                              endTime.day.toString() +
                              "-" +
                              endTime.month.toString() +
                              "-" +
                              endTime.year.toString(),
                          tokenP: json["aktuellerTokenpreis"],
                          anlagenName: wohnung["wohnungsname"],
                          bewertung: "",
                          text: wohnung["beschreibung"],
                          land: wohnung["land"],
                          ort: wohnung["ort"],
                          pLZ: wohnung["plz"].toString(),
                          strasse: wohnung["strasse"].toString(),
                          hausNr: wohnung["hausnummer"].toString(),
                          angebotID: json["angebotId"].toString(),
                          image: Bilder[json["fwId"]]!,
                        );
                      }),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
