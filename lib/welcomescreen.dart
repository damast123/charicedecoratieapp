import 'dart:convert';

import 'package:charicedecoratieapp/RegistAdmin.dart';
import 'package:charicedecoratieapp/main.dart';
import 'package:charicedecoratieapp/model/message.dart';
import 'package:charicedecoratieapp/widgets/Option.dart';
import 'package:charicedecoratieapp/widgets/local_notications_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:charicedecoratieapp/koneksi.dart';

Dio dio = new Dio(options);

void main() {
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final notifications = FlutterLocalNotificationsPlugin();
  final List<Messages> messages = [];

  final String url = koneksi.connect('userLogin.php');
  List data = [];

  void notifOnResume(Map<String, dynamic> message) {
    var content = message['notification'];
    print('content isi: ' + content.toString());
    print('Title notif on resume: ' + content['title']);
    print('body notif on resume: ' + content['body']);
    showOngoingNotification(notifications,
        title: content['title'], body: content['body']);
  }

  Future onSelectNotification(String payload) async {
    notifications.cancel(0);
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  void initState() {
    super.initState();
    // dio.interceptors.add(RertyOnConnect(retryRequest: DioConectyRequestRetry(dio: Dio(),connectivity: Connectivity();)));
    loadData();
    final settingsAndroid = AndroidInitializationSettings('neko');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        notifOnResume(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        notifOnResume(message);
      },
      onResume: (Map<String, dynamic> message) async {
        notifOnResume(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 3,
        title: new Text(
          'Welcome To Charicedecoratie_app',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset('assets/images/charicedecor.jpg'),
        backgroundColor: Colors.white12,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.red);
  }

  onDoneLoading() async {
    try {
      // final result = await InternetAddress.lookup(url);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        try {
          Response response = await dio.get(url);
          print("Ini isi response: " + response.extra.toString());
          print("Ini isi response time out: " +
              response.request.connectTimeout.toString());
          setState(() {
            var content = json.decode(response.data);

            data = content['cekuserlogin'];
          });

          print("ini isi data: " + data.toString());
          if (data.isEmpty) {
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => new MyRegistAdmin()));
          } else {
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => new Login()));
          }
        } catch (e) {
          print(e.toString());
        }

        // Future<String> getData() async {
        //   var res = await http.get(Uri.encodeFull(),
        //       headers: {'accept': 'application/json'});
        //   if (mounted) {
        //     setState(() {
        // var content = json.decode(res.body);

        // data = content['cekuserlogin'];
        // if (data.isEmpty) {
        //   Navigator.of(context, rootNavigator: true).pushReplacement(
        //       MaterialPageRoute(
        //           builder: (context) => new MyRegistAdmin()));
        // } else {
        //   Navigator.of(context, rootNavigator: true).pushReplacement(
        //       MaterialPageRoute(builder: (context) => new Login()));
        // }
        //     });
        //     return 'success!';
        //   }
        // }

        // getData();
      }
    } on SocketException catch (_) {
      print('not connected');
      await _asyncConfirmDialog(context);
    }
  }
}
