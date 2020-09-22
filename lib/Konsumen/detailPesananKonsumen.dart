import 'dart:convert';

import 'package:charicedecoratieapp/Konsumen/ReSchedule.dart';
import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/api/messaging.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:charicedecoratieapp/whiteSpace.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyDetailPesanPaketKonsumen());
}

class MyDetailPesanPaketKonsumen extends StatelessWidget {
  String noBooking = "";

  MyDetailPesanPaketKonsumen({Key key, this.noBooking}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Pesan Paket';

    return MaterialApp(
      title: appTitle,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: Detail_Pesan_Paket(
            no_booking: noBooking,
          ),
        ),
      ),
    );
  }
}

class Detail_Pesan_Paket extends StatefulWidget {
  String no_booking = "";

  Detail_Pesan_Paket({Key key, this.no_booking}) : super(key: key);
  @override
  _Detail_Pesan_PaketState createState() => _Detail_Pesan_PaketState();
}

class _Detail_Pesan_PaketState extends State<Detail_Pesan_Paket>
    with SingleTickerProviderStateMixin {
  bool isChecked = false;
  var isSelesai = true;
  List book = [];
  List profile = [];
  List profileAdmin = [];
  var dateNow;
  Future<String> fetchDataAdmin() async {
    final urlGetAdmin = koneksi
        .connect('getAdminReschedule.php?no_booking=' + widget.no_booking);
    Response response = await dio.get(urlGetAdmin);
    print(response.data.toString());
    if (response.statusCode == 200) {
      setState(() {
        var content = json.decode(response.data);

        profileAdmin = content['data_admin'];
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    final _selectedDay = DateTime.now();
    dateNow = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final String url = koneksi.connect(
        'getDetailHistoryBook.php?noBooking=' + widget.no_booking.toString());
    Future<String> getData() async {
      Response response = await dio.get(url);
      print(response.data.toString());
      setState(() {
        var content = json.decode(response.data);

        book = content['getBooking'];
      });

      DateTime eventDate = DateTime.parse(book[0]['tanggal_acara']);
      var tanggalAcara = DateFormat('yyyy-MM-dd').format(eventDate);
      if (tanggalAcara != dateNow) {
        isSelesai = false;
        isChecked = true;
      } else {
        isSelesai = true;
        isChecked = false;
      }
    }

    getData();
    this.fetchDataAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(15.0),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background_image.jpg'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(
                top: 210, bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
                    ),
                    Table(
                      children: [
                        TableRow(children: [
                          Text(
                            'Nama Acara',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            ": " + book[0]['nama_acara'],
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            "Tanggal Acara",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            ": " + book[0]['tanggal_acara'],
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            "Nama Pemesan",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            ": " + book[0]['nama_pemesan'],
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            "Tanggal bayar",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            ": " + book[0]['tanggal_bayar'],
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            "Grandtotal",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            ": " + book[0]['grandtotal'],
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            "Status Pemesanan",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            ": " + book[0]['status_pembayaran'],
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            "Jumlah Tamu",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            ": " + book[0]['jumlah_tamu'],
                            style: TextStyle(fontSize: 16),
                          )
                        ]),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              'Re Schedule',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: isChecked
                                ? () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) =>
                                                new MyReschedule(
                                                  noBooking: widget.no_booking
                                                      .toString(),
                                                  user: book[0]
                                                      ['username_konsumen'],
                                                )));
                                  }
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              'Selesai',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: isSelesai
                                ? () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Are you sure?"),
                                            content: Text(
                                                "Are you sure this booking " +
                                                    widget.no_booking +
                                                    " is done?"),
                                            actions: [
                                              FlatButton(
                                                child: Text("Yes"),
                                                onPressed: () async {
                                                  var url = koneksi.connect(
                                                      'selesaiBookingKonsumen.php');
                                                  Response response =
                                                      await dio.post(url,
                                                          data:
                                                              FormData.fromMap({
                                                            "no_booking": widget
                                                                .no_booking
                                                          }));
                                                  Fluttertoast.showToast(
                                                      msg: response.data);
                                                  sendNotificationSelesai();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    WhiteSpace(
                                                              nama: book[0][
                                                                  'username_konsumen'],
                                                            ),
                                                          ),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text("No"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                : null,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future sendNotificationSelesai() async {
    for (var i = 0; i < profileAdmin.length; i++) {
      final response = await Messaging.sendTo(
        title: "Booking: " + widget.no_booking,
        body:
            "Acara pada booking ini telah selesai. Silahkan bisa diambil barang tersebut.",
        fcmToken: profileAdmin[i]['token'],
      );

      if (response.statusCode != 200) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content:
              Text('[${response.statusCode}] Error message: ${response.body}'),
        ));
      }
    }
  }
}
