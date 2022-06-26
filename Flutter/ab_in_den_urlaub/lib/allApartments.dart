import 'dart:typed_data';

import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:ab_in_den_urlaub/globals.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'appBars.dart';
import 'dart:html';

class AllApartments extends StatefulWidget {
  AllApartments({Key? key}) : super(key: key);
  @override
  _AllApartmentsState createState() => _AllApartmentsState();
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class _AllApartmentsState extends State<AllApartments> {
  final ScrollController scrollController = ScrollController();
  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  String url = LoginInfo.serverIP + '/api/Ferienwohnung';
  var jsons = [];

  var jsonItalien = [];
  var jsonSpanien = [];
  var jsonGriechenland = [];
  var jsonDeutschland = [];
  var response;
  var wohnungen = [];
  var wohnungenById;
  Map<int, Widget> Bilder = Map();

  void loadCookies() async {
    try {
      LoginInfo.userid = int.parse(window.localStorage['userId'].toString());
      LoginInfo.currentAngebot = window.localStorage['angebotID'].toString();
      LoginInfo.tokens =
          int.parse(window.localStorage['tokenstand'].toString());
    } catch (e) {
      print("\n\n\n\nNo Cookies found!!!");
      //_showMyDialog();
      final snackBar = SnackBar(
        content: const Text(
            'Es handelt sich bei dieser Website um ein Projekt innerhalb des Informatikstudiums.\nDies ist keine echte Platform um Ferienwohnungen zu buchen.\nBitte geben Sie keine persoenlichen Daten an!'),
        action: SnackBarAction(
          label: 'Gelesen',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      window.localStorage.containsKey('userId');
      window.localStorage.containsKey('tokenstand');
      window.localStorage.containsKey('angebotID');

      window.localStorage['userId'] = "-1";
      window.localStorage['tokenstand'] = "0";
      window.localStorage['angebotID'] = "10";
    }
  }

  void getWohnungByID(int id) {
    //print("NEIN");
    //print("lala:" + wohnungen[45].toString());
    for (int i = 0; i < wohnungen.length; i++) {
      if (wohnungen[i]["fwId"].toString() == id.toString()) {
        wohnungenById = wohnungen[i];
        //print("JAWOHL");
      }
    }
    // print("lulul");
  }

  //wohnungenById

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
        print("Wohnungen[" + i.toString() + "]: " + wohnungen[i].toString());
      }
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchImage() async {
    await getWohnungen();
    for (int i = 0; i < jsonItalien.length; i++) {
      int fwID = jsonItalien[i]["fwId"];

      getWohnungByID(fwID);
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

    for (int i = 0; i < jsonSpanien.length; i++) {
      int fwID = jsonSpanien[i]["fwId"];

      getWohnungByID(fwID);
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
    for (int i = 0; i < jsonDeutschland.length; i++) {
      int fwID = jsonDeutschland[i]["fwId"];

      getWohnungByID(fwID);
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
    for (int i = 0; i < jsonGriechenland.length; i++) {
      int fwID = jsonGriechenland[i]["fwId"];

      getWohnungByID(fwID);
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

  void fetchFerienwohnung() async {
    try {
      response = await http.get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;
      //print(jsonData);
      setState(() {
        jsons = jsonData;
      });
    } catch (err) {
      //print(err.toString());
    }
  }

  void fetchAngebot() async {
    try {
      response =
          await http.get(Uri.parse(LoginInfo.serverIP + '/api/Angebote'));
      final jsonData = jsonDecode(response.body) as List;
      //print(jsonData);
      setState(() {
        jsons = jsonData;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchFerienwohnungByID(var id) async {
    try {
      response = await http.get(Uri.parse(
          LoginInfo.serverIP + '/api/Ferienwohnung/' + id.toString()));
      final jsonData = jsonDecode(response.body) as List;
      // print(jsonData);
      setState(() {
        jsons = jsonData;
      });
    } catch (err) {
      //print(err.toString());
    }
  }

  void fetchAngebotDeutschland(var land) async {
    try {
      response = await http.get(Uri.parse(LoginInfo.serverIP +
          '/filtered?MietzeitraumStart=2010-05-25%2000%3A00%3A00.000&MietzeitraumEnde=2077-05-25%2000%3A00%3A00.000&Mietpreis=1000000&Tokenpreis=999999&Land=' +
          land.toString()));
      final jsonData = jsonDecode(response.body) as List;
      // print(jsonData);

      setState(() {
        jsonDeutschland = jsonData;
        //print(jsonDeutschland.toString());
      });
    } catch (err) {
      //print(err.toString());
    }
  }

  void fetchAngebotSpanien(var land) async {
    try {
      response = await http.get(Uri.parse(LoginInfo.serverIP +
          '/filtered?MietzeitraumStart=2010-05-25%2000%3A00%3A00.000&MietzeitraumEnde=2077-05-25%2000%3A00%3A00.000&Mietpreis=1000000&Tokenpreis=999999&Land=' +
          land.toString()));
      final jsonData = jsonDecode(response.body) as List;
      // print(jsonData);
      setState(() {
        jsonSpanien = jsonData;
        //print(jsonSpanien.toString());
      });
    } catch (err) {
      //print(err.toString());
    }
    fetchImage();
  }

  void fetchAngebotItalien(var land) async {
    try {
      response = await http.get(Uri.parse(LoginInfo.serverIP +
          '/filtered?MietzeitraumStart=2010-05-25%2000%3A00%3A00.000&MietzeitraumEnde=2077-05-25%2000%3A00%3A00.000&Mietpreis=1000000&Tokenpreis=999999&Land=' +
          land.toString()));
      final jsonData = jsonDecode(response.body) as List;
      //  print(jsonData);
      setState(() {
        jsonItalien = jsonData;
        //print(jsonItalien.toString());
      });
    } catch (err) {
      // print(err.toString());
    }
  }

  void fetchAngebotGriechenland(var land) async {
    try {
      response = await http.get(Uri.parse(LoginInfo.serverIP +
          '/filtered?MietzeitraumStart=2010-05-25%2000%3A00%3A00.000&MietzeitraumEnde=2077-05-25%2000%3A00%3A00.000&Mietpreis=1000000&Tokenpreis=999999&Land=' +
          land.toString()));
      final jsonData = jsonDecode(response.body) as List;
      //  print(jsonData);
      setState(() {
        jsonGriechenland = jsonData;
        //print(jsonGriechenland.toString());
      });
    } catch (err) {
      //print(err.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    loadCookies();
    setState(() {
      loadCookies();
      //fetchFerienwohnung();
      //fetchAngebot();

      fetchAngebotDeutschland("Deutschland");
      fetchAngebotGriechenland("Griechenland");
      fetchAngebotItalien("Italien");
      fetchAngebotSpanien("Spanien");
    });
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        child: const FittedBox(
                          child: const Image(
                              image: AssetImage("images/hallstatt.jpg")),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.height * 0.7,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: const Text(
                            "Ab in den Urlaub...",
                            style: const TextStyle(
                              fontSize: 50,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                    ),
                    const Text("Italien", style: TextStyle(fontSize: 50)),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: jsonItalien.length,
                        itemBuilder: (context, i) {
                          final json = jsonItalien[i];
                          var startTime = json["mietzeitraumStart"];
                          startTime = DateTime.parse(startTime);
                          var endTime = json["mietzeitraumEnde"];
                          endTime = DateTime.parse(endTime);
                          //  fetchFerienwohnungByID(json["fwId"].toString());
                          final wohnung = json["fw"];

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
                            anlangenID: wohnung["fwId"].toString(),
                            bewertung: "",
                            text: wohnung["beschreibung"],
                            land: wohnung["land"],
                            ort: wohnung["ort"],
                            pLZ: wohnung["plz"].toString(),
                            strasse: wohnung["strasse"],
                            hausNr: wohnung["hausnummer"].toString(),
                            angebotID: json["angebotId"].toString(),
                            image: Bilder[json["fwId"]]!,
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    const Text("Deutschland", style: TextStyle(fontSize: 50)),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: jsonDeutschland.length,
                        itemBuilder: (context, i) {
                          final json = jsonDeutschland[i];
                          var startTime = json["mietzeitraumStart"];
                          startTime = DateTime.parse(startTime);
                          var endTime = json["mietzeitraumEnde"];
                          endTime = DateTime.parse(endTime);
                          //  fetchFerienwohnungByID(json["fwId"].toString());
                          final wohnung = json["fw"];
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
                            strasse: wohnung["strasse"],
                            hausNr: wohnung["hausnummer"].toString(),
                            angebotID: json["angebotId"].toString(),
                            image: Bilder[json["fwId"]]!,
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    const Text("Spanien", style: TextStyle(fontSize: 50)),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: jsonSpanien.length,
                        itemBuilder: (context, i) {
                          final json = jsonSpanien[i];
                          var startTime = json["mietzeitraumStart"];
                          startTime = DateTime.parse(startTime);
                          var endTime = json["mietzeitraumEnde"];
                          endTime = DateTime.parse(endTime);
                          //  fetchFerienwohnungByID(json["fwId"].toString());
                          final wohnung = json["fw"];
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
                            strasse: wohnung["strasse"],
                            hausNr: wohnung["hausnummer"].toString(),
                            angebotID: json["angebotId"].toString(),
                            image: Bilder[json["fwId"]]!,
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    const Text("Griechenland",
                        style: const TextStyle(fontSize: 50)),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: jsonGriechenland.length,
                        itemBuilder: (context, i) {
                          final json = jsonGriechenland[i];
                          var startTime = json["mietzeitraumStart"];
                          startTime = DateTime.parse(startTime);
                          var endTime = json["mietzeitraumEnde"];
                          endTime = DateTime.parse(endTime);
                          //  fetchFerienwohnungByID(json["fwId"].toString());
                          final wohnung = json["fw"];
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
                            strasse: wohnung["strasse"],
                            hausNr: wohnung["hausnummer"].toString(),
                            angebotID: json["angebotId"].toString(),
                            image: Bilder[json["fwId"]]!,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
