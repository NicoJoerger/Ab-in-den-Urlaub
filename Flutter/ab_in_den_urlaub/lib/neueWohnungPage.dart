import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals.dart';
import 'dart:html';
import 'appBars.dart';

class nWohnung extends StatefulWidget {
  nWohnung({Key? key}) : super(key: key);
  @override
  _nWohnungState createState() => _nWohnungState();
}

class _nWohnungState extends State<nWohnung> {
  // vars
  bool _checkbox_garden = false;
  bool _checkbox_balcony = false;
  bool _checkbox_wlan = false;
  var Containerh = 40.0;
  var Containerw = 400.0;
  var ContentWFactor = 0.5;

  void loadCookies() async {
    LoginInfo().userid = window.localStorage['userId'].toString();
    LoginInfo().currentAngebot = window.localStorage['angebotID'].toString();
    LoginInfo().tokens = window.localStorage['tokenstand'].toString();
  }

  final List<String> _address_countries_list = [
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
  ];
  String _selected_country = '';

  TextEditingController _address_location =
      new TextEditingController(); // address location    controller
  TextEditingController _address_street =
      new TextEditingController(); // address street      controller
  TextEditingController _address_housenumber =
      new TextEditingController(); // address housenumber controller

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
            // Säule Vertikal
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(height: 80), // vertical spacing

                  Text("Wohnung Registrieren", style: TextStyle(fontSize: 40)),

                  Container(height: 12), // vertical spacing

                  // address
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                      children: [
                        Text('Adresse', style: TextStyle(fontSize: 20)),
                        DropdownButton<String>(
                          hint: Text('Please choose a location'),
                          value: _selected_country = _address_countries_list[0],
                          onChanged: (newVal) {
                            setState(() {
                              _selected_country = newVal!;
                            });
                          },
                          items: _address_countries_list.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          controller: _address_location,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Ort',
                          ),
                        ),
                        TextFormField(
                          controller: _address_street,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Straße',
                          ),
                        ),
                        TextFormField(
                          controller: _address_housenumber,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Hausnummer',
                          ),
                        ),
                        Text('', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),

                  Container(height: 12), // vertical spacing

                  // pictures
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                      children: [
                        Text("Bilder", style: TextStyle(fontSize: 20)),
                        Image(image: AssetImage("images/beach.jpg")),
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
                            ],
                          ),
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
                      ],
                    ),
                  ),

                  Container(height: 12), // vertical spacing

                  // flat description
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                      children: [
                        Text('Beschreibung', style: TextStyle(fontSize: 20)),
                        Text(
                            "Hier kännen Sie eine Beschreibung zu Ihrer Wohnung abgeben."),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          minLines: 4,
                          maxLines: 10,
                        ),
                        Text('', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),

                  Container(height: 12), // vertical spacing

                  // other
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                      children: [
                        Text('Weitere Angaben', style: TextStyle(fontSize: 20)),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Anzahl Räume',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Anzahl Betten',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Anzahl Personen',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Wohnfläche in m2',
                          ),
                        ),
                        // garden checkbox
                        Container(
                          child: Row(
                            children: [
                              Text("Garten", style: TextStyle(fontSize: 20)),
                              Checkbox(
                                activeColor: Colors.orange,
                                checkColor: Colors.green,
                                value: _checkbox_garden,
                                onChanged: (value) {
                                  setState(() {
                                    _checkbox_garden = !_checkbox_garden;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        // balcony checkbox
                        Container(
                          child: Row(
                            children: [
                              Text("Balkon", style: TextStyle(fontSize: 20)),
                              Checkbox(
                                activeColor: Colors.orange,
                                checkColor: Colors.green,
                                value: _checkbox_balcony,
                                onChanged: (value) {
                                  setState(() {
                                    _checkbox_balcony = !_checkbox_balcony;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        // wlan checkbox
                        Container(
                          child: Row(
                            children: [
                              Text("WLAN", style: TextStyle(fontSize: 20)),
                              Checkbox(
                                activeColor: Colors.orange,
                                checkColor: Colors.green,
                                value: _checkbox_wlan,
                                onChanged: (value) {
                                  setState(() {
                                    _checkbox_wlan = !_checkbox_wlan;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Text('', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),

                  Container(height: 12), // vertical spacing

                  // send button
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.green,
                    child: OutlinedButton(
                      child: const Text('Wohnung registrieren',
                          style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        // when button is pressed
                        __send_registration_of_appartment();
                      },
                    ),
                  ),

                  Container(height: 80), // vertical spacing
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // push button ->
  void __send_registration_of_appartment() {
    print('\n');
    print("Land      : " + _selected_country);
    print("Ort       :  " + _address_location.text);
    print("Straße    : " + _address_street.text);
    print("Hausnummer: " + _address_housenumber.text);

    //post
    // registrierungseite kopieren
  }
}
