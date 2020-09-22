import 'dart:convert';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sticky_headers/sticky_headers.dart';

void main() {
  runApp(MyDepresiasi());
}

class MyDepresiasi extends StatelessWidget {
  MyDepresiasi({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeDepresiasi(),
    );
  }
}

class MyHomeDepresiasi extends StatefulWidget {
  MyHomeDepresiasi({Key key}) : super(key: key);

  @override
  _MyHomeDepresiasiState createState() => _MyHomeDepresiasiState();
}

class _MyHomeDepresiasiState extends State<MyHomeDepresiasi> {
  bool _sortNilaiAwal = true;
  bool _sortNilaiAkum = true;
  bool _sortNamaAsc = true;
  bool _sortUsia = true;
  bool _sortNilaiResidu = true;
  bool sort = true;
  int numberselect;

  final double fixedColWidth = 60.0;
  final double cellWidth = 100.0;
  final double cellHeight = 80.0;
  final double cellMargin = 10.0;
  final double cellSpacing = 5.0;
  final _rowController = ScrollController();
  final _subTableXController = ScrollController();
  final String url = koneksi.connect('getDepresiasi.php');
  List data = [];
  Future<String> getDataDepresiasi() async {
    try {
      Response response = await dio.get(url);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        data = content['depresiasi'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    this.getDataDepresiasi();
    sort = false;
    super.initState();

    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
  }

  @override
  void dispose() {
    AutoOrientation.landscapeRightMode();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidthCol = MediaQuery.of(context).size.width;
    AutoOrientation.landscapeRightMode();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Depresiasi"),
        ),
        body: Container(
          width: sizeWidthCol,
          child: ListView(children: <Widget>[
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
                    width: sizeWidthColl / 4, child: Text('Nama barang')),
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
                    SizedBox(width: sizeWidthColl / 9.8, child: Text('Usia')),
                numeric: false,
                tooltip: "Usia",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortUsia = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortUsia;
                    }
                    data.sort(
                        (a, b) => a['umur_barang'].compareTo(b['umur_barang']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 5.8, child: Text('Nilai awal')),
                numeric: false,
                tooltip: "Nilai awal",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortNilaiAwal = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortNilaiAwal;
                    }
                    data.sort(
                        (a, b) => a['nilai_awal'].compareTo(b['nilai_awal']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 5.6, child: Text('Nilai residu')),
                numeric: false,
                tooltip: "Nilai residu",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortNilaiResidu = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortNilaiResidu;
                    }
                    data.sort((a, b) =>
                        a['nilai_residu'].compareTo(b['nilai_residu']));
                    if (!ascending) {
                      data = data.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 7, child: Text('Akumulasi')),
                numeric: false,
                tooltip: "Akumulasi",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortNilaiAkum = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortNilaiAkum;
                    }
                    data.sort((a, b) =>
                        a['nilai_depresiasi'].compareTo(b['nilai_depresiasi']));
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
            label: SizedBox(width: sizeWidthColl / 8, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 5, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 5, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 7, child: Text('')),
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
                  width: sizeWidthColl / 8,
                  child: Text(
                    item['umur_barang'],
                  ),
                )),
                DataCell(SizedBox(
                    width: sizeWidthColl / 5,
                    child: Text(
                      item['nilai_awal'],
                    ))),
                DataCell(SizedBox(
                  width: sizeWidthColl / 5,
                  child: Text(item['nilai_residu']),
                )),
                DataCell(SizedBox(
                  width: sizeWidthColl / 7,
                  child: Text(
                    item['nilai_depresiasi'],
                  ),
                )),
              ]),
            )
            .toList(),
      ),
    );
  }
}
