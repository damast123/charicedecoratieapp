import 'dart:convert';

import 'package:charicedecoratieapp/helpers/dbhelpers.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/models/barang.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(addAdditional());
}

class addAdditional extends StatelessWidget {
  String idpaket = "";
  int jumlah = 0;
  addAdditional({Key key, this.idpaket, this.jumlah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyaddAdditional(
        idpaket: idpaket,
        jumlahs: jumlah,
      ),
    );
  }
}

class MyaddAdditional extends StatefulWidget {
  String idpaket = "";
  int jumlahs = 0;
  MyaddAdditional({Key key, this.idpaket, this.jumlahs}) : super(key: key);
  @override
  _addAdditionalState createState() => _addAdditionalState();
}

class _addAdditionalState extends State<MyaddAdditional> {
  final String url = koneksi.connect('getAdditional.php');

  DatabaseHelper _helper = DatabaseHelper();
  Future<List<Barang>> future;
  Map<String, dynamic> formData;
  Barang isiBarang;
  int jumlahS = 0;
  var dropdownValue;
  TextEditingController jumlahController = new TextEditingController();
  Map<String, dynamic> formId;
  List barang = [];

  Future<String> getData() async {
    Response response = await dio.get(url);
    print(response.data.toString());
    setState(() {
      var content = json.decode(response.data);

      barang = content['additional'];
    });
  }

  var checkusername = "";

  _loadSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkusername = prefs.getString('username') ?? "";
    });
  }

  @override
  void initState() {
    this.getData();
    super.initState();
    _loadSessionUser();
    updateListView();
    print("Ini isi jumlah: " + widget.jumlahs.toString());
  }

  Card cardo(Barang barang) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        subtitle: Column(
          children: <Widget>[
            Text(
              barang.good_name,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            Text(
              barang.good_jumlah.toString(),
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Rp." + barang.good_harga.toString(),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        trailing: GestureDetector(
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.red,
          ),
          onTap: () async {
            int result = await _helper.deletebarangs(barang);
            if (result > 0) {
              updateListView();
            }
          },
        ),
      ),
    );
  }

  void updateListView() {
    setState(() {
      future = _helper.getBarangById(widget.idpaket, checkusername);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Pesan Paket Konsumen"),
          ),
          body: WillPopScope(
            child: Container(
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
                            image: AssetImage(
                                'assets/images/background_image.jpg'),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.only(
                        top: 230,
                        bottom: MediaQuery.of(context).viewInsets.bottom / 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(23),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 20,
                            ),
                            Text(
                              "Nama barang:",
                              style: TextStyle(fontSize: 19),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              width: MediaQuery.of(context).size.width / 1,
                              height: 60,
                              child: DropdownButton(
                                value: dropdownValue,
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
                                    dropdownValue = newValue;
                                  });
                                },
                                items: barang.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['nama_aset']),
                                    value: item['idm_asset'].toString() +
                                        "," +
                                        item['nama_aset'].toString() +
                                        "," +
                                        item["harga_rata_rata"],
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 19,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              width: MediaQuery.of(context).size.width / 1,
                              child: new TextField(
                                keyboardType: TextInputType.number,
                                controller: jumlahController,
                              ),
                            ),
                            SizedBox(
                              height: 19,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: RaisedButton(
                                color: Colors.green,
                                onPressed: () async {
                                  String val = dropdownValue.toString();
                                  List stringVal = val.split(",");
                                  print(stringVal);
                                  var url = koneksi
                                      .connect('checkBarangAlternatif.php');
                                  http.post(url, body: {
                                    "namabarang": stringVal[1].toString(),
                                    "idbarang": stringVal[0].toString(),
                                    "jumlah": jumlahController.text.toString(),
                                  }).then((response) async {
                                    print(
                                        "Response status: ${response.statusCode}");
                                    print("Response body: ${response.body}");
                                    if (response.body == "Ok") {
                                      if (stringVal[0] == "84" ||
                                          stringVal[0] == "85" ||
                                          stringVal[0] == "122") {
                                        isiBarang = Barang(
                                            stringVal[1].toString(),
                                            stringVal[0].toString(),
                                            int.parse(jumlahController.text
                                                .toString()),
                                            15000,
                                            widget.jumlahs,
                                            widget.idpaket.toString(),
                                            checkusername,
                                            "tanggal");
                                        int result =
                                            await _helper.saveBarang(isiBarang);
                                        if (result > 0) {
                                          Fluttertoast.showToast(
                                              msg: result.toString());
                                          updateListView();
                                        } else {
                                          Fluttertoast.showToast(msg: "g isa");
                                        }
                                      } else if (stringVal[0] == "87" ||
                                          stringVal[0] == "88" ||
                                          stringVal[0] == "89") {
                                        isiBarang = Barang(
                                            stringVal[1].toString(),
                                            stringVal[0].toString(),
                                            int.parse(jumlahController.text
                                                .toString()),
                                            5000,
                                            widget.jumlahs,
                                            widget.idpaket.toString(),
                                            checkusername,
                                            "tanggal");
                                        int result =
                                            await _helper.saveBarang(isiBarang);
                                        if (result > 0) {
                                          Fluttertoast.showToast(
                                              msg: result.toString());
                                          updateListView();
                                        } else {
                                          Fluttertoast.showToast(msg: "g isa");
                                        }
                                      } else if (stringVal[0] == "86") {
                                        isiBarang = Barang(
                                            stringVal[1].toString(),
                                            stringVal[0].toString(),
                                            int.parse(jumlahController.text
                                                .toString()),
                                            5500,
                                            widget.jumlahs,
                                            widget.idpaket.toString(),
                                            checkusername,
                                            "tanggal");
                                        int result =
                                            await _helper.saveBarang(isiBarang);
                                        if (result > 0) {
                                          Fluttertoast.showToast(
                                              msg: result.toString());
                                          updateListView();
                                        } else {
                                          Fluttertoast.showToast(msg: "g isa");
                                        }
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Barang tidak cukup");
                                    }
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    '+' + " add",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 20,
                            ),
                            FutureBuilder<List<Barang>>(
                              future: future,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                      children: snapshot.data
                                          .map((todo) => cardo(todo))
                                          .toList());
                                } else {
                                  return Container(
                                      padding: EdgeInsets.all(100.0),
                                      child: Text(
                                        'Empty',
                                        style: TextStyle(fontSize: 20),
                                      ));
                                }
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onWillPop: () {
              Navigator.pop(context);
            },
          )),
    );
  }
}
