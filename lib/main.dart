import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

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
      appBar: new AppBar(
          title: new Text("Main screen"),
          automaticallyImplyLeading: false
      ),
      body: ListView(
        children: <Widget> [
          Image(image: AssetImage('assets/images/Logoprincipal.png')),
          RaisedButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SimScreen()),
            );
          })
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
          automaticallyImplyLeading: false
      ),
      body: new Center(
          child: new Image(image: AssetImage('assets/images/Logoprincipal.png')),
        //MAPS
      ),
    );
  }
}