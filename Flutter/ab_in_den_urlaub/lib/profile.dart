import 'package:ab_in_den_urlaub/Angebot.dart';
import 'package:ab_in_den_urlaub/admin.dart';
import 'package:ab_in_den_urlaub/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'appBars.dart';
import 'globals.dart';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

bool admin = false;

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class adminButton extends StatelessWidget {
  const adminButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (admin == true) {
      return TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Admin()));
          },
          child: Text("Admin"));
    } else {
      return Container();
    }
  }
}

class _ProfileState extends State<Profile> {
  String url = LoginInfo.serverIP + '/api/Nutzer';
  var rechnungshistorie = [];
  var angebote = [];
  var wohnungen = [];
  List<String> wohnungen2 = ['Wähle']; // Option 2
  String _selectedLocation = "Wähle";
  var userData = [];
  var response;
  var Texth = 40.0;
  var Textw = 400.0;
  final emailRegCon = TextEditingController();
  final passRegCon = TextEditingController();
  final passRegCon2 = TextEditingController();
  final creditCon = TextEditingController();
  final cvvCon = TextEditingController();
  final usernameCon = TextEditingController();
  final nachnameCon = TextEditingController();
  final vornameCon = TextEditingController();

  // evaluation
  bool vermieter = false;
  int countStarts = -1;
  final countStarsController = TextEditingController();
  final commentController = TextEditingController();

  String dropdownValue = 'Wähle Wohnung';

  void fuckyouasynchron() async {
    await fetchHistory();
    vermieter = await getUserVermieterStatus();

    for (int i = 0; i < rechnungshistorie.length; i++) {
      //print("rechnungshistorie[" +
      //    i.toString() +
      //    "].toString(): " +
      //    rechnungshistorie[i].toString());
    }
    //print("\n");

    for (int i = 0; i < rechnungshistorie.length; i++) {
      final json = rechnungshistorie[i];
      //print("i before fetchOffer: " + i.toString());
      //print("json[angebotId].toString(): " + json["angebotId"].toString());
      await fetchOffer(json["angebotId"].toString());
      //print("i after fetchOffer: " + i.toString());
      //print("\n");
    }

    //print("we got here");

    for (int i = 0; i < angebote.length; i++) {
      //print("angebote[" + i.toString() + "]: " + angebote[i].toString());
    }

    //print("\n");

    for (int i = 0; i < angebote.length; i++) {
      final json = angebote[i];
      //print("json[fwId].toString(): " + json["fwId"].toString());
      await fetchApartment(json["fwId"].toString());
    }

    //print("\n");

    for (int i = 0; i < wohnungen.length; i++) {
      //print("wohnungen[" + i.toString() + "]: " + wohnungen[i].toString());

    }
  }

