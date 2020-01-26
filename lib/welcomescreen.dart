import 'package:charicedecoratieapp/main.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:async';
import 'dart:io';
void main(){
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

enum ConfirmAction { CANCEL, ACCEPT }
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('No connection internet?'),
        content: const Text(
            'Is there no connection internet? Please check the connection...'),
        actions: <Widget>[
          FlatButton(
            child: const Text('ACCEPT'),
            onPressed: () {
              exit(0);
            },
          )
        ],
      );
    },
  );
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      title: new Text('Welcome To Charicedecoratie_app',
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),),
      image: Image.asset('assets/images/charicedecor.jpg'),
      backgroundColor: Colors.white12,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,

      loaderColor: Colors.red
    );
  }
  onDoneLoading() async {
    try {
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    print('connected');
    Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new Login()));
  }
  } on SocketException catch (_) {
    print('not connected');
    final ConfirmAction action = await _asyncConfirmDialog(context);
  }
    
  }

  
}
