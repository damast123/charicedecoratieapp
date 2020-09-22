import 'dart:convert';

import 'package:charicedecoratieapp/api/messaging.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyMakePIC());
}

class MyMakePIC extends StatelessWidget {
  String noBooking = "";
  String username = "";
  MyMakePIC({Key key, this.noBooking, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MakePIC(
        no_booking: noBooking,
        username: username,
      ),
    );
  }
}

class MakePIC extends StatefulWidget {
  String no_booking = "";
  String username = "";
  MakePIC({Key key, this.no_booking, this.username}) : super(key: key);

  @override
  _MakePICState createState() => _MakePICState();
}

class _MakePICState extends State<MakePIC> {
  var dropdownValueFreelance;
  List dataFreelance = [];
  List searchFreelance = [];
  var namausernames = "";
  var tokenusername = "";
  TextEditingController keterangan = new TextEditingController();
  Future<String> fetchDataFreelance() async {
    try {
      Response response = await dio.get(
          koneksi.connect('getFreelanceBooking.php?no=' + widget.no_booking));
      print("Ini isi response: " + response.toString());
      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.data);

          dataFreelance = content['getFreelance'];
        });
        return 'sukses';
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFreelance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Make PIC"),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  child: Text("pilih freelance PIC"),
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
                        var urlSearch = koneksi.connect('searchFreelance.php');

                        Response res = await dio.post(
                          urlSearch,
                          data: FormData.fromMap(
                            {
                              "username": dropdownValueFreelance.toString(),
                            },
                          ),
                        );
                        print("Response status: ${res.statusCode}");
                        print("Response body: ${res.data}");
                        Fluttertoast.showToast(msg: res.data);
                        setState(() {
                          var content = json.decode(res.data);

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
                    FlatButton(
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
                              "akses": "pic",
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
      title: "New job PIC",
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