  Future<void> getUserWohnungen() async {
    try {
      //print("HI Get Wohnungsname");
      response = await http.get(Uri.parse(LoginInfo.serverIP +
          "/api/Ferienwohnung/" +
          LoginInfo.userid.toString() +
          "/user"));
      //print("Wohnungsname get body: " + response.body);
      final jsonData = jsonDecode(response.body) as List;
      wohnungen2 = ['Wähle'];
      for (int i = 0; i < jsonData.length; i++) {
        //print("jsonDataUserWohnungen[" +
        //    i.toString() +
        //    "].toString(): " +
        //    jsonData[i].toString());
        //print(jsonData[i]["deaktiviert"]);
        if (!jsonData[i]["deaktiviert"]) {
          setState(() {
            wohnungen2.add(jsonData[i]["wohnungsname"]);
          });
        }
      }

      for (int i = 0; i < jsonData.length; i++) {
        print("jsonDataUserWohnungen[" +
            i.toString() +
            "].toString(): " +
            jsonData[i].toString());
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> fetchHistory() async {
    angebote = [];
    wohnungen = [];
    try {
      response = await http.get(Uri.parse(LoginInfo.serverIP +
          "/api/Rechnungshistorieeintrag/" +
          LoginInfo.userid.toString()));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        rechnungshistorie = jsonData;
      });
    } catch (err) {
      //print(err.toString());
    }
  }

  Future<void> fetchOffer(String id) async {
    //print(LoginInfo.serverIP + "/api/Angebote/" + id + "/a");
    try {
      response = await http
          .get(Uri.parse(LoginInfo.serverIP + "/api/Angebote/" + id + "/a"));
      //print("test1");
      final jsonData = jsonDecode(response.body) as List;
      //print("test2");
      setState(() {
        angebote.add(jsonData[0]);
      });
      //print("test3");
    } catch (err) {
      //print(err.toString());
    }
  }

  Future<void> fetchApartment(String id) async {
    try {
      //print("json[fwId].toString(): " + id);
      response = await http
          .get(Uri.parse(LoginInfo.serverIP + '/api/Ferienwohnung/' + id));
      //print("response body in fetchapartment: " + response.body);
      final jsonData = jsonDecode(response.body);

      //print("wohnung hinzugefügt: " + jsonData.toString());
      setState(() {
        wohnungen.add(jsonData["wohnungsname"]);
      });
    } catch (err) {
      //print(err.toString());
    }
  }

  void fetchUser() async {
    try {
      response = await http.get(Uri.parse(
          LoginInfo.serverIP + '/api/Nutzer/' + LoginInfo.userid.toString()));
      final jsonData = jsonDecode(response.body);
      setState(() {
        userData.add(jsonData);
      });
      //print("userData[0]: " + userData[0].toString());
      usernameCon.text = userData[0]["username"].toString();
      nachnameCon.text = userData[0]["nachname"].toString();
      vornameCon.text = userData[0]["vorname"].toString();
      passRegCon.text = userData[0]["password"].toString();
      passRegCon2.text = userData[0]["password"].toString();
      emailRegCon.text = userData[0]["email"].toString();
      admin = userData[0]["admin"];
    } catch (err) {
      print(err.toString());
    }

    try {
      response = await http.get(Uri.parse(LoginInfo.serverIP +
          '/api/Kreditkartendaten/' +
          LoginInfo.userid.toString()));
      final jsonData = jsonDecode(response.body);
      setState(() {
        userData.add(jsonData);
      });
      //print("userData[1]: " + userData[1].toString());
      creditCon.text = userData[1]["kartennummer"].toString();
      cvvCon.text = userData[1]["cvv"].toString();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> _showWohnungInputDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Maximale Tokenkosten'),
          content: SingleChildScrollView(
            child: DropdownButton<String>(
              dropdownColor: Colors.blue,
              value: _selectedLocation,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLocation = newValue!;
                });
              },
              items: wohnungen2.map((location) {
                return DropdownMenuItem(
                  child: Text(location),
                  value: location,
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Bestätigen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void cookies() async {
    LoginInfo.userid = int.parse(window.localStorage['userId'].toString());
    LoginInfo.currentAngebot = window.localStorage['angebotID'].toString();
    LoginInfo.tokens = int.parse(window.localStorage['tokenstand'].toString());
    window.localStorage.containsKey('userId');
    window.localStorage.containsKey('tokenstand');
    window.localStorage.containsKey('angebotID');

    window.localStorage['userId'] = LoginInfo.userid.toString();
    LoginInfo.loadToken();
    window.localStorage['tokenstand'] = LoginInfo.tokens.toString();
  }

  void postUser() async {
    print("userData: " + userData[0].toString());

    if (passRegCon.text == passRegCon2.text) {
      try {
        String body = """{"userId": """ +
            userData[0]["userId"].toString() +
            """, "username": \"""" +
            usernameCon.text +
            """\", "nachname": \"""" +
            nachnameCon.text +
            """\", "password": \"""" +
            passRegCon.text +
            """\", "email": \"""" +
            emailRegCon.text +
            """\", "vorname": \"""" +
            vornameCon.text +
            """\", "vermieter": null, "tokenstand": \"""" +
            LoginInfo.tokens.toString() +
            """\", 
"admin": null, 
"lastbuy": "2022-06-25T15:03:53.769806",
"deaktiviert": false, 
"bewertungs": [], 
"ferienwohnungs": [], 
"gebots": [], 
"kreditkartendatens": [],
"rechnungshistorieeintrags": []} """;
        userData[0]["username"] = usernameCon.text;
        userData[0]["nachname"] = nachnameCon.text;
        userData[0]["vorname"] = vornameCon.text;
        userData[0]["password"] = passRegCon.text;
        userData[0]["email"] = emailRegCon.text;
        userData[0]["tokenstand"] = LoginInfo.tokens.toString();
        print("New userData: " + body);
        response = await http.put(Uri.parse(LoginInfo.serverIP + "/api/Nutzer"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: body);
        if (response.statusCode == 200) {
          //LoginInfo.tokens = startToken;
          Navigator.pushNamed(context, '/Profile');
        } else if (response.statusCode == 400) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Registrierung Fehlgeschlagen1'),
              content: Text(response.body),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
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
        //print(response.body);
      } catch (err) {
        //print(err.toString());
      }
    } else {
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
    }
  }

  @override
  void initState() {
    print("initState() entered.\n");
    getUserWohnungen();
    fetchUser();
    // TODO: implement initState
    fuckyouasynchron();

    super.initState();
    //print("initState() exited.\n");
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
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Visibility(
                  visible: vermieter,
                  child: Container(
                    height: 50,
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/nAngebot'),
                          child: const Text('Neues Angebot erstellen'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              {Navigator.pushNamed(context, '/nWohnung')},
                          child: const Text('Neue Wohnung anlegen'),
                        ),
                        Row(children: [
                          DropdownButton<String>(
                            dropdownColor: Colors.blue,
                            value: _selectedLocation,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedLocation = newValue!;
                              });
                            },
                            items: wohnungen2.map((location) {
                              return DropdownMenuItem(
                                child: Text(location),
                                value: location,
                              );
                            }).toList(),
                          ),
                          Container(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () => _showWohnungInputDialog,
                            child: const Text('Wohnung löschen'),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: Textw,
                  height: Texth,
                  child:
                      Text("Profil bearbeiten", style: TextStyle(fontSize: 30)),
                ),
                const SizedBox(height: 10),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    controller: usernameCon,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    controller: nachnameCon,
                    decoration: InputDecoration(
                      labelText: 'Nachname',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    controller: vornameCon,
                    decoration: InputDecoration(
                      labelText: 'Vorname',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    controller: emailRegCon,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    obscureText: true,
                    controller: passRegCon,
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                    ),
                  ),
                ),
                Container(
                  width: Textw,
                  height: Texth,
                  child: TextField(
                    obscureText: true,
                    controller: passRegCon2,
                    decoration: InputDecoration(
                      labelText: 'Passwort wiederholen',
                    ),
                  ),
                ),
                /*Container(
                  width: Textw,
                  height: Texth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Textw / 2,
                        child: TextField(
                          controller: creditCon,
                          decoration: InputDecoration(
                            labelText: 'Kreditkartennummer',
                          ),
                        ),
                      ),
                      Container(
                        width: Textw / 5,
                        child: TextField(
                          controller: cvvCon,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                          ),
                        ),
                      ),
                      Container(
                        width: Textw / 4,
                        height: Texth,
                        child: TextButton(
                            onPressed: () {
                              postUser();
                            },
                            child: Text("Speichern")),
                      ),
                    ],
                  ),
                ),*/
                Container(
                  width: Textw / 4,
                  height: Texth,
                  child: TextButton(
                      onPressed: () {
                        postUser();
                      },
                      child: Text("Speichern")),
                ),
                // checkbox vermieter true/false
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: vermieter,
                        onChanged: (val) {
                          setState(() {
                            LoginInfo.vermieter = val!;
                            vermieter = val;
                            setUserToVermieter();
                          });
                        }),
                    Text("Ich möchte Wohnungen vermieten.")
                  ],
                ),
                adminButton(),
                TextButton(
                    onPressed: () => {
                          window.localStorage.containsKey('userId'),
                          window.localStorage.containsKey('tokenstand'),
                          window.localStorage.containsKey('angebotID'),
                          window.localStorage['userId'] = "-1",
                          window.localStorage['tokenstand'] = "0",
                          LoginInfo.userid = -1,
                          LoginInfo.currentAngebot = "0",
                          LoginInfo.tokens = 0,
                          Navigator.pushNamed(context, '/registrierung')
                        },
                    child: Text("Logout")),
                const SizedBox(height: 10),
                Text(
                  "Rechnungshistorie:",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: Text("Wohnungsname"),
                      ),
                      Container(
                        width: 150,
                        child: Text("Auktionsende"),
                      ),
                      Container(
                        width: 150,
                        child: Text("Mietzeitraum Anfang"),
                      ),
                      Container(
                        width: 150,
                        child: Text("Mietzeitraum Ende"),
                      ),
                      Container(
                        width: 150,
                        child: Text("Preis"),
                      ),
                      Container(
                        width: 150,
                        child: Text("Tokenpreis"),
                      ),
                      Container(
                        width: 150,
                        child: Text('Bewerteng'),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ListView.builder(
                    itemCount: wohnungen.length,
                    itemBuilder: (context, i) {
                      if (angebote.isNotEmpty && wohnungen.isNotEmpty) {
                        //print("Angebote werden angezeigt.\n");
                        final json = angebote[i];
                        final wohnung = wohnungen[i];

                        //print("wohnungen[" + i.toString() + "]: " + wohnungen[i].toString());

                        return GestureDetector(
                          onTap: () => {
                            window.localStorage['angebotID'] =
                                json["angebotId"].toString(),
                            Navigator.pushNamed(
                              context,
                              '/apartmentDetail',
                            )
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 150,
                                  child: Text(wohnungen[i].toString()),
                                ),
                                Container(
                                  width: 150,
                                  child: Text(json["auktionEnddatum"]
                                      .toString()
                                      .substring(
                                          0,
                                          json["auktionEnddatum"]
                                                  .toString()
                                                  .length -
                                              9)),
                                ),
                                Container(
                                  width: 150,
                                  child: Text(json["mietzeitraumStart"]
                                      .toString()
                                      .substring(
                                          0,
                                          json["mietzeitraumStart"]
                                                  .toString()
                                                  .length -
                                              9)),
                                ),
                                Container(
                                  width: 150,
                                  child: Text(json["mietzeitraumEnde"]
                                      .toString()
                                      .substring(
                                          0,
                                          json["mietzeitraumEnde"]
                                                  .toString()
                                                  .length -
                                              9)),
                                ),
                                Container(
                                  width: 150,
                                  child:
                                      Text(json["mietpreis"].toString() + "€"),
                                ),
                                Container(
                                  width: 150,
                                  child: Text(
                                      json["aktuellerTokenpreis"].toString()),
                                ),
                                Container(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        evaluationDialog(context, json['fwId']),
                                    child: const Text('Bewerten'),
                                  ),
                                )
                              ]),
                        );
                      } else {
                        return GestureDetector();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: LoginInfo.vermieter,
                  child: Column(
                    children: [
                      Text(
                        "Laufende Auktionen:",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              child: Text("Vermieter"),
                            ),
                            Container(
                              width: 150,
                              child: Text("Auktionsende"),
                            ),
                            Container(
                              width: 150,
                              child: Text("Angebotsname"),
                            ),
                            Container(
                              width: 150,
                              child: Text(""),
                            ),
                            Container(
                              width: 150,
                              child: Text(""),
                            ),
                            Container(
                              width: 150,
                              child: Text(""),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setUserToVermieter() async {
    // fetch user
    String get_user_url = LoginInfo.serverIP + '/api/Nutzer/';
    String put_user_url = LoginInfo.serverIP + '/api/Nutzer';
    String get_user_userId = LoginInfo.userid.toString();
    var response_get =
        await http.get(Uri.parse(get_user_url + get_user_userId));

    if (response.statusCode != 200) {
      // http call /api/user/{id} didn't worked
    } else {
      // http call /api/user/{id} worked
      final jsonData = jsonDecode(response_get.body);

      // set vermieter status
      jsonData['vermieter'] = vermieter;

      var response_put = await http.put(Uri.parse(put_user_url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(jsonData));
    }
  }

  Future<bool> getUserVermieterStatus() async {
    // fetch user
    String url =
        LoginInfo.serverIP + '/api/Nutzer/' + LoginInfo.userid.toString();

    // run Querry
    var responseUserIDQuery = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    // return user vermmieter
    return jsonDecode(responseUserIDQuery.body)['vermieter'];
  }

  void evaluationDialog(context, int fwId) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('neue Bewertung abgeben')),
        actions: <Widget>[
          Container(
            //width: MediaQuery.of(context).size.width * 0.3,   // fix later oleg
            //height: MediaQuery.of(context).size.height * 0.3, // fix later oleg

            alignment: Alignment.center,
            child: Column(
              children: [
                const Text('Geben sie ihren Kommentar ein.:'),
                Container(height: 5),
                TextField(
                  controller: commentController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 3,
                  maxLines: 8,
                ),
                Container(height: 10),
                const Text('Anz Sterne (0-5) eingben:'),
                Container(height: 5),
                TextField(
                  controller: countStarsController,

                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-5]'))
                  ], // Only numbers can be e
                ),
                Container(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      //
                      onPressed: () => addReview(fwId),
                      child: const Text('Abgeben'),
                    ),
                    TextButton(
                      // send Comment
                      onPressed: () => Navigator.pop(context, 'Nicht Abgeben'),
                      child: const Text('Nicht Abgeben'),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> addReview(int fwId) async {
    Navigator.pop(context, 'Abgeben'); // close Dialog

    //print('\nADD Review\n');           // check

    String url = LoginInfo.serverIP + '/api/Bewertung';

    // post review
    final postOfferResponse = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: buildEvaluationString(fwId));

    if (postOfferResponse.statusCode == 200) {
      print('\nReview posted succesfilly\n');
    }
  }

  String buildEvaluationString(int fwId) {
    String evaluationPostQuery = jsonEncode(<String, Object>{
      "userId": LoginInfo.userid, // user id
      "fwId": fwId, // id of the fw
      "anzsterne": int.parse(countStarsController.text),
      "kommentar": commentController.text,
    });

    return evaluationPostQuery;
  }
}
