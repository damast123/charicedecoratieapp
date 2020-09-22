import 'package:auto_orientation/auto_orientation.dart';
import 'package:charicedecoratieapp/Admin/stok_opname.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:charicedecoratieapp/koneksi.dart';

void main(List<String> args) {
  runApp(MyTampilanBarang());
}

class MyTampilanBarang extends StatelessWidget {
  String usn = "";
  MyTampilanBarang({Key key, this.usn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TampilanBarang(
        usn: usn,
      ),
    );
  }
}

class TampilanBarang extends StatefulWidget {
  String usn = "";
  TampilanBarang({Key key, this.usn}) : super(key: key);

  @override
  _TampilanBarangState createState() => _TampilanBarangState();
}

class _TampilanBarangState extends State<TampilanBarang> {
  bool _sortJumlahAsc = true;
  bool _sortHargaAsc = true;
  bool _sortNamaAsc = true;
  bool _sortWarnaAsc = true;
  bool _sortKategoriAsc = true;

  bool sort = true;
  int numberselect;
  final double fixedColWidth = 60.0;
  final double cellWidth = 100.0;
  final double cellHeight = 80.0;
  final double cellMargin = 10.0;
  final double cellSpacing = 5.0;
  final _rowController = ScrollController();
  final _subTableXController = ScrollController();
  List dataBarang = [];
  final String url = koneksi.connect('getAllAset.php');

  Future<String> getData() async {
    try {
      Response response = await dio.get(url);
      print("Ini isi response: " + response.toString());

      setState(() {
        var content = json.decode(response.data);

        dataBarang = content['m_asset'];
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
          title: Text("Data barang"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height / 1,
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              MyStockOpname(username: widget.usn)));
                    },
                  ),
                  Text("Stok opname"),
                  Text("    ")
                ],
              ),
              if (dataBarang.isNotEmpty)
                StickyHeader(
                    header: Container(
                      child: _buildFixedRow(sizeWidthCol),
                    ),
                    content: Container(child: _buildSubTable(sizeWidthCol))),
              if (dataBarang.isEmpty)
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width / 8),
                  alignment: Alignment.center,
                  child: Text(
                    "Tidak ada data barang. ",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
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
                    width: sizeWidthColl / 3.3, child: Text('Nama barang')),
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
                    dataBarang.sort(
                        (a, b) => a['nama_aset'].compareTo(b['nama_aset']));
                    if (!ascending) {
                      dataBarang = dataBarang.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label:
                    SizedBox(width: sizeWidthColl / 10, child: Text('Jumlah')),
                numeric: false,
                tooltip: "Jumlah",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortJumlahAsc = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortJumlahAsc;
                    }
                    dataBarang
                        .sort((a, b) => a['jumlah'].compareTo(b['jumlah']));
                    if (!ascending) {
                      dataBarang = dataBarang.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 7, child: Text('Harga rata-rata')),
                numeric: false,
                tooltip: "Harga rata-rata",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortHargaAsc = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortHargaAsc;
                    }
                    dataBarang.sort((a, b) =>
                        a['harga_rata_rata'].compareTo(b['harga_rata_rata']));
                    if (!ascending) {
                      dataBarang = dataBarang.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(width: sizeWidthColl / 7, child: Text('Warna')),
                numeric: false,
                tooltip: "Warna",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortWarnaAsc = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortWarnaAsc;
                    }
                    dataBarang.sort(
                        (a, b) => a['jenis_warna'].compareTo(b['jenis_warna']));
                    if (!ascending) {
                      dataBarang = dataBarang.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label:
                    SizedBox(width: sizeWidthColl / 3, child: Text('Kategori')),
                numeric: false,
                tooltip: "Kategori",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortKategoriAsc = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortKategoriAsc;
                    }
                    dataBarang.sort((a, b) =>
                        a['nama_kategori'].compareTo(b['nama_kategori']));
                    if (!ascending) {
                      dataBarang = dataBarang.reversed.toList();
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
        showCheckboxColumn: false,
        columns: [
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 3, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 9.2, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 5.9, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 5.7, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 3.5, child: Text('')),
            numeric: false,
          ),
        ],
        rows: dataBarang
            .map(
              (item) => DataRow(cells: [
                DataCell(SizedBox(
                  width: sizeWidthColl / 3,
                  child: Text(
                    item['nama_aset'],
                  ),
                )),
                DataCell(SizedBox(
                    width: sizeWidthColl / 9.2,
                    child: Text(
                      item['jumlah'],
                    ))),
                DataCell(SizedBox(
                  width: sizeWidthColl / 5.9,
                  child: Text(
                    item['harga_rata_rata'],
                  ),
                )),
                DataCell(SizedBox(
                    width: sizeWidthColl / 6.5,
                    child: Text(
                      item['jenis_warna'],
                    ))),
                DataCell(SizedBox(
                  width: sizeWidthColl / 3.5,
                  child: Text(
                    item['nama_kategori'],
                  ),
                )),
              ]),
            )
            .toList(),
      ),
    );
  }
}
