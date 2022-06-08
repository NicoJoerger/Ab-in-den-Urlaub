import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:ab_in_den_urlaub/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'appBars.dart';

class AllApartments extends StatefulWidget {
  AllApartments({Key? key}) : super(key: key);
  @override
  _AllApartmentsState createState() => _AllApartmentsState();
}

class _AllApartmentsState extends State<AllApartments> {
  String url = LoginInfo().serverIP + '/api/Ferienwohnung';
  var jsons = [];
  var jsonItalien = [];
  var jsonSpanien = [];
  var jsonGriechenland = [];
  var jsonDeutschland = [];
  var response;

  void fetchFerienwohnung() async {
    try {
      response = await http.get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;
      //print(jsonData);
      setState(() {
        jsons = jsonData;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchAngebot() async {
    try {
      response =
          await http.get(Uri.parse(LoginInfo().serverIP + '/api/Angebote'));
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
          LoginInfo().serverIP + '/api/Ferienwohnung/' + id.toString()));
      final jsonData = jsonDecode(response.body) as List;
      // print(jsonData);
      setState(() {
        jsons = jsonData;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchAngebotDeutschland(var land) async {
    try {
      response = await http.get(Uri.parse(LoginInfo().serverIP +
          '/filtered?MietzeitraumStart=2010-05-25%2000%3A00%3A00.000&MietzeitraumEnde=2077-05-25%2000%3A00%3A00.000&Mietpreis=1000000&Tokenpreis=999999&Land=' +
          land.toString()));
      final jsonData = jsonDecode(response.body) as List;
      // print(jsonData);
      setState(() {
        jsonDeutschland = jsonData;
        //  print(jsonDeutschland);
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchAngebotSpanien(var land) async {
    try {
      response = await http.get(Uri.parse(LoginInfo().serverIP +
          '/filtered?MietzeitraumStart=2010-05-25%2000%3A00%3A00.000&MietzeitraumEnde=2077-05-25%2000%3A00%3A00.000&Mietpreis=1000000&Tokenpreis=999999&Land=' +
          land.toString()));
      final jsonData = jsonDecode(response.body) as List;
      // print(jsonData);
      setState(() {
        jsonSpanien = jsonData;
        //  print(jsonSpanien);
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchAngebotItalien(var land) async {
    try {
      response = await http.get(Uri.parse(LoginInfo().serverIP +
          '/filtered?MietzeitraumStart=2010-05-25%2000%3A00%3A00.000&MietzeitraumEnde=2077-05-25%2000%3A00%3A00.000&Mietpreis=1000000&Tokenpreis=999999&Land=' +
          land.toString()));
      final jsonData = jsonDecode(response.body) as List;
      //  print(jsonData);
      setState(() {
        jsonItalien = jsonData;
        //    print(jsonItalien);
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchAngebotGriechenland(var land) async {
    try {
      response = await http.get(Uri.parse(LoginInfo().serverIP +
          '/filtered?MietzeitraumStart=2010-05-25%2000%3A00%3A00.000&MietzeitraumEnde=2077-05-25%2000%3A00%3A00.000&Mietpreis=1000000&Tokenpreis=999999&Land=' +
          land.toString()));
      final jsonData = jsonDecode(response.body) as List;
      //  print(jsonData);
      setState(() {
        jsonGriechenland = jsonData;
        print(jsonGriechenland);
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    setState(() {
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
                        scrollDirection: Axis.horizontal,
                        itemCount: jsonItalien.length,
                        itemBuilder: (context, i) {
                          final json = jsonItalien[i];
                          //  fetchFerienwohnungByID(json["fwId"].toString());
                          final wohnung = json["fw"];

                          return ApartmentCard(
                            von: wohnung["mietzeitraumStart"],
                            bis: wohnung["mietzeitraumEnde"],
                            tokenP: wohnung["aktuellerTokenpreis"],
                            anlagenName: wohnung["wohnungsname"],
                            bewertung: "",
                            text: wohnung["beschreibung"],
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
                        scrollDirection: Axis.horizontal,
                        itemCount: jsonDeutschland.length,
                        itemBuilder: (context, i) {
                          final json = jsonDeutschland[i];
                          //  fetchFerienwohnungByID(json["fwId"].toString());
                          final wohnung = json["fw"];
                          return ApartmentCard(
                            von: wohnung["mietzeitraumStart"],
                            bis: wohnung["mietzeitraumEnde"],
                            tokenP: wohnung["aktuellerTokenpreis"],
                            anlagenName: wohnung["wohnungsname"],
                            bewertung: "",
                            text: wohnung["beschreibung"],
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
                          //  fetchFerienwohnungByID(json["fwId"].toString());
                          final wohnung = json["fw"];
                          return ApartmentCard(
                            von: wohnung["mietzeitraumStart"],
                            bis: wohnung["mietzeitraumEnde"],
                            tokenP: wohnung["aktuellerTokenpreis"],
                            anlagenName: wohnung["wohnungsname"],
                            bewertung: "",
                            text: wohnung["beschreibung"],
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
                          //  fetchFerienwohnungByID(json["fwId"].toString());
                          final wohnung = json["fw"];
                          return ApartmentCard(
                            von: wohnung["mietzeitraumStart"],
                            bis: wohnung["mietzeitraumEnde"],
                            tokenP: wohnung["aktuellerTokenpreis"],
                            anlagenName: wohnung["wohnungsname"],
                            bewertung: "",
                            text: wohnung["beschreibung"],
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
