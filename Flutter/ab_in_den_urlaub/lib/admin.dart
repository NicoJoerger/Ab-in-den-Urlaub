//tokenpreis änder
//wohnungen und Angebote sperren
//Bewertungen löschen
import 'dart:collection';
import 'dart:typed_data';
import 'globals.dart';
import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'appBars.dart';

// wohnung deaktivieren, user deaktivieren, kommentare löschen
class User {
  const User(this.id, this.name);

  final String name;
  final int id;
}

class Wohnung {
  const Wohnung(this.id, this.name);

  final String name;
  final int id;
}

class Kommentar {
  const Kommentar(this.id, this.name);

  final String name;
  final int id;
}

class Admin extends StatefulWidget {
  Admin({Key? key}) : super(key: key);
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List<String> wohnungen2 = ['Wähle']; // Option 2
  String _selectedLocation = "Wähle";
  User selectedUser = User(0, "0");
  User user1 = User(0, "wählen");
  List<User> users = <User>[];

  Wohnung selectedWohnung = Wohnung(0, "0");
  Wohnung wohnung1 = Wohnung(0, "wählen");
  List<Wohnung> wohnungen = <Wohnung>[];

  Kommentar selectedKommentar = Kommentar(0, "0");
  Kommentar kommentar1 = Kommentar(0, "wählen");
  List<Kommentar> kommentare = <Kommentar>[];

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Image test = Image(image: AssetImage("images/hallstatt.jpg"));
  String url = LoginInfo.serverIP + '/api/Nutzer';
  var jsons = [];
  var response;
  var jsonsComment = [];
  var userByID = [];
  void fetchUser() async {
    try {
      response = await http.get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        jsons = jsonData;
        for (var i = 0; i < jsons.length; i++) {
          users.add(User(jsons[i]["userId"], jsons[i]["username"]));
        }
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchKommentare() async {
    try {
      response =
          await http.get(Uri.parse(LoginInfo.serverIP + "/api/Bewertung"));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        jsons = jsonData;
        for (var i = 0; i < jsons.length; i++) {
          kommentare
              .add(Kommentar(jsons[i]["bewertungId"], jsons[i]["kommentar"]));
        }
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void deleteComment() async {
    try {
      response = await http.delete(Uri.parse(LoginInfo.serverIP +
          "/api/Bewertung?id=" +
          selectedKommentar.id.toString()));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        jsons = jsonData;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchWohnungen() async {
    try {
      response =
          await http.get(Uri.parse(LoginInfo.serverIP + "/api/Ferienwohnung"));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        jsons = jsonData;
        for (var i = 0; i < jsons.length; i++) {
          wohnungen.add(Wohnung(jsons[i]["fwId"], jsons[i]["wohnungsname"]));
        }
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchImage() async {
    String urlImg = LoginInfo.serverIP + '/api/Bilder';
    try {
      response = await http.get(Uri.parse(urlImg));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        jsons = jsonData;
        print("imageresponse: " + jsonData.toString());
        test = imageFromBase64String(jsons[1]['bild']);
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void fetchUserById(String id) async {
    /*  String urlUsr = LoginInfo.serverIP + "/api/Nutzer/" + id;
    try {
      response = await http.get(Uri.parse(urlUsr));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        userByID = jsonData;
      });
    } catch (err) {
      print(err.toString());
    }*/
  }

  void fetchComment(var fwID) async {
    String urlComment =
        LoginInfo.serverIP + '/api/Bewertung/' + fwID.toString() + '/fw';
    try {
      response = await http.get(Uri.parse(urlComment));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        jsonsComment = jsonData;
        // print(jsonsComment);
        var jsonTemp = [];
        for (var i = 0; i < jsonsComment.length; i++) {
          jsonTemp = jsonData.elementAt(i);
          //fetchUserById(jsonsComment[i]["userId"].toString());
          //print(jsonTemp);
        }
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void postUser() async {
    try {
      response = await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      }, body: """ {
    "username": "niggotesterino",
    "nachname": "dsauhdiuashidushaiud",
    "vorname": "asdoiuhasiudshaiudhiuhciuewhbc",
    "password": "siauvbiushvruivbdiubvdiuvb",
    "email": "ascuiadshvieruvh349uhv9835hv9r",
    "tokenstand": 0,
    "vermieter": false,
    "admin": true
  }""");

      /**
           * (<String, String>{
            'username': "BastianDerlappen!1",
            "nachname": "dhfbdsuhzbu",
            "vorname": "asdhiabsdhua",
            "password": "asdhasbdhuasbdu",
            "email": "emailtest",
            "tokenstand": 0.toString(),
            "vermieter": false.toString(),
            "bewertungs": "[]",
            "ferienwohnungs": "[]",
            "gebots": "[]",
            "kreditkartendatens": "[]",
            "rechnungshistorieeintrags": "[]"
          })
           */
      //final jsonData = jsonDecode(response.body) as List;
      //setState(() {
      //  jsons = jsonData;
      //});
      print(response.body);
    } catch (err) {
      print(err.toString());
    }
  }

  void httpget() async {
    var response;
    try {
      response = await http.get(Uri.parse(url));
      final jsonData = jsonDecode(response.body);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: Text("test"), //response.body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (err) {}

    //print('Response status: ${response.statusCode}');
  }

  @override
  void initState() {
    // TODO: implement initState
    selectedUser = user1;
    users.add(selectedUser);

    selectedWohnung = wohnung1;
    wohnungen.add(selectedWohnung);

    selectedKommentar = kommentar1;
    kommentare.add(selectedKommentar);

    super.initState();
    fetchUser();
    fetchWohnungen();
    fetchKommentare();
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
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("User deaktiviere"),
                DropdownButton<User>(
                  value: selectedUser,
                  onChanged: (User? newValue) {
                    setState(() {
                      selectedUser = newValue!;
                    });
                  },
                  items: users.map((User user) {
                    return DropdownMenuItem<User>(
                      value: user,
                      child: Text(
                        user.name,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                //ElevatedButton(onPressed: (), child: Text("deaktivieren"))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Wohnung deaktiviere"),
                DropdownButton<Wohnung>(
                  value: selectedWohnung,
                  onChanged: (Wohnung? newValue) {
                    setState(() {
                      selectedWohnung = newValue!;
                    });
                  },
                  items: wohnungen.map((Wohnung wohnung) {
                    return DropdownMenuItem<Wohnung>(
                      value: wohnung,
                      child: Text(
                        wohnung.name,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                // ElevatedButton(onPressed: (), child: Text("deaktivieren"))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Kommentar löschen"),
                DropdownButton<Kommentar>(
                  value: selectedKommentar,
                  onChanged: (Kommentar? newValue) {
                    setState(() {
                      selectedKommentar = newValue!;
                    });
                  },
                  items: kommentare.map((Kommentar kommentar) {
                    return DropdownMenuItem<Kommentar>(
                      value: kommentar,
                      child: Text(
                        kommentar.name,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                    onPressed: () {
                      deleteComment();
                      kommentare = <Kommentar>[];
                      selectedKommentar = kommentar1;
                      kommentare.add(selectedKommentar);
                      fetchKommentare();
                    },
                    child: Text("deaktivieren"))
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
