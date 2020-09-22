import 'dart:convert';

import 'package:charicedecoratieapp/Admin/add_keterangan_barang.dart';
import 'package:charicedecoratieapp/Admin/home_admin.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(add_paket());
}

class add_paket extends StatelessWidget {
  final usern;
  const add_paket({Key key, this.usern}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: My_add_paket(
        username: usern,
      ),
    );
  }
}

class My_add_paket extends StatefulWidget {
  String username = "";
  My_add_paket({Key key, this.username}) : super(key: key);
  @override
  _My_add_paketState createState() => _My_add_paketState();
}

class _My_add_paketState extends State<My_add_paket>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController forPeopleController = new TextEditingController();
  TextEditingController hargaAwalController = new TextEditingController();
  var ratingController = 0.0;
  var dropdownValueJenis;
  List dataJenis = [];
  Future<String> fetchJenis() async {
    try {
      Response response = await dio.get(koneksi.connect('getJenisPaket.php'));
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        dataJenis = content['jenis'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetchJenis();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Form Add'),
        ),
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/background_image.jpg'),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 270),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(23),
                    child: ListView(
                      children: <Widget>[
                        Container(color: Color(0xfff5f5f5), child: nameField()),
                        Container(
                            color: Color(0xfff5f5f5), child: hargaAwalField()),
                        Container(
                          color: Color(0xfff5f5f5),
                          height: 60,
                          width: MediaQuery.of(context).size.width / 15,
                          child: DropdownButton(
                            value: dropdownValueJenis,
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
                                dropdownValueJenis = newValue;
                                if (dropdownValueJenis == "1") {
                                  forPeopleController.text = "1";
                                } else if (dropdownValueJenis == "2") {
                                  forPeopleController.text = "2";
                                } else if (dropdownValueJenis == "3") {
                                  forPeopleController.text = "10";
                                } else {
                                  forPeopleController.text = "0";
                                }
                              });
                            },
                            items: dataJenis.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['nama_jenis']),
                                value: item['idjenis'].toString(),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                            color: Color(0xfff5f5f5), child: forPeopleField()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 32),
                              child: Text(
                                "Rating:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            AbsorbPointer(
                              absorbing: false,
                              child: RatingBar(
                                initialRating: 0.0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemSize: 38,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  ratingController = rating;
                                  print(ratingController);
                                },
                              ),
                            ),
                          ],
                        ),
                        FlatButton.icon(
                          color: Colors.blue,
                          icon: Icon(
                            Icons.save_alt,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Add keterangan barang',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MyAddKeteranganBarang(),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            onPressed: () async {
                              var a = 0;
                              var url = koneksi.connect("addPacket.php");
                              Response response = await dio.post(url, data: {
                                "nama": nameController.text.toString(),
                                "people": forPeopleController.text.toString(),
                                "hargaawal":
                                    hargaAwalController.text.toString(),
                                "rating": ratingController.toString(),
                                "idjenis": dropdownValueJenis.toString()
                              });
                              print("Response status: ${response.statusCode}");
                              print("Response body: ${response.data}");
                              for (var i = 0;
                                  i < keteranganBarangs.length;
                                  i++) {
                                var urlAdKeterangan =
                                    koneksi.connect("add_keteragan_barang.php");
                                Response responseKeteranganBarang =
                                    await dio.post(urlAdKeterangan,
                                        data: FormData.fromMap({
                                          "nama": keteranganBarangs[i]
                                              .good_names
                                              .toString(),
                                          "warna": keteranganBarangs[i]
                                              .warnas
                                              .toString(),
                                          "jumlah": keteranganBarangs[i]
                                              .jummlah
                                              .toString(),
                                          "idpaket": response.data.toString()
                                        }));
                                a += i;
                                if (a == keteranganBarangs.length) {
                                  Fluttertoast.showToast(msg: "Sukses");
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => home_admin(
                                          username: widget.username,
                                        ),
                                      ),
                                      (Route<dynamic> route) => false);
                                }
                              }
                            },
                            child: Text(
                              'Apply',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'SFUIDisplay',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: Color(0xffff2d55),
                            elevation: 0,
                            minWidth: 400,
                            height: 50,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    return TextFormField(
      controller: nameController,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nama Paket',
          prefixIcon: Icon(Icons.person),
          labelStyle: TextStyle(fontSize: 15)),
    );
  }

  Widget hargaAwalField() {
    return TextFormField(
      controller: hargaAwalController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Harga Awal',
          prefixIcon: Icon(Icons.attach_money),
          labelStyle: TextStyle(fontSize: 15)),
    );
  }

  Widget forPeopleField() {
    return TextFormField(
      controller: forPeopleController,
      keyboardType: TextInputType.number,
      readOnly: true,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Untuk berapa orang',
          prefixIcon: Icon(Icons.people),
          labelStyle: TextStyle(fontSize: 15)),
    );
  }
}
