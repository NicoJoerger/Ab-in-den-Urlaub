import 'dart:convert';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';
//import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';
import 'dart:io';
import 'dart:io' show File;
import 'dart:html' as html;
import 'appBars.dart';

class nWohnung extends StatefulWidget {
  nWohnung({Key? key}) : super(key: key);
  @override
  _nWohnungState createState() => _nWohnungState();
}

class _nWohnungState extends State<nWohnung> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> itemImagesList = <XFile>[];
  String URLs = "";
  List<String> downloadUrl = <String>[];
  List<XFile>? photo = <XFile>[];
  List<Widget> itemPhotosWidgetList = <Widget>[];
  File? file;
  bool uploading = false;

  Image image = Image(image: AssetImage("/images/Empty.png"));
  List<Image> Bilder = [];
//List<File> images = [];
  List<XFile> xImages = [];

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
  List<Image> tempBilder = [];

  List<Uint8List> bytesFromPicker = [];
  List<Int32List> int32bytesFromPicker = [];

  String uint8ListTob64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);
    String header = "data:image/png;base64,";
    return header + base64String;
  }

  void postWohnung() async {
    print("POST WOHNUNG");
    print("id: " + LoginInfo.userid.toString());
    String body = """ {
    "userId": """ +
        LoginInfo.userid.toString() +
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
    "BilderLinks": \"""" +
        URLs +
        """\",
    "deaktiviert": """ +
        "false" +
        """  
  }""";
    try {
      print("try post");
      response = await http.post(
          Uri.parse(LoginInfo.serverIP + "/api/Ferienwohnung"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: body);
      print("response: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        fwId = jsonData["fwId"];
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
        //LoginInfo.tokens = startToken;
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
    LoginInfo.userid = int.parse(html.window.localStorage['userId'].toString());
    LoginInfo.currentAngebot = html.window.localStorage['angebotID'].toString();
    LoginInfo.tokens =
        int.parse(html.window.localStorage['tokenstand'].toString());
  }

  final List<String> _address_countries_list = [
    'Deutschland',
    'Frankreich',
    'Großbritannien',
    'Ungarn',
    'Schweden',
    'Spanien',
    'Kanada',
    'Griechenland',
    'Japan',
    'Italien'
  ];
  String _selected_country = 'Deutschland';

  @override
  void initState() {
// TODO: implement initState
    loadCookies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenheight = MediaQuery.of(context).size.height;
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
                          value: _selected_country,
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
                        Center(
                          child: itemPhotosWidgetList.isEmpty
                              ? Center(
                                  child: MaterialButton(
                                    onPressed: pickPhotoFromGallery,
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Center(
                                        child: Image.network(
                                          "https://static.thenounproject.com/png/3322766-200.png",
                                          height: 100.0,
                                          width: 100.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Wrap(
                                    spacing: 5.0,
                                    direction: Axis.horizontal,
                                    children: itemPhotosWidgetList,
                                    alignment: WrapAlignment.spaceEvenly,
                                    runSpacing: 10.0,
                                  ),
                                ),
                        ),
                        /*Container(
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
                              pickImage2();
                            },
                            child: Text("Neues Bild hochladen"),
                          ),
                        ),*/
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
                          "Hier können Sie eine Beschreibung zu Ihrer Wohnung abgeben.",
                        ),
                        TextField(
                          controller: description,
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
                        upload();

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

  displayWebUploadFormScreen(_screenwidth, _screenheight) {
    return OKToast(
        child: Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100.0,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white70,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(0.0, 0.5),
                    blurRadius: 30.0,
                  )
                ]),
            width: _screenwidth * 0.7,
            height: 300.0,
            child: Center(
              child: itemPhotosWidgetList.isEmpty
                  ? Center(
                      child: MaterialButton(
                        onPressed: pickPhotoFromGallery,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Center(
                            child: Image.network(
                              "https://static.thenounproject.com/png/3322766-200.png",
                              height: 100.0,
                              width: 100.0,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        spacing: 5.0,
                        direction: Axis.horizontal,
                        children: itemPhotosWidgetList,
                        alignment: WrapAlignment.spaceEvenly,
                        runSpacing: 10.0,
                      ),
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 50.0,
                  left: 100.0,
                  right: 100.0,
                ),
                child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    color: const Color.fromRGBO(0, 35, 102, 1),
                    onPressed: uploading ? null : () => upload(),
                    child: uploading
                        ? const SizedBox(
                            child: CircularProgressIndicator(),
                            height: 15.0,
                          )
                        : const Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  addImage() {
    for (var bytes in photo!) {
      itemPhotosWidgetList.add(Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          height: 90.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              child: kIsWeb
                  ? Image.network(File(bytes.path).path)
                  : Image.file(
                      File(bytes.path),
                    ),
            ),
          ),
        ),
      ));
    }
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage();
    if (photo != null) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        addImage();
        photo!.clear();
      });
    }
  }

  upload() async {
    String productId = await uplaodImageAndSaveItemInfo();
    setState(() {
      uploading = false;
    });
    URLs = "";
    for (int i = 0; i < downloadUrl.length; i++) {
      URLs = URLs + downloadUrl[i] + ";";
    }
    postWohnung();
  }

  Future<String> uplaodImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    String? productId = const Uuid().v4();
    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);

      await uploadImageToStorage(pickedFile, productId);
    }
    return productId;
  }

  uploadImageToStorage(PickedFile? pickedFile, String productId) async {
    String? pId = const Uuid().v4();
    Reference reference =
        FirebaseStorage.instance.ref().child('Items/$productId/product_$pId');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downloadUrl.add(value);
    print(value.toString());
  }
}
