import 'dart:async';
import 'dart:convert';

import 'package:charicedecoratieapp/Konsumen/About.dart';
import 'package:charicedecoratieapp/Konsumen/DetailBookingIsDone.dart';
import 'package:charicedecoratieapp/Konsumen/Detail_Pesanan_Confirm.dart';
import 'package:charicedecoratieapp/Konsumen/FAQ.dart';
import 'package:charicedecoratieapp/Konsumen/HomePaketAll.dart';
import 'package:charicedecoratieapp/Konsumen/detailPesananKonsumen.dart';
import 'package:charicedecoratieapp/Konsumen/history_konsumen.dart';
import 'package:charicedecoratieapp/delayed_animation.dart';
import 'package:charicedecoratieapp/helpers/dbhelpers.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/main.dart';
import 'package:charicedecoratieapp/model/jenis.dart';
import 'package:charicedecoratieapp/models/barang.dart';
import 'package:charicedecoratieapp/models/cart.dart';
import 'package:charicedecoratieapp/settingUser.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:charicedecoratieapp/widgets/featured_card.dart';
import 'package:charicedecoratieapp/widgets/featured_card_mostwanted.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';

void main() => runApp(Home());
DateTime currentBackPressTime;
List userProfile = [];
String v = "";

var checkusername = "";
List<Customer> getCartLah = [];
List barangDesk = [];
var minus = "";

class Home extends StatelessWidget {
  String value = "";
  Home({Key key, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeBotKonsumen(
        value: value,
      ),
    );
  }
}

class HomeBotKonsumen extends StatefulWidget {
  String value = "";
  HomeBotKonsumen({Key key, this.value}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeBotKonsumen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int i = 0;
  bool isBottomBarVisible = true;
  var pages = [MyHomeKonsumen(), PesananKonsumen(), ProfileKonsumen()];

  @override
  Widget build(BuildContext context) {
    v = widget.value;
    return Scaffold(
      body: pages[i],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: i,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Beranda'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.shopping_cart),
            title: new Text('Pemesanan'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.person_outline),
            title: new Text('Profil'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = i;
      i = index;
    });
  }
}

class MyHomeKonsumen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Beranda';

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: HomeKonsumen()),
    );
  }
}

class HomeKonsumen extends StatefulWidget {
  @override
  _HomeKonsumenState createState() => _HomeKonsumenState();
}

