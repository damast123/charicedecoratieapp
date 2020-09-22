import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:charicedecoratieapp/Freelance/DetailHistory.dart';
import 'package:charicedecoratieapp/Freelance/HistoryFreelance.dart';
import 'package:charicedecoratieapp/api/messaging.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/main.dart';
import 'package:charicedecoratieapp/settingUser.dart';
import 'package:charicedecoratieapp/Freelance/DetailBookingKonsumen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../welcomescreen.dart';

void main() => runApp(home_freelance());
DateTime currentBackPressTime;
String v = "";
String s = "";
List userProfileAdmin = [];
var userfreelnc = "";

class home_freelance extends StatelessWidget {
  String username = "";
  home_freelance({Key key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Myhome_freelance(value: username),
    );
  }
}

class Myhome_freelance extends StatefulWidget {
  String value = "";
  // final String apa;
  Myhome_freelance({Key key, this.value}) : super(key: key);

  @override
  _home_freelanceState createState() => _home_freelanceState();
}

class _home_freelanceState extends State<Myhome_freelance> {
  int _currentIndex = 0;

  final List<Widget> _children = [MyHomeFreelance(), MyProfileFreelance()];
  @override
  void initState() {
    super.initState();
    userfreelnc = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    AutoOrientation.portraitUpMode();
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
                      icon: Icon(Icons.person), title: Text('Profil'))
                ],
              )
            : Container(
                child: Text("Null"),
              ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class MyHomeFreelance extends StatelessWidget {
  const MyHomeFreelance({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: HomeFreelance(),
      ),
    );
  }
}

class HomeFreelance extends StatefulWidget {
//  Home({Key key, this.value}) : super(key:key);

  @override
  _HomeFreelanceState createState() => _HomeFreelanceState();
}

class _HomeFreelanceState extends State<HomeFreelance>
    with TickerProviderStateMixin, AfterLayoutMixin<HomeFreelance> {
  List tanggalBook = [];
  var usernamesFreelance = "";
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
  final String url =
      koneksi.connect('getBookingIsDoneFreelance1.php?username=' + userfreelnc);
  final String urlBook =
      koneksi.connect('getBookingIsDoneFreelance2.php?username=' + userfreelnc);
  bool buttonOn = true;
  List bookInProgress = [];
  List history = [];
  var tunggu = "";
  var berjalan = "";
  var riwayat = "";
  final String urlHistory = koneksi.connect(
      'historyBookingMonthAndYearFreelance.php?username=' + userfreelnc);

  Future<String> getDataBook() async {
    var res = await http
        .get(Uri.encodeFull(urlBook), headers: {'accept': 'application/json'});
    if (mounted) {
      setState(() {
        if (res.body == "0") {
          berjalan = "0";
        } else {
          var content = json.decode(res.body);

          bookInProgress = content['getBooking2'];
          berjalan = bookInProgress.length.toString();
        }
      });
      return 'success!';
    }
  }

  List bookWaitingList = [];
  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull(url), headers: {
      'accept': 'application/json',
      "content-type": "application/json"
    });
    if (mounted) {
      setState(() {
        if (res.body == "0") {
          tunggu = "0";
        } else {
          var content = json.decode(res.body);

          bookWaitingList = content['getBooking1'];
          tunggu = bookWaitingList.length.toString();
        }
      });

      return 'success!';
    }
  }

  _loadSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cekUsername = prefs.getString('username') ?? "";
      var url = koneksi.connect('getProfile.php');
      http.post(url, body: {"username": cekUsername}).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        var content = json.decode(response.body);
        userProfileAdmin = content['getProfile'];
      });
    });
  }

  Future<String> getDataHistoryBook() async {
    var res = await http.get(Uri.encodeFull(urlHistory),
        headers: {'accept': 'application/json'});
    if (mounted) {
      setState(() {
        if (res.body == "0") {
          riwayat = "0";
        } else {
          var content = json.decode(res.body);

          history = content['historyBooking'];
          riwayat = history.length.toString();
        }
      });
      return 'success!';
    }
  }

  @override
  void initState() {
    this.getData();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    this.getData();
    this.getDataBook();
    this._loadSessionUser();
    this.getDataHistoryBook();
    sort = false;
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
  }

  Future sendNotification(String pesan, String token) async {
    await Messaging.sendTo(
      title: "Status booking",
      body: pesan,
      fcmToken: token,
      // fcmToken: fcmToken,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                              "Tidak ada data. ",
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
                              "Tidak ada data. ",
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
                              "Tidak ada data. ",
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
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (context) => new HistoryFreelance(
                                    usernmfreelance: userfreelnc,
                                  )));
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
                      //ini di cek lagi
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => DetailBookCodeFreelance(
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
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  new MyDetailHistoryFreelance(
                                    getBooking: item['no_booking'],
                                    getIsDone: item['_isdone'],
                                    getFreelance: item['username'],
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
                      //ini di cek lagi
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => DetailBookCodeFreelance(
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
  Future<void> afterFirstLayout(BuildContext context) async {
    // TODO: implement afterFirstLayout
    final _selectedDay = DateTime.now();
    var dateNow = DateFormat('yyyy-MM-dd').format(_selectedDay);

    final String urlTanggalBooking =
        koneksi.connect('getBookTanggal.php?username=' + userfreelnc);
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
          print("ini isi difference dari tanggal d1: " + d1.toString());
          print("ini isi difference dari tanggal d2: " + d2.toString());
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

class MyProfileFreelance extends StatelessWidget {
  const MyProfileFreelance({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileFreelance(),
    );
  }
}

class ProfileFreelance extends StatefulWidget {
  @override
  _ProfileFreelanceState createState() => _ProfileFreelanceState();
}

class _ProfileFreelanceState extends State<ProfileFreelance> {
  _deleteSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('username');
      prefs.remove('password');
      prefs.remove('status');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profil'),
          ),
          body: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 13,
                  blurRadius: 15,
                  offset: Offset(-20, 3), // changes position of shadow
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          iconSize: (MediaQuery.of(context).size.width *
                                  MediaQuery.of(context).size.height) /
                              3456,
                          icon: Icon(Icons.person),
                          color: Colors.grey[600],
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (context) => new MySettingUser(
                                          username: userProfileAdmin[0]
                                              ['username'],
                                          nama: userProfileAdmin[0]
                                              ['nama_user'],
                                          noTelp: userProfileAdmin[0]
                                              ['no_telp'],
                                          email: userProfileAdmin[0]['email'],
                                        )));
                          }),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 50,
                      ),
                      IconButton(
                          iconSize: (MediaQuery.of(context).size.width *
                                  MediaQuery.of(context).size.height) /
                              3456,
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
                            //         builder: (context) => new Login()));
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 8.5),
                        child: Text(
                          "My account",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 50,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 11),
                        child: Text(
                          "Log out",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
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
