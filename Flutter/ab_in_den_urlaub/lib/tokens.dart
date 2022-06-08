import 'package:ab_in_den_urlaub/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'globals.dart';
import 'appBars.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class Token extends StatefulWidget {
  Token({Key? key}) : super(key: key);
  @override
  _TokenState createState() => _TokenState();
}

class _TokenState extends State<Token> {
  var Containerh = 40.0;
  var Containerw = 400.0;
  var sliderval = 100.0;
  int tokenPreis() {
    return 25;
  }

  void addTokens() async
  {
    var response;
    String urlUsr = LoginInfo().serverIP + '/api/Nutzer/' + LoginInfo().userid.toString();
    try{
      print(" test12\n");
      response = await http.get(Uri.parse(urlUsr));
      print(response.body+"\n");
      final jsonData = jsonDecode(response.body) as List;
      print(jsonData.toString()+"\n");
      final json = jsonData[0];
      print(" tes2t12\n");
      json["tokenstand"] = (json["tokenstand"].toInt() + sliderval.toInt());
      String urlToken = LoginInfo().serverIP + 'api/Nutzer';
      print("test123\n");
      response = await http.put(Uri.parse(urlToken), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      }, body: jsonData.toString());
      
      if(response.statusCode() == 200)
      {
        setState(() {
            LoginInfo().tokens += sliderval.toInt();
      });
      }
    }
    catch(err){
      print(err.toString());
    }
    
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Erhalte pro Jahr 200 Tokens kostenlos!",
                    style: TextStyle(fontSize: 70),
                  ),
                  Container(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Tokenpreis:",
                              style: TextStyle(fontSize: 60),
                            ),
                            Text(
                              "5 Token/€",
                              style: TextStyle(fontSize: 60),
                            ),
                            Text(
                              sliderval.toInt().toString() + " Jetzt kaufen",
                              style: TextStyle(fontSize: 30),
                            ),
                            Container(
                                width: 400,
                                child: Slider(
                                    divisions: 10000,
                                    min: 1,
                                    max: 10000,
                                    value: sliderval,
                                    onChanged: (double value) {
                                      setState(() {
                                        sliderval = value;
                                      });
                                    })),
                            TextButton(
                              onPressed: 
                              addTokens,
                              child: Text("Für " +
                                  ((sliderval.toInt() * tokenPreis()) / 100.0)
                                      .toString() +
                                  "€ zahlungspflichtig bestellen"),
                            )
                          ]),
                      Container(
                        width: 50,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 600,
                                width: 600,
                                child: Image.asset("/images/coins.png")),
                          ])
                    ],
                  ),
                ])),
      ),
    );
  }
}
