import 'dart:async';
import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:charicedecoratieapp/Admin/CheckChart.dart';
import 'package:charicedecoratieapp/Admin/CheckProfitLoss.dart';
import 'package:charicedecoratieapp/Admin/Depresiasi.dart';
import 'package:charicedecoratieapp/Admin/DetailHistoryAdmin.dart';
import 'package:charicedecoratieapp/Admin/TampilanBarang.dart';
import 'package:charicedecoratieapp/Admin/TampilanRating.dart';
import 'package:charicedecoratieapp/Admin/add_admin.dart';
import 'package:charicedecoratieapp/Admin/add_gambar_paket.dart';
import 'package:charicedecoratieapp/Admin/add_holliday.dart';
import 'package:charicedecoratieapp/Admin/add_pembelian.dart';
import 'package:charicedecoratieapp/Admin/add_supplier.dart';
import 'package:charicedecoratieapp/Admin/addpaket.dart';
import 'package:charicedecoratieapp/Admin/detail_booking_konsumen.dart';
import 'package:charicedecoratieapp/Admin/history_admin.dart';
import 'package:charicedecoratieapp/Admin/laporan_notaKeluar.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/main.dart';
import 'package:charicedecoratieapp/settingUser.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:charicedecoratieapp/widgets/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

void main() => runApp(home_admin());
DateTime currentBackPressTime;
String v = "";
String s = "";
List userProfileAdmin = [];
String usernames = "";

class home_admin extends StatelessWidget {
  String username = "";

  home_admin({Key key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: My_home_admin(
        value: username,
      ),
    );
  }
}

class My_home_admin extends StatefulWidget {
  // final String value;
  // final String apa;
  String value = "";
  My_home_admin({Key key, this.value}) : super(key: key);

  @override
  _My_home_adminState createState() => _My_home_adminState();
}

class _My_home_adminState extends State<My_home_admin> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MyHomeAdmin(),
    MyReportAdmin(),
    MyProfileAdmin()
  ];
  @override
  void initState() {
    super.initState();
    usernames = widget.value;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    v = "ye";
    bool isBottomBarVisible = true;
    s = "ok";
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: isBottomBarVisible
            ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                onTap: onTabTapped,
                currentIndex: _currentIndex,
                items: [
                  new BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('Beranda'),
                  ),
                  new BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance),
                    title: Text('Laporan'),
                  ),
                  new BottomNavigationBarItem(
                      icon: Icon(Icons.person), title: Text('Profil'))
                ],
              )
            : Container());
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class MyHomeAdmin extends StatelessWidget {
  const MyHomeAdmin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: HomeAdmin(),
      ),
    );
  }
}

