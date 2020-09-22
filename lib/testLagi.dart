// import 'dart:convert';
// import 'package:charicedecoratieapp/Konsumen/About.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:charicedecoratieapp/helpers/dbhelpers.dart';
// // import 'package:charicedecoratieapp/koneksi.dart';
// // import 'package:charicedecoratieapp/models/barang.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:rxdart/subjects.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:sqflite/sqflite.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReceivedNotification>();

// final BehaviorSubject<String> selectNotificationSubject =
//     BehaviorSubject<String>();

// NotificationAppLaunchDetails notificationAppLaunchDetails;

// class ReceivedNotification {
//   final int id;
//   final String title;
//   final String body;
//   final String payload;

//   ReceivedNotification({
//     @required this.id,
//     @required this.title,
//     @required this.body,
//     @required this.payload,
//   });
// }
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const kGoogleApiKey = "AIzaSyBFib6U1jD41vFahReMNicey6c_7DVerl4";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

void main() {
  runApp(TestLagiLah());
}

class TestLagiLah extends StatelessWidget {
  const TestLagiLah({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTest(),
    );
  }
}

class MyTest extends StatefulWidget {
  MyTest({Key key}) : super(key: key);

  @override
  _MyTestState createState() => _MyTestState();
}

class _MyTestState extends State<MyTest> {
  List book = [];
  DateTime tanggal_awal = DateTime.now();
  DateTime tanggal_akhir = DateTime.now();
  var setButton = true;
  var dateAfter = false;
  @override
  void initState() {
    super.initState();
    final String url =
        koneksi.connect('searchBooking.php?no_booking=B/2020/05/31/001');
    Future<String> getData() async {
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      if (mounted) {
        setState(() {
          var content = json.decode(res.body);

          book = content['searchbooking'];
          print("ini isi book: " + book.toString());
          tanggal_awal = DateTime.parse(book[0]['tanggal_acara']);
          tanggal_akhir = tanggal_awal.subtract(Duration(days: 1));
          dateAfter = DateTime.now().isAfter(tanggal_akhir);
          if (dateAfter == true) {
            //masukkan php post update pembayaran dan booking gagal
            setState(() {
              setButton = false;
            });
          } else {
            setState(() {
              setButton = true;
            });
          }
          print("ini isi date after: " + dateAfter.toString());
        });
        return 'success!';
      }
    }

    getData();
  }

  void onError(PlacesAutocompleteResponse response) {
    print("response error message: " + response.errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ini Test"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Text("ini isi tanggal acara: " + book[0]['tanggal_acara']),
              // SizedBox(
              //   height: 25,
              // ),
              // Text("ini isi tanggal terakhir: " + tanggal_akhir.toString()),
              // SizedBox(
              //   height: 25,
              // ),
              // RaisedButton(
              //     elevation: 0.0,
              //     color: Colors.blueAccent,
              //     child: Text(
              //       'Re Schedule',
              //     ),
              //     onPressed: setButton
              //         ? () {
              //             Fluttertoast.showToast(msg: "bisa ditekan kk.");
              //           }
              //         : null),
              RaisedButton(
                child: Text("place auto complate"),
                onPressed: () async {
                  Prediction p = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: kGoogleApiKey,
                      language: "id",
                      onError: onError
                      // components: [
                      //   Component(Component.country, "id"),
                      // ],
                      );
                  displayPrediction(p);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      final resl = detail.result.adrAddress.toString();
      final nama = detail.result.name.toString();
      print("resl ini: " + resl);
      print("nama ini: " + nama);
    }
  }
}
