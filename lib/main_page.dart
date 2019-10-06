import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals.dart' as globals;
import 'res_details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:async/async.dart';

class MainPage extends StatefulWidget {
  @override
  State createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  int index = 1;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String searchRes;
  bool currentlySearching = false;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();


  final AsyncMemoizer _memoizer = AsyncMemoizer();
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List filteredNames = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');
  List names = new List();
  List ids = new List();
  double lat, long;
  LocationData currentLocation;
  var location = new Location();
  String error;

  // Future<List> _future;

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
    super.initState();
    this._main();
    // _future = _main();
    
  }
  
  getLoc() async {
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      currentLocation = null;
    }
    lat = currentLocation.latitude;
    long = currentLocation.longitude;
  }

    Widget _buildList() {
    return new FutureBuilder(
      future: _main(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator()
          );
         } else if(snapshot.hasData) {
           return ListView.builder(
          itemCount: snapshot.data[0].length,
          itemBuilder: (BuildContext context, int index) {
            return new ListTile(
              title: Text(snapshot.data[0][index]),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResDetailPage())),
                globals.searchname = snapshot.data[0][index],
                globals.searchid = snapshot.data[1][index],
              },
            );
          },
        );
         } else {
           return new Container();
         }
    });
  }

  Widget _buildBottomNav() {
    return new BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        this.index = index;
        if (index == 0) {
        }
        if (index == 2) {
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
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(Icons.restaurant, color: Colors.white),
            ),
            title: Text(
              name,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(dist.toString() + "miles",
                style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Colors.white, size: 15.0)),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: _appBarTitle, actions: [
      new IconButton(
        alignment: Alignment.center,
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    ]);
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
                Text("Restaurants Near You:",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15.0)),
                SizedBox(height: 20.0),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCard("KFC", 20.0);
                  },
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
    if (currentlySearching == true) {
      return Container(
        color: Colors.white,
        child: _buildList(),
      );
    } else
      return Container();
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
        _filter.clear();
        currentlySearching = false;
      }
    });
  }

  _main() async {
    getLoc();
    print(lat);
    String link = "https://api.yelp.com/v3/autocomplete?text=" + _searchText + "&latitude=" + lat.toString() + "&longitude=" + long.toString();
    Uri uri = Uri.parse(link);

    var req = new http.Request("GET", uri);
    req.headers['Authorization'] =
        'Bearer endKOtxDzmquiDBFQKImIss0K8oBAsSaatw84j7Z_mdayis_dfwdaAeiAGgARwPu7I9i3rYzQcNTVA8JL05phkq7O7elOZ5fLYjliuElh5ac8QyeJ9Lsdn871yE2XXYx';
    var res = await req.send();

    var obj = jsonDecode(await res.stream.bytesToString());
    

    List name = [];
    List id = [];
    for (var term in obj['businesses']) {
      print('business names: ' + term['name']);
      print('business id: ' + term['id']);
      name.add(term['name']);
      id.add(term['id']);}
    return [name, id];

  }

}
  
