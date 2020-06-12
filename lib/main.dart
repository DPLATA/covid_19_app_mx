import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;



void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  @override
  MySplashScreen createState() => new MySplashScreen();
}

class MySplashScreen extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new MainScreen(),
        //image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        image: new Image(image: AssetImage('assets/images/Logoprincipal.png')),
        backgroundColor: Color(0xFFa5c9fd),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        //onClick: ()=>print("Flutter Egypt"),
        loaderColor: Color(0xFFd4d4d4),
        //image: new Image(image: AssetImage('assets/images/Logoprincipal.png')),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFa5c9fd),
      appBar: new AppBar(

          automaticallyImplyLeading: false
      ),
      body: ListView(
        children: <Widget> [
          Image(image: AssetImage('assets/images/Logoprincipal.png')),
          FlatButton(
              color: Colors.white,
              textColor: Colors.blue,
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SimScreen()),
                );
              },
              child: Text(
                "Simulation",
                style: TextStyle(fontSize: 20.0),
              ),
          ),
          FlatButton(
              color: Colors.white,
            textColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
            child: Text(
              "Map",
              style: TextStyle(fontSize: 20.0),
            )
          ),

        ]
      ),
    );
  }
}

class SimScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(

          automaticallyImplyLeading: false,
           actions: <Widget>[
           IconButton(
            icon: Icon(
                Icons.info,
                color: Colors.white
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChartsFetchData()
          ),
          Expanded(
            child: Image(image: AssetImage('assets/images/clustering.png')),
          ),
          Expanded(
            child: CountryJSONFetchData(),
          )
        ],
      )
    );
  }
}

class MapScreen extends StatelessWidget {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _myLocation =
  CameraPosition(target: LatLng(0, 0),);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(

          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
             icon: Icon(
                Icons.info,
                color: Colors.white
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen()));
            },
          )
        ],
      ),
      body: Column(
       children: [
         Expanded(
             child: MapaGoogle()
         ),
         Expanded(
         child: CountryFetchData()
          ),
       ]
      )
    );
  }
}

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _launchURL() async {
      const url = 'https://www.covidmexico.com/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    return new Scaffold(
      backgroundColor: Color(0xFFa5c9fd),
      appBar: new AppBar(

          automaticallyImplyLeading: false
      ),
      body: ListView(
          children: <Widget> [
            Image(image: AssetImage('assets/images/Logoprincipal.png')),
            FlatButton(
              color: Colors.white,
              textColor: Colors.blue,
              onPressed: () {
                _launchURL();
              },
              child: Text(
                  "Mexico's unoficial stats website",
                  style: TextStyle(fontSize: 20.0),
                )
            )

          ]
      ),
    );
  }
}

class _MapaGoogleState extends State<MapaGoogle> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(19.432608, -99.133209);
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_center.toString()),
        position: _center,
        infoWindow: InfoWindow(
          title: 'CDMX',
          snippet: 'COVID!! XO',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
      );
      _circles.add(Circle(
        circleId: CircleId(_center.toString()),
        center: LatLng(19.432608, -99.133209),
        fillColor: Colors.red.withOpacity(0.3),
        strokeColor: Colors.red.withOpacity(0.3),
        radius: 40000,
      )
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _markers,
            circles: _circles,
          ),
        ],
      ),
      )
    );
  }
}

class MapaGoogle extends StatefulWidget {
  @override
  _MapaGoogleState createState() => _MapaGoogleState();
}


//-----------------------------Charts-----------------------------------
class ChartsFetchData extends StatefulWidget {
  @override
  _ChartsFetchDataState createState() => _ChartsFetchDataState();
}


class _ChartsFetchDataState extends State<ChartsFetchData> {
  List list = List();
  var isLoading = false;
  var start = true;

  _fetchData() async {
    start = false;
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get("https://api.covid19api.com/total/dayone/country/mexico");
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new Country.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load ;(');
    }
  }

