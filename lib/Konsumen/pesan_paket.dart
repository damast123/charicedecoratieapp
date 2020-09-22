import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charicedecoratieapp/Konsumen/FormStepper.dart';
import 'package:charicedecoratieapp/Konsumen/add_additional.dart';
import 'package:charicedecoratieapp/Konsumen/add_theme.dart';
import 'package:charicedecoratieapp/Konsumen/add_warna.dart';
import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/UploadImage.dart';
import 'package:charicedecoratieapp/helpers/dbhelpers.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/models/barang.dart';
import 'package:charicedecoratieapp/models/scart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../welcomescreen.dart';

void main() {
  runApp(MyPesanPaketKonsumen());
}

class MyPesanPaketKonsumen extends StatelessWidget {
  String value = "";
  String jenisPakets = "";
  String getDate = "";
  String getJam = "";
  String jumlahTamu = "";
  String user = "";
  MyPesanPaketKonsumen(
      {Key key,
      this.value,
      this.jenisPakets,
      this.jumlahTamu,
      this.getDate,
      this.getJam,
      this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pesan Paket',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PesanPaketKonsumen(
          id: value,
          jenisPakets: jenisPakets,
          jumlahTamu: jumlahTamu,
          getDate: getDate,
          getJam: getJam,
          user: user,
        ));
  }
}

class PesanPaketKonsumen extends StatefulWidget {
  String id = "";
  String jenisPakets = "";
  String jumlahTamu = "";
  String getJam = "";
  String getDate = "";
  String user = "";
  PesanPaketKonsumen(
      {Key key,
      this.id,
      this.jenisPakets,
      this.jumlahTamu,
      this.getDate,
      this.getJam,
      this.user})
      : super(key: key);
  @override
  _PesanPaketKonsumenState createState() => _PesanPaketKonsumenState();
}

String display;