class HomeAdmin extends StatefulWidget {
//  Home({Key key, this.value}) : super(key:key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin>
    with TickerProviderStateMixin, AfterLayoutMixin<HomeAdmin> {
  //tabel
  bool _sortBookingAscH = true;
  bool _sortTanggalAscH = true;
  bool _sortNamaAscH = true;
  bool sortH = true;
  int numberselectH;

  bool _sortBookingAscP = true;
  bool _sortTanggalAscP = true;
  bool _sortNamaAscP = true;
  bool sortP = true;
  int numberselectP;

  bool _sortBookingAsc = true;
  bool _sortTanggalAsc = true;
  bool _sortNamaAsc = true;
  bool sort = true;
  int numberselect;
  final double fixedColWidth = 60.0;
  final double cellWidth = 100.0;
  final double cellHeight = 80.0;
  final double cellMargin = 10.0;
  final double cellSpacing = 5.0;
  final _rowController = ScrollController();
  final _subTableXController = ScrollController();

  bool isCheckedList = false;
  bool isCheckedWaiting = true;
  int lengthlist = 0;
  String cekUsername = "";
  final String url = koneksi.connect('getBookingIsDone1.php');

  bool buttonOn = true;
  List bookInProgress = [];
  List history = [];
  var tunggu = "0";
  var berjalan = "0";
  var riwayat = "0";
  List tanggalBook = [];

  final String urlHistory = koneksi.connect('historyBookingMonthAndYear.php');

  final String urlBook =
      koneksi.connect('getBookingIsDone2.php?username=' + usernames);
  Future<String> getDataBook() async {
    bookInProgress.clear();
    try {
      Response response = await dio.get(urlBook);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        bookInProgress = content['getBooking2'];
        berjalan = bookInProgress.length.toString();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  List bookWaitingList = [];
  Future<String> getData() async {
    bookWaitingList.clear();
    try {
      Response response = await dio.get(url);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        bookWaitingList = content['getBooking1'];
        tunggu = bookWaitingList.length.toString();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _loadSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cekUsername = prefs.getString('username') ?? "";
      var url = koneksi.connect('getProfile.php');
      dio
          .post(url, data: FormData.fromMap({"username": cekUsername}))
          .then((value) {
        var content = json.decode(value.data);
        userProfileAdmin = content['getProfile'];
      });
    });
  }

  Future<String> getDataHistoryBook() async {
    history.clear();
    try {
      Response response = await dio.get(urlHistory);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        history = content['historyBooking'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void showPengerjaanGo() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        content: new Text(
            "Ada pengerjaan paket di hari ini atau besok. Silahkan di cek atau disiapkan barang nya."),
        actions: <Widget>[
          new FlatButton(
            child: new Text('DISMISS'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    this.getData();
    this.getDataBook();
    this.getDataHistoryBook();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    this._loadSessionUser();
    sort = false;
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
  }

  @override
  void dispose() {
    AutoOrientation.portraitUpMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AutoOrientation.portraitUpMode();
    var sizeWidthCol = MediaQuery.of(context).size.width;
    return SafeArea(
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Menunggu: ' + tunggu,
                ),
                Tab(
                  text: 'Berjalan: ' + berjalan,
                ),
                Tab(text: 'Riwayat'),
              ],
            ),
            title: Text('Beranda'),
          ),
          body: TabBarView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        child: ListView(
                      children: <Widget>[
                        if (bookWaitingList.isNotEmpty)
                          StickyHeader(
                              header: Container(
                                child: _buildFixedRow(sizeWidthCol),
                              ),
                              content: Container(
                                  child: _buildSubTable(sizeWidthCol))),
                        if (bookWaitingList.isEmpty)
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width / 8),
                            alignment: Alignment.center,
                            child: Text(
                              "Tidak ada data booking. ",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
              new Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        child: ListView(
                      children: <Widget>[
                        if (bookInProgress.isNotEmpty)
                          StickyHeader(
                              header: Container(
                                child: _buildFixedRowProgress(sizeWidthCol),
                              ),
                              content: Container(
                                  child: _buildSubTableProgress(sizeWidthCol))),
                        if (bookInProgress.isEmpty)
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width / 8),
                            alignment: Alignment.center,
                            child: Text(
                              "Tidak ada data booking\nyang berjalan. ",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
              new Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        child: ListView(
                      children: <Widget>[
                        if (history.isNotEmpty)
                          StickyHeader(
                              header: Container(
                                child: _buildFixedRowHistory(sizeWidthCol),
                              ),
                              content: Container(
                                  child: _buildSubTableHistory(sizeWidthCol))),
                        if (history.isEmpty)
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width / 8),
                            alignment: Alignment.center,
                            child: Text(
                              "Tidak ada data riwayat bulan ini. ",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 120,
                  ),
                  RaisedButton(
                    elevation: 0.0,
                    color: Colors.blue,
                    child: Text(
                      'Daftar riwayat lain',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Fluttertoast.showToast(msg: "Tampilin semua history");
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => new MyHistoryAdmin()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        onWillPop: () => onWillPops(),
      ),
    );
  }

  Widget _buildFixedRowProgress(double sizeWidthColl) {
    return Material(
      color: Colors.white,
      child: DataTable(
          horizontalMargin: cellMargin,
          columnSpacing: cellSpacing,
          headingRowHeight: cellHeight,
          dataRowHeight: cellHeight,
          sortAscending: sortP,
          sortColumnIndex: numberselectP,
          columns: [
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 3, child: Text('Kode booking')),
                numeric: false,
                tooltip: "Kode booking",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselectP) {
                      sortP = _sortBookingAscP = ascending;
                    } else {
                      numberselectP = columnIndex;
                      sortP = _sortBookingAscP;
                    }
                    bookInProgress.sort(
                        (a, b) => a['no_booking'].compareTo(b['no_booking']));
                    if (!ascending) {
                      bookInProgress = bookInProgress.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 3, child: Text('Tanggal acara')),
                numeric: false,
                tooltip: "Tanggal acara",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselectP) {
                      sortP = _sortTanggalAscP = ascending;
                    } else {
                      numberselectP = columnIndex;
                      sortP = _sortTanggalAscP;
                    }
                    bookInProgress.sort((a, b) =>
                        a['tanggal_acara'].compareTo(b['tanggal_acara']));
                    if (!ascending) {
                      bookInProgress = bookInProgress.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 3, child: Text('Nama acara')),
                numeric: false,
                tooltip: "Nama acara",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselectP) {
                      sortP = _sortNamaAscP = ascending;
                    } else {
                      numberselectP = columnIndex;
                      sortP = _sortNamaAscP;
                    }
                    bookInProgress.sort(
                        (a, b) => a['nama_acara'].compareTo(b['nama_acara']));
                    if (!ascending) {
                      bookInProgress = bookInProgress.reversed.toList();
                    }
                  });
                }),
          ],
          rows: []),
    );
  }

  Widget _buildSubTableProgress(double sizeWidthColl) {
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
            label: SizedBox(width: sizeWidthColl / 2.7, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 2.7, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 4, child: Text('')),
            numeric: false,
          ),
        ],
        rows: bookInProgress
            .map(
              (item) => DataRow(
                  onSelectChanged: (bool selected) {
                    if (selected) {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => DetailBookCode(
                                    no_booking: item['no_booking'],
                                    username: cekUsername,
                                    isDone: "2",
                                  )));
                    }
                  },
                  cells: [
                    DataCell(SizedBox(
                      width: sizeWidthColl / 2.7,
                      child: Text(
                        item['no_booking'],
                      ),
                    )),
                    DataCell(SizedBox(
                        width: sizeWidthColl / 2.7,
                        child: Text(
                          item['tanggal_acara'],
                        ))),
                    DataCell(SizedBox(
                      width: sizeWidthColl / 4,
                      child: Text(
                        item['nama_acara'],
                      ),
                    )),
                  ]),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFixedRowHistory(double sizeWidthColl) {
    return Material(
      color: Colors.white,
      child: DataTable(
          horizontalMargin: cellMargin,
          columnSpacing: cellSpacing,
          headingRowHeight: cellHeight,
          dataRowHeight: cellHeight,
          sortAscending: sortH,
          sortColumnIndex: numberselectH,
          columns: [
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 3, child: Text('Kode booking')),
                numeric: false,
                tooltip: "Kode booking",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselectH) {
                      sortH = _sortBookingAscH = ascending;
                    } else {
                      numberselectH = columnIndex;
                      sortH = _sortBookingAscH;
                    }
                    history.sort(
                        (a, b) => a['no_booking'].compareTo(b['no_booking']));
                    if (!ascending) {
                      history = history.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 3, child: Text('Tanggal acara')),
                numeric: false,
                tooltip: "Tanggal acara",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselectH) {
                      sortH = _sortTanggalAscH = ascending;
                    } else {
                      numberselectH = columnIndex;
                      sortH = _sortTanggalAscH;
                    }
                    history.sort((a, b) =>
                        a['tanggal_acara'].compareTo(b['tanggal_acara']));
                    if (!ascending) {
                      history = history.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 3, child: Text('Nama acara')),
                numeric: false,
                tooltip: "Nama acara",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselectH) {
                      sortH = _sortNamaAscH = ascending;
                    } else {
                      numberselectH = columnIndex;
                      sortH = _sortNamaAscH;
                    }
                    history.sort(
                        (a, b) => a['nama_acara'].compareTo(b['nama_acara']));
                    if (!ascending) {
                      history = history.reversed.toList();
                    }
                  });
                }),
          ],
          rows: []),
    );
  }

  Widget _buildSubTableHistory(double sizeWidthColl) {
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
            label: SizedBox(width: sizeWidthColl / 2.7, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 2.7, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 4, child: Text('')),
            numeric: false,
          ),
        ],
        rows: history
            .map(
              (item) => DataRow(
                  onSelectChanged: (bool selected) {
                    if (selected) {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (context) => new MyDetailHistoryAdmin(
                                    getBooking: item['no_booking'],
                                    getIsDone: item['_isdone'],
                                  )));
                    }
                  },
                  cells: [
                    DataCell(SizedBox(
                      width: sizeWidthColl / 2.7,
                      child: Text(
                        item['no_booking'],
                      ),
                    )),
                    DataCell(SizedBox(
                        width: sizeWidthColl / 2.7,
                        child: Text(
                          item['tanggal_acara'],
                        ))),
                    DataCell(SizedBox(
                      width: sizeWidthColl / 4,
                      child: Text(
                        item['nama_acara'],
                      ),
                    )),
                  ]),
            )
            .toList(),
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
                    width: sizeWidthColl / 3, child: Text('Kode booking')),
                numeric: false,
                tooltip: "Kode booking",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortBookingAsc = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortBookingAsc;
                    }
                    bookWaitingList.sort(
                        (a, b) => a['no_booking'].compareTo(b['no_booking']));
                    if (!ascending) {
                      bookWaitingList = bookWaitingList.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 3, child: Text('Tanggal acara')),
                numeric: false,
                tooltip: "Tanggal acara",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortTanggalAsc = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortTanggalAsc;
                    }
                    bookWaitingList.sort((a, b) =>
                        a['tanggal_acara'].compareTo(b['tanggal_acara']));
                    if (!ascending) {
                      bookWaitingList = bookWaitingList.reversed.toList();
                    }
                  });
                }),
            DataColumn(
                label: SizedBox(
                    width: sizeWidthColl / 3, child: Text('Nama acara')),
                numeric: false,
                tooltip: "Nama acara",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (columnIndex == numberselect) {
                      sort = _sortNamaAsc = ascending;
                    } else {
                      numberselect = columnIndex;
                      sort = _sortNamaAsc;
                    }
                    bookWaitingList.sort(
                        (a, b) => a['nama_acara'].compareTo(b['nama_acara']));
                    if (!ascending) {
                      bookWaitingList = bookWaitingList.reversed.toList();
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
            label: SizedBox(width: sizeWidthColl / 2.7, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 2.7, child: Text('')),
            numeric: false,
          ),
          DataColumn(
            label: SizedBox(width: sizeWidthColl / 4, child: Text('')),
            numeric: false,
          ),
        ],
        rows: bookWaitingList
            .map(
              (item) => DataRow(
                  onSelectChanged: (bool selected) {
                    if (selected) {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => DetailBookCode(
                                    no_booking: item['no_booking'],
                                    username: cekUsername,
                                    isDone: "1",
                                  )));
                    }
                  },
                  cells: [
                    DataCell(SizedBox(
                      width: sizeWidthColl / 2.7,
                      child: Text(
                        item['no_booking'],
                      ),
                    )),
                    DataCell(SizedBox(
                        width: sizeWidthColl / 2.7,
                        child: Text(
                          item['tanggal_acara'],
                        ))),
                    DataCell(SizedBox(
                      width: sizeWidthColl / 4,
                      child: Text(
                        item['nama_acara'],
                      ),
                    )),
                  ]),
            )
            .toList(),
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    // TODO: implement afterFirstLayout
    final _selectedDay = DateTime.now();
    var dateNow = DateFormat('yyyy-MM-dd').format(_selectedDay);

    final String urlTanggalBooking =
        koneksi.connect('getBookTanggal.php?username=' + usernames);
    if (ad1 == "ada") {
      tanggalBook.clear();
      try {
        Response response = await dio.get(urlTanggalBooking);
        print("Ini isi response: " + response.toString());
        setState(() {
          var content = json.decode(response.data);

          tanggalBook = content['getBookingTanggal'];
        });
        for (var i = 0; i < tanggalBook.length; i++) {
          DateTime d1 = DateTime.parse(tanggalBook[i]['tanggal']);
          DateTime d2 = DateTime.parse(dateNow);
          var difference = d2.difference(d1).inDays;
          print("ini isi difference dari tanggal: " + difference.toString());
          if (difference == 0 || difference == -1) {
            showPengerjaanGo();
            ad1 = "";
            break;
          }
          break;
        }
      } catch (e) {
        print(e.toString());
      }
    } else {}
  }
}

