import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/models/keterangan_barang.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

Future main() async {
  runApp(MyAddKeteranganBarang());
}

List<KeteranganBarang> keteranganBarangs = new List<KeteranganBarang>();

class MyAddKeteranganBarang extends StatelessWidget {
  const MyAddKeteranganBarang({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddKeteranganBarang(),
    );
  }
}

class AddKeteranganBarang extends StatefulWidget {
  @override
  _AddKeteranganBarangState createState() => _AddKeteranganBarangState();
}

class _AddKeteranganBarangState extends State<AddKeteranganBarang> {
  String dropdownValue;
  var disp = "";

  var simpanNamaBarang = "";
  List namawarna = [];
  TextEditingController jumlahController = new TextEditingController();
  bool isChecked = false;
  List barang = [];
  List<String> added = [];
  String currentText = "";
  List<String> suggestions = [];
  final dateFormat = DateFormat("yyyy-MM-dd");
  DateTime date;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List type = [];
  final String url = koneksi.connect('getTypePayment.php');
  Future<String> getData() async {
    try {
      Response response = await dio.get(url);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        type = content['carapembayaran'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  final String urlDataBarang = koneksi.connect('get_add_keterangan_barang.php');
  Future<String> getDataBarang() async {
    var simpn = "";
    try {
      Response response = await dio.get(urlDataBarang);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        barang = content['m_asset'];
      });

      print(barang.toString());
      for (var i = 0; i < barang.length; i++) {
        var nm = barang[i]['nama_aset'];
        var wn = barang[i]['jenis_warna'];
        simpn = nm + "," + wn;
        suggestions.add(simpn);
      }
      print(suggestions.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    this.getData();
    this.getDataBarang();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget futureBuilder() {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      if (disp == "display") {
        return Container(
          height: MediaQuery.of(context).size.height / 5,
          child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey,
                );
              },
              itemCount: keteranganBarangs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              keteranganBarangs[index].good_names,
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Jumlah : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(keteranganBarangs[index]
                                        .jummlah
                                        .toString())
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Warna : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(keteranganBarangs[index]
                                        .warnas
                                        .toString())
                                  ],
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.delete,
                                color: Colors.black, size: 30.0),
                            onTap: () {
                              keteranganBarangs.removeAt(index);
                              if (keteranganBarangs.length < 0) {
                                setState(() {
                                  disp = "";
                                });
                              }
                              setState(() {
                                futureBuilder();
                              });

                              Fluttertoast.showToast(
                                  msg: "Barang pada index: " +
                                      index.toString() +
                                      " Sukses dihapus.");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      }
      return new Text("no data yet");
    });
  }

  _AddKeteranganBarangState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: new InputDecoration(labelText: "nama,warna"),
      controller: TextEditingController(text: ""),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: false,
      onFocusChanged: (text1) => setState(() {
        if (text1 == false) {
          // added.add(text);
          if (simpanNamaBarang == "") {
            Fluttertoast.showToast(
                msg:
                    "Tolong submit terlebih dahulu barang yang ingin di masukkan",
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5);
          }
        }
      }),
      textSubmitted: (text) => setState(() {
        if (text != "") {
          // added.add(text);

          simpanNamaBarang = text;
          namawarna.clear();
          namawarna.add(simpanNamaBarang.split(","));
          print("nama warna: " + namawarna.toString());
        }
      }),
    );
  }

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    var _sizeDevice = MediaQuery.of(context);
    Column body = new Column(children: [
      new ListTile(
        title: textField,
      ),
    ]);

    body.children.addAll(added.map((item) {
      return new ListTile(title: new Text(item));
    }));
    final appTitle = 'Add keteragan barang';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              width: _sizeDevice.size.width,
              height: _sizeDevice.size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/charicedecor.jpg'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter)),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 260, bottom: _sizeDevice.viewInsets.bottom / 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(23),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                        ),
                        Text("Nama barang"),
                        Container(
                            margin: EdgeInsets.only(right: 8),
                            width: MediaQuery.of(context).size.width / 1,
                            child: body),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text("Jumlah barang"),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 13),
                            width: MediaQuery.of(context).size.width / 1,
                            child: TextFormField(
                              controller: jumlahController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  new InputDecoration(hintText: "jumlah."),
                            )),
                        SizedBox(
                          width: _sizeDevice.size.width / 2,
                          child: RaisedButton.icon(
                              color: Colors.blue,
                              onPressed: () {
                                var cekStatus = "";
                                if (keteranganBarangs.isEmpty) {
                                  if (namawarna[0][1] == "") {
                                    keteranganBarangs.add(KeteranganBarang(
                                      namawarna[0][0],
                                      "kosong",
                                      jumlahController.text.toString(),
                                    ));
                                    setState(() {
                                      disp = "display";
                                    });
                                    Fluttertoast.showToast(msg: "Sukses");
                                  } else {
                                    keteranganBarangs.add(KeteranganBarang(
                                      namawarna[0][0],
                                      namawarna[0][1],
                                      jumlahController.text.toString(),
                                    ));
                                    setState(() {
                                      disp = "display";
                                    });
                                    Fluttertoast.showToast(msg: "Sukses");
                                  }
                                } else {
                                  for (var i = 0;
                                      i < keteranganBarangs.length;
                                      i++) {
                                    if (namawarna[0][1] == "") {
                                      if (namawarna[0][0] ==
                                              keteranganBarangs[i].good_names &&
                                          namawarna[0][1] == "") {
                                        cekStatus = "gagal";
                                        break;
                                      } else {}
                                    }
                                    //dipisah
                                    else {
                                      if (namawarna[0][0] ==
                                              keteranganBarangs[i].good_names &&
                                          namawarna[0][1] ==
                                              keteranganBarangs[i].warnas) {
                                        cekStatus = "gagal";

                                        break;
                                      } else {}
                                    }
                                  }
                                  if (cekStatus == "") {
                                    if (namawarna[0][1] == "") {
                                      keteranganBarangs.add(KeteranganBarang(
                                        namawarna[0][0],
                                        "kosong",
                                        jumlahController.text.toString(),
                                      ));
                                      setState(() {
                                        disp = "display";
                                      });
                                      Fluttertoast.showToast(msg: "Sukses");
                                    } else {
                                      keteranganBarangs.add(KeteranganBarang(
                                        namawarna[0][0],
                                        namawarna[0][1],
                                        jumlahController.text.toString(),
                                      ));
                                      setState(() {
                                        disp = "display";
                                      });
                                      Fluttertoast.showToast(msg: "Sukses");
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Data sudah ada. Silahkan dihapus terlebih dahulu lalu add lagi.");
                                  }
                                }
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.red,
                              ),
                              label: Text(
                                "add",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        futureBuilder(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