  @override
  Widget build(BuildContext context) {
    {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              start
                  ? FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () => _fetchData(),
                  child: Text(
                    "Fetch chart",
                    style: TextStyle(fontSize: 20.0),
                  ),
              )
                : SizedBox(
                height: 197,
                child: isLoading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                : charts.BarChart(
                  _createVisualizationData(list),
                  animate: true,
                  behaviors: [
                    charts.ChartTitle('Mexico last 10 days cases'),
                    charts.ChartTitle('Number of cases',
                        behaviorPosition: charts.BehaviorPosition.start),
                    charts.ChartTitle('Date',
                        behaviorPosition: charts.BehaviorPosition.bottom)
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  static List<charts.Series<CasesVsDate, String>>
  _createVisualizationData(list) {





    final data = [



      CasesVsDate(list[list.length-10].date, list[list.length-10].casesConfirmed),
      CasesVsDate(list[list.length-9].date, list[list.length-9].casesConfirmed),
      CasesVsDate(list[list.length-8].date, list[list.length-8].casesConfirmed),
      CasesVsDate(list[list.length-7].date, list[list.length-7].casesConfirmed),
      CasesVsDate(list[list.length-6].date, list[list.length-6].casesConfirmed),
      CasesVsDate(list[list.length-5].date, list[list.length-5].casesConfirmed),
      CasesVsDate(list[list.length-4].date, list[list.length-4].casesConfirmed),
      CasesVsDate(list[list.length-3].date, list[list.length-3].casesConfirmed),
      CasesVsDate(list[list.length-2].date, list[list.length-2].casesConfirmed),
      CasesVsDate(list[list.length-1].date, list[list.length-1].casesConfirmed)

    ];

    return [
      charts.Series<CasesVsDate, String>(
          id: 'CasesVsDate',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (CasesVsDate dataPoint, _) =>
          dataPoint.date,
          measureFn: (CasesVsDate dataPoint, _) =>
          dataPoint.confirmedCases,
          data: data)
    ];
  }
}

class CasesVsDate {
  final String date;
  final int confirmedCases;

  CasesVsDate(this.date, this.confirmedCases);
}







//-------------------------------Country-------------------------------

class Country {
  final String name;
  final int casesConfirmed;
  final int deaths;
  final String date;
  Country._({this.name, this. casesConfirmed, this.deaths, this.date});
  factory Country.fromJson(Map<String, dynamic> json) {
    return new Country._(
      name: json['Country'],
      casesConfirmed: json['Confirmed'],
      deaths: json['Deaths'],
      date: json["Date"].substring(6,10)
    );
  }
}

class CountryFetchData extends StatefulWidget {
  @override
  _CountryFetchDataState createState() => _CountryFetchDataState();
}

class _CountryFetchDataState extends State<CountryFetchData> {

  List list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get("https://api.covid19api.com/total/dayone/country/mexico");
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new Country.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load ;(');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fetchData(),
        child: Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: EdgeInsets.all(10.0),
                leading: Image(image: AssetImage('assets/images/mexFlag.png')),
                title: new Text('Day: ' + (index+1).toString() + '  ' + 'Date: ' +  list[index].date),
                subtitle: Text('Mexico'),
                trailing: Text('Cases confirmed: ' + list[index].casesConfirmed.toString()),
              );
            }));

  }
}

//-------------------------JSON DATA-------------------------------------------->

class CountryJSONFetchData extends StatefulWidget {
  @override
  _CountryJSONFetchDataState createState() => _CountryJSONFetchDataState();
}

class _CountryJSONFetchDataState extends State<CountryJSONFetchData> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
          child: Center(
            child: new FutureBuilder(
              future: DefaultAssetBundle.of(context).loadString('assets/json/csvjson.json'),
              builder: (context, snapshot) {
                var data = json.decode(snapshot.data.toString());
                return new ListView.builder(
                  itemBuilder: (BuildContext context, int index){
                    return new ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      title: Text("Country: " + data[index]["Country/Region"]),
                      subtitle: Text("Recovered per 100 000: " + data[index]["Recovered / 100 Cases"].toString()),
                      trailing: Text("Deaths per 100 000: " + data[index]["Deaths / 100 Cases"].toString()),
                    );
                  },
                  itemCount: data == null ? 0 : data.length,
                );
              },
            ),
          ),
        )

    );

  }
}