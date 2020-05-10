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
              Navigator.push(context, MaterialPageRoute(builder: (context) => MapSampleState()));
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
              _launchURL;
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
  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class MapSampleState extends StatelessWidget {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}