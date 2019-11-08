import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'main_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

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
  Future businessDetails;
  final AsyncMemoizer _memoizer = AsyncMemoizer();



  @override
  void initState() {
    // buisnessDetails = {};
    // businessDetails = this.main();
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
        child: Column(
          children: <Widget>[
            Container(
              child: new FutureBuilder(
                future: main(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                  ));
                  } else if(snapshot.hasData) {
                    return Column(children: <Widget>[
                      new Text(snapshot.data['name']),
                      Container(
                        child: new Image(image: NetworkImage(snapshot.data['image'])),
                        constraints: BoxConstraints(
                          maxHeight: 250

                        ),
                        )
                    ],);
                  } else {
                    return new Container();
                  }
                },
              ),
            ),
            Container(
              child: new FutureBuilder(
                future: main(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                  ),);
                } else if(snapshot.hasData) {
                  print('has data: ' + snapshot.data['food'].toString());
                  return Expanded(child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return new ListTile(
                        title: Text(snapshot.data['food'][index]['name']),
                        subtitle: Text((snapshot.data['food'][index]['sentiment']).toStringAsFixed(2)),
                      );
                    }  
                  ),);
                } else {
                  print('no data');
                  return new Container();
                }
               },
              ),
            ),
          ],)
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  //   @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: _buildBar(context),
  //     body: Center(
  //       child: Column(
  //         children: <Widget>[
  //           new Container(
  //             child: Text(businessDetails['name']),)
  //         ],)
          
  //     ),
  //     drawer: _buildDrawer(),
  //     bottomNavigationBar: _buildBottomNav(),
  //   );
  // }


  main() async {
   
    String link = "https://api.yelp.com/v3/businesses/" + globals.searchid;
    // String link = "https://food-extraction2--sunyu912.repl.co/getreview/" +
    //     globals.searchid;
     print('get link: ' + link);
    Uri uri = Uri.parse(link);

    var req = new http.Request("GET", uri);
        req.headers['Authorization'] =
        'Bearer endKOtxDzmquiDBFQKImIss0K8oBAsSaatw84j7Z_mdayis_dfwdaAeiAGgARwPu7I9i3rYzQcNTVA8JL05phkq7O7elOZ5fLYjliuElh5ac8QyeJ9Lsdn871yE2XXYx';
    var res = await req.send();

    var obj = jsonDecode(await res.stream.bytesToString());
    Map details = {};
    details['name'] = obj['name'];
    details['image'] = obj['image_url'];

    String reviewLink = "https://food-extraction2-2.sunyu912.repl.co/getreviewurl?url=" + obj['url'];
    Uri reviewURI = Uri.parse(reviewLink);
    var req2 = new http.Request("GET", reviewURI);
    var res2 = await req2.send();
    var reviews =jsonDecode(await res2.stream.bytesToString());
    print('reviews: ' + reviews.toString());
    details['food'] = new List();
    for(var i = 0; i < 5; i++) {
      details['food'].add(reviews[i]);
    }
    print('details: ' + details.toString());
    return details;
  }
  // main() {
  //  return this._memoizer.runOnce(() async {
  //     String link = "https://api.yelp.com/v3/businesses/" + globals.searchid;
  //   // String link = "https://food-extraction2--sunyu912.repl.co/getreview/" +
  //   //     globals.searchid;
  //    print('get link: ' + link);
  //   Uri uri = Uri.parse(link);

  //   var req = new http.Request("GET", uri);
  //       req.headers['Authorization'] =
  //       'Bearer endKOtxDzmquiDBFQKImIss0K8oBAsSaatw84j7Z_mdayis_dfwdaAeiAGgARwPu7I9i3rYzQcNTVA8JL05phkq7O7elOZ5fLYjliuElh5ac8QyeJ9Lsdn871yE2XXYx';
  //   var res = await req.send();

  //   var obj = jsonDecode(await res.stream.bytesToString());
  //   Map details = {};
  //   details['name'] = obj['name'];
  //   details['image'] = obj['image_url'];

  //   String reviewLink = "https://rectangularselfassuredconsultant--five-nine.repl.co/getreviewurl?url=" + obj['url'];
  //   Uri reviewURI = Uri.parse(reviewLink);
  //   var req2 = new http.Request("GET", reviewURI);
  //   var res2 = await req2.send();
  //   var reviews =jsonDecode(await res2.stream.bytesToString());
  //   print('reviews: ' + reviews.toString());
  //   details['food'] = new List();
  //   for(var i = 0; i < 5; i++) {
  //     details['food'].add(reviews[i]);
  //   }
  //   print('details: ' + details.toString());
  //   return details;
  //  }
  //  );}
}
