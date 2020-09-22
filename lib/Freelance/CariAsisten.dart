import 'dart:convert';

import 'package:charicedecoratieapp/Freelance/home_freelance.dart';
import 'package:charicedecoratieapp/api/messaging.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyCariAsisten());
}

class MyCariAsisten extends StatelessWidget {
  String noBooking = "";
  String username = "";
  MyCariAsisten({Key key, this.noBooking, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CariAsisten(
        no_booking: noBooking,
        username: username,
      ),
    );
  }
}

class CariAsisten extends StatefulWidget {
  String no_booking = "";
  String username = "";
  CariAsisten({Key key, this.no_booking, this.username}) : super(key: key);

  @override
  _CariAsistenState createState() => _CariAsistenState();
}

class _CariAsistenState extends State<CariAsisten> {
  var dropdownValueFreelance;
  List dataFreelance = [];
  List searchFreelance = [];
  TextEditingController keterangan = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Future<String> fetchDataFreelance() async {
      final response = await http.get(
          koneksi.connect('getFreelanceBooking.php?no=' + widget.no_booking));

      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.body);

          dataFreelance = content['getFreelance'];
        });
        return 'sukses';
      } else {
        throw Exception('Failed to load post');
      }
    }

    fetchDataFreelance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cari Asisten"),
        ),
        body: WillPopScope(
          onWillPop: () {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => home_freelance(
                    username: widget.username,
                  ),
                ),
                (Route<dynamic> route) => false);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
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
                        setState(() {
                          dropdownValueFreelance = newValue;
                          var url = koneksi.connect('searchFreelance.php');
                          http.post(url, body: {
                            "username": dropdownValueFreelance.toString(),
                          }).then((response) {
                            print("Response status: ${response.statusCode}");
                            print("Response body: ${response.body}");
                            Fluttertoast.showToast(msg: response.body);
                            setState(() {
                              var content = json.decode(response.body);

                              searchFreelance = content['getFreelance'];
                            });
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
                        itemCount: searchFreelance == null
                            ? 0
                            : searchFreelance.length,
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
                          onPressed: () {
                            var url = koneksi.connect('postPembagianKerja.php');
                            http.post(url, body: {
                              "username": searchFreelance[0]['username'],
                              "admin": widget.username,
                              "no_booking": widget.no_booking,
                              "status": "pending",
                              "akses": "asisten",
                              "keterangan": keterangan.text.toString(),
                            }).then((response) {
                              print("Response status: ${response.statusCode}");
                              print("Response body: ${response.body}");
                              if (response.body == "sukses") {
                                sendNotification(searchFreelance[0]['token']);
                              }
                              Fluttertoast.showToast(msg: response.body);
                            });
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
      ),
    );
  }

  Future sendNotification(String freelance) async {
    final response = await Messaging.sendTo(
      title: "New job",
      body: "Ada job baru. silahkan dicek.",
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