//disini untuk home
//pisah

class MyReportAdmin extends StatelessWidget {
  const MyReportAdmin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReportAdmin(),
    );
  }
}

class ReportAdmin extends StatefulWidget {
  // const PesananKonsumen({Key key, this.choice}) : super(key: key);
  // final Choice choice;
  @override
  _ReportAdminState createState() => _ReportAdminState();
}

class _ReportAdminState extends State<ReportAdmin> {
  final String urlfavtable = koneksi.connect('Favpaket.php');
  var setFavTab = true;
  List favTable = [];
  var getmonth = "";
  var getyear = "";

  Future<String> getDataTable() async {
    try {
      Response response = await dio.get(urlfavtable);
      print("Ini isi response: " + response.toString());
      if (response.data == "kosong") {
        setFavTab = false;
      } else {
        setState(() {
          var content = json.decode(response.data);

          favTable = content['paketfav'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List getProfitLoss = [];
  double getUntung = 0;
  double getRugi = 0;
  final String urlGetProfitLoss = koneksi.connect('profitandloss.php');
  Future<String> getDataProfitLoss() async {
    try {
      Response response = await dio.get(urlGetProfitLoss);
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        getProfitLoss = content['labarugi'];
        getUntung = double.parse(getProfitLoss[0]['untung']);
        getRugi = double.parse(getProfitLoss[1]['rugi']);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    this.getDataTable();
    this.getDataProfitLoss();

    var now = new DateTime.now();
    getmonth = now.month.toString();
    getyear = now.year.toString();
  }

  @override
  void dispose() {
    AutoOrientation.portraitUpMode();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AutoOrientation.portraitUpMode();
    MoneyFormatterOutput foUntung =
        FlutterMoneyFormatter(amount: getUntung).output;
    MoneyFormatterOutput foRugi = FlutterMoneyFormatter(amount: getRugi).output;
    return SafeArea(
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Laporan admin'),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'Pendapatan dan pengeluaran bulan ini',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Container(
                    height: 75.0,
                    child: getProfitLoss.isEmpty
                        ? Container(
                            child: Text(
                              "Tidak ada pembelian atau jasa booking diterima",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: Colors.grey,
                              );
                            },
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  color: Colors.white,
                                  child: Table(
                                    border:
                                        TableBorder.all(color: Colors.black),
                                    children: [
                                      TableRow(children: [
                                        Text(
                                          '  Pendapatan',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        Text(
                                          '  Pengeluaran',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Text(
                                          '  Rp.' +
                                              foUntung.nonSymbol.toString(),
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.cyan[600]),
                                        ),
                                        Text(
                                          '  Rp.' + foRugi.nonSymbol.toString(),
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.red[600]),
                                        ),
                                      ])
                                    ],
                                  ));
                            }),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (context) => new CheckProfitLoss(
                                    year: getyear.toString(),
                                    month: getmonth.toString(),
                                  )));
                    },
                    child: Text(
                      'Check statistika pendapatan pengeluaran',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    'Favorit dekorasi meja berdasarkan populer:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Container(
                      height: 175,
                      child: favTable.isEmpty
                          ? Container(
                              padding: EdgeInsets.only(left: 30.0),
                              child: Text(
                                "Kosong",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: favTable.length,
                              itemBuilder: (BuildContext context, index) {
                                return Container(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                              favTable[index]['nama_paket'],
                                              style: TextStyle(
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'Rating : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .amber[500]),
                                                    ),
                                                    Text(
                                                      favTable[index]['rating']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 15.0),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })),
                  SizedBox(
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: setFavTab
                          ? () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                      builder: (context) => new MyCheckChart(
                                            getVal: "1",
                                          )));
                            }
                          : null,
                      child: Text(
                        'Cek statistika dekorasi meja',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              new LaporanAdmin()));
                                },
                                child: Text(
                                  'Cek nota keluar',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: RaisedButton(
                                color: Colors.orange,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              new TampilanBarang(
                                                  usn: userProfileAdmin[0]
                                                      ['username'])))
                                      .then((_) {
                                    setState(() {
                                      AutoOrientation.portraitUpMode();
                                    });
                                  });
                                },
                                child: Text(
                                  'Cek barang',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) => MyDepresiasi()))
                                      .then((_) {
                                    AutoOrientation.portraitUpMode();
                                  });
                                },
                                child: Text(
                                  'Cek depresiasi',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: RaisedButton(
                                color: Colors.orange,
                                onPressed: () {
                                  Fluttertoast.showToast(
                                      msg: "Cek nilai freelance");
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              new MyTamilanRatingUser()))
                                      .then((_) {
                                    AutoOrientation.portraitUpMode();
                                  });
                                },
                                child: Text(
                                  'Cek freelance',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => onWillPops(),
      ),
    );
  }
}

