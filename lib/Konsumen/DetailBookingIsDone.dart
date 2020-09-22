import 'dart:convert';

import 'package:charicedecoratieapp/Konsumen/testimony_paket.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyDetailBookDone());
}

class MyDetailBookDone extends StatelessWidget {
  String getBooking = "";
  String getIsDone = "";
  MyDetailBookDone({Key key, this.getBooking, this.getIsDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeDetailBookDone(
        getBooking: getBooking,
        getIsDone: getIsDone,
      ),
    );
  }
}

class MyHomeDetailBookDone extends StatefulWidget {
  String getBooking = "";
  String getIsDone = "";
  MyHomeDetailBookDone({Key key, this.getBooking, this.getIsDone})
      : super(key: key);

  @override
  _MyHomeDetailBookDoneState createState() => _MyHomeDetailBookDoneState();
}

class _MyHomeDetailBookDoneState extends State<MyHomeDetailBookDone> {
  var setTestimoni = true;
  List dataTestimoni = [];
  List dataBooking = [];
  List dataReqPaket = [];
  var getTesti = "";
  @override
  void initState() {
    Future<String> fetchDataBooking() async {
      final url = koneksi
          .connect('getDetailHistoryBook.php?noBooking=' + widget.getBooking);
      Response response = await dio.get(url);
      print(response.data.toString());
      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.data);

          dataBooking = content['getBooking'];
        });

        print("Data booking: " + dataBooking.toString());

        return 'sukses';
      } else {
        throw Exception('Failed to load post');
      }
    }

    Future<String> fetchDataReqPaket() async {
      final urlDataReqPaket = koneksi
          .connect('getRequestPaketAdmin.php?no_booking=' + widget.getBooking);
      Response response = await dio.get(urlDataReqPaket);
      print(response.data.toString());
      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.data);

          dataReqPaket = content['getreqbooking'];
        });

        print("Data req booking: " + dataReqPaket.toString());
      } else {
        throw Exception('Failed to load post');
      }
    }

    Future<String> fetchDataTestimoni() async {
      final urlTestimoni = koneksi.connect(
          'getTestimoniBookingByNoBooking.php?noBooking=' + widget.getBooking);
      Response response = await dio.get(urlTestimoni);
      print(response.data.toString());
      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.data);

          dataTestimoni = content['getTestimoni'];
        });

        print("Data testimoni: " + dataTestimoni.toString());
        if (dataTestimoni.isEmpty) {
          getTesti = "Kosong";
          if (widget.getIsDone == "-1") {
            setTestimoni = false;
            print("masuk sini?");
          } else {
            setTestimoni = true;
            print("apa masuk sini?");
          }
        } else {
          getTesti = "Isi";
          setTestimoni = false;
        }
      } else {
        throw Exception('Failed to load post');
      }
    }

    super.initState();
    fetchDataBooking();
    fetchDataReqPaket();
    fetchDataTestimoni();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("No Booking: " + widget.getBooking),
        ),
        body: Container(
          child: Padding(
              padding: EdgeInsets.all(13),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Detail Booking:",
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 5),
                          child: Column(
                            children: [
                              Container(
                                child: dataBooking.isEmpty
                                    ? Container(
                                        child: Center(
                                          child: Text(
                                            "Kosong",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      )
                                    : Table(
                                        children: [
                                          TableRow(children: [
                                            Text(
                                              'Nama Acara',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              ": " +
                                                  dataBooking[0]['nama_acara'],
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              "Tanggal Acara",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              ": " +
                                                  dataBooking[0]
                                                      ['tanggal_acara'],
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              "Tanggal Transaksi",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            if (dataBooking[0]
                                                    ['tanggal_bayar'] ==
                                                null)
                                              Text(
                                                ": " + 'Tidak ada',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            if (dataBooking[0]
                                                    ['tanggal_bayar'] !=
                                                null)
                                              Text(
                                                ": " +
                                                    dataBooking[0]
                                                        ['tanggal_bayar'],
                                                style: TextStyle(fontSize: 18),
                                              )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              "Nama Pemesan",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              ": " +
                                                  dataBooking[0]
                                                      ['nama_pemesan'],
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              "Grandtotal",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              ": " +
                                                  dataBooking[0]['grandtotal'],
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              "Status Pemesanan",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              ": " +
                                                  dataBooking[0]
                                                      ['status_pembayaran'],
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              "Jumlah Tamu",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              ": " +
                                                  dataBooking[0]['jumlah_tamu'],
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              "Status",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            if (widget.getIsDone == "-1")
                                              Text(
                                                ": " + 'Batal',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            if (widget.getIsDone == "3")
                                              Text(
                                                ": " + 'Selesai',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                          ]),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                "Request Paket",
                                style: TextStyle(fontSize: 18),
                              ),
                              Container(
                                height: 150.0,
                                child: dataReqPaket.isEmpty
                                    ? Center(
                                        child: Text(
                                          "Kosong",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      )
                                    : ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return Divider(
                                            color: Colors.grey,
                                          );
                                        },
                                        itemCount: dataReqPaket.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                              child: Table(
                                            children: [
                                              TableRow(children: [
                                                Text(
                                                  "Nama Paket",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Text(
                                                  ": " +
                                                      dataReqPaket[index]
                                                          ['nama_paket'],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              ]),
                                              TableRow(children: [
                                                Text(
                                                  "Nama Tema",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Text(
                                                  ": " +
                                                      dataReqPaket[index]
                                                          ['nama_tema'],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              ]),
                                              TableRow(children: [
                                                Text(
                                                  "Jenis Warna",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Text(
                                                  ": " +
                                                      dataReqPaket[index]
                                                          ['jenis_warna'],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              ]),
                                              TableRow(children: [
                                                Text(
                                                  "Rating Paket",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Text(
                                                  ": " +
                                                      dataReqPaket[index]
                                                          ['rating'],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              ]),
                                            ],
                                          ));
                                        }),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Testimoni anda:",
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Column(
                          children: [
                            Container(
                              child: dataTestimoni.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Kosong",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )
                                  : Table(
                                      children: [
                                        TableRow(children: [
                                          Text(
                                            "Tanggal Testimoni",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            ": " +
                                                dataTestimoni[0]
                                                    ['tanggal_testimoni'],
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ]),
                                        TableRow(children: [
                                          Text(
                                            "Isi Testimoni",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            ": " +
                                                dataTestimoni[0]
                                                    ['isi_testimoni'],
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ]),
                                        TableRow(children: [
                                          Text(
                                            "Rating",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            ": " + dataTestimoni[0]['star'],
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ]),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 20,
                      child: RaisedButton(
                        onPressed: setTestimoni
                            ? () {
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            new TestimoniPaket(
                                              no_booking: dataBooking[0]
                                                  ['no_booking'],
                                              tanggal: dataBooking[0]
                                                  ['tanggal_acara'],
                                              grandtotal: dataBooking[0]
                                                  ['grandtotal'],
                                            )));
                              }
                            : null,
                        child: Text(
                          "Give Testimoni",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
