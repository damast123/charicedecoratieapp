import 'dart:convert';

import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  runApp(MyDetailHistoryFreelance());
}

class MyDetailHistoryFreelance extends StatelessWidget {
  String getBooking = "";
  String getIsDone = "";
  String getFreelance = "";
  MyDetailHistoryFreelance(
      {Key key, this.getBooking, this.getIsDone, this.getFreelance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeDetailHistoryFreelance(
        getBooking: getBooking,
        getIsDone: getIsDone,
        getFreelance: getFreelance,
      ),
    );
  }
}

class MyHomeDetailHistoryFreelance extends StatefulWidget {
  String getBooking = "";
  String getIsDone = "";
  String getFreelance = "";
  MyHomeDetailHistoryFreelance(
      {Key key, this.getBooking, this.getIsDone, this.getFreelance})
      : super(key: key);

  @override
  _MyHomeDetailHistoryFreelanceState createState() =>
      _MyHomeDetailHistoryFreelanceState();
}

class _MyHomeDetailHistoryFreelanceState
    extends State<MyHomeDetailHistoryFreelance> {
  List dataTestimoni = [];
  List dataBooking = [];
  List dataPembagianKerja = [];

  @override
  void initState() {
    print("ini isi freelance: " + widget.getFreelance);
    print("ini isi booking: " + widget.getBooking);
    Future<String> fetchDataBooking() async {
      final response = await http.get(koneksi
          .connect('getDetailHistoryBook.php?noBooking=' + widget.getBooking));

      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.body);

          dataBooking = content['getBooking'];
          print("Data booking: " + dataBooking.toString());
        });
        return 'sukses';
      } else {
        print(response.statusCode);
      }
    }

    Future<String> fetchDataPembagianKerja() async {
      final response = await http.get(koneksi.connect(
          'getFreelanceDetailPembagianKerja.php?freelance=' +
              widget.getFreelance +
              "&no_booking=" +
              widget.getBooking));

      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.body);

          dataPembagianKerja = content['getFreelance'];
          print("Data pembagian kerja: " + dataPembagianKerja.toString());
        });
        return 'sukses';
      } else {
        print(response.statusCode);
      }
    }

    super.initState();
    fetchDataBooking();
    fetchDataPembagianKerja();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("No Booking: " + widget.getBooking),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
