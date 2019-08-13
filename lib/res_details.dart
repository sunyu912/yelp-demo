import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'main_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResDetailPage extends StatefulWidget {
  @override
  ResDetailPageState createState() => new ResDetailPageState();
}

class ResDetailPageState extends State<ResDetailPage> {
  int index = 1;
  String searchRes;
  List names = new List();
  final TextEditingController _filter = new TextEditingController();
  List filteredNames = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');

  @override
  void initState() {
    this.main();
    this.build(context);
    super.initState();
  }

  Widget buildName(String name, String id) {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(children: <Widget>[
        new Text(name,
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500)),
        SizedBox(height: 50.0),
        new Text(id,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500)),
      ]),
    ));
  }

  Widget _buildBottomNav() {
    return new BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        this.index = index;
        if (index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
          globals.searchname = "";
          globals.searchid = "";
        }
        if (index == 0) {
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

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Center(
        child:
          Container(
            child: new FutureBuilder(
              future: main(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: filteredNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new ListTile(
                      title: Text(filteredNames[index]),
                      onTap: () => {},
                    );
                  },
                );
              },
            ),
          ),
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }


  main() async {
    String link = "https://food-extraction2--sunyu912.repl.co/getreview/" +
        globals.searchid;
    Uri uri = Uri.parse(link);

    var req = new http.Request("GET", uri);
    var res = await req.send();

    var obj = jsonDecode(await res.stream.bytesToString());
    List reps = [];
    for (var term in obj) reps.add(term['name']);
    setState(() {
      filteredNames = reps;
    });
  }
}
