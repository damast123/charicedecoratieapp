import 'dart:convert';

import 'package:charicedecoratieapp/Admin/laporan_notaKeluar.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyInputStokOpname());
}

class MyInputStokOpname extends StatelessWidget {
  String username;
  MyInputStokOpname({Key key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InputStokOpname(
        username: username,
      ),
    );
  }
}

class InputStokOpname extends StatefulWidget {
  String username;
  InputStokOpname({Key key, this.username}) : super(key: key);
  @override
  _InputStokOpnameState createState() => _InputStokOpnameState();
}

class _InputStokOpnameState extends State<InputStokOpname> {
  var dropdownValueBarang;
  TextEditingController keteranganController = new TextEditingController();
  TextEditingController jumlahRealController = new TextEditingController();
  TextEditingController jumlahComputerController = new TextEditingController();

  final String urlgetbarang = koneksi.connect('getAsset.php');
  List barang = [];

  Future<String> getData() async {
    try {
      Response response = await dio.get(urlgetbarang);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        barang = content['m_asset'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Stok opname"),
        ),
        body: WillPopScope(
            onWillPop: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => new MyAppLaporanAdmin()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.all(15.0),
              child: Form(
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
                          top: 150,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(23),
                        child: ListView(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Nama barang:'),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 6,
                                ),
                                Container(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: DropdownButton(
                                    value: dropdownValueBarang,
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
                                        dropdownValueBarang = newValue;
                                        for (var i = 0;
                                            i < barang.length;
                                            i++) {
                                          if (barang[i]['idm_asset'] ==
                                              newValue) {
                                            jumlahComputerController.text =
                                                barang[i]['jumlah'].toString();
                                          }
                                        }
                                      });
                                    },
                                    items: barang.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(item['nama_aset']),
                                        value: item['idm_asset'].toString(),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Jumlah riil:'),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 4.5,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    color: Color(0xfff5f5f5),
                                    child: jumlahriilField()),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Jumlah komputer:'),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 9,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    color: Color(0xfff5f5f5),
                                    child: jumlahkomputerField()),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Keterangan:'),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 4.7,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    color: Color(0xfff5f5f5),
                                    child: keteranganField()),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: MaterialButton(
                                onPressed: () async {
                                  var url =
                                      koneksi.connect("postStokOpname.php");

                                  Response res = await dio.post(url,
                                      data: FormData.fromMap({
                                        "username": widget.username.toString(),
                                        "idbarang":
                                            dropdownValueBarang.toString(),
                                        "jumlah_real": jumlahRealController.text
                                            .toString(),
                                        "jumlah_komp": jumlahComputerController
                                            .text
                                            .toString(),
                                        "keterangan": keteranganController.text
                                            .toString(),
                                      }));
                                  Fluttertoast.showToast(msg: res.data);
                                },
                                child: Text(
                                  'Input',
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
            )),
      ),
    );
  }

  Widget jumlahriilField() {
    return TextFormField(
      controller: jumlahRealController,
      keyboardType: TextInputType.number,
      autocorrect: false,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Jumlah riil',
          hintText: 'input jumlah dari stok di gudang',
          labelStyle: TextStyle(fontSize: 15)),
    );
  }

  Widget jumlahkomputerField() {
    return TextFormField(
      controller: jumlahComputerController,
      keyboardType: TextInputType.number,
      autocorrect: false,
      readOnly: true,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Jumlah komputer',
          labelStyle: TextStyle(fontSize: 15)),
    );
  }

  Widget keteranganField() {
    return TextFormField(
      controller: keteranganController,
      keyboardType: TextInputType.text,
      autocorrect: false,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Keterangan',
          hintText: 'Input keterangan',
          labelStyle: TextStyle(fontSize: 15)),
    );
  }
}
