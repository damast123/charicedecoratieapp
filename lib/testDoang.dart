import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:charicedecoratieapp/koneksi.dart';

void main() {
  runApp(MyCustomDataTable());
}

var _rowsCells = [[]];
final _fixedColCells = [];
final _fixedRowCells = ["Date", "Goods Name", "In", "Price", "Out", "Price"];

class MyCustomDataTable extends StatelessWidget {
  const MyCustomDataTable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 10),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: Text("data"),
                ),
              ),
              Center(
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      children: [],
                    )
                    // Text(
                    //   "Paket",
                    //   style: TextStyle(fontSize: 22),
                    // ),
                    ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  "Paket",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: new Card(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                    child: new Row(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Icon(Icons.add_comment),
                      ),
                      new SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(2.0),
                        child: Text("Paket"),
                      )
                    ]),
                  )))
            ],
          )
          // CustomDataTable(
          //   rowsCells: _rowsCells,
          //   fixedColCells: _fixedColCells,
          //   fixedRowCells: _fixedRowCells,
          //   cellBuilder: (data) {
          //     return Text('$data', style: TextStyle(color: Colors.red));
          //   },
          // ),
          ),
    );
  }
}

class CustomDataTable<T> extends StatefulWidget {
  final T fixedCornerCell;
  final List<T> fixedColCells;
  final List<T> fixedRowCells;
  final List<List<T>> rowsCells;

  final Widget Function(T data) cellBuilder;
  final double fixedColWidth;
  final double cellWidth;
  final double cellHeight;
  final double cellMargin;
  final double cellSpacing;

  CustomDataTable({
    this.fixedCornerCell,
    this.fixedColCells,
    this.fixedRowCells,
    @required this.rowsCells,
    this.cellBuilder,
    this.fixedColWidth = 60.0,
    this.cellHeight = 56.0,
    this.cellWidth = 120.0,
    this.cellMargin = 10.0,
    this.cellSpacing = 10.0,
  });

  @override
  State<StatefulWidget> createState() => CustomDataTableState();
}

class CustomDataTableState<T> extends State<CustomDataTable<T>> {
  final _columnController = ScrollController();
  final _rowController = ScrollController();
  final _subTableYController = ScrollController();
  final _subTableXController = ScrollController();
  bool sort;
  var numberselect = 1;
  final String url = koneksi.connect('getAsset.php');
  var data =
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

        var strings = [];
        _rowsCells.removeAt(0);
        for (var i = 0; i < data.length; i++) {
          _fixedColCells.add(i);
          _rowsCells.add([
            data[i]['idm_asset'],
            data[i]['nama_aset'],
            data[i]['jumlah'],
            data[i]['harga_rata_rata'],
            data[i]['out'],
            data[i]['price']
          ]);
          strings.add([
            data[i]['idm_asset'],
            data[i]['idm_asset'],
            data[i]['idm_asset'],
            data[i]['idm_asset'],
            data[i]['idm_asset'],
            data[i]['idm_asset']
          ]);
        }
        // _rowsCells = strings.map((j) => j.cast<int>()).toList();
        print('Ini data' + data.toString());
        print('Ini strings ' + strings.toString());
        print('Ini Row Cell' + _rowsCells.toString());
      });
      return 'success!';
    }
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
        data.sort(
            (a, b) => a['harga_rata_rata'].compareTo(b['harga_rata_rata']));
      } else {
        data.sort(
            (a, b) => b['harga_rata_rata'].compareTo(a['harga_rata_rata']));
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

  Widget _buildChild(double width, T data) => SizedBox(
      width: width, child: widget.cellBuilder?.call(data) ?? Text('$data'));
  // samping nya, Dibawah yang null
  Widget _buildFixedCol() => widget.fixedColCells == null
      ? SizedBox.shrink()
      : Material(
          color: Colors.red,
          child: DataTable(
              horizontalMargin: widget.cellMargin,
              columnSpacing: widget.cellSpacing,
              headingRowHeight: widget.cellHeight,
              dataRowHeight: widget.cellHeight,
              columns: [
                DataColumn(
                    label: _buildChild(
                        widget.fixedColWidth, widget.fixedColCells.first))
              ],
              rows: widget.fixedColCells
                  .sublist(widget.fixedRowCells == null ? 1 : 0)
                  .map((c) => DataRow(
                      cells: [DataCell(_buildChild(widget.fixedColWidth, c))]))
                  .toList()),
        );
  // atasnya, samping nya null
  Widget _buildFixedRow() => widget.fixedRowCells == null
      ? SizedBox.shrink()
      : Material(
          color: Colors.blue,
          child: DataTable(
              horizontalMargin: widget.cellMargin,
              columnSpacing: widget.cellSpacing,
              headingRowHeight: widget.cellHeight,
              dataRowHeight: widget.cellHeight,
              sortAscending: sort,
              sortColumnIndex: numberselect,
              columns: widget.fixedRowCells
                  .map((c) => DataColumn(
                      label: _buildChild(widget.cellWidth, c),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          print('ini fixed row ' +
                              _fixedRowCells.length.toString());
                          // numberselect = _rowsCells.length;
                          sort = !sort;
                        });
                        onSort(columnIndex, ascending);
                      }))
                  .toList(),
              rows: []),
        );
  //Isinya
  Widget _buildSubTable() => Material(
      color: Colors.lightGreenAccent,
      child: DataTable(
          horizontalMargin: widget.cellMargin,
          columnSpacing: widget.cellSpacing,
          headingRowHeight: widget.cellHeight,
          dataRowHeight: widget.cellHeight,
          sortAscending: sort,
          sortColumnIndex: numberselect,
          columns: widget.rowsCells.first
              .map((c) => DataColumn(
                  label: _buildChild(widget.cellWidth, c),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      print('ini sub table');
                      numberselect = _rowsCells.length;
                      sort = !sort;
                    });
                    onSort(columnIndex, ascending);
                  }))
              .toList(),
          rows: widget.rowsCells
              .sublist(widget.fixedRowCells == null ? 1 : 0)
              .map((row) => DataRow(
                  cells: row
                      .map((c) => DataCell(_buildChild(widget.cellWidth, c)))
                      .toList()))
              .toList()));
  //Yang null
  Widget _buildCornerCell() =>
      widget.fixedColCells == null || widget.fixedRowCells == null
          ? SizedBox.shrink()
          : Material(
              color: Colors.amberAccent,
              child: DataTable(
                  horizontalMargin: widget.cellMargin,
                  columnSpacing: widget.cellSpacing,
                  headingRowHeight: widget.cellHeight,
                  dataRowHeight: widget.cellHeight,
                  columns: [
                    DataColumn(
                        label: _buildChild(
                            widget.fixedColWidth, widget.fixedCornerCell))
                  ],
                  rows: []),
            );

  @override
  void initState() {
    super.initState();
    this.getData();
    sort = false;
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
    _subTableYController.addListener(() {
      _columnController.jumpTo(_subTableYController.position.pixels);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            SingleChildScrollView(
              controller: _columnController,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              child: _buildFixedCol(),
            ),
            Flexible(
              child: SingleChildScrollView(
                controller: _subTableXController,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: _subTableYController,
                  scrollDirection: Axis.vertical,
                  child: _buildSubTable(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            _buildCornerCell(),
            Flexible(
              child: SingleChildScrollView(
                controller: _rowController,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                child: _buildFixedRow(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
