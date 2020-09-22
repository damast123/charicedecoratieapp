import 'dart:convert';

import 'package:charicedecoratieapp/Admin/Give_job.dart';
import 'package:charicedecoratieapp/Admin/home_admin.dart';
import 'package:charicedecoratieapp/api/messaging.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';

main() {
  runApp(DetailBookCode());
}

var no_telp_konsumen = "";

class DetailBookCode extends StatelessWidget {
  String no_booking = "";
  String username = "";
  String isDone = "";
  DetailBookCode({Key key, this.no_booking, this.username, this.isDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Detail_Booking_Konsumen(
        no_booking: no_booking,
        username: username,
        isDone: isDone,
      ),
    );
  }
}

class Detail_Booking_Konsumen extends StatefulWidget {
  String no_booking = "";
  String username = "";
  String isDone = "";
  Detail_Booking_Konsumen(
      {Key key, this.no_booking, this.username, this.isDone})
      : super(key: key);
  @override
  _Detail_Booking_KonsumenState createState() =>
      _Detail_Booking_KonsumenState();
}

class _Detail_Booking_KonsumenState extends State<Detail_Booking_Konsumen> {
  List getBooking = [];
  List getRequestBook = [];
  List getBarangAdd = [];
  MoneyFormatterOutput fo;
  var setDisable = true;
  var user = "";

