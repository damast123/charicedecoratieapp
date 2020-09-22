import 'dart:convert';

import 'package:charicedecoratieapp/Freelance/CariAsisten.dart';
import 'package:charicedecoratieapp/Freelance/home_freelance.dart';
import 'package:charicedecoratieapp/api/messaging.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

main() {
  runApp(DetailBookCodeFreelance());
}

class DetailBookCodeFreelance extends StatelessWidget {
  String no_booking = "";
  String username = "";
  String isDone = "";
  DetailBookCodeFreelance(
      {Key key, this.no_booking, this.username, this.isDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyDetailBookCodeFreelance(
        no_booking: no_booking,
        username: username,
        isDone: isDone,
      ),
    );
  }
}

class MyDetailBookCodeFreelance extends StatefulWidget {
  String no_booking = "";
  String username = "";
  String isDone = "";
  MyDetailBookCodeFreelance(
      {Key key, this.no_booking, this.username, this.isDone})
      : super(key: key);
  @override
  _MyDetailBookCodeFreelanceState createState() =>
      _MyDetailBookCodeFreelanceState();
}

class _MyDetailBookCodeFreelanceState extends State<MyDetailBookCodeFreelance> {
  List getBooking = [];
  List getRequestBook = [];
  List getBarangAdd = [];
  List getPembagian = [];
  TextEditingController ket = new TextEditingController();
  TextEditingController alasanController = new TextEditingController();
  MoneyFormatterOutput fo;
  var setDisable = true;
  var user = "";
  var token_ADMIN = "";
  var akses = "";

