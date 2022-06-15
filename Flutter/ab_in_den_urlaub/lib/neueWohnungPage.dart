import 'dart:convert';

import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';
import 'dart:html';
import 'appBars.dart';

class nWohnung extends StatefulWidget {
  nWohnung({Key? key}) : super(key: key);
  @override
  _nWohnungState createState() => _nWohnungState();
}

Image image = Image(image: AssetImage("/images/Empty.png"));
List<Widget> Bilder = [];

class _nWohnungState extends State<nWohnung> {
  // vars
  var response;
  bool _checkbox_garden = false;
  bool _checkbox_balcony = false;
  bool _checkbox_wlan = false;
  var Containerh = 40.0;
  var Containerw = 400.0;
  var ContentWFactor = 0.5;
  final _address_location = new TextEditingController();
  final _address_street = new TextEditingController();
  final _address_housenumber = new TextEditingController();
  final description = new TextEditingController();
  final rooms = new TextEditingController();
  final area = new TextEditingController();
  final wohnungsname = new TextEditingController();
  final plz = new TextEditingController();
  final anzbaeder = new TextEditingController();
  final betten = new TextEditingController();
  var wgbId = [];
  var fwId;

  void postWohnungsBilder() async {
    try {
      for (var i = 0; i < Bilder.length; i++) {
        response = await http.post(
            Uri.parse(LoginInfo().serverIP + "/api/Wohnungsbilder"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: """ {
    "fwId": """ +
                fwId.toString() +
                """ } """);
        print(response.statusCode);
        final jsonData = jsonDecode(response.body);

        print("basti");

        print(jsonData);
        wgbId.add(jsonData["wgbId"]);
        print("mazze");
      }
      print(Bilder.length.toString());
      for (var i = 0; i < Bilder.length; i++) {
        print("try leude");
        response = await http.put(Uri.parse(LoginInfo().serverIP +
            "/api/Wohnungsbilder/" +
            wgbId[i].toString()));
        print("moin max hier");
      }

      if (response.statusCode == 200) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registrierung Erfolgreich'),
            content: Text('Danke für das Registrieren Ihrer Wohnung.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        //LoginInfo().tokens = startToken;
        //Navigator.pushNamed(context, '/Profile');
      } /*else if (response.statusCode == 400) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registrierung Fehlgeschlagen'),
            content: Text(response.body),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }*/
      else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registrierung Fehlgeschlagen'),
            content: Text('Fehler'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      print(response.body);
    } catch (err) {
      print(err.toString());
    }
  }

  void postWohnung() async {
    String body = """ {
    "userId": """ +
        LoginInfo().userid.toString() +
        """,
    "strasse": \"""" +
        _address_street.text +
        """\",
    "hausnummer": """ +
        _address_housenumber.text +
        """,
    "ort": \"""" +
        _address_location.text +
        """\",
    "plz": """ +
        plz.text +
        """,
    "wohnflaeche": """ +
        area.text +
        """,
    "anzzimmer": """ +
        rooms.text +
        """,
    "anzbetten": """ +
        betten.text +
        """,
    "anzbaeder": """ +
        anzbaeder.text +
        """,
    "wifi": """ +
        _checkbox_wlan.toString() +
        """,
    "garten": """ +
        _checkbox_garden.toString() +
        """,
    "balkon": """ +
        _checkbox_balcony.toString() +
        """,                
    "beschreibung": \"""" +
        description.text +
        """\",                
    "wohnungsname": \"""" +
        wohnungsname.text +
        """\",    
    "land": \"""" +
        _selected_country +
        """\",
    "deaktiviert": """ +
        "false" +
        """  
  }""";
    try {
      response = await http.post(
          Uri.parse(LoginInfo().serverIP + "/api/Ferienwohnung"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        fwId = jsonData["fwId"];
        postWohnungsBilder();
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registrierung Erfolgreich'),
            content: Text('Danke für das Registrieren Ihrer Wohnung.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        //LoginInfo().tokens = startToken;
        //Navigator.pushNamed(context, '/Profile');
      } /*else if (response.statusCode == 400) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registrierung Fehlgeschlagen'),
            content: Text(response.body),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }*/
      else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registrierung Fehlgeschlagen'),
            content: Text('Fehler'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      print(response.body);
    } catch (err) {
      print(err.toString());
    }
  } /*else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Registrierung Fehlgeschlagen'),
          content: Text('Passwörter stimmen nicht überein.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });*/

  void loadCookies() async {
    LoginInfo().userid = int.parse(window.localStorage['userId'].toString());
    LoginInfo().currentAngebot = window.localStorage['angebotID'].toString();
    LoginInfo().tokens =
        int.parse(window.localStorage['tokenstand'].toString());
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? Ximage = await _picker.pickImage(source: ImageSource.gallery);
    if (Ximage != null) {
      image = Image(image: XFileImage(Ximage));
      Bilder.add(image);
    }

    setState(() {});
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
                          controller: wohnungsname,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Name ihrer Wohnung',
                          ),
                        ),
                        TextFormField(
                          controller: _address_location,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Ort',
                          ),
                        ),
                        TextFormField(
                          controller: plz,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'PLZ',
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
                        Container(
                          child: ImageSlideshow(
                              width: 1000,
                              height: 500,
                              initialPage: 0,
                              children: Bilder),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () {
                              pickImage();
                            },
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
                            "Hier können Sie eine Beschreibung zu Ihrer Wohnung abgeben."),
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
                          controller: rooms,
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
                          controller: anzbaeder,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Anzahl Bäder',
                          ),
                        ),
                        TextFormField(
                          controller: betten,
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
                          controller: area,
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
                        postWohnung();

                        // when button is pressed
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
/*
  // push button ->
  void __send_registration_of_appartment() {
    print('\n');
    print("Land      : " + _selected_country);
    print("Ort       :  " + _address_location.text);
    print("Straße    : " + _address_street.text);
    print("Hausnummer: " + _address_housenumber.text);

    //post
    // registrierungseite kopieren
  }*/
}
