import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:typed_data';

import 'globals.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'appBars.dart';

class apartmentDetail extends StatefulWidget {
  String anlagenName = "";
  String angebotID = "";
  String anlagenID = "";
  String bewertung = "";
  String text = "";
  String images = "";
  String von = "";
  String bis = "";
  String eurpP = "";
  String land = "";
  String ort = "";
  String pLZ = "";
  String strasse = "";
  String hausNr = "";
  String wohnflaeche = "";
  String zimmer = "";
  String betten = "";
  String baeder = "";
  bool wlan = false;
  bool garten = false;
  bool balkon = false;
  int tokenP = 0;

  apartmentDetail(
      {Key? key,
      this.anlagenName = "",
      this.bewertung = "",
      this.angebotID = "1",
      this.anlagenID = "1",
      this.von = "",
      this.bis = "",
      this.tokenP = 0,
      this.text = "0",
      this.eurpP = "0",
      this.land = "0",
      this.ort = "0",
      this.pLZ = "0",
      this.strasse = "0",
      this.hausNr = "0",
      this.wohnflaeche = "0",
      this.zimmer = "0",
      this.betten = "0",
      this.baeder = "0",
      this.wlan = false,
      this.garten = false,
      this.balkon = false})
      : super(key: key);
  @override
  _apartmentDetailState createState() => _apartmentDetailState();
}

class _apartmentDetailState extends State<apartmentDetail> {
  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  var Containerh = 40.0;
  var Containerw = 400.0;
  var ContentWFactor = 0.5;

  var test;
  var response;
  var jsons = [];
  var bilder = [];

  void fetchOffer() async {
    String urlOffer = LoginInfo().serverIP +
        '/api/Angebote/' +
        widget.angebotID.toString() +
        "/a";
    try {
      response = await http.get(Uri.parse(urlOffer));
      var jsonData = jsonDecode(response.body);
      print("jsonDataAngebot: " + jsonData.toString() + "\n");
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchApartment() async {
    String urlApart = LoginInfo().serverIP + "/api/Ferienwohnung/" + widget.anlagenID.toString();
    try{
      response = await http.get(Uri.parse(urlApart));
      var jsonData = jsonDecode(response.body);
      print("jsonDataWohnung: " + jsonData.toString() + "\n");
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchImage() async {
    String urlImg = LoginInfo().serverIP + '/api/Bilder';
    try {
      response = await http.get(Uri.parse(urlImg));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        jsons = jsonData;
        print("hallo");
        test = imageFromBase64String(jsons[1]['bild']);
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  void initState() {
    fetchApartment();
    fetchImage();
    super.initState();
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
                const Text("Bilder", style: TextStyle(fontSize: 50)),
                Container(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: test,
                ),
                Container(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        Image(image: AssetImage("images/beach.jpg")),
                        Image(image: AssetImage("images/beach.jpg")),
                        Image(image: AssetImage("images/beach.jpg")),
                        Image(image: AssetImage("images/beach.jpg")),
                      ]),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Neues Bild hochladen"),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Beschreibungstext',
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(""),
                      ],
                    ),
                    //Column(
                    //children: [Checkbox(value: false, onChanged: () => {})],
                    //),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(value: false, onChanged: (bool? val) {}),
                        Text("Ich möchte Wohnungen vermieten.")
                      ],
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Speichern"),
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
