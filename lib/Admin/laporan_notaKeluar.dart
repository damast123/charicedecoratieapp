import 'dart:convert';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:charicedecoratieapp/Admin/Nota_Keluar.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/responsive/responsive_layout_builder.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sticky_headers/sticky_headers.dart';

Future main() async {
  runApp(MyAppLaporanAdmin());
}

class MyAppLaporanAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LaporanAdmin());
  }
}

class LaporanAdmin extends StatefulWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  LaporanAdmin({
    Key key,
  }) : super(key: key);

  @override
  _MyLaporanAdminState createState() => _MyLaporanAdminState();
}

class _MyLaporanAdminState extends State<LaporanAdmin> {
  bool _sortBarangKeluar = true;
  bool _sortTanggalKeluar = true;
  bool _sortNamaAsc = true;
  bool _sortBarangMasuk = true;
  bool _sortTanggalMasuk = true;
  bool _sortHarga = true;
  bool sort = true;
  int numberselect;

  final double fixedColWidth = 60.0;
  final double cellWidth = 100.0;
  final double cellHeight = 80.0;
  final double cellMargin = 10.0;
  final double cellSpacing = 5.0;
  final _rowController = ScrollController();
  final _subTableXController = ScrollController();
  final String url = koneksi.connect('getNotaKeluar.php');
  List data = [];

  Future<String> getData() async {
    try {
      Response response = await dio.get(url);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        data = content['m_asset'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    this.getData();
    sort = false;
    super.initState();
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
  }

  @override
  void dispose() {
    AutoOrientation.landscapeRightMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AutoOrientation.landscapeRightMode();
    var sizeWidthCol = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Laporan nota keluar'),
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MyNotaKeluar()));
                  },
                ),
                Text("Tambah data"),
                Text("    ")
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
                label: SizedBox(
                    width: sizeWidthColl / 4, child: Text('Goods name')),
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
                label:
                    SizedBox(width: sizeWidthColl / 9, child: Text('Date In')),
                numeric: false,
                tooltip: "Tanggal masuk",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortTanggalMasuk = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortTanggalMasuk;
                    }
                    data.sort((a, b) => a['tanggal_pembelian']
                        .compareTo(b['tanggal_pembelian']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 10, child: Text('Goods In')),
                numeric: false,
                tooltip: "Barang masuk",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortBarangMasuk = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortBarangMasuk;
                    }
                    data.sort((a, b) => a['ins'].compareTo(b['ins']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label:
                    SizedBox(width: sizeWidthColl / 9, child: Text('Date Out')),
                numeric: false,
                tooltip: "Tanggal keluar",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortTanggalKeluar = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortTanggalKeluar;
                    }
                    data.sort((a, b) =>
                        a['tanggal_keluar'].compareTo(b['tanggal_keluar']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 10, child: Text('Goods Out')),
                numeric: false,
                tooltip: "Barang keluar",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortBarangKeluar = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortBarangKeluar;
                    }
                    data.sort((a, b) => a['outs'].compareTo(b['outs']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(width: sizeWidthColl / 6, child: Text('Price')),
                numeric: false,
                tooltip: "Harga beli",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortHarga = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortHarga;
                    }
                    data.sort(
                        (a, b) => a['hargabeli'].compareTo(b['hargabeli']));
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
            label: SizedBox(width: sizeWidthColl / 3.7, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 6.8, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 9, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 6.8, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 9, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 6, child: Text('')),
            numeric: false,
          ),
        ],
        rows: data
            .map(
              (item) => DataRow(cells: [
                DataCell(SizedBox(
                  width: sizeWidthColl / 3.7,
                  child: Text(
                    item['nama_aset'],
                  ),
                )),
                DataCell(SizedBox(
                    width: sizeWidthColl / 6.8,
                    child: Text(
                      item['tanggal_pembelian'],
                    ))),
                DataCell(SizedBox(
                  width: sizeWidthColl / 9,
                  child: Text(
                    item['ins'],
                  ),
                )),
                DataCell(SizedBox(
                    width: sizeWidthColl / 6.8,
                    child: Text(
                      item['tanggal_keluar'],
                    ))),
                DataCell(SizedBox(
                  width: sizeWidthColl / 9,
                  child: Text(
                    item['outs'],
                  ),
                )),
                DataCell(SizedBox(
                  width: sizeWidthColl / 6,
                  child: Text(item['hargabeli']),
                )),
              ]),
            )
            .toList(),
      ),
    );
  }
}
