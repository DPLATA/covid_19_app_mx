import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


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
          title: new Text("Main screen"),
          automaticallyImplyLeading: false
      ),
      body: ListView(
        children: <Widget> [
          Image(image: AssetImage('assets/images/Logoprincipal.png')),
          RaisedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SimScreen()),
                );
              },
              child: const Text('Simulation'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
            child: const Text('Map'),
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
          title: new Text("Simulation screen"),
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
      body: new Center(
          child: new Image(image: AssetImage('assets/images/Logoprincipal.png')),
        //MAPS
      ),
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
          title: new Text("Map screen"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
             icon: Icon(
                Icons.info,
                color: Colors.white
            ),
            onPressed: (){
              //_launchURL;
              Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen()));
            },
          )
        ],
      ),
      body: MapaGoogle()
    );
  }
  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFa5c9fd),
      appBar: new AppBar(
          title: new Text("Info screen"),
          automaticallyImplyLeading: false
      ),
      body: ListView(
          children: <Widget> [
            Image(image: AssetImage('assets/images/Logoprincipal.png')),
            RaisedButton(
              onPressed: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SimScreen()),
                );*/
              },
              child: const Text('Gov information page'),
            )

          ]
      ),
    );
  }
}

class _MapaGoogleState extends State<MapaGoogle> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MAPA'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}

class MapaGoogle extends StatefulWidget {
  @override
  _MapaGoogleState createState() => _MapaGoogleState();
}