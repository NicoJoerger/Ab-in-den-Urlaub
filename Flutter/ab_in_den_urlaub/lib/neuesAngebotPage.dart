import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'globals.dart';
import 'dart:html';
import 'appBars.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class nAngebot extends StatefulWidget {
  nAngebot({Key? key}) : super(key: key);
  @override
  _nAngebotState createState() => _nAngebotState();
}

class _nAngebotState extends State<nAngebot> {
  var Containerh = 40.0;
  var Containerw = 400.0;
  var ContentWFactor = 0.2;
  String dropdownValue = 'One';
  List<String> wohnungen2 = ['Wähle']; // Option 2
  String _selectedLocation = "Wähle";
  DateTime selectedRBeginn = DateTime.now();
  DateTime selectedABeginn = DateTime.now();
  DateTime selectedREnde = DateTime.now();
  DateTime selectedAEnde = DateTime.now();

  void loadCookies() async {
    LoginInfo().userid = int.parse(window.localStorage['userId'].toString());
    LoginInfo().currentAngebot = window.localStorage['angebotID'].toString();
    LoginInfo().tokens =
        int.parse(window.localStorage['tokenstand'].toString());
  }

  Future<void> selectRBeginn(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedRBeginn,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedRBeginn) {
      setState(() {
        print(picked.toString());
        selectedRBeginn = picked;
      });
    }
  }

  Future<void> selectABeginn(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedABeginn,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedABeginn) {
      setState(() {
        selectedABeginn = picked;
      });
    }
  }

  Future<void> selectREnde(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedREnde,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedREnde) {
      setState(() {
        selectedREnde = picked;
      });
    }
  }

  Future<void> selectAEnde(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedAEnde,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedAEnde) {
      setState(() {
        selectedAEnde = picked;
      });
    }
  }

  Future<void> getUserWohnungen() async {
    try {
      print("HI Get Wohnungsname");
      var response = await http.get(Uri.parse(LoginInfo().serverIP +
          "/api/Ferienwohnung/" +
          LoginInfo().userid.toString() +
          "/user"));
      print("Wohnungsname get body: " + response.body);
      final jsonData = jsonDecode(response.body) as List;
      wohnungen2 = ['Wähle'];
      for (int i = 0; i < jsonData.length; i++) {
        print("jsonDataUserWohnungen[" +
            i.toString() +
            "].toString(): " +
            jsonData[i].toString());
        setState(() {
          wohnungen2.add(jsonData[i]["wohnungsname"]);
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  void initState() {
    getUserWohnungen();
    // TODO: implement initState
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
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                const Text(
                  "Wohnung",
                  style: TextStyle(fontSize: 30),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: Containerw,
                    child: const Text("Zu vermietende Wohnung"),
                  ),
                  SizedBox(
                    width: 200,
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
                  )
                ]),
                const Text(
                  "Reise",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: Containerh,
                  //width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Containerw,
                        child: Text("Reisebeginn: " +
                            "${selectedRBeginn.toLocal()}".split(' ')[0] +
                            "  "),
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => selectRBeginn(context),
                          child: const Text('Ändern'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Containerh,
                  //width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Containerw,
                        child: Text("Abreisetag: " +
                            "${selectedREnde.toLocal()}".split(' ')[0] +
                            "  "),
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => selectREnde(context),
                          child: const Text('Ändern'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Auktion",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: Containerh,
                  //width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Containerw,
                        child: Text("Auktionbeginn: " +
                            "${selectedABeginn.toLocal()}".split(' ')[0] +
                            "  "),
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => selectABeginn(context),
                          child: const Text('Ändern'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Containerh,
                  //width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Containerw,
                        child: Text("Auktionsende: " +
                            "${selectedAEnde.toLocal()}".split(' ')[0] +
                            "  "),
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => selectAEnde(context),
                          child: const Text('Ändern'),
                        ),
                      ),
                    ],
                  ),
                ),
                Text("stonierbar")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