  @override
  void initState() {
    super.initState();
    print("no booking: " + widget.no_booking);
    String v = widget.no_booking;
    user = widget.username;
    final String url =
        koneksi.connect('getDataBookingAdmin.php?no_booking=' + v);
    final String urlgetrequest =
        koneksi.connect('getRequestPaketAdmin.php?no_booking=' + v);
    final String urlgetadditional =
        koneksi.connect('getAdditionalAdmin.php?no_booking=' + v);

    Future<String> getData() async {
      try {
        Response response = await dio.get(url);
        print("Ini isi response: " + response.toString());
        setState(() {
          var content = json.decode(response.data);

          getBooking = content['getbooking'];
          fo = FlutterMoneyFormatter(
                  amount: double.parse(getBooking[0]['grandtotal'].toString()))
              .output;
          no_telp_konsumen = getBooking[0]['no_konsumen'].toString();
        });
      } catch (e) {
        print(e.toString());
      }
    }

    Future<String> getDataReq() async {
      try {
        Response response = await dio.get(urlgetrequest);
        print("Ini isi response: " + response.toString());
        setState(() {
          var content = json.decode(response.data);

          getRequestBook = content['getreqbooking'];
        });
      } catch (e) {
        print(e.toString());
      }
    }

    Future<String> getDataAdd() async {
      try {
        Response response = await dio.get(urlgetadditional);
        print("Ini isi response: " + response.toString());
        setState(() {
          var content = json.decode(response.data);

          getBarangAdd = content['getaddbooking'];
        });
      } catch (e) {
        print(e.toString());
      }
    }

    getData();
    getDataAdd();
    getDataReq();
    if (widget.isDone == "1") {
      setDisable = true;
    } else {
      setDisable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var sizeDevice = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detail Booking: " + widget.no_booking),
        ),
        body: WillPopScope(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: sizeDevice.height / 60,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          "  Data Konsumen:",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Text(
                                'Name',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                // "",
                                ": " + getBooking[0]["nama_pemesan"],
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'No telp',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                // "",
                                ": " + getBooking[0]['no_konsumen'],
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          "  Data restoran:",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Text(
                                'Nama restoran',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                // "",
                                ": " + getBooking[0]['alamat'],
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'No telp',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                ": " + getBooking[0]['no_telp'],
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          "  Data event:",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Text(
                                'Name event',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                ": " + getBooking[0]['nama_acara'],
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'For many people: ',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                ": " + getBooking[0]['jumlah_tamu'],
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'Date',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                ": " + getBooking[0]['acara_tanggal'],
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'Start time',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                ": " + getBooking[0]['jam_acara'],
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          "  Detail request paket:",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 150.0,
                        child: getRequestBook.isEmpty
                            ? Container(
                                child: Text("Tidak ada data"),
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: Colors.grey,
                                  );
                                },
                                itemCount: getRequestBook.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Table(
                                        children: [
                                          TableRow(children: [
                                            Text(
                                              'Nama paket',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              ": " +
                                                  getRequestBook[index]
                                                      ["nama_paket"],
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              'Jenis paket',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              ": " +
                                                  getRequestBook[index]
                                                      ["nama_jenis"],
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              'Tema paket',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              ": " +
                                                  getRequestBook[index]
                                                      ["nama_tema"],
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              'Jenis warna',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              ": " +
                                                  getRequestBook[index]
                                                      ["jenis_warna"],
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text('    '),
                                            Text(" ")
                                          ]),
                                          TableRow(children: [
                                            Text('        '),
                                            RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: "Show images",
                                                    recognizer:
                                                        new TapGestureRecognizer()
                                                          ..onTap = () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Jenis Gambar'),
                                                                    content: setupAlertGambar(
                                                                        getRequestBook[index]
                                                                            [
                                                                            'nama_gambar']),
                                                                  );
                                                                });
                                                          },
                                                    style: TextStyle(
                                                      fontFamily: 'SFUIDisplay',
                                                      color: Colors.lightBlue,
                                                      fontSize: 18,
                                                    ))
                                              ]),
                                            ),
                                          ]),
                                        ],
                                      ));
                                }),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          "  Detail barang:",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 150.0,
                        child: getBarangAdd.isEmpty
                            ? Container(
                                child: Text("Tidak ada"),
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: Colors.grey,
                                  );
                                },
                                itemCount: getBarangAdd.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Table(
                                        children: [
                                          TableRow(children: [
                                            Text(
                                              'Nama barang',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              ": " +
                                                  getBarangAdd[index]
                                                      ["nama_aset"],
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              'Jumlah',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              ": " +
                                                  getBarangAdd[index]["jumlah"],
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ]),
                                        ],
                                      ));
                                }),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Align(
                      child: Text(
                        "Bukti transfer:",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    GestureDetector(
                      child: Image.network(
                        koneksi.getImageBukti(getBooking[0]['bukti'] + '.jpg'),
                        height: 480,
                        width: 300,
                        fit: BoxFit.fill,
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Bukti Gambar'),
                                content: setupAlertGambarBukti(
                                    getBooking[0]['bukti']),
                              );
                            });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Grand Total",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Text(
                          "Rp." + fo.nonSymbol,
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.blue[200]),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      child: Wrap(
                        children: [
                          SizedBox(
                            child: RaisedButton(
                              color: Colors.blue,
                              child: Text(
                                'Confirm',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: setDisable
                                  ? () async {
                                      var urlConfirm =
                                          koneksi.connect('updateBooking.php');
                                      Response res = await dio.post(urlConfirm,
                                          data: FormData.fromMap({
                                            "username":
                                                widget.username.toString(),
                                            "no_booking":
                                                widget.no_booking.toString(),
                                            "status": "accept",
                                          }));
                                      sendNotificationKonsumen(
                                          getBooking[0]['token']);
                                      Fluttertoast.showToast(msg: res.data);
                                      Navigator.of(context, rootNavigator: true)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => home_admin(
                                                    username: user,
                                                  )));
                                    }
                                  : null,
                            ),
                            width: MediaQuery.of(context).size.width / 2.5,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            child: RaisedButton(
                              color: Colors.blue,
                              child: Text(
                                'Give job',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: setDisable
                                  ? () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  new MyGiveJob(
                                                    noBooking: widget.no_booking
                                                        .toString(),
                                                    username: widget.username
                                                        .toString(),
                                                  )));
                                    }
                                  : null,
                            ),
                            width: MediaQuery.of(context).size.width / 2.5,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            child: RaisedButton(
                              onPressed: () {
                                whatsAppOpen();
                              },
                              color: Colors.blue,
                              child: Text(
                                'Contact konsumen',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 2.5,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        // FlatButton(
                        //   color: Colors.blue,
                        //   child: Text(
                        //     'Cancel',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        //   onPressed: setDisable
                        //       ? () {
                        //           var url =
                        //               koneksi.connect('updateBooking.php');
                        //           http.post(url, body: {
                        //             "username": widget.username.toString(),
                        //             "no_booking": widget.no_booking.toString(),
                        //             "status": "decline",
                        //             "hakakses": "admin"
                        //           }).then((response) {
                        //             print(
                        //                 "Response status: ${response.statusCode}");
                        //             print("Response body: ${response.body}");
                        //             Navigator.of(context, rootNavigator: true)
                        //                 .pushReplacement(MaterialPageRoute(
                        //                     builder: (context) =>
                        //                         home_admin()));
                        //           });
                        //         }
                        //       : null,
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            onWillPop: () {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacement(MaterialPageRoute(
                      builder: (context) => home_admin(
                            username: user,
                          )));
            }),
      ),
    );
  }

  void whatsAppOpen() async {
    await FlutterLaunch.launchWathsApp(
        phone: no_telp_konsumen,
        message: "Bukti pada no booking: " + widget.no_booking);
  }

  Widget setupAlertGambar(String namagambar) {
    return Container(
      height: 500.0,
      width: 500.0,
      child: Image.network(
        koneksi.getImagePaket(namagambar),
        height: 480,
        width: 480,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget setupAlertGambarBukti(String namagambar) {
    return Container(
      height: 800.0,
      width: 600.0,
      child: Image.network(
        koneksi.getImageBukti(namagambar + '.jpg'),
        height: 720,
        width: 550,
        fit: BoxFit.fill,
      ),
    );
  }

  Future sendNotificationKonsumen(String konsumen) async {
    final response = await Messaging.sendTo(
      title: "Booking " + widget.no_booking + " selesai diproses",
      body:
          "Booking anda telah selesai diproses ini. Terima kasih telah memesan and have a nice day",
      fcmToken: konsumen,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }
}
