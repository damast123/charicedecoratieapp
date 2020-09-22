import 'dart:convert';

import 'package:charicedecoratieapp/Admin/MakePIC.dart';
import 'package:charicedecoratieapp/api/messaging.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyGiveJob());
}

class MyGiveJob extends StatelessWidget {
  String noBooking = "";
  String username = "";
  MyGiveJob({Key key, this.noBooking, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GiveJob(
        no_booking: noBooking,
        username: username,
      ),
    );
  }
}

class GiveJob extends StatefulWidget {
  String no_booking = "";
  String username = "";
  GiveJob({Key key, this.no_booking, this.username}) : super(key: key);

  @override
  _GiveJobState createState() => _GiveJobState();
}

class _GiveJobState extends State<GiveJob> {
  var dropdownValueFreelance;
  List dataFreelance = [];
  List searchFreelance = [];
  bool setPic = true;
  TextEditingController keterangan = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Future<String> fetchDataFreelance() async {
      try {
        Response response = await dio.get(
            koneksi.connect('getFreelanceBooking.php?no=' + widget.no_booking));
        print("Ini isi response: " + response.toString());
        setState(() {
          var content = json.decode(response.data);
          dataFreelance = content['getFreelance'];
        });
      } catch (e) {
        print(e.toString());
      }
    }

    Future<String> cekPICFreelance() async {
      try {
        Response response = await dio.get(
            koneksi.connect('cekPICFreelance.php?no=' + widget.no_booking));
        print("Ini isi response: " + response.toString());
        if (response.statusCode == 200) {
          setState(() {
            if (response.data == "tidak ada") {
              setPic = true;
            } else {
              setPic = false;
            }
          });
          return 'sukses';
        } else {
          throw Exception('Failed to load post');
        }
      } catch (e) {
        print(e.toString());
      }
    }

    fetchDataFreelance();
    cekPICFreelance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Give Job"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      margin: EdgeInsets.only(right: 20, top: 20, bottom: 10),
                      child: RaisedButton(
                        child: Text(
                          "Make PIC",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: setPic
                            ? () {
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => MyMakePIC(
                                              noBooking:
                                                  widget.no_booking.toString(),
                                              username:
                                                  widget.username.toString(),
                                            )));
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  child: Text("pilih freelance asisten"),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 60,
                  width: MediaQuery.of(context).size.width / 1.15,
                  child: DropdownButton(
                    value: dropdownValueFreelance,
                    isExpanded: true,
                    iconEnabledColor: Colors.black,
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (newValue) {
                      setState(() async {
                        dropdownValueFreelance = newValue;
                        var url = koneksi.connect('searchFreelance.php');
                        Response response = await dio.post(
                          url,
                          data: FormData.fromMap(
                            {
                              "username": dropdownValueFreelance.toString(),
                            },
                          ),
                        );
                        print("Response status: ${response.statusCode}");
                        print("Response body: ${response.data}");
                        Fluttertoast.showToast(msg: response.data);
                        setState(() {
                          var content = json.decode(response.data);

                          searchFreelance = content['getFreelance'];
                        });
                      });
                    },
                    items: dataFreelance.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['nama_user']),
                        value: item['username'].toString(),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 9,
                ),
                new Container(
                  height: 150.0,
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey,
                        );
                      },
                      itemCount:
                          searchFreelance == null ? 0 : searchFreelance.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Table(children: [
                            TableRow(children: [
                              Text(
                                'Nama user',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                ": " + searchFreelance[index]["nama_user"],
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'No telepon',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                ": " + searchFreelance[index]['no_telp'],
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ]),
                            if (searchFreelance[index]['nilai'] == null)
                              TableRow(children: [
                                Text(
                                  'Rating',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Text(
                                  ": 0",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ]),
                            if (searchFreelance[index]['nilai'] != null)
                              TableRow(children: [
                                Text(
                                  'Rating',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Text(
                                  ": " + searchFreelance[index]['nilai'],
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ]),
                          ]),
                        );
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Keterangan",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 20),
                  child: TextField(
                      controller: keterangan,
                      maxLines: 8,
                      decoration: InputDecoration(
                          hintText: "Enter your text in here",
                          border: OutlineInputBorder())),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          'Send to selected freelance',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          var url = koneksi.connect('postPembagianKerja.php');
                          Response response = await dio.post(url,
                              data: FormData.fromMap({
                                "username": searchFreelance[0]['username'],
                                "admin": widget.username,
                                "no_booking": widget.no_booking,
                                "status": "pending",
                                "akses": "asisten",
                                "keterangan": keterangan.text.toString(),
                              }));
                          if (response.data == "sukses") {
                            if (searchFreelance[0]['token'] == null) {
                              Fluttertoast.showToast(
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 15,
                                  msg: response.data +
                                      ". Namun freelance tidak mendapatkan notif. Silahkan kontak freelance tersebut.");
                            } else {
                              sendNotification(searchFreelance[0]['token']);
                              Fluttertoast.showToast(
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 10,
                                  msg: response.data);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future sendNotification(String freelance) async {
    final response = await Messaging.sendTo(
      title: "New job Asisten",
      body: "Ada job baru dari admin ini. Silahkan dicek.",
      fcmToken: freelance,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }
}
