import 'dart:convert';

import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/models/barangPembelian.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:charicedecoratieapp/widgets/Option.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

void main() {
  runApp(add_BarangPembelian());
}

List<PembelianBarang> pembelianBarang = new List<PembelianBarang>();

class add_BarangPembelian extends StatelessWidget {
  const add_BarangPembelian({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Myadd_BarangPembelian(),
    );
  }
}

class Myadd_BarangPembelian extends StatefulWidget {
  @override
  _Myadd_BarangPembelianState createState() => _Myadd_BarangPembelianState();
}

class _Myadd_BarangPembelianState extends State<Myadd_BarangPembelian> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController hargaController = new TextEditingController();
  TextEditingController jumlahbarangController = new TextEditingController();
  TextEditingController usiaController = new TextEditingController();
  TextEditingController nilaiResiduController = new TextEditingController();
  var nilaiResidu = 0.0;
  var usia = 0;
  List _statusbarangs = ["Main", "Additional"];
  List _usiaDepresiasi = ["Bulan", "Tahun"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<DropdownMenuItem<String>> _dropDownMenuItemsUsia;
  String _currentRole;
  String _currentDepresiasi;
  List<String> added = [];
  List saves = [];
  String currentText = "";
  String simpanNamaBarang = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  List<String> suggestions = [];
  var dropdownValueWarna;
  var dropdownValueKategori;
  final String url = koneksi.connect('getSearchBarang.php');
  final String urlgetWarna = koneksi.connect('getPembelianWarna.php');
  final String urlgetKategori = koneksi.connect('getKategori.php');
  List barang = [];
  List warna = [];
  List kategori = [];

  Future<String> getData() async {
    try {
      Response response = await dio.get(url);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        barang = content['m_asset'];
      });

      for (var i = 0; i < barang.length; i++) {
        suggestions.add(barang[i]['nama_aset']);
      }
      print(suggestions.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getKategori() async {
    try {
      Response response = await dio.get(urlgetKategori);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        kategori = content['kategori'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getWarna() async {
    try {
      Response response = await dio.get(urlgetWarna);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);
        warna.add("");
        warna = content['warna'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _dropDownMenuItemsUsia = getDropDownMenuItemsUsia();
    _currentRole = _dropDownMenuItems[0].value;
    _currentDepresiasi = _dropDownMenuItemsUsia[0].value;

    this.getData();
    this.getWarna();
    this.getKategori();
    super.initState();
  }

  _Myadd_BarangPembelianState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: new InputDecoration(errorText: "Masukkan nama barang"),
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
        }
      }),
    );
  }

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String role in _statusbarangs) {
      items.add(new DropdownMenuItem(value: role, child: new Text(role)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsUsia() {
    List<DropdownMenuItem<String>> items = new List();
    for (String role in _usiaDepresiasi) {
      items.add(new DropdownMenuItem(value: role, child: new Text(role)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    Column body = new Column(children: [
      new ListTile(
        title: textField,
      ),
    ]);

    body.children.addAll(added.map((item) {
      return new ListTile(title: new Text(item));
    }));

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Tambah barang'),
        ),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/charicedecor.jpg'),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.only(top: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(23),
                      child: ListView(
                        children: <Widget>[
                          body,
                          Container(
                              margin: EdgeInsets.all(14.5),
                              color: Color(0xfff5f5f5),
                              child: jumlahbarangField()),
                          Container(
                              margin: EdgeInsets.all(14.5),
                              color: Color(0xfff5f5f5),
                              child: hargaField()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Pilih warna:'),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: DropdownButton(
                              value: dropdownValueWarna,
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
                                  dropdownValueWarna = newValue;
                                });
                              },
                              items: warna.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(item['jenis_warna']),
                                  value: item['jenis_warna'].toString(),
                                );
                              }).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Pilih kategori:'),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: DropdownButton(
                              value: dropdownValueKategori,
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
                                  dropdownValueKategori = newValue;
                                });
                              },
                              items: kategori.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(item['nama_kategori']),
                                  value: item['idKategori'].toString(),
                                );
                              }).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Status barang:'),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: DropdownButton(
                              value: _currentRole,
                              isExpanded: true,
                              iconEnabledColor: Colors.black,
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.black,
                              ),
                              onChanged: changedDropDownItem,
                              items: _dropDownMenuItems,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(14.5),
                            color: Color(0xfff5f5f5),
                            child: TextFormField(
                              controller: usiaController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFUIDisplay'),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Perkiraan usia',
                                  labelStyle: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Dalam satuan:'),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: DropdownButton(
                              value: _currentDepresiasi,
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
                                  _currentDepresiasi = newValue;
                                });
                              },
                              items: _dropDownMenuItemsUsia,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: MaterialButton(
                              onPressed: () {
                                if (_currentDepresiasi == "Tahun") {
                                  usia = 12 *
                                      int.parse(usiaController.text.toString());
                                  nilaiResidu = (double.parse(
                                              jumlahbarangController.text
                                                  .toString()) *
                                          double.parse(hargaController.text
                                              .toString())) /
                                      usia;
                                } else {
                                  usia =
                                      int.parse(usiaController.text.toString());
                                  nilaiResidu = (double.parse(
                                              jumlahbarangController.text
                                                  .toString()) *
                                          double.parse(hargaController.text
                                              .toString())) /
                                      usia;
                                }
                                pembelianBarang.add(PembelianBarang(
                                    simpanNamaBarang,
                                    int.parse(
                                        jumlahbarangController.text.toString()),
                                    double.parse(
                                        hargaController.text.toString()),
                                    dropdownValueWarna,
                                    dropdownValueKategori,
                                    _currentRole,
                                    usia.toString(),
                                    nilaiResidu.toString()));
                                Fluttertoast.showToast(
                                    msg: "Sukses menambahkan data barang",
                                    gravity: ToastGravity.CENTER);
                              },
                              child: Text(
                                'Add Pembelian',
                                style: TextStyle(
                                  fontSize: 16,
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
      ),
    );
  }

  Widget hargaField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: hargaController,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Harga',
          labelStyle: TextStyle(fontSize: 16)),
    );
  }

  Widget jumlahbarangField() {
    return TextFormField(
      controller: jumlahbarangController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Jumlah barang',
          labelStyle: TextStyle(fontSize: 16)),
    );
  }

  void changedDropDownItem(String selectedrole) {
    setState(() {
      _currentRole = selectedrole;
    });
  }
}
