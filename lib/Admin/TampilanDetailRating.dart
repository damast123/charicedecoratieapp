import 'dart:convert';

import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:charicedecoratieapp/koneksi.dart';

void main(List<String> args) {
  runApp(MyDetailTamilanRatingUser());
}

class MyDetailTamilanRatingUser extends StatelessWidget {
  String freelance = "";
  MyDetailTamilanRatingUser({Key key, this.freelance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailTampilanRatingUser(
        freelance: freelance,
      ),
    );
  }
}

class DetailTampilanRatingUser extends StatefulWidget {
  String freelance = "";
  DetailTampilanRatingUser({Key key, this.freelance}) : super(key: key);

  @override
  _DetailTampilanRatingUserState createState() =>
      _DetailTampilanRatingUserState();
}

class _DetailTampilanRatingUserState extends State<DetailTampilanRatingUser> {
  List dataFreelance = [];
  Future<String> fetchDataFreelance() async {
    final url = (koneksi.connect(
        'getFreelanceDetailPembagianKerja.php?freelance=' + widget.freelance));

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
          title: Text("Detail Rating freelance"),
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
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey,
                            );
                          },
                          itemCount: dataFreelance.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    dataFreelance[index]['no_booking'],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                20),
                                    child: Table(children: [
                                      TableRow(children: [
                                        Text(
                                          "Nama user",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          ": " +
                                              dataFreelance[index]['nama_user'],
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
                                                dataFreelance[index]['nilai'],
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        if (dataFreelance[index]['nilai'] ==
                                            null)
                                          Text(
                                            ": " + "0",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                      ]),
                                      TableRow(children: [
                                        Text(
                                          "Akses project",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          ": " + dataFreelance[index]['akses'],
                                          style: TextStyle(fontSize: 20),
                                        )
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
