import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:charicedecoratieapp/Admin/laporan_notaKeluar.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/models/barangPengeluaran.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future main() async {
  runApp(MyNotaKeluar());
}

class MyNotaKeluar extends StatelessWidget {
  const MyNotaKeluar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotaKeluar(),
    );
  }
}

class NotaKeluar extends StatefulWidget {
  @override
  _NotaKeluarState createState() => _NotaKeluarState();
}

class _NotaKeluarState extends State<NotaKeluar> {
  String dropdownValue;
  var disp = "";

  var simpanNamaBarang = "";
  List namawarna = [];
  List jumlahBarangSisa = [];
  TextEditingController jumlahController = new TextEditingController();
  bool isChecked = false;
  List barang = [];
  List<PengeluaranBarang> pengeluaranBarang = new List<PengeluaranBarang>();
  List<String> added = [];
  String currentText = "";
  List<String> suggestions = [];
  final dateFormat = DateFormat("yyyy-MM-dd");
  DateTime date;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List type = [];

  final String urlDataBarang = koneksi.connect('get_nota_keluar.php');
  Future<String> getDataBarang() async {
    var simpn = "";

    try {
      Response response = await dio.get(urlDataBarang);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        barang = content['m_asset'];
        print(barang.toString());
        for (var i = 0; i < barang.length; i++) {
          var nm = barang[i]['nama_aset'];
          var wn = barang[i]['jenis_warna'];
          simpn = nm + "," + wn;
          suggestions.add(simpn);
          jumlahBarangSisa.add(barang[i]['getJumlah']);
        }
        print(suggestions.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
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
              itemCount: pengeluaranBarang.length,
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
                              pengeluaranBarang[index].good_names,
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
                                    Text(pengeluaranBarang[index]
                                        .good_jumlahs
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
                                    Text(pengeluaranBarang[index]
                                        .warnas
                                        .toString())
                                  ],
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.delete,
                                color: Colors.black, size: 30.0),
                            onTap: () {
                              pengeluaranBarang.removeAt(index);
                              if (pengeluaranBarang.length < 0) {
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

  _NotaKeluarState() {
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
    final appTitle = 'Nota Keluar';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: WillPopScope(
          child: Stack(
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
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text("Tanggal keluar"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 17),
                            child: DateTimeField(
                              format: dateFormat,
                              decoration: InputDecoration(labelText: 'Date'),
                              onShowPicker: (context, currentValue) async {
                                final d = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1994),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                var s = dateFormat.format(d);
                                return date = DateTime.parse(s);
                              },
                            ),
                          ),
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
                              width: MediaQuery.of(context).size.width / 1.28,
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
                                onPressed: () async {
                                  var cekStatus = "";
                                  var stringUrlChek = koneksi
                                      .connect("check_barang_nota_keluar.php");
                                  if (pengeluaranBarang.isEmpty) {
                                    if (namawarna[0][1] == "") {
                                      print("nama: " +
                                          namawarna[0][0].toString());
                                      print("jumlah: " +
                                          jumlahController.text.toString());
                                      var a = {
                                        "nama": namawarna[0][0].toString(),
                                        "jumlah":
                                            jumlahController.text.toString(),
                                        "warna": "kosong",
                                      };
                                      Response response = await dio.post(
                                          stringUrlChek,
                                          data: FormData.fromMap(a));
                                      if (response.data == "sukses") {
                                        Fluttertoast.showToast(
                                            msg: response.data);
                                        pengeluaranBarang.add(PengeluaranBarang(
                                          namawarna[0][0],
                                          jumlahController.text.toString(),
                                          "kosong",
                                        ));
                                        setState(() {
                                          disp = "display";
                                        });
                                        Fluttertoast.showToast(msg: "Sukses");
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: response.data);
                                      }
                                      // http.post(stringUrlChek, body: {
                                      //   "nama": namawarna[0][0].toString(),
                                      //   "jumlah":
                                      //       jumlahController.text.toString(),
                                      //   "warna": "kosong",
                                      // }).then((res) {
                                      //   if (res.body == "sukses") {
                                      //     Fluttertoast.showToast(msg: res.body);
                                      //     pengeluaranBarang
                                      //         .add(PengeluaranBarang(
                                      //       namawarna[0][0],
                                      //       jumlahController.text.toString(),
                                      //       "kosong",
                                      //     ));
                                      //     setState(() {
                                      //       disp = "display";
                                      //     });
                                      //     Fluttertoast.showToast(msg: "Sukses");
                                      //   } else {
                                      //     Fluttertoast.showToast(msg: res.body);
                                      //   }
                                      // });
                                    } else {
                                      Response response = await dio.post(
                                          stringUrlChek,
                                          data: FormData.fromMap({
                                            "nama": namawarna[0][0].toString(),
                                            "jumlah": jumlahController.text
                                                .toString(),
                                            "warna": namawarna[0][1].toString(),
                                          }));
                                      if (response.data == "sukses") {
                                        Fluttertoast.showToast(
                                            msg: response.data);
                                        pengeluaranBarang.add(PengeluaranBarang(
                                          namawarna[0][0],
                                          jumlahController.text.toString(),
                                          "kosong",
                                        ));
                                        setState(() {
                                          disp = "display";
                                        });
                                        Fluttertoast.showToast(msg: "Sukses");
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: response.data);
                                      }
                                    }
                                  } else {
                                    for (var i = 0;
                                        i < pengeluaranBarang.length;
                                        i++) {
                                      if (namawarna[0][1] == "") {
                                        if (namawarna[0][0] ==
                                                pengeluaranBarang[i]
                                                    .good_names &&
                                            namawarna[0][1] == "") {
                                          cekStatus = "gagal";
                                          break;
                                        } else {}
                                      }
                                      //dipisah
                                      else {
                                        if (namawarna[0][0] ==
                                                pengeluaranBarang[i]
                                                    .good_names &&
                                            namawarna[0][1] ==
                                                pengeluaranBarang[i].warnas) {
                                          cekStatus = "gagal";
                                          break;
                                        } else {}
                                      }
                                    }

                                    if (cekStatus == "") {
                                      if (namawarna[0][1] == "") {
                                        var a = {
                                          "nama": namawarna[0][0].toString(),
                                          "jumlah":
                                              jumlahController.text.toString(),
                                          "warna": "kosong",
                                        };
                                        Response response = await dio.post(
                                            stringUrlChek,
                                            data: FormData.fromMap(a));

                                        if (response.data == "sukses") {
                                          Fluttertoast.showToast(
                                              msg: response.data);
                                          pengeluaranBarang
                                              .add(PengeluaranBarang(
                                            namawarna[0][0],
                                            jumlahController.text.toString(),
                                            "kosong",
                                          ));
                                          setState(() {
                                            disp = "display";
                                          });
                                          Fluttertoast.showToast(msg: "Sukses");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: response.data);
                                        }
                                      }

                                      //dipisah
                                      else {
                                        Response response = await dio.post(
                                            stringUrlChek,
                                            data: FormData.fromMap({
                                              "nama":
                                                  namawarna[0][0].toString(),
                                              "jumlah": jumlahController.text
                                                  .toString(),
                                              "warna":
                                                  namawarna[0][1].toString(),
                                            }));
                                        if (response.data == "sukses") {
                                          pengeluaranBarang
                                              .add(PengeluaranBarang(
                                            namawarna[0][0],
                                            jumlahController.text.toString(),
                                            namawarna[0][1],
                                          ));
                                          setState(() {
                                            disp = "display";
                                          });
                                          Fluttertoast.showToast(msg: "Sukses");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: response.data);
                                        }
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: _sizeDevice.size.width / 2,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    var url =
                                        koneksi.connect('postNotaKeluar.php');
                                    var urlDetilPembelian = koneksi.connect(
                                        'postNotaKeluarDetailPembelian.php');
                                    var urlDetilNotaKeluar = koneksi
                                        .connect('postNotaKeluarDetail.php');
                                    int jumlahs = 0;
                                    for (var x = 0;
                                        x < pengeluaranBarang.length;
                                        x++) {
                                      var setJumlahs = int.parse(
                                          pengeluaranBarang[x]
                                              .good_jumlahs
                                              .toString());
                                      jumlahs = jumlahs + setJumlahs;
                                      var a = 1;
                                      var getResponsed = "";
                                      http.post(urlDetilPembelian, body: {
                                        "tanggal": date.toString(),
                                        "nama": pengeluaranBarang[x]
                                            .good_names
                                            .toString(),
                                        "jumlah": pengeluaranBarang[x]
                                            .good_jumlahs
                                            .toString(),
                                        "warna": pengeluaranBarang[x]
                                            .warnas
                                            .toString(),
                                      }).then((response) {
                                        if (response.body == "") {
                                          getResponsed = response.body;
                                        }
                                      });
                                      print("ini jenis x: " + x.toString());
                                      a = a + x;
                                      if (a == pengeluaranBarang.length) {
                                        if (getResponsed == "") {
                                          http.post(url, body: {
                                            "tanggal": date.toString(),
                                            "jumlah": jumlahs.toString()
                                          }).then((response) {
                                            print("response: " + response.body);
                                            for (var z = 0;
                                                z < pengeluaranBarang.length;
                                                z++) {
                                              http.post(urlDetilNotaKeluar,
                                                  body: {
                                                    "nama": pengeluaranBarang[z]
                                                        .good_names
                                                        .toString(),
                                                    "nota_keluar": response.body
                                                        .toString(),
                                                    "jumlah":
                                                        pengeluaranBarang[z]
                                                            .good_jumlahs
                                                            .toString(),
                                                    "warna":
                                                        pengeluaranBarang[z]
                                                            .warnas
                                                            .toString(),
                                                  }).then((responsed) {
                                                if (responsed.body == "") {
                                                  Fluttertoast.showToast(
                                                      msg: "sukses");
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  new MyAppLaporanAdmin()));
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: "gagal");
                                                }
                                              });
                                            }
                                          });
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          onWillPop: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => new MyAppLaporanAdmin()));
          },
        ),
      ),
    );
  }
}
