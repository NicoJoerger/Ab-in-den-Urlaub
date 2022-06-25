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
  var containerHight = 40.0;
  var containerWidth = 400.0;
  var contentWidthFactor = 0.2;
  String dropdownValue = 'One';
  List<String> wohnungen2 = ['Wähle']; // Option 2
  String _selectedLocation = "Wähle";
  DateTime selectedRBeginn = DateTime.now();
  DateTime selectedABeginn = DateTime.now();
  DateTime selectedREnde = DateTime.now();
  DateTime selectedAEnde = DateTime.now();

  bool landLordStatus = LoginInfo.vermieter;
  bool offerCancellable = false;
  final tokenPriceController = TextEditingController();
  final rentalPriceController = TextEditingController();
  var dict = new Map();
  Map<String, int> dictionaryFeriwnwohnungNameID = {};
  dynamic startOfJourney;
  dynamic endOfJourney;
  

  void loadCookies() async {
    LoginInfo.userid = int.parse(window.localStorage['userId'].toString());
    LoginInfo.currentAngebot = window.localStorage['angebotID'].toString();
    LoginInfo.tokens = int.parse(window.localStorage['tokenstand'].toString());
  }

  Future<void> selectRBeginn(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedRBeginn,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedRBeginn) {
      setState(() {
        //print(picked.toString());
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
      //print("HI Get Wohnungsname");
      var response = await http.get(Uri.parse(LoginInfo.serverIP +
          "/api/Ferienwohnung/" +
          LoginInfo.userid.toString() +
          "/user"));
      //print("Wohnungsname get body: " + response.body);
      final jsonData = jsonDecode(response.body) as List;
      wohnungen2 = ['Wähle'];
      //print('\ndict\n');
      for (int i = 0; i < jsonData.length; i++) {
        /*print("jsonDataUserWohnungen[" +
            i.toString() +
            "].toString(): " +
            jsonData[i].toString());
        print(jsonData[i]["deaktiviert"]);*/
        if (!jsonData[i]["deaktiviert"]) {
          setState(() {
            wohnungen2.add(jsonData[i]["wohnungsname"]);
            // add fwId to dict
            dict[jsonData[i]["wohnungsname"].toString()] = jsonData[i]["fwId"];
          });
        }
      }
      //print('\nfertiiiiiiiiiiiiiig\n');
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
                // spacing
                SizedBox(
                  height: 1 / 10 * MediaQuery.of(context).size.height,
                ),

                Container(),

                const Text(
                  "Wohnung",
                  style: TextStyle(fontSize: 30),
                ),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: containerWidth,
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
                  height: containerHight,
                  //width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: containerWidth,
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
                  height: containerHight,
                  //width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: containerWidth,
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
                  height: containerHight,
                  //width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: containerWidth,
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
                  height: containerHight,
                  //width: MediaQuery.of(context).size.width * ContentWFactor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: containerWidth,
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

                // Text
                const Text(
                  'Preise/Storno',
                  style: TextStyle(fontSize: 30),
                ),

                // TextFormField token price
                /*
                SizedBox(
                  width: 1.5 * containerWidth,
                  child: TextFormField(
                    controller: tokenPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Please enter tokenprice',
                    ),
                  ),
                ),
                */

                // TextFormField rental price
                SizedBox(
                  width: 1.5 * containerWidth,
                  child: TextFormField(
                    controller: rentalPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Please enter rental price.',
                    ),
                  ),
                ),

                // Checkbox cancellable
                SizedBox(
                    width: 1.5 * containerWidth,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("stonierbar"),
                          Checkbox(
                            activeColor: Colors.orange,
                            checkColor: Colors.green,
                            value: offerCancellable,
                            onChanged: (value) {
                              setState(() {
                                offerCancellable = value!;
                              });
                            },
                          ),
                        ])),

                // spacing
                SizedBox(
                  height: 1 / 30 * MediaQuery.of(context).size.height,
                ),

                // Button post Offer
                SizedBox(
                  width: 1.5 * containerWidth,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    child: OutlinedButton(
                      child: const Text('Angebot erstellen',
                          style: TextStyle(color: Colors.black)),
                      onPressed: () {checkAndPostOffer();},
                    ),
                  ),
                ),

                // spacing
                SizedBox(
                  height: 1 / 10 * MediaQuery.of(context).size.height,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void postOffer() async {
    // url for post offer
    String url = LoginInfo.serverIP + '/api/Angebote';

    // post Angebot
    final postOfferResponse = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: await buildPostOfferJSON()
    );

    if (postOfferResponse.statusCode == 200) // post Offer succeded
    {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Angebot erfolgreich abgegeben.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else // post Offer didnt succeded
    {
      String errorMessage = '';

      // Error checking.
      if (LoginInfo.userid == -1) {
        errorMessage = 'Sie sind nicht eingeloggt.';
      }

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Angebot nicht erfolgreich abgegeben.'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    // check if offer is in DB
  }

  void checkAndPostOffer() async
  {
    if( offerFilledOut() ) // form 'offer' is filled out
    {
      if( await flatOfferALreadyExistsForGivenTimeframe() ) // offer already exists for timeframe
      {
        alert('Mietzeitraum überschneidet sich mit einerm anderen Angebot!'); // offer is already there for timeframe
      }
      else // timeframe is open for offer
      {
        postOffer();
      }
    }
    else
    {
      alert('Formular ist nicht korrekt ausgefüllt!'); // form 'offer' is not filled out
    }
  }

  bool offerFilledOut()
  {
    bool filledOut = false;

    // for testing
    /*
    String s = '\nofferFilledOut:'+
               '\nrentalPriceController.text.isNotEmpty           >> ' + rentalPriceController.text.isNotEmpty.toString()           +
               '\n_selectedLocation != Wähle                      >> ' + (_selectedLocation != 'Wähle').toString()                  +
               '\n(selectedRBeginn.compareTo(selectedREnde)  < 0) >> ' + (selectedRBeginn.compareTo(selectedREnde)  < 0).toString() +
               '\n(selectedABeginn.compareTo(selectedAEnde)  < 0) >> ' + (selectedABeginn.compareTo(selectedAEnde)  < 0).toString() +
               '\n(selectedABeginn.compareTo(DateTime.now()) > 0) >> ' + (selectedABeginn.compareTo(DateTime.now()) > 0).toString() +
               '\n(selectedRBeginn.compareTo(DateTime.now()) > 0) >> ' + (selectedRBeginn.compareTo(DateTime.now()) > 0).toString() +
               '\n(selectedRBeginn.compareTo(selectedAEnde)  > 0) >> ' + (selectedRBeginn.compareTo(selectedAEnde)  > 0).toString()
               ;

    alert(s);
    */

    if
    (
          rentalPriceController.text.isNotEmpty          // rentalPrice filled in
      &&  _selectedLocation != 'Wähle'                   // location selected
      &&  selectedRBeginn.compareTo(selectedREnde)  < 0  // selectedRBegin  < selectedREnd
      &&  selectedABeginn.compareTo(selectedAEnde)  < 0  // selectedABeginn < selectedAEnde
      &&  selectedABeginn.compareTo(DateTime.now()) > 0  // selectedABeginn > now
      &&  selectedRBeginn.compareTo(DateTime.now()) > 0  // selectedRBeginn > now
      &&  selectedRBeginn.compareTo(selectedAEnde)  > 0  // selectedRBeginn > selectedAEnde
    )
    {
      filledOut = true;
      startOfJourney  = selectedRBeginn.year.toString() + '-' + selectedRBeginn.month.toString().padLeft(2, '0') + '-' + selectedRBeginn.day.toString().padLeft(2, '0');
      endOfJourney    = selectedREnde.year.toString()   + '-' + selectedREnde.month.toString().padLeft(2, '0')   + '-' + selectedREnde.day.toString().padLeft(2, '0');
    }

    return filledOut;
  }

  Future<String> buildPostOfferJSON() async {

    // vars
    String endOfAuction    = selectedAEnde.year.toString()   + '-' + selectedAEnde.month.toString().padLeft(2, '0')   + '-' + selectedAEnde.day.toString().padLeft(2, '0');
    int    tokenPriceStart = 100;

    String offerPostQuery = jsonEncode(<String, Object>{
      "fwId"               : dict[_selectedLocation]!  ,
      "mietzeitraumStart"  : startOfJourney            ,
      "mietzeitraumEnde"   : endOfJourney              ,
      "auktionEnddatum"    : endOfAuction              ,
      "aktuellerTokenpreis": tokenPriceStart           , 
      "mietpreis"          : rentalPriceController.text,
      "stornierbar"        : offerCancellable
    });

    //print('\nofferPostQuery\n'+offerPostQuery+'\n');

    return offerPostQuery;
  }

  Future<bool> flatOfferALreadyExistsForGivenTimeframe() async 
  {
    // vars
    String              url             = LoginInfo.serverIP + '/api/Angebote/'+ dict[_selectedLocation]!.toString()+'/fw';
    Uri                 uri             = Uri.parse(url);
    bool                inUse           = false;
    Map<String, String> heads           = <String, String>{'Content-Type': 'application/json; charset=UTF-8'};
    http.Response       offers;
    dynamic             offersDecoded;
    dynamic             offerDecoded;
    dynamic             startOfJourneyGiven;
    dynamic             endofJourneyGiven;

    // get offers at json
    offers = await http.get(uri, headers: heads);
    offersDecoded = jsonDecode(offers.body);

    // set inUSe true if flats are rented at the same time
    for(offerDecoded in offersDecoded)
    {
      startOfJourneyGiven = offerDecoded['mietzeitraumStart'].toString().substring(0, 10);
      endofJourneyGiven   = offerDecoded['mietzeitraumEnde'].toString().substring(0, 10);

      if( (startOfJourney.compareTo(startOfJourneyGiven) >= 0) && (startOfJourney.compareTo(endofJourneyGiven) <= 0) )
      {
        inUse = true;
      }

      if( (endOfJourney.compareTo(startOfJourneyGiven) >= 0) && (endOfJourney.compareTo(endofJourneyGiven) <= 0) )
      {
        inUse = true;
      }

      if( (startOfJourney.compareTo(startOfJourneyGiven) < 0) && (endOfJourney.compareTo(endofJourneyGiven) > 0))
      {
        inUse = true;
      }

    }

    print('\n flatOfferALreadyExistsForGivenTimeframe() >> '+inUse.toString());

    return inUse; 
  }

  // Displays Dialog with Title of String message
  void alert(String message)
  {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(message),
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