class MyProfileAdmin extends StatelessWidget {
  const MyProfileAdmin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileAdmin(),
    );
  }
}

class ProfileAdmin extends StatefulWidget {
  @override
  _ProfileAdminState createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  _deleteSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('username');
      prefs.remove('password');
      prefs.remove('status');
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AutoOrientation.portraitUpMode();
    return SafeArea(
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profil'),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 35,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 2, 2),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 7,
                          blurRadius: 2,
                          offset: Offset(-20, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Text(
                            'Paket',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: IconButton(
                                  iconSize: (MediaQuery.of(context).size.width *
                                          MediaQuery.of(context).size.height) /
                                      6170,
                                  icon: Icon(Icons.add_circle),
                                  color: Colors.lightGreen,
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                            builder: (context) => add_paket(
                                                  usern: userProfileAdmin[0]
                                                      ['username'],
                                                )));
                                  }),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 197,
                            ),
                            IconButton(
                                iconSize: (MediaQuery.of(context).size.width *
                                        MediaQuery.of(context).size.height) /
                                    6170,
                                icon: Icon(Icons.add_a_photo),
                                color: Colors.blueGrey[600],
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              new MyGambarPaket(
                                                value: userProfileAdmin[0]
                                                    ['username'],
                                              )));
                                }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Tambah paket",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 100,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Tambah gambar",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 2, 2),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 7,
                          blurRadius: 2,
                          offset: Offset(-20, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Text(
                            'Tambahan',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                iconSize: (MediaQuery.of(context).size.width *
                                        MediaQuery.of(context).size.height) /
                                    6170,
                                icon: Icon(Icons.calendar_view_day),
                                color: Colors.red,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              new Add_Holliday(
                                                getVal: userProfileAdmin[0]
                                                    ['username'],
                                              )));
                                }),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 200,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: IconButton(
                                  iconSize: (MediaQuery.of(context).size.width *
                                          MediaQuery.of(context).size.height) /
                                      6170,
                                  icon: Icon(Icons.person_add),
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                new add_Admin()));
                                  }),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: Text(
                                "Tambah hari libur",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 100,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(
                                "Tambah admin",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                iconSize: (MediaQuery.of(context).size.width *
                                        MediaQuery.of(context).size.height) /
                                    6170,
                                icon: Icon(Icons.add_circle),
                                color: Colors.lightGreen,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              new add_Supplier()));
                                }),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 200,
                            ),
                            IconButton(
                                iconSize: (MediaQuery.of(context).size.width *
                                        MediaQuery.of(context).size.height) /
                                    6170,
                                icon: Icon(Icons.add_shopping_cart),
                                color: Colors.cyan[600],
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              new add_Pembelian()));
                                }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                "Tambah suplier",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 100,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Tambah pembelian",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 35,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 2, 2),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 7,
                          blurRadius: 2,
                          offset: Offset(-20, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                iconSize: (MediaQuery.of(context).size.width *
                                        MediaQuery.of(context).size.height) /
                                    6170,
                                icon: Icon(Icons.person),
                                color: Colors.grey[700],
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              new MySettingUser(
                                                username: userProfileAdmin[0]
                                                    ['username'],
                                                nama: userProfileAdmin[0]
                                                    ['nama_user'],
                                                noTelp: userProfileAdmin[0]
                                                    ['no_telp'],
                                                email: userProfileAdmin[0]
                                                    ['email'],
                                              )));
                                }),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 200,
                            ),
                            IconButton(
                                iconSize: (MediaQuery.of(context).size.width *
                                        MediaQuery.of(context).size.height) /
                                    6170,
                                icon: Icon(Icons.exit_to_app),
                                color: Colors.black,
                                onPressed: () {
                                  _deleteSessionUser();
                                  Navigator.of(context, rootNavigator: true)
                                      .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => Login(),
                                          ),
                                          (Route<dynamic> route) => false);
                                  // Navigator.of(context, rootNavigator: true)
                                  //     .pushReplacement(MaterialPageRoute(
                                  //         builder: (context) => Login()));
                                }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Akun saya",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 100,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(
                                "Log out",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => onWillPops(),
      ),
    );
  }
}

Future<bool> onWillPops() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: "Are you sure want to exit app");
    return Future.value(false);
  }
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  return Future.value(true);
}
