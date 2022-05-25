import 'package:ab_in_den_urlaub/neueWohnungPage.dart';
import 'package:ab_in_den_urlaub/neuesAngebotPage.dart';
import 'package:ab_in_den_urlaub/registrierung.dart';
import 'package:ab_in_den_urlaub/testapi.dart';
import 'package:ab_in_den_urlaub/tokens.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'allApartments.dart';
import 'apartment.dart';
import 'package:ab_in_den_urlaub/neuesAngebotPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => AllApartments(),
      '/testapi': (context) => TestAPI(),
      '/registrierung': (context) => Registrierung(),
      '/nAngebot': (context) => nAngebot(),
      '/nWohnung': (context) => nWohnung(),
      '/Wohnungssuche': (context) => nWohnung(),
      '/Rechnungshistorie': (context) => nWohnung(),
      '/Tokens': (context) => Token(),
    });
  }
}