class _HomeKonsumenState extends State<HomeKonsumen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  DatabaseHelper _helper = DatabaseHelper();

  String cekuser = "";

  final String url = koneksi.connect('getJenisPaket.php');
  List jenis = [];
  int count = 1;
  Future getData() async {
    jenis.clear();
    try {
      Response response = await dio.get(url);

      var content = json.decode(response.data);
      jenis = content['jenis'];
      return jenis;
    } catch (e) {
      print("error object e:" + e);
    }
  }

  final String urlgetmostwanted = koneksi.connect('mostwanted.php');
  List mostwanted = [];

  Future<String> getmostwanted() async {
    mostwanted.clear();
    try {
      Response response = await dio.get(urlgetmostwanted);
      print(response.data.toString());
      setState(() {
        var content = json.decode(response.data);

        mostwanted = content['mostwanted'];
      });

      print('ini isi most wanted: ' + mostwanted.toString());
    } catch (e) {
      print("error object e:" + e);
    }
  }

  _loadSessionUserBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkusername = prefs.getString('username') ?? "";
    });
  }

  _loadSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cekuser = prefs.getString('username') ?? "";
    });
    var urlgetProfile = koneksi.connect('getProfile.php');
    print(checkusername);

    Response response = await dio.post(urlgetProfile,
        data: FormData.fromMap({"username": checkusername}));
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.data}");
    setState(() {
      var content = json.decode(response.data);
      userProfile = content['getProfile'];
    });
  }

  @override
  Future<void> initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) => getData());

    super.initState();
    // for (var i = 0; i < getCartLah.length; i++) {
    //   var tanggal_akhir = DateTime.parse(getCartLah[i].tanggal_acara);
    //   var difference = _selectedDay.difference(tanggal_akhir).inDays;
    //   print("Ini isi difference: " + difference.toString());
    //   print("Ini isi getCartLah: " + getCartLah[i].tanggal_acara);
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _afterLayout(_) async {
    _loadSessionUserBook();
    this.getData();
    this.getmostwanted();
    this._loadSessionUser();
    int result = await _helper.deleteBarang();

    if (result > 0) {
      await _helper.deleteCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Container(
          child: SingleChildScrollView(
            child: DelayedAimation(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => MYHome_paket(
                                          getVal: "false",
                                          user: cekuser,
                                        )));
                          },
                          child: Text(
                            'Lihat semua paket',
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Paket yang sering dipesan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  // StreamBuilder(
                  //   stream: mostwanted,
                  // ),
                  Container(
                      height: 230,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mostwanted == null ? 0 : mostwanted.length,
                          itemBuilder: (_, index) {
                            return FeaturedCardMostWanted(
                                name: mostwanted[index]['nama_paket'],
                                jenisPaket: mostwanted[index]['nama_jenis'],
                                id: mostwanted[index]['idpaket'],
                                picture: mostwanted[index]['nama_gambar'],
                                user: cekuser);
                          })),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 15, bottom: 10),
                    child: Text(
                      'Jenis paket',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data);
                        return Container(
                            height: 230,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return FeaturedCard(
                                    name: snapshot.data[index]['nama_jenis'],
                                    id: snapshot.data[index]['idjenis'],
                                    picture: snapshot.data[index]
                                        ['gambar_jenis'],
                                    usern: cekuser,
                                  );
                                }));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  // Container(
                  //     height: 230,
                  //     child: jenis.isEmpty
                  //         ? Container(
                  //             padding: EdgeInsets.only(left: 30.0),
                  //             child: Text(
                  //               "Tidak ada jenis",
                  //               style: TextStyle(
                  //                 fontSize: 20,
                  //               ),
                  //             ),
                  //           )
                  //         : ListView.builder(
                  //             scrollDirection: Axis.horizontal,
                  //             itemCount: jenis.length,
                  //             itemBuilder: (_, index) {
                  //               return FeaturedCard(
                  //                 name: jenis[index]['nama_jenis'],
                  //                 id: jenis[index]['idjenis'],
                  //                 picture: jenis[index]['gambar_jenis'],
                  //                 usern: cekuser,
                  //               );
                  //             })),
                ],
              ),
              delay: 100,
            ),
          ),
        ),
        onWillPop: () {
          {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime) > Duration(seconds: 2)) {
              currentBackPressTime = now;
              Fluttertoast.showToast(msg: "Are you sure want to back");
              return Future.value(false);
            }
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return Future.value(true);
          }
        });
  }
}

class PesananKonsumen extends StatefulWidget {
  @override
  _PesananKonsumenState createState() => _PesananKonsumenState();
}

