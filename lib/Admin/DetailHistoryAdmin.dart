import 'dart:convert';

import 'package:charicedecoratieapp/Admin/testimoni_user.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyDetailHistoryAdmin());
}

class MyDetailHistoryAdmin extends StatelessWidget {
  String getBooking = "";
  String getIsDone = "";
  MyDetailHistoryAdmin({Key key, this.getBooking, this.getIsDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeDetailHistoryAdmin(
        getBooking: getBooking,
        getIsDone: getIsDone,
      ),
    );
  }
}

class MyHomeDetailHistoryAdmin extends StatefulWidget {
  String getBooking = "";
  String getIsDone = "";
  MyHomeDetailHistoryAdmin({Key key, this.getBooking, this.getIsDone})
      : super(key: key);

  @override
  _MyHomeDetailHistoryAdminState createState() =>
      _MyHomeDetailHistoryAdminState();
}

class _MyHomeDetailHistoryAdminState extends State<MyHomeDetailHistoryAdmin> {
  var setTestimoni = true;
  List dataTestimoni = [];
  List dataBooking = [];
  List dataReqPaket = [];
  List dataPembagianKerja = [];
  var getTesti = "";
  @override
  void initState() {
    Future<String> fetchDataBooking() async {
      try {
        Response response = await dio.get(koneksi.connect(
            'getDetailHistoryBook.php?noBooking=' + widget.getBooking));
        print("Ini isi response: " + response.toString());
        setState(() {
          var content = json.decode(response.data);

          dataBooking = content['getBooking'];
        });
      } catch (e) {
        print(e.toString());
      }
    }

    Future<String> fetchDataReqPaket() async {
      try {
        Response response = await dio.get(koneksi.connect(
            'getRequestPaketAdmin.php?no_booking=' + widget.getBooking));
        print("Ini isi response: " + response.toString());
        if (response.statusCode == 200) {
          setState(() {
            var content = json.decode(response.data);

            dataReqPaket = content['getreqbooking'];
          });

          print("Data req paket: " + dataReqPaket.toString());
        } else {
          throw Exception('Failed to load post');
        }
      } catch (e) {
        print(e.toString());
      }
    }

    Future<String> fetchDataPembagianKerja() async {
      try {
        Response response = await dio.get(koneksi.connect(
            'getStarPembagianKerja.php?no_booking=' + widget.getBooking));
        print("Ini isi response: " + response.toString());
        if (response.statusCode == 200) {
          setState(() {
            var content = json.decode(response.data);

            dataPembagianKerja = content['getPembagian'];
          });

          if (dataPembagianKerja.isEmpty) {
            print("atau masuk sini ");
            setTestimoni = false;
          } else {
            if (dataPembagianKerja[0]['nilai'] == null ||
                dataPembagianKerja[0]['nilai'] == "0") {
              if (dataPembagianKerja[0]['status'] == "freelance") {
                if (widget.getIsDone == "-1") {
                  setTestimoni = false;
                } else {
                  setTestimoni = true;
                }
              } else {
                setTestimoni = false;
              }
            } else {
              print("atau masuk sini ");
              setTestimoni = false;
            }
          }
          print("Data req paket: " + dataReqPaket.toString());
        } else {
          throw Exception('Failed to load post');
        }
      } catch (e) {
        print(e.toString());
      }
    }

    Future<String> fetchDataTestimoni() async {
      try {
        Response response = await dio.get(koneksi.connect(
            'getTestimoniBookingByNoBooking.php?noBooking=' +
                widget.getBooking));
        print("Ini isi response: " + response.toString());
        if (response.statusCode == 200) {
          setState(() {
            var content = json.decode(response.data);

            dataTestimoni = content['getTestimoni'];
          });

          print("Data req paket: " + dataReqPaket.toString());
        } else {
          throw Exception('Failed to load post');
        }
      } catch (e) {
        print(e.toString());
      }
    }

    super.initState();
    fetchDataBooking();
    fetchDataPembagianKerja();
    fetchDataReqPaket();
    fetchDataTestimoni();
    print("Ini widget getIsDone: " + widget.getIsDone);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "No Booking: " + dataBooking[0]['no_booking'],
            style: TextStyle(fontSize: 22),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Detail Booking:",
                    style: TextStyle(fontSize: 20),
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
                  child: Column(
                    children: [
                      Container(
                        child: dataBooking.isEmpty
                            ? Container(
                                child: Center(
                                  child: Text(
                                    "Kosong",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.all(10),
                                child: Table(
                                  children: [
                                    TableRow(children: [
                                      Text(
                                        'Nama Acara',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        ": " + dataBooking[0]['nama_acara'],
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Tanggal Acara",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        ": " + dataBooking[0]['tanggal_acara'],
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Tanggal Transaksi",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      if (dataBooking[0]['tanggal_bayar'] ==
                                          null)
                                        Text(
                                          ": " + 'xxxx-xx-xx',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      if (dataBooking[0]['tanggal_bayar'] !=
                                          null)
                                        Text(
                                          ": " +
                                              dataBooking[0]['tanggal_bayar'],
                                          style: TextStyle(fontSize: 18),
                                        )
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Nama Pemesan",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        ": " + dataBooking[0]['nama_pemesan'],
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Grandtotal",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        ": " + dataBooking[0]['grandtotal'],
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
                                            dataBooking[0]['status_pembayaran'],
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Jumlah Tamu",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        ": " + dataBooking[0]['jumlah_tamu'],
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Status",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      if (dataBooking[0]['_isdone'] == "-1")
                                        Text(
                                          ": " + 'Batal',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      if (dataBooking[0]['_isdone'] == "3")
                                        Text(
                                          ": " + 'Selesai',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                    ]),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Request Paket",
                    style: TextStyle(fontSize: 20),
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
                    child: dataReqPaket.isEmpty
                        ? Center(
                            child: Text(
                              "Kosong",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: Colors.grey,
                              );
                            },
                            itemCount: dataReqPaket.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Table(
                                    children: [
                                      TableRow(children: [
                                        Text(
                                          "Nama Paket",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          ": " +
                                              dataReqPaket[index]['nama_paket'],
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Text(
                                          "Nama Tema",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          ": " +
                                              dataReqPaket[index]['nama_tema'],
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Text(
                                          "Jenis Warna",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          ": " +
                                              dataReqPaket[index]
                                                  ['jenis_warna'],
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Text(
                                          "Rating Paket",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          ": " + dataReqPaket[index]['rating'],
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ]),
                                    ],
                                  ));
                            }),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Testimoni Konsumen",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 25,
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
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width,
                    child: dataTestimoni.isEmpty
                        ? Center(
                            child: Text(
                              "Kosong",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(10),
                            child: Table(
                              children: [
                                TableRow(children: [
                                  Text(
                                    "Tanggal Testimoni",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    ": " +
                                        dataTestimoni[0]['tanggal_testimoni'],
                                    style: TextStyle(fontSize: 18),
                                  )
                                ]),
                                TableRow(children: [
                                  Text(
                                    "Isi Testimoni",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    ": " + dataTestimoni[0]['isi_testimoni'],
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
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Data pekerja:",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width,
                        child: dataPembagianKerja.isEmpty
                            ? Center(
                                child: Text(
                                  "Kosong",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            : ListView.separated(
                                separatorBuilder: (context, z) {
                                  return Divider(
                                    color: Colors.grey,
                                  );
                                },
                                itemCount: dataPembagianKerja.length,
                                itemBuilder: (BuildContext context, int z) {
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    child: Table(
                                      children: [
                                        TableRow(children: [
                                          Text(
                                            "Nama user pengerjaan",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            ": " +
                                                dataPembagianKerja[z]
                                                    ['nama_user'],
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ]),
                                        TableRow(children: [
                                          Text(
                                            "Rating: ",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          if (dataPembagianKerja[z]['nilai'] ==
                                              null)
                                            Text(
                                              ": " + "0.0",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          if (dataPembagianKerja[z]['nilai'] !=
                                              null)
                                            Text(
                                              ": " +
                                                  dataPembagianKerja[z]
                                                      ['nilai'],
                                              style: TextStyle(fontSize: 18),
                                            ),
                                        ]),
                                        TableRow(children: [
                                          Text(
                                            "Akses project",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          if (dataPembagianKerja[z]['akses'] !=
                                              null)
                                            Text(
                                              ": " +
                                                  dataPembagianKerja[z]
                                                      ['akses'],
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          if (dataPembagianKerja[z]['akses'] ==
                                              null)
                                            Text(
                                              ": " + "admin",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                        ]),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: setTestimoni
                      ? () {
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => new MyTestimoni(
                                      username: dataPembagianKerja[0]
                                          ['username'],
                                      noBooking: dataBooking[0]
                                          ['no_booking'])));
                        }
                      : null,
                  child: Text(
                    "Give Rating Freelance",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
