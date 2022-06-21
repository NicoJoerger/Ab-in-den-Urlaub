import 'package:flutter/material.dart';

import 'appBars.dart';

class Impressum extends StatefulWidget {
  const Impressum({Key? key}) : super(key: key);
  @override
  _ImpressumState createState() => _ImpressumState();
}

class _ImpressumState extends State<Impressum> {
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
              children: const 
              [
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
