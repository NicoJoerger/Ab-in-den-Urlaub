import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';

import 'appBars.dart';

class nWohnung extends StatefulWidget {
  nWohnung({Key? key}) : super(key: key);
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
