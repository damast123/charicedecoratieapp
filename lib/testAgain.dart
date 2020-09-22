import 'dart:convert';

import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/responsive/layout_size.dart';
import 'responsive/responsive_layout_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sticky_headers/sticky_headers.dart';

void main() {
  runApp(MyAppStatelessWidget());
}

class MyAppStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MyApp({
    Key key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const Map<LayoutSize, String> layoutSizeEnumToString = {
    LayoutSize.watch: 'Wristwatch',
    LayoutSize.mobile: 'Mobile',
    LayoutSize.tablet: 'Tablet',
    LayoutSize.desktop: 'Desktop',
    LayoutSize.tv: 'TV',
  };
  static const Map<MobileLayoutSize, String> mobileLayoutSizeEnumToString = {
    MobileLayoutSize.small: 'Small',
    MobileLayoutSize.medium: 'Medium',
    MobileLayoutSize.large: 'Large',
  };
  static const Map<TabletLayoutSize, String> tabletLayoutSizeEnumToString = {
    TabletLayoutSize.small: 'Small',
    TabletLayoutSize.large: 'Large',
  };
  bool sort;
  var numberselect = 1;
  final double fixedColWidth = 60.0;
  final double cellWidth = 100.0;
  final double cellHeight = 80.0;
  final double cellMargin = 10.0;
  final double cellSpacing = 5.0;
  final _rowController = ScrollController();
  final _subTableXController = ScrollController();
  final String url = koneksi.connect('getAsset.php');
  List data =
      []; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> getData() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    var res = await http
        .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
    if (mounted) {
      setState(() {
        //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
        var content = json.decode(res.body);
        //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
        //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
        data = content['m_asset'];
      });
      return 'success!';
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

  onSort(int columnIndex, bool ascending) {
    if (columnIndex == 1) {
      if (ascending) {
        data.sort((a, b) => a['nama_aset'].compareTo(b['nama_aset']));
      } else {
        data.sort((a, b) => b['nama_aset'].compareTo(a['nama_aset']));
      }
    } else if (columnIndex == 3) {
      if (ascending) {
        data.sort((a, b) => a['hargaMasuk'].compareTo(b['hargaMasuk']));
      } else {
        data.sort((a, b) => b['hargaMasuk'].compareTo(a['hargaMasuk']));
      }
    } else if (columnIndex == 4) {
      if (ascending) {
        // out.clear();
        // for(var i=0;i<data.length;i++)
        // {
        //   out.add(data[i]['jumlah']);
        // }
        // out.sort();
        data.sort((a, b) => int.parse(a['jumlah']) - int.parse(b['jumlah']));
      } else {
        // out.clear();
        // for(var i=0;i<data.length;i++)
        // {
        //   out.add(data[i]['jumlah']);
        // }
        data.sort((a, b) => int.parse(b['jumlah']) - int.parse(a['jumlah']));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    var sizeWidthCol = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Charicedecoratie'),
        ),
        body: ResponsiveLayoutBuilder(
          builder: (context, size) => Container(
            width: sizeWidthCol,
            child: ListView(children: <Widget>[
              Center(
                  child: Text(
                'Good Note',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
              // StickyHeader(
              //     header: Container(
              //       child: _buildFixedRow(),
              //     ),
              //     content: _buildSubTable()),
              StickyHeader(
                  header: Container(
                    child: _buildFixedRow(sizeWidthCol),
                  ),
                  content: Container(child: _buildSubTable(sizeWidthCol))),
            ]),
          ),
        ));
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
                label: SizedBox(width: sizeWidthColl / 10, child: Text('Date')),
                numeric: false,
                tooltip: "Date",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sort = !sort;
                  });
                  onSort(columnIndex, ascending);
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 5, child: Text('Goods Name')),
                numeric: false,
                tooltip: "Goods Name",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sort = !sort;
                  });
                  onSort(columnIndex, ascending);
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 12.5, child: Text('Goods In')),
                numeric: false,
                tooltip: "Goods In",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sort = !sort;
                  });
                  onSort(columnIndex, ascending);
                }),
            DataColumn(
                label: SizedBox(width: sizeWidthColl / 6, child: Text('Price')),
                numeric: false,
                tooltip: "Price",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sort = !sort;
                  });
                  onSort(columnIndex, ascending);
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 10, child: Text('Goods Out')),
                numeric: false,
                tooltip: "Goods Out",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sort = !sort;
                  });
                  onSort(columnIndex, ascending);
                }),
            DataColumn(
                label: SizedBox(width: sizeWidthColl / 6, child: Text('Price')),
                numeric: false,
                tooltip: "Price",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sort = !sort;
                  });
                  onSort(columnIndex, ascending);
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
            label: SizedBox(width: sizeWidthColl / 10, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 5, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 12.5, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 6, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 10, child: Text('')),
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
                    width: sizeWidthColl / 10, //SET width
                    child: Text(
                      'xxxx-xx-xx',
                    ))),
                DataCell(SizedBox(
                  width: sizeWidthColl / 5, //SET width
                  child: Text(
                    item['nama_aset'],
                  ),
                )),
                DataCell(SizedBox(
                  width: sizeWidthColl / 12.5, //SET width
                  child: Text(
                    '1',
                  ),
                )),
                DataCell(SizedBox(
                  width: sizeWidthColl / 6, //SET width
                  child: Text(item['hargaMasuk']),
                )),
                DataCell(SizedBox(
                  width: sizeWidthColl / 10, //SET width
                  child: Text(
                    item['jumlah'],
                  ),
                )),
                DataCell(SizedBox(
                  width: sizeWidthColl / 6, //SET width
                  child: Text(
                    item['hargaKeluar'],
                  ),
                )),
              ]),
            )
            .toList(),
      ),
    );
  }
}
