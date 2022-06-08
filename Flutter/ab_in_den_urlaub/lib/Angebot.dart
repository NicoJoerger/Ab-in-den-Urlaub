import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';

import 'appBars.dart';

class nWohnung extends StatefulWidget {
  String anlagenName = "";
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

  nWohnung(
      {Key? key,
      required this.anlagenName,
      required this.bewertung,
      required this.von,
      required this.bis,
      required this.tokenP,
      required this.text,
      required this.eurpP,
      required this.land,
      required this.ort,
      required this.pLZ,
      required this.strasse,
      required this.hausNr,
      required this.wohnflaeche,
      required this.zimmer,
      required this.betten,
      required this.baeder,
      required this.wlan,
      required this.garten,
      required this.balkon})
      : super(key: key);
  @override
  _nWohnungState createState() => _nWohnungState();
}

class _nWohnungState extends State<nWohnung> {
  var Containerh = 40.0;
  var Containerw = 400.0;
  var ContentWFactor = 0.5;
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
                  child: Image(image: AssetImage("images/beach.jpg")),
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
                    child: Text("Bieten"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Land"),
                    Text("Ort"),
                    Text("PLZ"),
                    Text("Straße"),
                    Text("HausNR"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Wohnfläche: "),
                    Text("Zimmer: "),
                    Text("Betten: "),
                    Text("Bäder: "),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: Text(
                    'Beschreibungstext',
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
                        Text("W-Lan")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(value: false, onChanged: (bool? val) {}),
                        Text("Garten")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(value: false, onChanged: (bool? val) {}),
                        Text("Balkon")
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
