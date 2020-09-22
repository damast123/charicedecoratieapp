import 'dart:convert';

import 'package:charicedecoratieapp/Admin/add_barangpembelian.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/models/barangPembelian.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(add_Pembelian());
}

List<PembelianBarang> pembelianBarangAdd = new List<PembelianBarang>();

class add_Pembelian extends StatelessWidget {
  const add_Pembelian({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Myadd_Pembelian(),
    );
  }
}

class Myadd_Pembelian extends StatefulWidget {
  @override
  _Myadd_PembelianState createState() => _Myadd_PembelianState();
}

String displaysAdd;

class _Myadd_PembelianState extends State<Myadd_Pembelian> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController grandtotalController = new TextEditingController();
  TextEditingController invoiceController = new TextEditingController();
  TextEditingController nilaiResiduController = new TextEditingController();
  final dateFormat = DateFormat("yyyy-MM-dd");
  DateTime date;
  var dropdownValueSupplier;
  final String urlSupplier = koneksi.connect('getSupplier.php');
  List supplier = [];

  Future<String> getSupplier() async {
    try {
      Response response = await dio.get(urlSupplier);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        supplier = content['supplier'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget futureBuilder() {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      if (displaysAdd != null) {
        return Container(
          height: MediaQuery.of(context).size.height / 5,
          child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey,
                );
              },
              itemCount: pembelianBarangAdd.length,
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
                              pembelianBarangAdd[index].good_names,
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
                                    Text(pembelianBarangAdd[index]
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
                                    Text(pembelianBarangAdd[index]
                                        .warnas
                                        .toString())
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Harga : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(pembelianBarangAdd[index]
                                        .good_hargas
                                        .toString())
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Usia : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(pembelianBarangAdd[index].usia),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Nilai residu : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        pembelianBarangAdd[index].nilai_residu),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.delete,
                                color: Colors.black, size: 30.0),
                            onTap: () {
                              pembelianBarang.removeAt(index);
                              pembelianBarangAdd.removeAt(index);
                              setState(() {
                                updateListView();
                              });
                              Fluttertoast.showToast(
                                  msg: "Ini index: " +
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
      return new Align(
          alignment: Alignment.center,
          child: Text(
            "no data yet",
            style: TextStyle(fontSize: 18, color: Colors.blueGrey),
          ));
    });
  }

  void updateListView() async {
    pembelianBarangAdd.clear();
    double grandtotals = 0.0;
    for (var i = 0; i < pembelianBarang.length; i++) {
      pembelianBarangAdd.add(PembelianBarang(
          pembelianBarang[i].good_names,
          pembelianBarang[i].good_jumlahs,
          pembelianBarang[i].good_hargas,
          pembelianBarang[i].warnas,
          pembelianBarang[i].idkategoris,
          pembelianBarang[i].status_barangs,
          pembelianBarang[i].usia,
          pembelianBarang[i].nilai_residu));
      grandtotals += pembelianBarangAdd[i].good_jumlahs.toDouble() *
          pembelianBarangAdd[i].good_hargas;
    }
    grandtotalController.text = grandtotals.toString();
  }

  @override
  void initState() {
    this.getSupplier();
    this.updateListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Tambah barang'),
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
                        TextFormField(
                          controller: invoiceController,
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'invoice',
                              labelStyle: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DateTimeField(
                          format: dateFormat,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0.0)),
                            ),
                          ),
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
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: grandtotalController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'grandtotal',
                              labelStyle: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Pilih supplier:',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: DropdownButton(
                            value: dropdownValueSupplier,
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
                                dropdownValueSupplier = newValue;
                              });
                            },
                            items: supplier.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['name_supplier']),
                                value: item['idsupplier'].toString(),
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: GestureDetector(
                                onTap: () => {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              new add_BarangPembelian()))
                                      .then((_) {
                                    print("bisa g ?");
                                    setState(() {
                                      this.updateListView();
                                      displaysAdd = "add";
                                    });
                                  }),
                                },
                                child: Text(
                                  "tambah barang pembelian",
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        futureBuilder(),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            onPressed: () async {
                              var url = koneksi.connect("addPembelian.php");
                              Response responsePembelian = await dio.post(url,
                                  data: FormData.fromMap({
                                    "invoice":
                                        invoiceController.text.toString(),
                                    "date": date.toString(),
                                    "grandtotal":
                                        grandtotalController.text.toString(),
                                    "supplier":
                                        dropdownValueSupplier.toString(),
                                  }));
                              if (responsePembelian.data == "gagal") {
                                Fluttertoast.showToast(
                                    msg: responsePembelian.data);
                              } else {
                                print("Ini isi response pembelian: " +
                                    responsePembelian.data);
                                var setA = "";
                                for (var i = 0;
                                    i < pembelianBarangAdd.length;
                                    i++) {
                                  var urlAddBarangPembelian =
                                      koneksi.connect("addBarangPembelian.php");
                                  Response responseAddPembelian =
                                      await dio.post(urlAddBarangPembelian,
                                          data: FormData.fromMap({
                                            "no_pembelian": responsePembelian
                                                .data
                                                .toString(),
                                            "nama_barang": pembelianBarangAdd[i]
                                                .good_names
                                                .toString(),
                                            "qty": pembelianBarangAdd[i]
                                                .good_jumlahs
                                                .toString(),
                                            "price": pembelianBarangAdd[i]
                                                .good_hargas
                                                .toString(),
                                            "usia": pembelianBarangAdd[i]
                                                .usia
                                                .toString(),
                                            "nilairesidu": pembelianBarangAdd[i]
                                                .nilai_residu
                                                .toString(),
                                            "color": pembelianBarangAdd[i]
                                                .warnas
                                                .toString(),
                                            "category": pembelianBarangAdd[i]
                                                .idkategoris
                                                .toString(),
                                            "status": pembelianBarangAdd[i]
                                                .status_barangs
                                                .toString()
                                          }));
                                  print(
                                      "Response status: ${responseAddPembelian.statusCode}");
                                  print(
                                      "Response body: ${responseAddPembelian.data}");
                                  Fluttertoast.showToast(
                                      msg:
                                          responseAddPembelian.data.toString());
                                  setA = responseAddPembelian.data.toString();
                                  if (setA == "gagal") {
                                    break;
                                  } else {}
                                }
                                if (setA == "sukses") {
                                  Fluttertoast.showToast(msg: "sukses");
                                }
                              }
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
    );
  }
}