  @override
  void initState() {
    super.initState();
    print("no booking: " + widget.no_booking);
    String v = widget.no_booking;
    user = widget.username;
    final String url =
        koneksi.connect('getDataBookingAdmin.php?no_booking=' + v);
    final String urlPembagianKerja = koneksi.connect(
        'get_pembagian_kerja.php?no_booking=' + v + "&username=" + user);
    final String urlgetrequest =
        koneksi.connect('getRequestPaketAdmin.php?no_booking=' + v);
    final String urlgetadditional =
        koneksi.connect('getAdditionalAdmin.php?no_booking=' + v);
    Future<String> getData() async {
      var res = await http.get(Uri.encodeFull(url), headers: {
        'accept': 'application/json',
        "content-type": "application/json"
      });
      if (mounted) {
        setState(() {
          var content = json.decode(res.body);

          getBooking = content['getbooking'];
          fo = FlutterMoneyFormatter(
                  amount: double.parse(getBooking[0]['grandtotal'].toString()))
              .output;
          print("ini isi getBooking: " + getBooking.toString());
        });

        return 'success!';
      }
    }

    Future<String> getDataPembagian() async {
      var res = await http.get(Uri.encodeFull(urlPembagianKerja), headers: {
        'accept': 'application/json',
        "content-type": "application/json"
      });
      if (mounted) {
        setState(() {
          var content = json.decode(res.body);

          getPembagian = content['pembagian'];
          ket.text = getPembagian[0]['keterangan'];
          //akses
          akses = getPembagian[0]['akses'];
          print("ini isi akses: " + akses);
        });

        return 'success!';
      }
    }

    Future<String> getDataReq() async {
      var res = await http.get(Uri.encodeFull(urlgetrequest), headers: {
        'accept': 'application/json',
        "content-type": "application/json"
      });
      if (mounted) {
        setState(() {
          var content = json.decode(res.body);

          getRequestBook = content['getreqbooking'];
        });

        return 'success!';
      }
    }

    Future<String> getDataAdd() async {
      var res = await http.get(Uri.encodeFull(urlgetadditional), headers: {
        'accept': 'application/json',
        "content-type": "application/json"
      });
      if (mounted) {
        setState(() {
          var content = json.decode(res.body);

          getBarangAdd = content['getaddbooking'];
        });

        return 'success!';
      }
    }

    final String urlgetokenAdmin =
        koneksi.connect('get_token_admin.php?no_booking=' + v);
    Future<String> getokenAdmin() async {
      var res = await http.get(Uri.encodeFull(urlgetokenAdmin), headers: {
        'accept': 'application/json',
        "content-type": "application/json"
      });
      if (mounted) {
        setState(() {
          token_ADMIN = res.body;
        });

        return 'success!';
      }
    }

    getData();
    getDataAdd();
    getokenAdmin();
    getDataReq();
    getDataPembagian();
    if (widget.isDone == "1") {
      setDisable = true;
    } else {
      setDisable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var sizeDevice = MediaQuery.of(context).size;
    Widget child;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detail Booking" + widget.no_booking),
        ),
        body: WillPopScope(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (getPembagian[0]['akses'] == "pic")
                      Column(
                        children: [
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            padding: EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                            child: Table(
                                              children: [
                                                TableRow(children: [
                                                  Text(
                                                    'Nama paket',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Text(
                                                    ": " +
                                                        getRequestBook[index]
                                                            ["nama_paket"],
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )
                                                ]),
                                                TableRow(children: [
                                                  Text(
                                                    'Jenis paket',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Text(
                                                    ": " +
                                                        getRequestBook[index]
                                                            ["nama_jenis"],
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )
                                                ]),
                                                TableRow(children: [
                                                  Text(
                                                    'Tema paket',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Text(
                                                    ": " +
                                                        getRequestBook[index]
                                                            ["nama_tema"],
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )
                                                ]),
                                                TableRow(children: [
                                                  Text(
                                                    'Jenis warna',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Text(
                                                    ": " +
                                                        getRequestBook[index]
                                                            ["jenis_warna"],
                                                    style:
                                                        TextStyle(fontSize: 20),
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
                                                                          title:
                                                                              Text('Jenis Gambar'),
                                                                          content:
                                                                              setupAlertGambar(getRequestBook[index]['nama_gambar']),
                                                                        );
                                                                      });
                                                                },
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'SFUIDisplay',
                                                            color: Colors
                                                                .lightBlue,
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            padding: EdgeInsets.all(20.0),
                                            child: Table(
                                              children: [
                                                TableRow(children: [
                                                  Text(
                                                    'Nama barang',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Text(
                                                    ": " +
                                                        getBarangAdd[index]
                                                            ["nama_aset"],
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )
                                                ]),
                                                TableRow(children: [
                                                  Text(
                                                    'Jumlah',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Text(
                                                    ": " +
                                                        getBarangAdd[index]
                                                            ["jumlah"],
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )
                                                ]),
                                              ],
                                            ));
                                      }),
                            ),
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
                                style: TextStyle(fontSize: 20.0),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "Keterangan:",
                                  style: TextStyle(fontSize: 20),
                                ),
                                TextField(
                                  controller: ket,
                                  maxLines: 8,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: setDisable
                                      ? () {
                                          var url = koneksi.connect(
                                              'UpdatePembagianKerja.php');
                                          http.post(url, body: {
                                            "username":
                                                widget.username.toString(),
                                            "no_booking":
                                                widget.no_booking.toString(),
                                            "status": "acc",
                                            "akses": "pic",
                                          }).then((response) {
                                            print(
                                                "Response status: ${response.statusCode}");
                                            print(
                                                "Response body: ${response.body}");
                                            if (response.body == "gagal") {
                                              Fluttertoast.showToast(
                                                  msg: response.body);
                                            } else {
                                              sendNotificationKonsumen(
                                                  getBooking[0]['token']);
                                              Fluttertoast.showToast(
                                                  msg: "sukses");
                                            }
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  child: Text(
                                    "Decline",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: setDisable
                                      ? () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Cancel?'),
                                                  content: Container(
                                                    height: 300.0,
                                                    width: 400.0,
                                                    child: TextField(
                                                      maxLines: 2,
                                                      controller:
                                                          alasanController,
                                                    ),
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                        onPressed: () async {
                                                          sendNotificationDecline(
                                                              token_ADMIN,
                                                              alasanController
                                                                  .text
                                                                  .toString());
                                                          Fluttertoast
                                                              .showToast(
                                                                  msg:
                                                                      "sukses");
                                                          var url = koneksi.connect(
                                                              'UpdatePembagianKerja.php');
                                                          http.post(url, body: {
                                                            "username": widget
                                                                .username
                                                                .toString(),
                                                            "no_booking": widget
                                                                .no_booking
                                                                .toString(),
                                                            "status": "decline",
                                                            "akses": "pic",
                                                          }).then((response) {
                                                            print(
                                                                "Response status: ${response.statusCode}");
                                                            print(
                                                                "Response body: ${response.body}");
                                                            if (response.body ==
                                                                "gagal") {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg: response
                                                                          .body);
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Sukses");
                                                            }
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text("Ok"))
                                                  ],
                                                );
                                              });
                                        }
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  child: Text(
                                    "Search asisten",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: setDisable
                                      ? () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CariAsisten(
                                                            no_booking: widget
                                                                .no_booking,
                                                            username:
                                                                widget.username,
                                                          )));
                                        }
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    //ini asisten
                    if (getPembagian[0]['akses'] == "asisten")
                      Column(
                        children: [
                          SizedBox(
                            height: sizeDevice.height / 60,
                          ),
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
                          SizedBox(
                            height: 18,
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
                                  fontSize: 20.0,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "Keterangan:",
                                  style: TextStyle(fontSize: 20),
                                ),
                                TextField(
                                  controller: ket,
                                  maxLines: 8,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: RaisedButton(
                                  child: Text("Confirm"),
                                  onPressed: setDisable
                                      ? () {
                                          var url = koneksi.connect(
                                              'UpdatePembagianKerja.php');
                                          http.post(url, body: {
                                            "username":
                                                widget.username.toString(),
                                            "no_booking":
                                                widget.no_booking.toString(),
                                            "status": "acc",
                                            "akses": "asisten",
                                          }).then((response) {
                                            print(
                                                "Response status: ${response.statusCode}");
                                            print(
                                                "Response body: ${response.body}");
                                            if (response.body == "gagal") {
                                              Fluttertoast.showToast(
                                                  msg: response.body);
                                            } else {
                                              sendNotificationAcc(
                                                  response.body);
                                              Fluttertoast.showToast(
                                                  msg: "sukses");
                                            }
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: RaisedButton(
                                  child: Text("Decline"),
                                  onPressed: setDisable
                                      ? () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Cancel?'),
                                                  content: Container(
                                                    height: 300.0,
                                                    width: 400.0,
                                                    child: TextField(
                                                      maxLines: 2,
                                                      controller:
                                                          alasanController,
                                                    ),
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                        onPressed: () async {
                                                          sendNotificationDecline(
                                                              token_ADMIN,
                                                              alasanController
                                                                  .text
                                                                  .toString());
                                                          var url = koneksi.connect(
                                                              'UpdatePembagianKerja.php');
                                                          http.post(url, body: {
                                                            "username": widget
                                                                .username
                                                                .toString(),
                                                            "no_booking": widget
                                                                .no_booking
                                                                .toString(),
                                                            "status": "decline",
                                                            "akses": "asisten",
                                                          }).then((response) {
                                                            print(
                                                                "Response status: ${response.statusCode}");
                                                            print(
                                                                "Response body: ${response.body}");
                                                            if (response.body ==
                                                                "gagal") {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg: response
                                                                          .body);
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Sukses");
                                                            }
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text("Ok"))
                                                  ],
                                                );
                                              });
                                        }
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    //sampe sini
                  ],
                ),
              ),
            ),
            onWillPop: () {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacement(MaterialPageRoute(
                      builder: (context) => home_freelance(
                            username: user,
                          )));
            }),
      ),
    );
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

  void whatsAppOpen() async {
    await FlutterLaunch.launchWathsApp(phone: "+6281357999781", message: "");
  }

  Future sendNotificationDecline(String admin, String alasan) async {
    final response = await Messaging.sendTo(
      title: "Booking: " + getBooking[0]['no_booking'],
      body: "freelance ini menolak karena:\n" + alasan,
      fcmToken: admin,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  Future sendNotificationKonsumen(String konsumen) async {
    final response = await Messaging.sendTo(
      title: "Booking " + getBooking[0]['no_booking'] + " selesai diproses",
      body:
          "Booking anda telah selesai diproses.\nSilahkan menunggu hingga event acara anda. Terima kasih.",
      fcmToken: konsumen,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  Future sendNotificationAcc(String admin) async {
    final response = await Messaging.sendTo(
      title: "Booking: " + getBooking[0]['no_booking'],
      body: "Booking ini telah diterima oleh freelance.",
      fcmToken: admin,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }
}
