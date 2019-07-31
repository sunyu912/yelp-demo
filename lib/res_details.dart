// IS THIS FILE STILL NEEDED???

// import 'algorithm.dart';
import 'package:flutter/material.dart';
// import 'package:map_view/map_view.dart';
// import 'main_page2.dart';
// import 'settings_page.dart';
import 'package:flutter/services.dart';
// import 'maps_page.dart';
import 'globals.dart' as globals;
// import 'vibLevel_page.dart';
// import 'haptic_page.dart';
// import 'tutorial.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'bluetooth_page.dart';
import 'main_page.dart';
import 'res_details.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResDetailPage extends StatefulWidget {
  @override
  ResDetailPageState createState() => new ResDetailPageState();
}

class ResDetailPageState extends State<ResDetailPage> {
  int index = 1;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  dynamic _borderRadius = new BorderRadius.circular(10.0);
  String searchRes;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  List names = new List();
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List filteredNames = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');


  @override
  void initState() {
    this.main();
    this.build(context);
    super.initState();
  }

  // void _showSnackBar2() {
  //   _scaffoldstate.currentState.showSnackBar(new SnackBar(
  //     content: new Text("Please fill in required fields!"),
  //   ));
  // }

  // void _submit() {
  //   final form = formKey.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     if (searchRes == null)
  //       _showSnackBar2();
  //     else
  //       globals.search = searchRes;
  //   }
  // }


  Widget buildName(String name) {
    return Center(
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(children: <Widget>[
        new Text(globals.search,
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500)),
        SizedBox(height: 50.0),
        new Text("*",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500)),
      ]),
    ));
  }

  // Widget buildPhone() {
  //   return Padding(
  //     padding: EdgeInsets.all(20.0),
  //     child: Column(children: <Widget>[
  //       new Text("Phone Number:",
  //           style: TextStyle(
  //               color: Colors.black,
  //               fontSize: 21.0,
  //               fontFamily: "Quicksand",
  //               fontWeight: FontWeight.w500)),
  //       new Text("*",
  //           style: TextStyle(
  //               color: Colors.black,
  //               fontSize: 21.0,
  //               fontFamily: "Quicksand",
  //               fontWeight: FontWeight.w500)),
  //     ]),
  //   );
  // }

  // Widget buildRating() {
  //   return Padding(
  //     padding: EdgeInsets.all(20.0),
  //     child: Column(children: <Widget>[
  //       new Text("Rating:",
  //           style: TextStyle(
  //               color: Colors.black,
  //               fontSize: 21.0,
  //               fontFamily: "Quicksand",
  //               fontWeight: FontWeight.w500)),
  //       new Text("*",
  //           style: TextStyle(
  //               color: Colors.black,
  //               fontSize: 21.0,
  //               fontFamily: "Quicksand",
  //               fontWeight: FontWeight.w500)),
  //     ]),
  //   );
  // }

  Widget _buildBottomNav() {
    return new BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        this.index = index;
        if (index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
              globals.search = "";
        }
        if (index == 0) {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => BluetoothPage()));
        }
      },
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text("Home"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.search),
          title: new Text("Search"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.account_box),
          title: new Text("Profile"),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
        child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: Row(
            children: <Widget>[
              Image.asset('assets/Logo.png', width: 70.0, height: 70.0),
              SizedBox(width: 25.0),
              Text("Hi, Ryan",
                  style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
        ListTile(
            title: Text("Vibrational Levels",
                style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => VibPage()));
            }),
        ListTile(
            title: Text("Haptic Patterns",
                style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => HapticPage()));
            }),
        ListTile(
            title: Text("Rerun Tutorial",
                style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => TutorialPage()));
            }),
        ListTile(
            title: Text("Settings", style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => SettingsPage()));
            }),
        ListTile(title: Text("Help", style: TextStyle(fontFamily: "Rajdhani"))),
        ListTile(
            title: Text("About Us", style: TextStyle(fontFamily: "Rajdhani"))),
      ],
    ));
  }

  // Widget _buildListTile(String k) {
  //   return ListTile(
  //       contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //       leading: Container(
  //         padding: EdgeInsets.only(right: 12.0),
  //         decoration: new BoxDecoration(
  //             border: new Border(
  //                 right: new BorderSide(width: 1.0, color: Colors.white24))),
  //         child: Icon(Icons.restaurant, color: Colors.white),
  //       ),
  //       title: Text(
  //         "Restaurant",
  //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //       ),
  //       // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
  //       trailing:
  //           Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
  // }

  // Widget _buildCard(String m) {
  //   return Card(
  //     elevation: 8.0,
  //     margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  //     child: Container(
  //       decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
  //       child: _buildListTile(m),
  //     ),
  //   );
  // }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    // //showMap();
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      key: _scaffoldstate,
      appBar: _buildBar(context),
      body: Stack(
        children: <Widget>[
          Container(
            child: buildName(globals.search),
          ),
          // Container(
          //   child: Column(
          //     children: <Widget>[
          //       SizedBox(height: 30.0),
          //       Text("Recommended:",
          //           style:
          //               TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0)),
          //       SizedBox(height: 20),
          //       Container(
          //         height: 150.0,
          //         child: ListView.builder(
          //           scrollDirection: Axis.vertical,
          //           shrinkWrap: true,
          //           itemCount: 4,
          //           itemBuilder: (BuildContext context, int index) {
          //             return _buildCard("KFC");
          //           },
          //         ),
          //       ),
          //       SizedBox(height: 20),
          //       Text("Restaurants Near You:",
          //           style:
          //               TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0)),
          //       SizedBox(height: 20.0),
          //       Container(
          //         height: 259.0,
          //         child: ListView.builder(
          //           scrollDirection: Axis.vertical,
          //           shrinkWrap: true,
          //           itemCount: 10,
          //           itemBuilder: (BuildContext context, int index) {
          //             return _buildCard("KFC");
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
      // Container(
      //   padding: EdgeInsets.all(20.0),
      //   child: Column(
      //     children: <Widget>[
      // _buildForm(),
      // SizedBox(height: 19.0),
      // _buildButton(),
      // SizedBox(height: 19.0),
      //       _buildText(),
      //       // _buildButton2(),
      //       Flex(
      //         direction: Axis.vertical,
      //         children: <Widget>[],
      //       )
      //     ],
      //   ),
      // ),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  main() async {
    String search = "del";
    String link = "https://api.yelp.com/v3/autocomplete?text=" + _searchText;
    Uri uri = Uri.parse(link);

    var req = new http.Request("GET", uri);
    req.headers['Authorization'] =
        'Bearer R3cZok5aDPZXwYwynJU9KrTx9QpqhBbncwKC2HAgtTvdHISyKiIAncxRmx6xLNr4nFFnwaQZRdTriepxbVQpqy0vdP62_ARSKXbxLf3qM7k3pVlez5iIdCTCmH8_XXYx';
    var res = await req.send();

    var obj = jsonDecode(await res.stream.bytesToString());
    List terms = [];
    for (var term in obj['terms']) terms.add(term['text']);
    setState(() {
      names = terms;
      filteredNames = names;
      print(filteredNames);
    });
  }
}