class _PesanPaketKonsumenState extends State<PesanPaketKonsumen>
    with SingleTickerProviderStateMixin {
  DatabaseHelper _helper = DatabaseHelper();
  Future<List<Barang>> future;
  List<Barang> getNamaDanJumlah = [];
  double grandtotal;
  Barang isiBarang;
  double getdulu = 0.0;
  TextEditingController jumlahController = new TextEditingController();
  TextEditingController ketsController = new TextEditingController();
  Cart cart;
  bool isChecked = false;

  var dropdownValue;
  var dropdownValueTema;
  var dropdownValueBarang;

  String jenisGambar;
  String namaGambar;

  int jumlahS = 0;

  bool getaddit;
  var pictname = "";
  var setpictname = "";
  List getpictname;
  var items = List<String>();
  var itemsed = List<String>();
  var ada = "tidak";

  List myArray = List<String>();
  List paket = [];
  List warna = [];
  List barang = [];
  List dapatBarang = [];
  String gambar;
  List tema = [];
  List gambarDatabase = [];
  List getHarga = [];
  List getJumlah = [];
  List<Barang> kirimBarang = [];
  List setIdBarang = [];
  List setJumlahBarang = [];
  List setNamaBarang = [];
  var urlPostAdd = "";

  int setjumlah3;
  double getjumlah3 = 0.0;

  Widget showImage(String namagambardatabase) {
    if (namagambardatabase == "") {
      return Container(
        child: Text(""),
      );
    } else {
      return CachedNetworkImage(
        height: 300,
        width: 300,
        fit: BoxFit.cover,
        imageUrl: koneksi.getImagePaket(namagambardatabase),
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      );
    }
  }

  void getBarangs() async {
    final Future<Database> dbFuture = _helper.initializeDatabase();
    await dbFuture.then((database) {
      setState(() {
        Future<List<Barang>> todoListFuture = _helper.getBarang(widget.user);
        todoListFuture.then((todoList) {
          setState(() {
            for (var i = 0; i < todoList.length; i++) {
              kirimBarang.add(Barang(
                  todoList[i].good_name,
                  todoList[i].good_id,
                  todoList[i].good_jumlah,
                  todoList[i].good_harga,
                  todoList[i].Cart_id,
                  todoList[i].paket_ID,
                  todoList[i].username_ID,
                  todoList[i].tanggal));
              // getHarga.add(todoList[i].good_harga);
              // getJumlah.add(todoList[i].good_jumlah);
            }
          });
        });
      });
    });
  }

  void updateListView() async {
    final Future<Database> dbFuture = _helper.initializeDatabase();
    await dbFuture.then((database) {
      setState(() {
        Future<List<Barang>> todoListFuture =
            _helper.getBarangById(widget.id, widget.user);
        todoListFuture.then((todoList) {
          setState(() {
            for (var i = 0; i < todoList.length; i++) {
              getdulu += (todoList[i].good_harga * todoList[i].good_jumlah);
            }
          });
        });
      });
    });
  }

  Widget futureBuilder() {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      if (display != null) {
        return Container(
          height: MediaQuery.of(context).size.height / 6,
          child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey,
                );
              },
              itemCount: setNamaBarang.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Table(
                    children: [
                      TableRow(children: [
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Nama: ' + setNamaBarang[index]),
                              IconButton(
                                  iconSize: (MediaQuery.of(context).size.width *
                                          MediaQuery.of(context).size.height) /
                                      12000,
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                        msg: "Ini isi index: " +
                                            index.toString());
                                    setNamaBarang.removeAt(index);
                                    setIdBarang.removeAt(index);
                                    if (setNamaBarang.length < 0) {
                                      setState(() {
                                        display = null;
                                      });
                                    } else {
                                      setState(() {
                                        display = "Mantap";
                                      });
                                    }
                                  }),
                            ],
                          ),
                        )
                      ])
                    ],
                  ),
                );
              }),
        );
      }
      return new Text("no data yet");
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
    String v = widget.id;

    _loadSessionUser();
    getaddit = false;
    jumlahController.text = widget.jumlahTamu.toString();

    final String url = koneksi.connect('detailPaket.php?id=' + v);
    String urlgetwarna = "";
    if (widget.jenisPakets == "3") {
      urlgetwarna = koneksi.connect('getwarnaRoundTable.php?idpaket=' +
          v +
          '&jumlah=' +
          widget.jumlahTamu.toString() +
          "&tanggal=" +
          widget.getDate);
    } else if (widget.jenisPakets == "2") {
      urlgetwarna = koneksi.connect('getwarna.php?idpaket=' +
          v +
          '&jumlah=' +
          "4" +
          "&tanggal=" +
          widget.getDate);
    } else {
      urlgetwarna = koneksi.connect('getwarna.php?idpaket=' +
          v +
          '&jumlah=' +
          widget.jumlahTamu.toString() +
          "&tanggal=" +
          widget.getDate);
    }

    final String urlgettema = koneksi.connect('getTema.php');

    Future<String> getData() async {
      Response response = await dio.get(url);
      setState(() {
        var content = json.decode(response.data);

        paket = content['paket'];
      });
      print(response.data.toString());

      grandtotal = double.parse(paket[0]['harga_awal']);
      print("Ini grandtotal: " + grandtotal.toString());
      MoneyFormatterOutput fo =
          FlutterMoneyFormatter(amount: grandtotal).output;
      if (widget.jenisPakets == "3") {
        setjumlah3 = int.parse(widget.jumlahTamu);
        getjumlah3 = setjumlah3 / 10;
        ketsController.text = "Paket ini akan dipesan oleh : " +
            getjumlah3.round().toString() +
            " meja dengan harga paket Rp." +
            fo.nonSymbol.toString() +
            " per meja.";
      } else if (widget.jenisPakets == "2") {
        ketsController.text = "Paket ini akan dipesan oleh : " +
            widget.jumlahTamu +
            " orang dengan harga paket Rp." +
            fo.nonSymbol.toString();
      } else {
        ketsController.text = "Paket ini akan dipesan oleh : " +
            widget.jumlahTamu +
            " orang dengan harga paket Rp." +
            fo.nonSymbol.toString() +
            " per orang.";
      }
    }

    Future<String> getWarna() async {
      Response response = await dio.get(urlgetwarna);
      print(response.data.toString());

      if (response.data == "kosong") {
        Fluttertoast.showToast(msg: "Ada warna yang kurang");
        Navigator.pop(context);
      } else {
        setState(() {
          var content = json.decode(response.data);

          warna = content['warnas'];
          print("ini jenis warna: " + warna.toString());
        });
      }
    }

    Future<String> gettema() async {
      Response response = await dio.get(urlgettema);
      print(response.data.toString());
      setState(() {
        var content = json.decode(response.data);

        tema = content['tema'];
      });
    }

    final String urlFecthGambar = koneksi.connect('getGambarPaket.php?id=' + v);
    Future<String> getDataGambar() async {
      Response response = await dio.get(urlFecthGambar);
      print(response.data.toString());
      setState(() {
        var content = json.decode(response.data);

        gambarDatabase = content['getGambar'];
      });
    }

    final String urlAcc = koneksi.connect('getAcc.php?jumlahtamu=' +
        widget.jumlahTamu +
        '&tanggal=' +
        widget.getDate);

    Future<String> getDataBarang() async {
      Response response = await dio.get(urlAcc);
      print(response.data.toString());
      setState(() {
        var content = json.decode(response.data);

        barang = content['getBarang'];
      });

      if (widget.jenisPakets == "1") {
        if (barang.isNotEmpty) {
          getaddit = true;
          if (getNamaDanJumlah.length > 0) {
            setState(() {
              display = "Mantap";
            });
          } else {
            display = null;
          }
        } else {
          getNamaDanJumlah.clear();
          getaddit = false;
        }
      } else {
        getNamaDanJumlah.clear();
        getaddit = false;
      }
    }

    getDataGambar();
    getData();
    gettema();
    getBarangs();
    getWarna();
    super.initState();
    getDataBarang();
    this.updateListView();
    print("ini yang di pesan paket usern: " + widget.user);
  }

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pesan Paket Konsumen"),
        ),
        body: WillPopScope(
          child: Container(
            width: _deviceSize.size.width,
            height: _deviceSize.size.height,
            padding: EdgeInsets.only(left: 0, top: 30.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            Text(
                              "Tanggal",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87),
                            ),
                            Text(
                              ": " + widget.getDate,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              "Jam",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87),
                            ),
                            Text(
                              ": " + widget.getJam,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Package Name',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87),
                            ),
                            Text(
                              ': ' + paket[0]['nama_paket'],
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0.0, top: 20.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '*Pilih warna:',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: _deviceSize.size.width,
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
                        dropdownValue = newValue;
                        setState(() {
                          dropdownValue = newValue;
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => new ChooseColor()));
                    },
                    child: Text(
                      'Tidak ada warna?',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0.0, top: 20.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Pilih tema:',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: _deviceSize.size.width,
                    height: 60,
                    child: DropdownButton(
                      value: dropdownValueTema,
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
                          dropdownValueTema = newValue;
                        });
                      },
                      items: tema.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['nama_tema']),
                          value: item['idtema'].toString(),
                        );
                      }).toList(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => new MyAddTheme()));
                    },
                    child: Text(
                      'Tidak ada tema?',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0.0, top: 20.0),
                  ),
                  Text(
                    '*Katalog gambar:',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  showImage(setpictname),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: RaisedButton(
                          padding: const EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () async {
                            pictname = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Jenis Gambar'),
                                    content: setupAlertDialoadContainer(),
                                  );
                                });
                            if (pictname == null) {
                            } else {
                              setState(() {
                                getpictname = pictname.split(",");
                                setpictname = getpictname[1];
                              });
                            }
                          },
                          child: new Text("Pilih gambar dari kami"),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: RaisedButton(
                          onPressed: () async {
                            gambarDatabase.clear();
                            Navigator.of(context, rootNavigator: true)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => MyUploadImage(
                                  value: widget.id,
                                ),
                              ),
                            )
                                .then((_) {
                              print("bisa g ?");
                              setState(() {
                                print("sampe sini bisa g ?");
                                final String urlFecthGambar = koneksi.connect(
                                    'getGambarPaket.php?id=' + widget.id);
                                Future<String> getDataGambar() async {
                                  Response response =
                                      await dio.get(urlFecthGambar);
                                  print(response.data.toString());
                                  if (mounted) {
                                    setState(() {
                                      var content = json.decode(response.data);

                                      gambarDatabase = content['getGambar'];
                                    });
                                    return 'success!';
                                  }
                                }

                                getDataGambar();
                              });
                            });
                          },
                          textColor: Colors.white,
                          color: Colors.orange,
                          padding: const EdgeInsets.all(8.0),
                          child: new Text(
                            "Pilih dari gambar sendiri",
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => addAdditional(
                            idpaket: widget.id,
                            jumlah: jumlahS,
                          ),
                        ),
                      )
                          .then((_) {
                        print("bisa g ?");
                        setState(() {
                          getdulu = 0.0;
                          print("sampe sini bisa g ?");
                          this.updateListView();
                          this.getBarangs();
                        });
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.red,
                          size: 36.0,
                        ),
                        Text(
                          'Tambah alternatif barang',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      controller: ketsController,
                      autocorrect: false,
                      enabled: false,
                      maxLines: 8,
                      readOnly: true,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Visibility(
                    visible: getaddit,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Nama barang:",
                              style: TextStyle(fontSize: 18),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              width: _deviceSize.size.width / 1,
                              height: 60,
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
                                  });
                                },
                                items: barang.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['nama_aset']),
                                    value: item['idm_asset'].toString() +
                                        "," +
                                        item['nama_aset'].toString(),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              child: RaisedButton(
                                onPressed: () {
                                  if (setIdBarang.length > 1) {
                                    Fluttertoast.showToast(
                                        msg: "Hanya boleh 2 barang saja.");
                                  } else {
                                    String val = dropdownValueBarang.toString();
                                    setState(() {
                                      List stringVal = val.split(",");
                                      setNamaBarang.add(stringVal[1]);
                                      setIdBarang.add(stringVal[0]);
                                      display = "Mantap";
                                    });
                                  }
                                },
                                color: Colors.blue,
                                child: Text(
                                  '+ add',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Isi tambahan aksesoris",
                              style: TextStyle(fontSize: 18),
                            ),
                            futureBuilder(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: RaisedButton(
                          onPressed: () async {
                            if (dropdownValue.toString() == "" ||
                                setpictname.toString() == "") {
                              Fluttertoast.showToast(
                                  msg:
                                      "Silahkan isi data warna dan pilih gambar dari katalog.");
                            } else {
                              if (widget.jenisPakets == "3") {
                                urlPostAdd = koneksi
                                    .connect('postSebelumPemesananPaketRT.php');
                              } else if (widget.jenisPakets == "2") {
                                urlPostAdd = koneksi
                                    .connect('postSebelumPemesananPaketTC.php');
                              } else {
                                urlPostAdd = koneksi
                                    .connect('postSebelumPemesananPaket.php');
                              }
                              if (setIdBarang.isEmpty) {
                                print("urlPostAdd: " + urlPostAdd);
                                print("getjumlah3: " +
                                    widget.jumlahTamu.toString());
                                Response responsePostAdd = await dio.post(
                                    urlPostAdd,
                                    data: FormData.fromMap({
                                      "idpaket": paket[0]['idpaket'].toString(),
                                      "jenis_warna": dropdownValue.toString(),
                                      "jumlah": widget.jumlahTamu.toString(),
                                      "tanggal_pilih": widget.getDate,
                                    }));
                                if (responsePostAdd.data == "gagal") {
                                  Fluttertoast.showToast(
                                      msg: "Ada barang yang kurang");
                                } else {
                                  var content =
                                      json.decode(responsePostAdd.data);

                                  dapatBarang = content['barangs'];
                                  print("Ini isi dapat barang: " +
                                      dapatBarang.toString());
                                  for (var i = 0; i < dapatBarang.length; i++) {
                                    isiBarang = Barang(
                                        dapatBarang[i]['nama_aset'],
                                        dapatBarang[i]['idm_asset'],
                                        int.parse(dapatBarang[i]
                                                ['jumlahKeterangan']
                                            .toString()),
                                        0.0,
                                        jumlahS,
                                        paket[0]['idpaket'].toString(),
                                        checkusername,
                                        widget.getDate);
                                    int result =
                                        await _helper.saveBarang(isiBarang);
                                    print("ini isi result barang: " +
                                        result.toString());
                                  }
                                  double getGrandOrang = 0.0;
                                  double getGranTotal = 0.0;
                                  if (widget.jenisPakets == "3") {
                                    getGrandOrang = grandtotal * getjumlah3;
                                    getGranTotal = getGrandOrang + getdulu;
                                  } else if (widget.jenisPakets == "2") {
                                    getGrandOrang = grandtotal * 1.0;
                                    getGranTotal = getGrandOrang + getdulu;
                                  } else {
                                    getGrandOrang = grandtotal *
                                        double.parse(widget.jumlahTamu);
                                    getGranTotal = getGrandOrang + getdulu;
                                  }
                                  cart = Cart(
                                      paket[0]['idpaket'].toString(),
                                      paket[0]['nama_paket'].toString(),
                                      paket[0]['idjenis'].toString(),
                                      paket[0]['nama_jenis'].toString(),
                                      dropdownValue.toString(),
                                      dropdownValueTema.toString(),
                                      getpictname[0].toString(),
                                      getpictname[1].toString(),
                                      int.parse(
                                          jumlahController.text.toString()),
                                      getGranTotal,
                                      widget.getDate,
                                      widget.getJam,
                                      checkusername);
                                  int results =
                                      await _helper.saveCustomer(cart);
                                  if (results > 0) {
                                    Fluttertoast.showToast(msg: "Sukses");
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => MyFormStep(
                                        tanggal: widget.getDate,
                                        id: paket[0]['idpaket'].toString(),
                                        jam: widget.getJam.toString(),
                                        user: checkusername,
                                      ),
                                    ));
                                  } else {
                                    Fluttertoast.showToast(msg: "g isa");
                                  }
                                }
                              } else {
                                print("urlPostAdd: " + urlPostAdd);
                                Response responsePostAdd = await dio.post(
                                    urlPostAdd,
                                    data: FormData.fromMap({
                                      "idpaket": paket[0]['idpaket'].toString(),
                                      "jenis_warna": dropdownValue.toString(),
                                      "jumlah": widget.jumlahTamu.toString(),
                                      "tanggal_pilih": widget.getDate,
                                      "idm_asset": setIdBarang.toString(),
                                    }));
                                if (responsePostAdd.data == "gagal") {
                                  Fluttertoast.showToast(
                                      msg: "Ada barang yang kurang");
                                } else {
                                  var content =
                                      json.decode(responsePostAdd.data);

                                  dapatBarang = content['barangs'];
                                  print("Ini isi dapat barang: " +
                                      dapatBarang.toString());
                                  for (var i = 0; i < dapatBarang.length; i++) {
                                    isiBarang = Barang(
                                        dapatBarang[i]['nama_aset'],
                                        dapatBarang[i]['idm_asset'],
                                        int.parse(dapatBarang[i]
                                                ['jumlahKeterangan']
                                            .toString()),
                                        0.0,
                                        1,
                                        paket[0]['idpaket'].toString(),
                                        checkusername,
                                        widget.getDate);
                                    int result =
                                        await _helper.saveBarang(isiBarang);
                                    print("ini isi result barang: " +
                                        result.toString());
                                  }
                                  double getGrandOrang = 0.0;
                                  double getGranTotal = 0.0;

                                  getGrandOrang = grandtotal *
                                      double.parse(widget.jumlahTamu);
                                  getGranTotal = getGrandOrang + getdulu;

                                  cart = Cart(
                                      paket[0]['idpaket'].toString(),
                                      paket[0]['nama_paket'].toString(),
                                      paket[0]['idjenis'].toString(),
                                      paket[0]['nama_jenis'].toString(),
                                      dropdownValue.toString(),
                                      dropdownValueTema.toString(),
                                      getpictname[0].toString(),
                                      getpictname[1].toString(),
                                      int.parse(
                                          jumlahController.text.toString()),
                                      getGranTotal,
                                      widget.getDate,
                                      widget.getJam,
                                      checkusername);
                                  int results =
                                      await _helper.saveCustomer(cart);
                                  if (results > 0) {
                                    Fluttertoast.showToast(msg: "Sukses");
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => MyFormStep(
                                        tanggal: widget.getDate,
                                        id: paket[0]['idpaket'].toString(),
                                        jam: widget.getJam.toString(),
                                        user: checkusername,
                                      ),
                                    ));
                                  } else {
                                    Fluttertoast.showToast(msg: "g isa");
                                  }
                                }
                              }
                            }
                          },
                          color: Colors.blue,
                          child: Text(
                            'Book sekarang',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: RaisedButton(
                          onPressed: () {
                            whatsAppOpen();
                            // Navigator.pop(context);
                          },
                          color: Colors.blue,
                          child: Text(
                            'Hubungi kami',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onWillPop: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Home(
                    value: widget.user,
                  ),
                ),
                (Route<dynamic> route) => false);
          },
        ),
      ),
    );
  }

  Widget grandtotalField() {
    grandtotal = double.parse(paket[0]['harga_awal']);

    MoneyFormatterOutput fo = FlutterMoneyFormatter(amount: grandtotal).output;
    return TextFormField(
      decoration: InputDecoration(labelText: 'Harga awal'),
      readOnly: true,
      initialValue: "Rp." + fo.nonSymbol,
    );
  }

  void whatsAppOpen() async {
    await FlutterLaunch.launchWathsApp(phone: "+6281357999781", message: "");
  }

  Widget setupAlertDialoadContainer() {
    return Container(
        height: 300.0,
        width: 300.0,
        child: GestureDetector(
          child: gambarDatabase.isEmpty
              ? Container(
                  child: Center(
                  child: Text("Tidak ada isi"),
                ))
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey,
                    );
                  },
                  shrinkWrap: true,
                  itemCount: gambarDatabase.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Image.network(
                          koneksi.getImagePaket(
                              gambarDatabase[index]['nama_gambar']),
                          fit: BoxFit.cover),
                      onTap: () {
                        Navigator.of(context).pop(gambarDatabase[index]
                                ['idgambar'] +
                            "," +
                            gambarDatabase[index]['nama_gambar']);
                      },
                    );
                  },
                ),
        ));
  }
}
