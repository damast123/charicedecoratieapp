import 'dart:async';

import 'package:charicedecoratieapp/api/messaging.dart';
import 'package:charicedecoratieapp/main.dart';
import 'package:flutter/material.dart';
import 'widgets/local_notications_helper.dart';
import 'package:charicedecoratieapp/model/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main(List<String> args) {
  runApp(MySendNotif());
}

class MySendNotif extends StatelessWidget {
  const MySendNotif({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titles = "Send Notif";
    return MaterialApp(
      title: titles,
      home: Scaffold(
        appBar: AppBar(
          title: Text(titles),
        ),
        body: SendNotif(),
      ),
    );
  }
}

class SendNotif extends StatefulWidget {
  SendNotif({Key key}) : super(key: key);

  @override
  _SendNotifState createState() => _SendNotifState();
}

class _SendNotifState extends State<SendNotif> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final notifications = FlutterLocalNotificationsPlugin();
  final List<Messages> messages = [];

  void notifOnResume(Map<String, dynamic> message) {
    var content = message['notification'];
    print('content isi: ' + content.toString());
    print('Title notif on resume: ' + content['title']);
    print('body notif on resume: ' + content['body']);
    showOngoingNotification(notifications,
        title: content['title'], body: content['body']);
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('neko');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

    super.initState();
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

  Future sendNotification() async {
    final response = await Messaging.sendTo(
      title: "Ini Title",
      body: "Harus e sudah aman",
      fcmToken:
          "cO-rfi7km7w:APA91bG7O_b2qt0FB5FE4QEOWBJlOK1tKQowVrqXuy9zeSGAi0Hwbhd_eEqvAi3XN4jpGC_IpLEJEpNKcIZgzun1a2G0ofEaLfl5sn27KPVyUirgplCpuztgRIleIEiAHCyk86vsOMB4",
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: sendNotification,
        child: Text('Send notification to all'),
      ),
    );
  }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    // send key to your server to allow server to use
    // this token to send push notifications
  }
}