class _PesananKonsumenState extends State<PesananKonsumen>
    with TickerProviderStateMixin {
  DatabaseHelper _helper = DatabaseHelper();
  AnimationController _controller;
  bool showConfirm = false;
  final String urlGetWaitingList =
      koneksi.connect('getBookingIsDone0.php?username=' + checkusername);
  final String url = koneksi
      .connect('getBookingIsDoneKonsumen2.php?username=' + checkusername);
  final String urlHistory = koneksi.connect(
      'historyBookingMonthAndYearKonsumen.php?username=' + checkusername);
  bool buttonOn = true;

  List<Barang> getCartBarang = [];
  List history = [];
  List waitingList = [];
  List book = [];

  Future<String> getDataBook() async {
    book.clear();
    try {
      Response response = await dio.get(url);
      print(response.data.toString());
      setState(() {
        var content = json.decode(response.data);

        book = content['getBooking2'];
      });
    } catch (e) {
      print("error object e:" + e);
    }
  }

  Future<String> getDataWaitingList() async {
    waitingList.clear();
    try {
      Response response = await dio.get(urlGetWaitingList);
      print(response.data.toString());
      setState(() {
        var content = json.decode(response.data);

        waitingList = content['getBooking0'];
      });
    } catch (e) {
      print("error object e:" + e);
    }
  }

  Future<String> getDataHistoryBook() async {
    history.clear();
    try {
      Response response = await dio.get(urlHistory);
      print(response.data.toString());
      setState(() {
        var content = json.decode(response.data);
        history = content['historyBooking'];
      });
    } catch (e) {
      print("error object e:" + e);
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
    this.getDataHistoryBook();
    this.getDataWaitingList();
    this.getDataBook();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: WillPopScope(
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.payment)),
                    Tab(icon: Icon(Icons.list)),
                    Tab(icon: Icon(Icons.history)),
                  ],
                ),
                title: Text('Pemesanan'),
              ),
              body: DelayedAimation(
                child: TabBarView(
                  children: <Widget>[
                    new SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 30,
                          ),
                          Text(
                            'Booking dan menunggu pembayaran',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            child: waitingList.isEmpty
                                ? Container(
                                    child: Text(
                                      "Tidak ada booking yang akan dibayar",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  )
                                : Container(
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    child: ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return Divider(
                                            color: Colors.grey,
                                          );
                                        },
                                        itemCount: waitingList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Card(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    ListTile(
                                                      title: Text(
                                                        waitingList[index]
                                                            ['no_booking'],
                                                        style: TextStyle(
                                                            fontSize: 25.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Text(
                                                                'Nama acara : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                  waitingList[
                                                                          index]
                                                                      [
                                                                      'nama_acara'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16))
                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Text(
                                                                'Tanggal acara : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                  waitingList[
                                                                          index]
                                                                      [
                                                                      'tanggal_acara'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16))
                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Text(
                                                                'Grandtotal : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                  waitingList[
                                                                          index]
                                                                      [
                                                                      'grandtotal'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: Icon(
                                                          Icons
                                                              .keyboard_arrow_right,
                                                          color: Colors.black,
                                                          size: 30.0),
                                                      onTap: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                new MyDetailPesananConfirm(
                                                              booking: waitingList[
                                                                      index][
                                                                  'no_booking'],
                                                              user: userProfile[
                                                                      0]
                                                                  ['username'],
                                                            ),
                                                          ),
                                                        )
                                                            .then(
                                                          (_) {
                                                            this.getDataHistoryBook();
                                                            this.getDataWaitingList();
                                                            this.getDataBook();
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    new Column(
                      children: <Widget>[
                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  'Daftar pesanan',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                if (book.isEmpty)
                                  Container(
                                      child: Text(
                                    'Tidak ada data pesanan',
                                    style: TextStyle(fontSize: 20),
                                  )),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: book.isEmpty
                                      ? Container(
                                          padding: EdgeInsets.all(100.0),
                                          child: Text(
                                            'Kosong',
                                            style: TextStyle(fontSize: 20),
                                          ))
                                      : ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color: Colors.grey,
                                            );
                                          },
                                          itemCount: book.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Card(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      ListTile(
                                                        title: Text(
                                                          book[index]
                                                              ['no_booking'],
                                                          style: TextStyle(
                                                              fontSize: 25.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        subtitle: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  'Nama acara : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                    book[index][
                                                                        'nama_acara'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  'Tanggal acara : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                    book[index][
                                                                        'tanggal_acara'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  'Grandtotal : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                    book[index][
                                                                        'grandtotal'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16))
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        trailing: Icon(
                                                            Icons
                                                                .keyboard_arrow_right,
                                                            color: Colors.black,
                                                            size: 30.0),
                                                        onTap: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .push(
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          new MyDetailPesanPaketKonsumen(
                                                                            noBooking:
                                                                                book[index]['no_booking'],
                                                                          )));
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    new Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Riwayat booking',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          height: 270.0,
                          child: history.isEmpty
                              ? Container(
                                  padding: EdgeInsets.all(100.0),
                                  child: Text(
                                    'Tidak ada riwayat\nbooking di bulan ini',
                                    style: TextStyle(fontSize: 20),
                                  ))
                              : ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: Colors.grey,
                                    );
                                  },
                                  itemCount: history.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                title: Text(
                                                  history[index]['no_booking'],
                                                  style: TextStyle(
                                                      fontSize: 25.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Nama acara : ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                            history[index][
                                                                'nama_pemesan'],
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Tanggal acara : ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                            history[index][
                                                                'tanggal_acara'],
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Grandtotal : ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          history[index]
                                                              ['grandtotal'],
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'status : ',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        if (history[index]
                                                                ['_isdone'] ==
                                                            "-1")
                                                          Text(
                                                            'Batal',
                                                          ),
                                                        if (history[index]
                                                                ['_isdone'] ==
                                                            "3")
                                                          Text(
                                                            'Selesai',
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                trailing: Icon(
                                                    Icons.keyboard_arrow_right,
                                                    color: Colors.black,
                                                    size: 30.0),
                                                onTap: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              new MyDetailBookDone(
                                                                getBooking: history[
                                                                        index][
                                                                    'no_booking'],
                                                                getIsDone: history[
                                                                        index]
                                                                    ['_isdone'],
                                                              )));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 120,
                        ),
                        RaisedButton(
                          elevation: 0.0,
                          color: Colors.blue,
                          child: Text(
                            'Tampilkan semua riwayat',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (context) => new HistoryKonsumen(
                                          username: userProfile[0]['username'],
                                        )));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                delay: 100,
              ),
            ),
          ),
          onWillPop: () {
            {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime) > Duration(seconds: 2)) {
                currentBackPressTime = now;
                Fluttertoast.showToast(msg: "Are you sure want to back");
                return Future.value(false);
              }
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              return Future.value(true);
            }
          },
        ),
      ),
    );
  }

  void whatsAppOpen() async {
    await FlutterLaunch.launchWathsApp(phone: "+6281357999781", message: "");
  }
}

