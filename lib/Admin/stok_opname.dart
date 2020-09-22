import 'dart:convert';

import 'package:charicedecoratieapp/Admin/input_stok_opname.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sticky_headers/sticky_headers.dart';

void main() {
  runApp(MyStockOpname());
}

class MyStockOpname extends StatelessWidget {
  String username;
  MyStockOpname({Key key, this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StockOpname(
          username: username,
        ));
  }
}

class StockOpname extends StatefulWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String username;
  StockOpname({Key key, this.username}) : super(key: key);

  @override
  _StockOpnameState createState() => _StockOpnameState();
}

class _StockOpnameState extends State<StockOpname> {
  bool _sortKeterangan = true;
  bool _sortJumlahKomputer = true;
  bool _sortNamaAsc = true;
  bool _sortTanggal = true;
  bool _sortJumlahRiil = true;

  bool sort = true;
  int numberselect;

  final double fixedColWidth = 60.0;
  final double cellWidth = 100.0;
  final double cellHeight = 80.0;
  final double cellMargin = 10.0;
  final double cellSpacing = 5.0;
  final _rowController = ScrollController();
  final _subTableXController = ScrollController();
  final String url = koneksi.connect('getStokOpname.php');
  List data = [];

  Future<String> getData() async {
    try {
      Response response = await dio.get(url);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        data = content['stok_opname'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    this.getData();
    sort = false;
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    var sizeWidthCol = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Stok opname'),
        ),
        body: Container(
          width: sizeWidthCol,
          child: ListView(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    DateTime now = DateTime.now();
                    int lastday = DateTime(now.year, now.month + 1, 0).day;
                    int dayNow = now.day;
                    int getWeek = lastday - dayNow;
                    print("Ini last day: " + lastday.toString());
                    if (getWeek < 7) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MyInputStokOpname(
                                username: widget.username,
                              )));
                    } else {
                      print("Belum sampe");
                      Fluttertoast.showToast(
                          msg:
                              "Stok opname dapat dilakukan 7 hari sebelum hari terakhir",
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIosWeb: 10);
                    }
                  },
                ),
                Text("Tambah data"),
              ],
            ),
            if (data.isNotEmpty)
              StickyHeader(
                  header: Container(
                    child: _buildFixedRow(sizeWidthCol),
                  ),
                  content: Container(child: _buildSubTable(sizeWidthCol))),
            if (data.isEmpty)
              Container(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).size.width / 8),
                alignment: Alignment.center,
                child: Text(
                  "Tidak ada data. ",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _buildFixedRow(double sizeWidthColl) {
    return Material(
      color: Colors.white,
      child: DataTable(
          horizontalMargin: cellMargin,
          columnSpacing: cellSpacing,
          headingRowHeight: cellHeight,
          dataRowHeight: cellHeight,
          sortAscending: sort,
          sortColumnIndex: numberselect,
          columns: [
            DataColumn(
                label:
                    SizedBox(width: sizeWidthColl / 5.5, child: Text('Date')),
                numeric: false,
                tooltip: "Tanggal",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortTanggal = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortTanggal;
                    }
                    data.sort((a, b) => a['tanggal'].compareTo(b['tanggal']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 4.3, child: Text('Goods Name')),
                numeric: false,
                tooltip: "Nama barang",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortNamaAsc = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortNamaAsc;
                    }
                    data.sort(
                        (a, b) => a['nama_aset'].compareTo(b['nama_aset']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 7, child: Text('Real Number')),
                numeric: false,
                tooltip: "Jumlah riil",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortJumlahRiil = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortJumlahRiil;
                    }
                    data.sort(
                        (a, b) => a['jumlah_real'].compareTo(b['jumlah_real']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 7, child: Text('Comp Number')),
                numeric: false,
                tooltip: "Jumlah komputer",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortJumlahKomputer = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortJumlahKomputer;
                    }
                    data.sort(
                        (a, b) => a['jumlah_komp'].compareTo(b['jumlah_komp']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(width: sizeWidthColl / 3, child: Text('Note')),
                numeric: false,
                tooltip: "Keterangan",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortKeterangan = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortKeterangan;
                    }
                    data.sort((a, b) =>
                        a['keterangan_stok'].compareTo(b['keterangan_stok']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
          ],
          rows: []),
    );
  }

  Widget _buildSubTable(double sizeWidthColl) {
    return Material(
      color: Colors.white,
      child: DataTable(
        horizontalMargin: cellMargin,
        columnSpacing: cellSpacing,
        headingRowHeight: 10.0,
        dataRowHeight: cellHeight,
        columns: [
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 5, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 3.4, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 6, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 7, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 4, child: Text('')),
            numeric: false,
          ),
        ],
        rows: data
            .map(
              (item) => DataRow(cells: [
                DataCell(SizedBox(
                    width: sizeWidthColl / 5,
                    child: Text(
                      item['tanggal'],
                    ))),
                DataCell(SizedBox(
                  width: sizeWidthColl / 3.4,
                  child: Text(
                    item['nama_aset'],
                  ),
                )),
                DataCell(SizedBox(
                  width: sizeWidthColl / 6,
                  child: Text(
                    item['jumlah_real'],
                  ),
                )),
                DataCell(SizedBox(
                  width: sizeWidthColl / 7,
                  child: Text(item['jumlah_komp']),
                )),
                DataCell(SizedBox(
                  width: sizeWidthColl / 4,
                  child: Text(
                    item['keterangan_stok'],
                  ),
                )),
              ]),
            )
            .toList(),
      ),
    );
  }
}
