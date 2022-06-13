import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:io';
import 'globals.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'appBars.dart';
import 'dart:html';

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

  var response;
  var jsons = [];
  List<Widget> bilder = [];
  var jsonOffer;
  var jsonApart;

  String strasse = "";
  String hausnummer = "";
  String mietzeitraumStart = "";
  String mietzeitraumEnde = "";
  String plz = "";
  String ort = "";
  String land = "";
  String beschreibung = "";
  String fwID = "";
  TextEditingController _controller = TextEditingController();

  void fetchOffer() async {
    String urlOffer = LoginInfo().serverIP +
        '/api/Angebote/' +
        LoginInfo().currentAngebot +
        "/a";
    try {
      response = await http.get(Uri.parse(urlOffer));
      jsonOffer = jsonDecode(response.body);
      mietzeitraumStart = jsonOffer["mietzeitraumStart"].toString();
      mietzeitraumEnde = jsonOffer["mietzeitraumEnde"].toString();
      fwID = jsonOffer["fwId"].toString();
      print("jsonDataAngebot: " + jsonOffer.toString() + "\n");
    } catch (err) {
      print(err.toString());
    }
    fetchApartment();
  }

  void fetchApartment() async {
    
    String urlApart = LoginInfo().serverIP +
        "/api/Ferienwohnung/" + 
        fwID;
        print("fetch Apartment");
    try {
      response = await http.get(Uri.parse(urlApart));
      jsonApart = jsonDecode(response.body);
      strasse = jsonApart["strasse"].toString();
      hausnummer = jsonApart["hausnummer"].toString();
      plz = jsonApart["plz"].toString();
      beschreibung = jsonApart["beschreibung"].toString();
      ort = jsonApart["ort"].toString();
      land = jsonApart["land"].toString();
      _controller = TextEditingController(text: beschreibung);
      print("jsonDataWohnung: " + jsonApart.toString() + "\n");
    } catch (err) {
      print(err.toString());
    }
    //fetchImage();
  }

  void loadCookies() {
    LoginInfo().userid = int.parse(window.localStorage['userId'].toString());
    LoginInfo().currentAngebot = window.localStorage['angebotID'].toString();
    LoginInfo().tokens =
        int.parse(window.localStorage['tokenstand'].toString());
    fetchOffer();
  }

  void fetchImage() async {
    print("ID:" + widget.anlagenID);
    String urlImg = LoginInfo().serverIP + '/api/Wohnungsbilder/' + widget.anlagenID.toString();
    try {
      response = await http.get(Uri.parse(urlImg));
      jsons = jsonDecode(response.body) as List;
      print("lange: " + jsons.length.toString());
      setState(() {
        for(int i = 0; i< (jsons.length);i++)
        {
          Image image  = imageFromBase64String(jsons[i]["bild"]);
          print("test");
          bilder.add(image);
        }
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  void initState () {
     loadCookies();
    //print("datum:" + widget.text + "\n");
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
                  child: ImageSlideshow(
                      width: 1000,
                      height: 700,
                      initialPage: 0,
                      children: bilder),
                ),
                Container(
                  height: 10,
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: Text(widget.text),
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
                        Text("Adresse: " +
                            strasse +
                            " " +
                            hausnummer +
                            ", " +
                            plz +
                            " " +
                            ort +
                            " " +
                            land,)
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Mietzeitraum: " +
                            mietzeitraumStart +
                            " bis: " +
                            mietzeitraumEnde)
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Aktueller Tokenpreis: " +
                            //widget.tokenP.toString() +
                            " Tokens")
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Mietpreis: " + widget.eurpP + "€")],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Wohnfläche: " + widget.wohnflaeche + "m²"),
                        SizedBox(
                          width: 50,
                        ),
                        Text("Anzahl Zimmer: " + widget.zimmer),
                        SizedBox(
                          width: 50,
                        ),
                        Text("Anzahl Betten: " + widget.betten),
                        SizedBox(
                          width: 50,
                        ),
                        Text("Anzahl Bäder: " + widget.baeder),
                        SizedBox(
                          width: 50,
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(value: widget.wlan, onChanged: null),
                        Text("Wifi"),
                        Checkbox(value: widget.garten, onChanged: null),
                        Text("Garten"),
                        Checkbox(value: widget.balkon, onChanged: null),
                        Text("Balkon"),
                        Checkbox(value: widget.balkon, onChanged: null),
                        Text("Stornierbar: (TODO)")
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
                    child: Text("Bieten"),
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
