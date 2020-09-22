import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:charicedecoratieapp/Konsumen/detail_paket_testimoni.dart';
import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/Konsumen/pesan_paket.dart';
import 'package:charicedecoratieapp/helpers/dbhelpers.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/models/barang.dart';
import 'package:charicedecoratieapp/models/cart.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';

Map<DateTime, List> _holidays = {};
void main() => runApp(MyDetailPaketKonsumen());

class MyDetailPaketKonsumen extends StatelessWidget {
  String getbool = "";
  String getDate = "";
  String getJam = "";
  String val = "";
  String user = "";
  MyDetailPaketKonsumen(
      {Key key, this.val, this.getbool, this.getDate, this.getJam, this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailPaketKonsumen(
        value: val,
        getBool: getbool,
        getdate: getDate,
        getjam: getJam,
        user: user,
      ),
    );
  }
}

class DetailPaketKonsumen extends StatefulWidget {
  String value = "";
  String getBool = "";
  String getdate = "";
  String getjam = "";
  String user = "";
  DetailPaketKonsumen(
      {Key key, this.value, this.getBool, this.getdate, this.getjam, this.user})
      : super(key: key);

  @override
  _MyDetailPaketKonsumenState createState() => _MyDetailPaketKonsumenState();
}

class _MyDetailPaketKonsumenState extends State<DetailPaketKonsumen>
    with TickerProviderStateMixin {
  List paket = [];
  List getBarang = [];
  List dataGoogleCalendar = [];
  List dataEventCalendar = [];
  List dataLiburAdmin = [];
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  var _value;
  final format = DateFormat("Hm");
  String startTime;
  String endTime;
  final startTimes = DateTime(2018, 6, 23, 07, 29);
  final endTimes = DateTime(2018, 6, 23, 22, 01);
  var times;
  var date;
  TextEditingController timeController = new TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  bool _isVisiblePesan = false;
  DatabaseHelper _helper = DatabaseHelper();
  Future<List<Customer>> future;
  TextEditingController jumlahTamu = new TextEditingController();
  var ada = "tidak ada";
  List gambar = [];
  String adaRoomAtauBackdrop = "";
  var checkusername = "";
  var url = koneksi.connect('getwarna.php');
  var urlRT = koneksi.connect('getwarnaRoundTable.php');
  Future<List<Barang>> futurebarang;
  List<Barang> kirimBarang = [];
  List setIdPaket = [];
  List setJumlah = [];
  List setIdBarang = [];
  List setTanggalBarang = [];

  _loadSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkusername = prefs.getString('username') ?? "";
    });
  }

  Future<String> fetchPost() async {
    final response = await http.get(
        'https://www.googleapis.com/calendar/v3/calendars/en.indonesian%23holiday%40group.v.calendar.google.com/events?key=AIzaSyDvlHs0BcZVHR_LeME6LLIL-g4HUCqfvrs');
    print(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        var content = json.decode(response.body);

        dataGoogleCalendar = content['items'];
        for (var i = 0; i < dataGoogleCalendar.length; i++) {
          _holidays.addAll({
            DateTime.parse(dataGoogleCalendar[i]['start']['date']): [
              dataGoogleCalendar[i]['summary']
            ]
          });
        }
      });
      return 'sukses';
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<String> fetchLiburAdmin() async {
    final urlLiburAdmin = koneksi.connect('getLiburDate.php');

    Response response = await dio.get(urlLiburAdmin);
    print(response.data.toString());

    if (response.statusCode == 200) {
      setState(() {
        var content = json.decode(response.data);

        dataLiburAdmin = content['getLibur'];
        for (var i = 0; i < dataLiburAdmin.length; i++) {
          _events.addAll(
            {
              DateTime.parse(dataLiburAdmin[i]): ["Libur"],
            },
          );
        }
        print("ini isi libur: " + _events.toString());
      });
      return 'sukses';
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    String v = widget.value;
    _loadSessionUser();
    final String url = koneksi.connect('detailpaket.php?id=' + v);
    Future<String> getData() async {
      Response response = await dio.get(url);
      setState(() {
        var content = json.decode(response.data);

        paket = content['paket'];
      });
    }

    final String urlGetGambar =
        koneksi.connect('getGambarDetailPaket.php?id=' + v);
    Future<String> getDataGetGambar() async {
      Response response = await dio.get(urlGetGambar);
      print(response.data.toString());

      gambar.clear();
      setState(() {
        var content = json.decode(response.data);

        gambar = content['namaGambar'];
      });

      print("ini isi gambar: " + gambar.toString());
    }

    final String urlgetKeterangan =
        koneksi.connect('getKeteranganBarang.php?id=' + v);
    Future<String> getDataKeteranganBarang() async {
      Response response = await dio.get(urlgetKeterangan);
      print(response.data.toString());
      setState(() {
        var content = json.decode(response.data);

        getBarang = content['barang'];
      });
    }

    if (widget.getBool == "true") {
      _isVisiblePesan = true;
    } else {
      _isVisiblePesan = false;
    }

    getDataKeteranganBarang();
    getData();

    getDataGetGambar();
    this.fetchPost();
    fetchLiburAdmin();

    super.initState();
    print("ini yang di detail paket usern: " + widget.user);
    var _now = DateTime.now();
    final _selectedDay = _now.add(new Duration(days: 3));

    final getdates = DateFormat("yyyy-MM-dd").format(_selectedDay);
    date = getdates;
    startTime = DateFormat("Hm").format(startTimes);
    endTime = DateFormat("Hm").format(endTimes);

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    var date1 = day.subtract(Duration(hours: 12));
    var now = new DateTime.now();

    print('CALLBACK: date1 ' + date1.toString());
    print('CALLBACK: date2 ' + now.toString());
    final diference = date1.difference(now).inDays;
    print("isi diference: " + diference.toString());

    if (diference <= 1) {
      Fluttertoast.showToast(msg: "Minimal 2 hari dari hari ini");
      setState(() {
        date = "";
      });
    } else {
      if (events.contains("Libur")) {
        Fluttertoast.showToast(msg: "Libur");
        setState(() {
          date = "Libur";
        });
      } else {
        setState(() {
          final getday = DateFormat("yyyy-MM-dd").format(day);
          date = getday;
          print("hasil date telah berubah: " + date.toString());
        });
      }
    }
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Detail Paket';
    var changesD = double.parse(paket[0]['harga_awal']);
    MoneyFormatterOutput hargaAwal =
        FlutterMoneyFormatter(amount: changesD).output;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: WillPopScope(
            onWillPop: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Home(
                      value: widget.user,
                    ),
                  ),
                  (Route<dynamic> route) => false);
            },
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    SizedBox(
                        height: 350.0,
                        width: 350.0,
                        child: Carousel(
                          images: gambar.map((item) {
                            return CachedNetworkImage(
                              height: 350.0,
                              width: 350.0,
                              fit: BoxFit.cover,
                              imageUrl:
                                  koneksi.getImagePaket(item['nama_gambar']),
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            );
                          }).toList(),
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotColor: Colors.lightGreenAccent,
                          indicatorBgPadding: 5.0,
                          dotBgColor: Colors.purple.withOpacity(0.5),
                          borderRadius: true,
                          moveIndicatorFromBottom: 180.0,
                          noRadiusForIndicator: true,
                          autoplay: false,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 32),
                      child: Table(
                        children: [
                          TableRow(children: [
                            Text(' Package name: ',
                                style: TextStyle(fontSize: 20.0)),
                            Text(
                              ' ' + paket[0]['nama_paket'],
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ]),
                          TableRow(children: [
                            Text('', style: TextStyle(fontSize: 20.0)),
                            Text(
                              '',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ]),
                          TableRow(children: [
                            Text(
                              ' Type of Packet: ',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              ' ' + paket[0]['nama_jenis'],
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ]),
                          TableRow(children: [
                            Text('', style: TextStyle(fontSize: 20.0)),
                            Text(
                              '',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ]),
                          TableRow(children: [
                            Text(' Harga paket: ',
                                style: TextStyle(fontSize: 20.0)),
                            Text(
                              ' Rp.' + hargaAwal.nonSymbol + "/orang",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Rating",
                            style: TextStyle(fontSize: 20),
                          ),
                          AbsorbPointer(
                            absorbing: true,
                            child: RatingBar(
                              initialRating: double.parse(paket[0]['rating']),
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ),
                          Text(paket[0]['rating'] + '/5')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Text(
                      "Paket ini akan include:",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height / 5,
                        child: getBarang.isEmpty
                            ? Container(
                                height: MediaQuery.of(context).size.height / 20,
                                padding: EdgeInsets.all(100.0),
                                child: Text(
                                  'Empty',
                                  style: TextStyle(fontSize: 20),
                                ))
                            : Container(
                                height: MediaQuery.of(context).size.height / 20,
                                child: ListView.builder(
                                    itemCount: getBarang.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        child: Card(
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                              new ListTile(
                                                leading: Container(
                                                  height: 20.0,
                                                  width: 20.0,
                                                  decoration: new BoxDecoration(
                                                    color: Colors.black,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                title: new Text(getBarang[index]
                                                    ['nama_kategori']),
                                              ),
                                            ])),
                                      );
                                    }),
                              )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Wrap(
                      spacing: 20.0,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          new MyDetail_testimoni(
                                            val: paket[0]['idpaket'],
                                          )));
                            },
                            child: Text(
                              'Testimoni',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'SFUIDisplay',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: Color(0xffff2d55),
                            elevation: 0,
                            height: 50,
                            minWidth: MediaQuery.of(context).size.width / 3,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            onPressed: () {
                              if (paket[0]['idjenis'] == "2") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: Form(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  height: 400,
                                                  width: 400,
                                                  child:
                                                      _buildTableCalendarWithBuilders(),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: DateTimeField(
                                                      controller:
                                                          timeController,
                                                      format: format,
                                                      onShowPicker: (context,
                                                          currentValue) async {
                                                        final time =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime: TimeOfDay
                                                              .fromDateTime(
                                                                  currentValue ??
                                                                      DateTime(
                                                                          2018,
                                                                          6,
                                                                          23,
                                                                          07,
                                                                          30)),
                                                        );
                                                        DateTime today =
                                                            DateTime(
                                                                2019,
                                                                9,
                                                                7,
                                                                time.hour,
                                                                time.minute);
                                                        String todays =
                                                            DateFormat("Hm")
                                                                .format(today);
                                                        DateTime getStart =
                                                            DateFormat("Hm")
                                                                .parse(
                                                                    startTime);
                                                        DateTime getEnd =
                                                            DateFormat("Hm")
                                                                .parse(endTime);
                                                        DateTime getToday =
                                                            DateFormat("Hm")
                                                                .parse(todays);
                                                        if (getToday.isAfter(
                                                                getStart) &&
                                                            getToday.isBefore(
                                                                getEnd)) {
                                                          return DateTimeField
                                                              .convert(time);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Hanya menerima dari jam 7:30 sampai 22:00",
                                                              timeInSecForIosWeb:
                                                                  10,
                                                              toastLength: Toast
                                                                  .LENGTH_LONG);
                                                        }
                                                      },
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    child: Text("Submit"),
                                                    onPressed: () async {
                                                      if (date.toString() !=
                                                              "" &&
                                                          timeController.text
                                                                  .toString() !=
                                                              "") {
                                                        if (date.toString() ==
                                                            "Libur") {
                                                          Fluttertoast
                                                              .showToast(
                                                                  msg: "Libur");
                                                        } else {
                                                          var urlBook =
                                                              koneksi.connect(
                                                                  'checkDateAndTimeBooking.php');
                                                          Response response =
                                                              await dio.post(
                                                                  urlBook,
                                                                  data: FormData
                                                                      .fromMap(
                                                                    {
                                                                      "date": date
                                                                          .toString(),
                                                                      "time": timeController
                                                                          .text
                                                                          .toString(),
                                                                    },
                                                                  ));
                                                          if (response.data ==
                                                              "Isi") {
                                                            Response
                                                                responsedata =
                                                                await dio.post(
                                                                    url,
                                                                    data: FormData
                                                                        .fromMap(
                                                                      {
                                                                        "idpaket":
                                                                            paket[0]['idpaket'].toString(),
                                                                        "tanggal":
                                                                            date.toString(),
                                                                        "jumlah":
                                                                            "4"
                                                                      },
                                                                    ));
                                                            if (responsedata
                                                                    .data ==
                                                                "kosong") {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Ada barang yang kosong");
                                                            } else {
                                                              Navigator.of(
                                                                      context)
                                                                  .pushAndRemoveUntil(
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                MyPesanPaketKonsumen(
                                                                          value:
                                                                              paket[0]['idpaket'],
                                                                          jenisPakets:
                                                                              paket[0]['idjenis'],
                                                                          jumlahTamu:
                                                                              "2",
                                                                          getDate:
                                                                              date.toString(),
                                                                          getJam: timeController
                                                                              .text
                                                                              .toString(),
                                                                          user:
                                                                              widget.user,
                                                                        ),
                                                                      ),
                                                                      (Route<dynamic>
                                                                              route) =>
                                                                          false);
                                                            }
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg: response
                                                                    .data
                                                                    .toString());
                                                          }
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Ada data yang masih kosong. Silahkan isi data yang kosong tersebut");
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else if (paket[0]['idjenis'] == "3") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: Form(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text("Minimal 1 meja."),
                                                Padding(
                                                  padding: EdgeInsets.all(3.0),
                                                  child: TextFormField(
                                                    controller: jumlahTamu,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    maxLines: 1,
                                                    decoration: new InputDecoration(
                                                        labelText:
                                                            'Berapa meja',
                                                        hintText:
                                                            'Masukkan jumlah meja yang diinginkan',
                                                        icon: const Icon(
                                                            Icons.people),
                                                        labelStyle: new TextStyle(
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid)),
                                                  ),
                                                ),
                                                Text(
                                                    "Silahkan mengganti tanggal. Minimal 2 hari dari hari ini."),
                                                Container(
                                                  height: 310,
                                                  width: 400,
                                                  child:
                                                      _buildTableCalendarWithBuilders(),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: DateTimeField(
                                                      controller:
                                                          timeController,
                                                      format: format,
                                                      onShowPicker: (context,
                                                          currentValue) async {
                                                        final time =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime: TimeOfDay
                                                              .fromDateTime(
                                                                  currentValue ??
                                                                      DateTime(
                                                                          2018,
                                                                          6,
                                                                          23,
                                                                          07,
                                                                          30)),
                                                        );
                                                        DateTime today =
                                                            DateTime(
                                                                2019,
                                                                9,
                                                                7,
                                                                time.hour,
                                                                time.minute);
                                                        String todays =
                                                            DateFormat("Hm")
                                                                .format(today);
                                                        DateTime getStart =
                                                            DateFormat("Hm")
                                                                .parse(
                                                                    startTime);
                                                        DateTime getEnd =
                                                            DateFormat("Hm")
                                                                .parse(endTime);
                                                        DateTime getToday =
                                                            DateFormat("Hm")
                                                                .parse(todays);
                                                        if (getToday.isAfter(
                                                                getStart) &&
                                                            getToday.isBefore(
                                                                getEnd)) {
                                                          return DateTimeField
                                                              .convert(time);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Hanya menerima dari jam 7:30 sampai 22:00",
                                                              timeInSecForIosWeb:
                                                                  10,
                                                              toastLength: Toast
                                                                  .LENGTH_LONG);
                                                        }
                                                      },
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    child: Text("Submit"),
                                                    onPressed: () async {
                                                      if (date.toString() !=
                                                              "" &&
                                                          timeController.text
                                                                  .toString() !=
                                                              "" &&
                                                          jumlahTamu.text
                                                                  .toString() !=
                                                              "") {
                                                        if (date.toString() ==
                                                            "Libur") {
                                                          Fluttertoast
                                                              .showToast(
                                                                  msg: "Libur");
                                                        } else {
                                                          var jum = int.parse(
                                                              jumlahTamu.text
                                                                  .toString());
                                                          var getJum =
                                                              int.parse(paket[0]
                                                                      [
                                                                      'untuk_berapa_orang']
                                                                  .toString());
                                                          var sendJum =
                                                              jum * getJum;
                                                          if (jum < 1) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Tidak boleh kurang dari 1");
                                                          } else {
                                                            //dio
                                                            var urlBook =
                                                                koneksi.connect(
                                                                    'checkDateAndTimeBooking.php');
                                                            Response response =
                                                                await dio.post(
                                                                    urlBook,
                                                                    data: FormData
                                                                        .fromMap(
                                                                      {
                                                                        "date":
                                                                            date.toString(),
                                                                        "time": timeController
                                                                            .text
                                                                            .toString(),
                                                                      },
                                                                    ));
                                                            if (response.data ==
                                                                "Isi") {
                                                              Response
                                                                  responsedata =
                                                                  await dio.post(
                                                                      urlRT,
                                                                      data: FormData
                                                                          .fromMap(
                                                                        {
                                                                          "idpaket":
                                                                              paket[0]['idpaket'].toString(),
                                                                          "tanggal":
                                                                              date.toString(),
                                                                          "jumlah": jumlahTamu
                                                                              .text
                                                                              .toString(),
                                                                        },
                                                                      ));
                                                              if (responsedata
                                                                      .data ==
                                                                  "kosong") {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Ada barang yang kosong");
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushAndRemoveUntil(
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              MyPesanPaketKonsumen(
                                                                            value:
                                                                                paket[0]['idpaket'],
                                                                            jenisPakets:
                                                                                paket[0]['idjenis'],
                                                                            jumlahTamu:
                                                                                sendJum.toString(),
                                                                            getDate:
                                                                                date.toString(),
                                                                            getJam:
                                                                                timeController.text.toString(),
                                                                            user:
                                                                                widget.user,
                                                                          ),
                                                                        ),
                                                                        (Route<dynamic>
                                                                                route) =>
                                                                            false);
                                                              }
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg: response
                                                                      .data
                                                                      .toString());
                                                            }
                                                          }
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Ada data yang masih kosong. Silahkan isi data yang kosong tersebut");
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: Form(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text("Minimal 3 orang."),
                                                Padding(
                                                  padding: EdgeInsets.all(3.0),
                                                  child: TextFormField(
                                                    controller: jumlahTamu,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    maxLines: 1,
                                                    decoration: new InputDecoration(
                                                        labelText:
                                                            'For many people',
                                                        hintText:
                                                            'Enter number of people include you',
                                                        icon: const Icon(
                                                            Icons.people),
                                                        labelStyle: new TextStyle(
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid)),
                                                  ),
                                                ),
                                                Text(
                                                    "Silahkan mengganti tanggal. Minimal 2 hari dari hari ini."),
                                                Container(
                                                  height: 310,
                                                  width: 400,
                                                  child:
                                                      _buildTableCalendarWithBuilders(),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: DateTimeField(
                                                      controller:
                                                          timeController,
                                                      format: format,
                                                      onShowPicker: (context,
                                                          currentValue) async {
                                                        final time =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime: TimeOfDay
                                                              .fromDateTime(
                                                                  currentValue ??
                                                                      DateTime(
                                                                          2018,
                                                                          6,
                                                                          23,
                                                                          07,
                                                                          30)),
                                                        );
                                                        DateTime today =
                                                            DateTime(
                                                                2019,
                                                                9,
                                                                7,
                                                                time.hour,
                                                                time.minute);
                                                        String todays =
                                                            DateFormat("Hm")
                                                                .format(today);
                                                        DateTime getStart =
                                                            DateFormat("Hm")
                                                                .parse(
                                                                    startTime);
                                                        DateTime getEnd =
                                                            DateFormat("Hm")
                                                                .parse(endTime);
                                                        DateTime getToday =
                                                            DateFormat("Hm")
                                                                .parse(todays);
                                                        if (getToday.isAfter(
                                                                getStart) &&
                                                            getToday.isBefore(
                                                                getEnd)) {
                                                          return DateTimeField
                                                              .convert(time);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Hanya menerima dari jam 7:30 sampai 22:00",
                                                              timeInSecForIosWeb:
                                                                  10,
                                                              toastLength: Toast
                                                                  .LENGTH_LONG);
                                                        }
                                                      },
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    child: Text("Submit"),
                                                    onPressed: () async {
                                                      //dio
                                                      if (date.toString() !=
                                                              "" &&
                                                          timeController.text
                                                                  .toString() !=
                                                              "") {
                                                        if (date.toString() ==
                                                            "Libur") {
                                                          Fluttertoast
                                                              .showToast(
                                                                  msg: "Libur");
                                                        } else {
                                                          var set = int.parse(
                                                              jumlahTamu.text
                                                                  .toString());
                                                          if (set < 3) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "G boleh kurang dari 3.");
                                                          } else {
                                                            var _isDialogShowing =
                                                                true;
                                                            var urlBook =
                                                                koneksi.connect(
                                                                    'checkDateAndTimeBooking.php');
                                                            Response response =
                                                                await dio.post(
                                                                    urlBook,
                                                                    data: FormData
                                                                        .fromMap(
                                                                      {
                                                                        "date":
                                                                            date.toString(),
                                                                        "time": timeController
                                                                            .text
                                                                            .toString(),
                                                                      },
                                                                    ));
                                                            if (response.data ==
                                                                "Isi") {
                                                              Response
                                                                  responsedata =
                                                                  await dio.post(
                                                                      url,
                                                                      data: FormData
                                                                          .fromMap(
                                                                        {
                                                                          "idpaket":
                                                                              paket[0]['idpaket'].toString(),
                                                                          "tanggal":
                                                                              date.toString(),
                                                                          "jumlah": jumlahTamu
                                                                              .text
                                                                              .toString(),
                                                                        },
                                                                      ));
                                                              if (responsedata
                                                                      .data ==
                                                                  "kosong") {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Ada barang yang kosong");
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushAndRemoveUntil(
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              MyPesanPaketKonsumen(
                                                                            value:
                                                                                paket[0]['idpaket'],
                                                                            jenisPakets:
                                                                                paket[0]['idjenis'],
                                                                            jumlahTamu:
                                                                                jumlahTamu.text.toString(),
                                                                            getDate:
                                                                                date.toString(),
                                                                            getJam:
                                                                                timeController.text.toString(),
                                                                            user:
                                                                                widget.user,
                                                                          ),
                                                                        ),
                                                                        (Route<dynamic>
                                                                                route) =>
                                                                            false);
                                                              }
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg: response
                                                                      .data
                                                                      .toString());
                                                            }
                                                          }
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Ada data yang masih kosong. Silahkan isi data yang kosong tersebut");
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }
                            },
                            child: Text(
                              'Pesan paket',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'SFUIDisplay',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: Color(0xffff2d55),
                            elevation: 0,
                            height: 50,
                            minWidth: MediaQuery.of(context).size.width / 3,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2100));
    if (picked != null) {
      var f = DateFormat('yyyy-MM-dd').format(picked);
      var now = new DateTime.now();
      final diference = picked.difference(now).inDays;
      if (diference <= 1) {
        Fluttertoast.showToast(msg: "");
      }
      setState(() => dateCtl.text = f.toString());
    }
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_US',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.red[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.red[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.red[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.red[300]
            : _calendarController.isToday(date)
                ? Colors.red[500]
                : Colors.red[500],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '#',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  //send notification

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print(_selectedEvents.toString() +
                      'sebelah selected $event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}
