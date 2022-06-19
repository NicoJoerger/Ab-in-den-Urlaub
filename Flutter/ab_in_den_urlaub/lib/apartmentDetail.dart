import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String angebotID = "";
  var response;
  var jsons = [];
  List<Widget> bilder = [];
  var jsonOffer;
  var jsonApart;
  var fwID = "";
  String hochstbietender = "";
  String mietzeitraumStart = "";
  String mietzeitraumEnde = "";
  String beschreibung = "";
  String tokenpreis = "";
  String mietpreis = "";
  String strasse = "";
  String plz = "";
  String hausnummer = "";
  String ort = "";
  String URL = "";
  List<String> urls = [];
  String land = "";
  String anzBetten = "";
  String anzZimmer = "";
  String flaeche = "";
  String anzbaeder = "";
  String wName = "";
  bool wifi = false;
  bool garten = false;
  bool balkon = false;
  bool stornierbar = false;
  TextEditingController _controller = TextEditingController();
  final newBet = TextEditingController();

  // review
  // review data
  List<String> reviewList = [];
  List<int> countStarsList = [];
  List<String> usernameList = [];

  void postBet() async {
    String body = """ {
    "angebotId": """ +
        LoginInfo.currentAngebot +
        """,
    "userId": """ +
        LoginInfo.userid.toString() +
        """,
    "preis": """ +
        newBet.text +
        """

  }""";
    try {
      //if (int.parse(tokenpreis) > 100) {
      //if (int.parse(newBet.text) > int.parse(tokenpreis)) {
      response = await http.post(Uri.parse(LoginInfo.serverIP + "/api/Gebot"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: body);
      // print(response.body);

      if (response.statusCode == 200) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Bieten Erfolgreich'),
            content: Text('Danke für das bieten auf eine Wohnung.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        setState(() {
          tokenpreis = newBet.text;
        });
      } else if (response.body == "User hat nicht genug Token") {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Bieten Fehlgeschlagen'),
            content: Text('Sie haben nicht genug Tokens.'),
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
            title: const Text('Bieten Fehlgeschlagen'),
            content: Text(
                'Sie müssen das aktuelle Gebot überbieten. (Gegegebenfalls Seite neu laden)'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }

      fetchGebot();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> _showTokenInputDialog() async {
    //
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Wieviele Tokens wollen Sie bieten?'),
              content: const Text('AlertDialog description'),
              actions: <Widget>[
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: const Text('Show Dialog'),
        );
      },
    );
  }

  Future<void> fetchOffer() async {
    //print("ID: " + angebotID);
    String urlOffer = LoginInfo.serverIP +
        '/api/Angebote/' +
        LoginInfo.currentAngebot +
        "/a";
    try {
      //print("test5");
      response = await http.get(Uri.parse(urlOffer));
      jsonOffer = jsonDecode(response.body);
      fwID = jsonOffer[0]["fwId"].toString();
      //print("json Offer: " + jsonOffer[0].toString() + "\n");
      var von = jsonOffer[0]["mietzeitraumStart"];
      var bis = jsonOffer[0]["mietzeitraumEnde"];
      //print("nach");
      von = DateTime.parse(von);
      bis = DateTime.parse(bis);
      setState(() {
        mietzeitraumStart = "" +
            von.day.toString() +
            "." +
            von.month.toString() +
            "." +
            von.year.toString() +
            " ";
        mietzeitraumEnde = "" +
            bis.day.toString() +
            "." +
            bis.month.toString() +
            "." +
            bis.year.toString();
        tokenpreis = jsonOffer[0]["aktuellerTokenpreis"].toString();
        mietpreis = jsonOffer[0]["mietpreis"].toString();
        stornierbar = jsonOffer[0]["stornierbar"];
      });
      //print("von: " + mietzeitraumStart + " bis: " + mietzeitraumEnde+ "\n");
      //print("jsonDataAngebot: " + jsonOffer.toString() + "\n");
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> fetchApartment() async {
    String urlApart =
        LoginInfo.serverIP + "/api/Ferienwohnung/" + fwID.toString();
    try {
      response = await http.get(Uri.parse(urlApart));
      jsonApart = jsonDecode(response.body);
      //print("Wohnung: " + jsonApart.toString());
      setState(() {
        strasse = jsonApart["strasse"].toString();
        plz = jsonApart["plz"].toString();
        hausnummer = jsonApart["hausnummer"].toString();
        ort = jsonApart["ort"].toString();
        land = jsonApart["land"].toString();
        anzBetten = jsonApart["anzbetten"].toString();
        anzZimmer = jsonApart["anzzimmer"].toString();
        flaeche = jsonApart["wohnflaeche"].toString();
        anzbaeder = jsonApart["anzbaeder"].toString();
        wifi = jsonApart["wifi"];
        garten = jsonApart["garten"];
        balkon = jsonApart["balkon"];
        beschreibung = jsonApart["beschreibung"].toString();
        wName = jsonApart["wohnungsname"].toString();
        URL = jsonApart["bilderLinks"].toString();
      });
      beschreibung = jsonApart["beschreibung"].toString();
      _controller = TextEditingController(text: beschreibung);
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> fetchGebot() async {
    String urlImg = LoginInfo.serverIP +
        '/api/Gebot/' +
        LoginInfo.currentAngebot +
        '/a';
    try {
      response = await http.get(Uri.parse(urlImg));
      jsons = jsonDecode(response.body);
      String userId = jsons[0]["userId"].toString();
      if (userId == LoginInfo.userid.toString()) {
        setState(() {
          hochstbietender = "Sie sind aktuell Höchstbietender";
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> loadCookies() async {
    String userIDString = window.localStorage['userId'].toString();
    String tokenString = window.localStorage['tokenstand'].toString();
    LoginInfo.userid = int.parse(userIDString);
    LoginInfo.currentAngebot = window.localStorage['angebotID'].toString();
    angebotID = window.localStorage['angebotID'].toString();
    //print("\n\nAngebotID = " + LoginInfo.currentAngebot.toString());
    //print(tokenString + userIDString);
    LoginInfo.tokens = int.parse(tokenString);
  }

  Future<void> fetchImage() async {
    print("HOLE BILD");
    //print("ID:" + widget.anlagenID);
    /*String urlImg = LoginInfo.serverIP + '/api/Wohnungsbilder/' + fwID;
    try {
      response = await http.get(Uri.parse(urlImg));
      jsons = jsonDecode(response.body) as List;
      //print("lange: " + jsons.length.toString());
      setState(() {
        for (int i = 0; i < (jsons.length); i++) {
          Image image = imageFromBase64String(jsons[i]["bild"]);
          print("test");
          bilder.add(image);
        }
      });
    } catch (err) {
      print(err.toString());
    }*/
    Image nBild;
    print("url:" + URL);
    urls = URL.split(";");
    for (int i = 0; i < urls.length - 1;i++) {
      urls[i] = urls[i].replaceAll(";", "");
      print("element: " +urls[i] );
      nBild = Image.network(urls[i]);
      bilder.add(nBild);
    }
    print("BILD GEHOLT");

    setState(() {
      
    });
  }

  Future<void> fetchReviewsAndUsername() async {
    print('\nSTART fetchReviewsAndUsername\n');

      // vars
      String urlReviews  = LoginInfo.serverIP + '/api/Bewertung';
      String urlUsername = LoginInfo.serverIP + '/api/Nutzer/';

    // fetch reviews
    final jsonAllReviws = await http.get(Uri.parse(urlReviews),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    // error message if reviews not got
    if (jsonAllReviws.statusCode != 200) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Reviews nicht erfolgreich geholt.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    // select reviews for this flat
    final reviews = jsonDecode(jsonAllReviws.body);

    for (dynamic review in reviews) {
      if (review['fwId'].toString() == fwID) {
        reviewList.add(review['kommentar']);
        countStarsList.add(review['anzsterne']);

        //print('\nreview');
        //print('\nrKomm'+review['kommentar'].toString());
        //print('\nrAnzS'+review['anzsterne'].toString());

        // fetch username

        final jsonUser = await http.get(
            Uri.parse(urlUsername + review['userId'].toString()),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            });

        final user = jsonDecode(jsonUser.body);

        // add username
        usernameList.add(user['username']);

        // error message if usersname not gotten
        if (jsonUser.statusCode != 200) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('User nicht erfolgreich geholt.'),
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
    }

    print('\nKommentare:\n');
    for (int i = 0; i < reviewList.length; i++) {
      print('user   :' + usernameList[i]);
      print('comment:' + reviewList[i]);
      print('review :' + countStarsList[i].toString() + '\n');
    }

    // works
    if (usernameList.isNotEmpty) {
      setState(() {});
    }

    print('\nEND fetchReviewsAndUsername\n');
  }

  @override
  void initState() {
    getData();
    //cookies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) 
  {
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

    return Material
    (
      type: MaterialType.transparency,
      child: Scaffold
      (
        appBar: PreferredSize
        (
          preferredSize: AppBar().preferredSize,
          child: AppBarBrowser(),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [

                // wohnungsname
                Text(wName, style: const TextStyle(fontSize: 50)),

                // Images
                SizedBox
                (
                  child: ImageSlideshow
                  (
                      width: MediaQuery.of(context).size.width * ContentWFactor,
                      height: 500,
                      initialPage: 0,
                      children: bilder
                  ),
                ),

                // beschreibung title
                Container
                (
                  height: 1 / 5 * (1 / 3 * MediaQuery.of(context).size.height),
                  width: MediaQuery.of(context).size.width * ContentWFactor,
                  alignment: Alignment.center,
                  decoration: BoxDecoration
                  (
                    border: Border.all
                    (
                      color: Colors.lightBlue,
                    ),
                    borderRadius: const BorderRadius.only
                    (
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))
                  ),
                  child: const Center(child: Text('Wohnungsinformationen'))
                ),

                // beschreibung data
                Container
                (
                  decoration: BoxDecoration
                  (
                    border: Border.all
                    (
                      color: Colors.lightBlue,
                    ),
                    borderRadius: const BorderRadius.only
                    (
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                    )
                  ),           
                  width: MediaQuery.of(context).size.width * ContentWFactor,
                  child:  Column
                  (
                    children: 
                    [
                      const Center(child: Text("Beschreibung")),
                      Container
                      (
                        padding: const EdgeInsets.all(20),
                        child: Center(child: Text(beschreibung)),
                      ),
                      Row
                      (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 
                        [
                          Text("Adresse: " +
                              strasse +
                              " " +
                              hausnummer +
                              ", " +
                              plz +
                              " " +
                              ort +
                              " " +
                              land),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Mietzeitraum: " +
                              mietzeitraumStart +
                              " bis: " +
                              mietzeitraumEnde)
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Aktueller Tokenpreis: " + tokenpreis + " Tokens")
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Mietpreis: " + mietpreis + "€")],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Wohnfläche: " + flaeche + "m²"),
                          const SizedBox(
                            width: 50,
                          ),
                          Text("Anzahl Zimmer: " + anzZimmer),
                          const SizedBox(
                            width: 50,
                          ),
                          Text("Anzahl Betten: " + anzBetten),
                          const SizedBox(
                            width: 50,
                          ),
                          Text("Anzahl Bäder: " + anzbaeder),
                          const SizedBox(
                            width: 50,
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(value: wifi, onChanged: null),
                          const Text("Wifi"),
                          Checkbox(value: garten, onChanged: null),
                          const Text("Garten"),
                          Checkbox(value: balkon, onChanged: null),
                          const Text("Balkon"),
                          Checkbox(value: stornierbar, onChanged: null),
                          const Text("Stornierbar")
                        ],
                    ),
                    ],
                  ),
                ),

                // bieten
                Container
                (
                  width: MediaQuery.of(context).size.width * ContentWFactor,
                  //alignment: Alignment.center,
                  margin: const EdgeInsets.all(20),
                  child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 
                    [
                      ElevatedButton
                      (
                        onPressed: () => showDialog<String>
                        (
                          context: context,
                          builder: (BuildContext context) => AlertDialog
                          (
                            title: const Center(child: Text('Bieten')),
                            content: const Text('Wieviele Tokens wollen Sie bieten?'),
                            actions: <Widget>
                            [
                              TextFormField
                              (
                                controller: newBet,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                ],
                              ),
                              TextButton
                              (
                                onPressed: () => 
                                {
                                  postBet(),

                                  /*setState(() {
                                    //tokenpreis = newBet.text;
                                  }),*/
                                  Navigator.pop(context, 'Bieten'),
                                },
                                child: const Text('Bieten'),
                              ),
                            ],
                          ),
                        ),
                          child: const Text('Bieten'),
                      ),
                       
                    ],
                  )
                ),

                Text(hochstbietender),
              
                 // reviews title
                Container
                (
                  height: 1 / 5 * (1 / 3 * MediaQuery.of(context).size.height),
                  width: MediaQuery.of(context).size.width * ContentWFactor,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.lightBlue,
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: const Text('Bewertungen'),
                ),

                // reviews
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lightBlue,
                        ),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    height:
                        4 / 5 * (1 / 3 * MediaQuery.of(context).size.height),
                    width: MediaQuery.of(context).size.width * ContentWFactor,
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        physics: const ScrollPhysics(),
                        child: Column(children: [
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(                               
                                child: ListTile(
                                    title: Column(children: [
                                  RichText(
                                    text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: usernameList[index],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const TextSpan(text: ' schrieb:')
                                        ]),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '"' + reviewList[index] + '"',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          const TextSpan(
                                              text: 'und bewertete mit '),
                                          TextSpan(
                                              text: countStarsList[index]
                                                      .toString() +
                                                  '/5',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const TextSpan(text: ' Sternen')
                                        ]),
                                  ),
                                ])),
                              );
                            },
                            itemCount: reviewList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                          ),
                        ]))),

                // spacing
                const SizedBox(height: 100,)

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    await loadCookies();
    await fetchOffer();
    await fetchApartment();
    await fetchReviewsAndUsername();
    await fetchImage();
  }

}