class ProfileKonsumen extends StatefulWidget {
  @override
  _ProfileKonsumenState createState() => _ProfileKonsumenState();
}

class _ProfileKonsumenState extends State<ProfileKonsumen>
    with TickerProviderStateMixin {
  AnimationController _controller;

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
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
    print("ini isi userprofile: " + userProfile[0]['nama_user']);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Profil'),
            ),
            body: DelayedAimation(
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 13,
                              blurRadius: 15,
                              offset:
                                  Offset(-20, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                    iconSize:
                                        (MediaQuery.of(context).size.width *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height) /
                                            4608,
                                    icon: Icon(Icons.android),
                                    color: Colors.green,
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  new MyAbout()));
                                    }),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 500,
                                ),
                                IconButton(
                                    iconSize:
                                        (MediaQuery.of(context).size.width *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height) /
                                            4608,
                                    icon: Icon(Icons.info_outline),
                                    color: Colors.lightBlue,
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  new MyFAQ()));
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 6.5),
                                  child: Text(
                                    "About",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 80,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 9.5),
                                  child: Text(
                                    "FAQ",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 13,
                              blurRadius: 15,
                              offset:
                                  Offset(-20, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                    iconSize:
                                        (MediaQuery.of(context).size.width *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height) /
                                            4608,
                                    icon: Icon(Icons.account_box),
                                    color: Colors.black87,
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  new MySettingUser(
                                                    username: userProfile[0]
                                                        ['username'],
                                                    nama: userProfile[0]
                                                        ['nama_user'],
                                                    noTelp: userProfile[0]
                                                        ['no_telp'],
                                                    email: userProfile[0]
                                                        ['email'],
                                                  )));
                                    }),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 50,
                                ),
                                IconButton(
                                  iconSize: (MediaQuery.of(context).size.width *
                                          MediaQuery.of(context).size.height) /
                                      4608,
                                  icon: Icon(Icons.exit_to_app),
                                  color: Colors.red,
                                  onPressed: () {
                                    _deleteSessionUser();
                                    Navigator.of(context, rootNavigator: true)
                                        .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) => Login(),
                                            ),
                                            (Route<dynamic> route) => false);
                                  },
                                ),
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
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              delay: 100,
            ),
          ),
        ),
        onWillPop: () {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: "Are you sure want to back");
            return Future.value(false);
          }
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return Future.value(true);
        });
  }
}
