import 'dart:convert';

import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyTestimoni());
}

class MyTestimoni extends StatelessWidget {
  String username = "";
  String noBooking = "";
  MyTestimoni({Key key, this.username, this.noBooking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestimoniUser(
        username: username,
        noBooking: noBooking,
      ),
    );
  }
}

class TestimoniUser extends StatefulWidget {
  String username = "";
  String noBooking = "";
  TestimoniUser({Key key, this.username, this.noBooking}) : super(key: key);

  @override
  _TestimoniUserState createState() => _TestimoniUserState();
}

class _TestimoniUserState extends State<TestimoniUser> {
  List rate = [];
  List namaFreelance = [];
  List usernFreelance = [];
  TextEditingController ket = new TextEditingController();
  @override
  void initState() {
    Future<String> fetchDataFreelance() async {
      final url = koneksi.connect('getFreelancePembagianKerja.php?username=' +
          widget.username +
          '&noBooking=' +
          widget.noBooking);
      try {
        Response response = await dio.get(url);
        print("Ini isi response: " + response.toString());
        setState(() {
          var content = json.decode(response.data);

          namaFreelance = content['getFreelance'];
        });

        for (var i = 0; i < namaFreelance.length; i++) {
          usernFreelance.add(namaFreelance[i]['username']);
          rate.add(0.0);
        }
        usernFreelance.add("s");
        rate.add(0.0);
      } catch (e) {
        print(e.toString());
      }
    }

    super.initState();
    print("ini isi widget username: " + widget.username);
    print("ini isi widget no booking: " + widget.noBooking);
    fetchDataFreelance();
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Penilaian freelance';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 2, 5, 2),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Data Freelance: ",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.grey,
                      );
                    },
                    itemCount: namaFreelance.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10,
                                    left:
                                        MediaQuery.of(context).size.width / 10),
                                child: Table(
                                  children: [
                                    TableRow(children: [
                                      Text(
                                        "Nama user",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        ": " +
                                            namaFreelance[index]['nama_user'],
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Rating user",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        ": " +
                                            namaFreelance[index]['nilai']
                                                .toString(),
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ]),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 39),
                                    child: Text(
                                      'Rating: ',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: AbsorbPointer(
                                      absorbing: false,
                                      child: RatingBar(
                                        itemSize: 38,
                                        initialRating: 0.0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          rate[index] = rating;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      var url =
                          koneksi.connect("postTestimoniUserFreelance.php");
                      Response res = await dio.post(url,
                          data: FormData.fromMap({
                            "username": usernFreelance.toString(),
                            "noBooking": widget.noBooking,
                            "rating": rate.toString()
                          }));
                      Fluttertoast.showToast(
                          msg: res.data,
                          timeInSecForIosWeb: 10,
                          toastLength: Toast.LENGTH_LONG);
                    },
                    child: Text(
                      'Kirim',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 2.7,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
