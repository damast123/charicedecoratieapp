import 'dart:convert';

import 'package:charicedecoratieapp/Admin/TampilanDetailRating.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:charicedecoratieapp/koneksi.dart';

void main(List<String> args) {
  runApp(MyTamilanRatingUser());
}

class MyTamilanRatingUser extends StatelessWidget {
  const MyTamilanRatingUser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TampilanRatingUser(),
    );
  }
}

class TampilanRatingUser extends StatefulWidget {
  TampilanRatingUser({Key key}) : super(key: key);

  @override
  _TampilanRatingUserState createState() => _TampilanRatingUserState();
}

class _TampilanRatingUserState extends State<TampilanRatingUser> {
  List dataFreelance = [];
  Future<String> fetchDataFreelance() async {
    final url = koneksi.connect('getFreelance.php');

    try {
      Response response = await dio.get(url);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        dataFreelance = content['getFreelance'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetchDataFreelance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Rating freelance"),
        ),
        body: Container(
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
                    top: 270, bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                    padding: EdgeInsets.all(23),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1,
                      width: MediaQuery.of(context).size.width / 1,
                      child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey,
                            );
                          },
                          itemCount: dataFreelance.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new MyDetailTamilanRatingUser(
                                              freelance: dataFreelance[index]
                                                  ['username'],
                                            )));
                              },
                              child: Container(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                20),
                                        child: Table(children: [
                                          TableRow(children: [
                                            Text(
                                              "Nama user",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              ": " +
                                                  dataFreelance[index]
                                                      ['nama_user'],
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              "Rating",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            if (dataFreelance[index]['nilai'] !=
                                                null)
                                              Text(
                                                ": " +
                                                    dataFreelance[index]
                                                        ['nilai'],
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            if (dataFreelance[index]['nilai'] ==
                                                null)
                                              Text(
                                                ": " + "0",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                          ]),
                                        ]),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: RatingBar(
                                            itemSize: 38,
                                            initialRating: double.parse(
                                              dataFreelance[index]['nilai'],
                                            ),
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
