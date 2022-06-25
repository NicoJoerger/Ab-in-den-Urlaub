import 'package:flutter/material.dart';
import 'globals.dart';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class AppBarBrowser extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);
  Widget getCoinsWidget() {
    if (LoginInfo.tokens == 0) {
      return Text("Buy Coins");
    } else {
      return Text(LoginInfo.tokens.toString());
    }
  }

  void fetchtoken() async {
    try {
      var response = await http.get(Uri.parse(
          LoginInfo.serverIP + '/api/Nutzer/' + LoginInfo.userid.toString()));
      final userData = jsonDecode(response.body);

      //print("userData[0]: " + userData[0].toString());
      LoginInfo.tokens = userData[0]["tokenstand"];
      print("Tokenstand appBar = " + LoginInfo.tokens.toString());
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
              height: 30,
              child: Image.asset(
                "/images/homepage.png",
                color: Colors.white,
              ),
            ),
            onTap: () => {Navigator.pushNamed(context, "/")},
          ),
          GestureDetector(
            child: Text("Suche Ferienwohnungen"),
            onTap: () {
              Navigator.pushNamed(context, '/Suche');
            },
          ),
          GestureDetector(
            child: Text("Mein Profil"),
            onTap: () {
              if (LoginInfo.userid != -1) {
                Navigator.pushNamed(context, '/Profile');
              } else {
                Navigator.pushNamed(context, '/registrierung');
              }
            },
          ),
          GestureDetector(
            child: Row(children: [
              getCoinsWidget(),
              Image.asset(
                "/images/coins.png",
                height: 30,
              ),
            ]),
            onTap: () {
              Navigator.pushNamed(context, '/Tokens');
            },
          ),
          /*
          Column(
            children: [
              GestureDetector(
                child: Stack(
                  children: [
                    Image(
                      height: AppBar().preferredSize.height / 3,
                      image: AssetImage("images/en.webp"),
                    ),
                    Text("DE", style: TextStyle(color: Colors.black),),
                  ],
                ),
              ),
              GestureDetector(
                child: Text("EN"),
              )
            ],
          ),
          */
        ],
      ),
    );
  }
}
