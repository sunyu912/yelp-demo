

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
import 'res_details.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  State createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  int index = 1;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  dynamic _borderRadius = new BorderRadius.circular(10.0);
  String searchRes;
  bool currentlySearching = false;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List filteredNames = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');
  List names = new List();

  MainPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this.main();
    super.initState();
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return new FutureBuilder(
      future: main(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: filteredNames.length,
          itemBuilder: (BuildContext context, int index) {
            return new ListTile(
              title: Text(filteredNames[index]),
              onTap: () => {
                Navigator.push(context,
              MaterialPageRoute(builder: (context) => ResDetailPage())),
                globals.search = filteredNames[index],
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return new BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        this.index = index;
        if (index == 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ResDetailPage()));
        }
        if (index == 2) {
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
            title: Text("Recents", style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => VibPage()));
            }),
        ListTile(
            title: Text("Favorites", style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => HapticPage()));
            }),
        ListTile(
            title:
                Text("User Settings", style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => TutorialPage()));
            }),
        ListTile(
            title: Text("Help", style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => SettingsPage()));
            }),
        ListTile(
            title: Text("About Us", style: TextStyle(fontFamily: "Rajdhani"))),
        ListTile(
            title: Text("Log In", style: TextStyle(fontFamily: "Rajdhani"))),
      ],
    ));
  }

  Widget _buildCard(String name, double dist) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.redAccent),
        child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.restaurant, color: Colors.white),
        ),
        title: Text(
            name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(dist.toString() + "miles", style: TextStyle(color: Colors.white)),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 15.0)),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      actions: [new IconButton(
        alignment: Alignment.center,
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),]
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      key: _scaffoldstate,
      resizeToAvoidBottomPadding: false,
      appBar: _buildBar(context),
      body: Stack(
        children: <Widget>[ 
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Text("Recommended:",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15.0)),
                SizedBox(height: 20.0),
                Container(
                  height: 150.0,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCard("KFC", 20.0);
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text("Restaurants Near You:",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15.0)),
                SizedBox(height: 20.0),
                Container(
                  height: 259.0,
                  child: 
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCard("KFC", 20.0);
                    },
                  ),
                ),
              ],
            ),
          ),
          overlayContainer(),
        ],
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget overlayContainer() {
    if (currentlySearching == true){
      return Container(
            color: Colors.white,
            child: _buildList(),
          );
    }
    else
      return Container(
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
        currentlySearching = true;
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search');
        // filteredNames = names;
        _filter.clear();
        currentlySearching = false;
      }
    });
  }

  main() async {
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
