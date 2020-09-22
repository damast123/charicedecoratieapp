import 'dart:math';

import 'package:charicedecoratieapp/enter_new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'koneksi.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:rxdart/subjects.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
String RandomString(int strlen) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  runApp(LupaPass());
}

class LupaPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Lupa password';

    return MaterialApp(
      title: appTitle,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: MyCustomForm(),
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  List data;
  final _formKey = GlobalKey<FormState>();
  var gethashpass = "";
  TextEditingController txtController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  var simpanAngka = "";
  bool _isVisible;
  @override
  void initState() {
    super.initState();
    _isVisible = false;
    var initializationSettingsAndroid = AndroidInitializationSettings('neko');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    FlutterLocalNotificationsPlugin().initialize(initializationSettings,
        onSelectNotification: onSelectNotificationLupaPassword);
    _requestIOSPermissions();
  }

  Future onSelectNotificationLupaPassword(String payload) async {
    FlutterLocalNotificationsPlugin().cancel(0);
    await Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new EnterNewPassword(email: txtController.text.toString())));
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _sizeDevice = MediaQuery.of(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Form(
      key: _formKey,
      child: Stack(
        children: <Widget>[
          Container(
            width: _sizeDevice.size.width,
            height: _sizeDevice.size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/charicedecor.jpg'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter)),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 270, bottom: _sizeDevice.viewInsets.bottom / 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        controller: txtController,
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email or Username',
                            prefixIcon: Icon(Icons.person_outline),
                            labelStyle: TextStyle(fontSize: 15)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter email or username';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          var url = koneksi.connect("lupapass.php");
                          http.post(url, body: {
                            "text": txtController.text.toString()
                          }).then((response) async {
                            print("Response status: ${response.statusCode}");
                            print("Response body: ${response.body}");
                            if (response.body == "Ada") {
                              simpanAngka = RandomString(10);
                              setState(() {
                                _isVisible = true;
                              });
                              await _showNotification();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Email atau username salah...",
                                  timeInSecForIosWeb: 10,
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          });
                        }
                      },
                      child: Text(
                        'Cek',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SFUIDisplay',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Color(0xffff2d55),
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            controller: numberController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Input kode',
                                labelStyle: TextStyle(fontSize: 15)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                if (simpanAngka ==
                                    numberController.text.toString()) {
                                  Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new EnterNewPassword(
                                                  email: txtController.text
                                                      .toString())));
                                } else {
                                  Fluttertoast.showToast(msg: "Salah kode");
                                }
                              }
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'SFUIDisplay',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: Color(0xffff2d55),
                            elevation: 0,
                            minWidth: 400,
                            height: 50,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Kode lupa password',
        'Silahkan masukkan kode ini ' + simpanAngka + ' ke input kode.',
        platformChannelSpecifics,
        payload: 'item x');
  }
}
