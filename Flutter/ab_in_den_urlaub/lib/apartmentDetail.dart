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
  String beschreibung = "";
  TextEditingController _controller = TextEditingController();

  void fetchOffer() async {
    String urlOffer = LoginInfo().serverIP +
        '/api/Angebote/' +
        widget.angebotID.toString() +
        "/a";
    try {
      response = await http.get(Uri.parse(urlOffer));
      jsonOffer = jsonDecode(response.body);
      print("jsonDataAngebot: " + jsonOffer.toString() + "\n");
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchApartment() async {
    String urlApart = LoginInfo().serverIP +
        "/api/Ferienwohnung/" +
        widget.anlagenID.toString();
    try {
      response = await http.get(Uri.parse(urlApart));
      jsonApart = jsonDecode(response.body);
      beschreibung = jsonApart["beschreibung"].toString();
      _controller = TextEditingController(text: beschreibung);
      print("jsonDataWohnung: " + jsonApart.toString() + "\n");
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchImage() async {
    print("ID:" + widget.anlagenID);
    String urlImg = LoginInfo().serverIP + '/api/Wohnungsbilder/' + widget.anlagenID;
    try {
      response = await http.get(Uri.parse(urlImg));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        jsons = jsonData;
        print("bilder:" + jsons.toString());
        for(int i = 0; i< (jsons.length);i++)
        {
          Image image  = imageFromBase64String(jsons[i]);
          bilder.add(image);
        }
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  void initState() {
    //print("datum:" + widget.text + "\n");
    fetchApartment();
    fetchImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (arguments["text"] != null) {
      widget.text = arguments["text"];
      widget.von = arguments["von"];
      widget.bis = arguments["bis"];
      widget.land = arguments["land"];
      widget.ort = arguments["ort"];
      widget.strasse = arguments["strasse"];
      widget.pLZ = arguments["pLZ"];
      widget.hausNr = arguments["hausNr"];
      widget.anlagenID = arguments["anlangenID"];
    }
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
                            widget.strasse +
                            " " +
                            widget.hausNr +
                            ", " +
                            widget.pLZ +
                            " " +
                            widget.ort +
                            " " +
                            widget.land),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Mietzeitraum: " +
                            widget.von +
                            " bis: " +
                            widget.bis)
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Aktueller Tokenpreis: " +
                            widget.tokenP.toString() +
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
