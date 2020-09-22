import 'dart:async';
import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/helpers/dbhelpers.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/models/barang.dart';
import 'package:charicedecoratieapp/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyBFib6U1jD41vFahReMNicey6c_7DVerl4";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

DateTime currentBackPressTimes;
void main() {
  runApp(MyFormStep());
}

class MyFormStep extends StatelessWidget {
  String tanggal = "";
  String id = "";
  String jam = "";
  String user = "";

  MyFormStep({Key key, this.tanggal, this.id, this.jam, this.user})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FormStepperBody(
        tanggal: tanggal,
        id: id,
        jam: jam,
        user: user,
      ),
    );
  }
}

class FormStepperBody extends StatefulWidget {
  String tanggal = "";
  String id = "";
  String jam = "";
  String user = "";
  FormStepperBody({Key key, this.tanggal, this.id, this.jam, this.user})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _FormStepperBodyState();
  }
}

class _FormStepperBodyState extends State<FormStepperBody>
    with TickerProviderStateMixin, AfterLayoutMixin<FormStepperBody> {
  final format = DateFormat("Hm");
  String startTime;
  String endTime;
  final startTimes = DateTime(2018, 6, 23, 07, 29);
  final endTimes = DateTime(2018, 6, 23, 22, 01);
  int currStep = 0;
  bool complete = false;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var format_order = false;
  String dropdownValuePembayaran;
  String dropdownValueTempat;
  TextEditingController jumlahController = new TextEditingController();
  TextEditingController tempatController = new TextEditingController();
  TextEditingController keteranganController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController eventController = new TextEditingController();
  TextEditingController teleponController = new TextEditingController();

  List dataCaraPembayaran = List();

  bool stepchange = false;
  var times;
  var date;
  String cekUsername = "";
  String namaUser = "";
  DatabaseHelper _helper = DatabaseHelper();
  Future<List<Barang>> futurebarang;
  Future<List<Customer>> futurecart;

  List<Barang> kirimBarang = [];
  List<Customer> kirimCart = [];
  List dataLiburAdmin = [];
  List setIdBarang = [];
  List setJumlahBarang = [];
  List setPaketIdBarang = [];
  var promo = "";

  var kirim = "";
  @override
  void afterFirstLayout(BuildContext context) {
    showRestorantGo();
  }

  void showRestorantGo() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        content: new Text(
            'Pastikan Anda memiliki permintaan di restoran yang diinginkan.'),
        actions: <Widget>[
          new FlatButton(
            child: new Text('DISMISS'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Future<String> fetchCaraPembayaran() async {
    final response = await http.get(koneksi.connect('getTypePayment.php'));

    if (response.statusCode == 200) {
      setState(() {
        var content = json.decode(response.body);

        dataCaraPembayaran = content['carapembayaran'];
        print("cara pembayaran: " + dataCaraPembayaran.toString());
      });
      return 'sukses';
    } else {
      throw Exception('Failed to load post');
    }
  }

  void updateBarang() async {
    setState(() {
      futurebarang = _helper.getBarangs();
    });
  }

  void getBarangs() async {
    final Future<Database> dbFuture = _helper.initializeDatabase();
    await dbFuture.then((database) {
      setState(() {
        Future<List<Barang>> todoListFuture = _helper.getBarangs();
        todoListFuture.then((todoList) {
          setState(() {
            for (var i = 0; i < todoList.length; i++) {
              kirimBarang.add(Barang(
                  todoList[i].good_name,
                  todoList[i].good_id,
                  todoList[i].good_jumlah,
                  todoList[i].good_harga,
                  todoList[i].Cart_id,
                  todoList[i].paket_ID,
                  todoList[i].username_ID,
                  todoList[i].tanggal));
              // getHarga.add(todoList[i].good_harga);
              // getJumlah.add(todoList[i].good_jumlah);
              setIdBarang.add(todoList[i].good_id);
              setJumlahBarang.add(todoList[i].good_jumlah);
              setPaketIdBarang.add(todoList[i].paket_ID);
            }
          });
        });
      });
    });
  }

  void getCarts() async {
    final Future<Database> dbFuture = _helper.initializeDatabase();
    await dbFuture.then((database) {
      setState(() {
        Future<List<Customer>> todoListFuture = _helper.getCustomerCarts();
        todoListFuture.then((todoList) {
          setState(() {
            for (var i = 0; i < todoList.length; i++) {
              kirimCart.add(Customer(
                  todoList[i].id,
                  todoList[i].paket_id,
                  todoList[i].paket_name,
                  todoList[i].type_paket,
                  todoList[i].paket_type,
                  todoList[i].paket_color,
                  todoList[i].paket_theme,
                  todoList[i].id_gambar,
                  todoList[i].paket_gambar,
                  todoList[i].for_many_people,
                  todoList[i].grandtotal,
                  todoList[i].tanggal_acara,
                  todoList[i].jam_acara,
                  todoList[i].nama_users));
              // getHarga.add(todoList[i].good_harga);
              // getJumlah.add(todoList[i].good_jumlah);
            }
          });
        });
      });
    });
  }

  void updateCart() {
    setState(() {
      futurecart = _helper.getCustomerCarts();
    });
  }

  _loadSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cekUsername = prefs.getString('username') ?? "";
      nameController.text = prefs.getString('namauser') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    // _helper.deleteBarang();
    // _helper.deleteCart();
    final _selectedDay = DateTime.now();
    final getdates = DateFormat("yyyy-MM-dd").format(_selectedDay);

    startTime = DateFormat("Hm").format(startTimes);
    endTime = DateFormat("Hm").format(endTimes);
    print("ini start time: " + startTime.toString());
    print("ini end time: " + endTime.toString());
    this.fetchCaraPembayaran();
    this._loadSessionUser();
    date = getdates;
    this.updateCart();
    this.updateBarang();
    this.getCarts();
    this.getBarangs();

    Future<String> getPromo() async {
      final response = await http.get(
          koneksi.connect('getPromo.php?username_konsumen=' + widget.user));

      if (response.statusCode == 200) {
        setState(() {
          promo = response.body;
          print("Ini isi promo: " + promo);
        });
        return 'sukses';
      } else {
        throw Exception('Failed to load post');
      }
    }

    getPromo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onError(PlacesAutocompleteResponse response) {
    print("response error message: " + response.errorMessage);
    Fluttertoast.showToast(
        msg: "response error message: " + response.errorMessage);
  }

  StepState _getState(int i) {
    if (currStep >= i)
      return StepState.complete;
    else
      return StepState.indexed;
  }

  Card cardo(Customer getcustomers) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        title: Table(
          children: [
            TableRow(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Nama paket: "),
                  Text(getcustomers.paket_name)
                ],
              )
            ])
          ],
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Table(
              children: [
                TableRow(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Jenis paket: "),
                      Text(getcustomers.paket_type.toString()),
                    ],
                  )
                ])
              ],
            ),
            Table(
              children: [
                TableRow(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Jumlah orang: "),
                      Text(getcustomers.for_many_people.toString()),
                    ],
                  ),
                ])
              ],
            ),
            Table(
              children: [
                TableRow(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Id tema: "),
                      Text(getcustomers.paket_theme.toString()),
                    ],
                  ),
                ])
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.delete, color: Colors.black, size: 30.0),
        onTap: () async {
          int result =
              await _helper.deletecartbarangs(getcustomers.id.toString());
          if (result > 0) {
            int results = await _helper.deleteCarts(getcustomers.id.toString());
            if (results > 0) {
              updateCart();
              updateBarang();
              getBarangs();
              getCarts();
              Fluttertoast.showToast(msg: "Sukses");
            }
          }
          // await _helper.deleteCarts(getcustomers);
        },
      ),
    );
  }

  Card cardos(Barang getbarangs) {
    return Card(
        color: Colors.white,
        elevation: 2.0,
        child: GestureDetector(
          child: ListTile(
            title: Table(
              children: [
                TableRow(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Nama barang: "),
                      Flexible(
                        child: Container(
                          child: Text(
                            getbarangs.good_name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  )
                ])
              ],
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Table(
                  children: [
                    TableRow(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Jumlah barang: "),
                          Text(getbarangs.good_jumlah.toString()),
                        ],
                      )
                    ])
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Fluttertoast.showToast(msg: getbarangs.good_name);
          },
        ));
  }

  List<Step> spr = <Step>[];
  List<Step> _getSteps(BuildContext context, double height, double width) {
    spr = <Step>[
      new Step(
          title: const Text('Detail Paket'),
          isActive: true,
          state: _getState(1),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text("Detail paket cart."),
                  FutureBuilder<List<Customer>>(
                    future: futurecart,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                            children: snapshot.data
                                .map((todo) => cardo(todo))
                                .toList());
                      } else {
                        return Container(
                            padding: EdgeInsets.all(100.0),
                            child: Text(
                              'Empty',
                              style: TextStyle(fontSize: 20),
                            ));
                      }
                    },
                  ),
                  Text("Detail Barang."),
                  FutureBuilder<List<Barang>>(
                    future: futurebarang,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                            children: snapshot.data
                                .map((todos) => cardos(todos))
                                .toList());
                      } else {
                        return Container(
                            padding: EdgeInsets.all(100.0),
                            child: Text(
                              'Empty',
                              style: TextStyle(fontSize: 20),
                            ));
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
      new Step(
          title: const Text('Data'),
          isActive: true,
          state: _getState(2),
          content: new Column(
            children: <Widget>[
              Container(
                child: Text(
                  "Nama pemesan:",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                maxLines: 1,
                decoration: new InputDecoration(
                    labelText: 'Nama pemesan',
                    hintText: 'Enter your name',
                    icon: const Icon(
                      Icons.person,
                    ),
                    labelStyle: new TextStyle(
                        decorationStyle: TextDecorationStyle.solid)),
              ),
              Container(
                child: Text(
                  "Nama event:",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextFormField(
                controller: eventController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                maxLines: 2,
                decoration: new InputDecoration(
                    labelText: 'Event name',
                    hintText: 'Enter event name',
                    icon: const Icon(
                      Icons.event,
                      color: Colors.cyan,
                    ),
                    labelStyle: new TextStyle(
                        decorationStyle: TextDecorationStyle.solid)),
              ),
              Container(
                child: Text(
                  "Cara pembayaran:",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Icon(
                      Icons.payment,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 29.5),
                    margin: EdgeInsets.only(left: 10.0, right: 5.0),
                    height: 60,
                    width: width,
                    child: DropdownButton(
                      value: dropdownValuePembayaran,
                      isExpanded: true,
                      iconEnabledColor: Colors.black,
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          dropdownValuePembayaran = newValue;
                        });
                      },
                      items: dataCaraPembayaran.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['nama_pembayaran']),
                          value: item['idcara_pembayaran'].toString(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Container(
                child: Text(
                  "Tempat:",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              // TextFormField(
              //   controller: tempatController,
              //   // onTap: () {},
              //   autocorrect: false,
              //   maxLines: 2,
              // decoration: new InputDecoration(
              //     labelText: 'Tempat restoran',
              //     hintText: 'Enter event name',
              //     icon: const Icon(
              //       Icons.place,
              //       color: Colors.red,
              //     ),
              //     labelStyle: new TextStyle(
              //         decorationStyle: TextDecorationStyle.solid)),
              // ),
              Container(
                height: 60,
                width: width,
                child: TextField(
                  controller: tempatController,
                  decoration: new InputDecoration(
                      labelText: 'Tempat restoran',
                      hintText: 'Enter event name',
                      icon: const Icon(
                        Icons.place,
                        color: Colors.red,
                      ),
                      labelStyle: new TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                  onTap: () async {
                    Prediction p = await PlacesAutocomplete.show(
                      context: context,
                      onError: onError,
                      apiKey: kGoogleApiKey,
                      language: "id",
                      components: [
                        Component(Component.country, "id"),
                      ],
                    );
                    displayPrediction(p);
                  },
                ),
              ),
              Container(
                child: Text(
                  "Keterangan tempat:",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextFormField(
                controller: keteranganController,
                autocorrect: false,
                maxLines: 2,
                decoration: new InputDecoration(
                    labelText: 'Keterangan tempat',
                    hintText: 'Input keterangan tempat',
                    icon: const Icon(
                      Icons.info,
                      color: Colors.grey,
                    ),
                    labelStyle: new TextStyle(
                        decorationStyle: TextDecorationStyle.solid)),
              ),
              Container(
                child: Text(
                  "No telepon restoran:",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextFormField(
                controller: teleponController,
                // onTap: () {},
                keyboardType: TextInputType.number,
                autocorrect: false,
                maxLines: 2,
                decoration: new InputDecoration(
                    labelText: 'No telepon tempat',
                    hintText: 'Input no telepon tempat',
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.blueGrey,
                    ),
                    labelStyle: new TextStyle(
                        decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          )),
    ];
    return spr;
  }

  next() {
    currStep + 1 != spr.length
        ? goTo(currStep + 1)
        : setState(() => complete = true);
  }

  cancel() {
    if (currStep > 0) {
      goTo(currStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currStep = step);
  }

  @override
  Widget build(BuildContext context) {
    var device_size = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Kembali ke home?'),
                      content: Container(
                        height: 300.0,
                        width: 400.0,
                        child: Text(
                            "Apakah anda yakin ingin keluar?\nBila keluar maka data yang telah diisi\nakan hilang."),
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () async {
                            int result = await _helper.deleteBarang();

                            if (result > 0) {
                              await _helper.deleteCart();
                            }

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => Home(
                                    value: checkusername,
                                  ),
                                ),
                                (Route<dynamic> route) => false);

                            // Navigator.of(context, rootNavigator: true)
                            //     .pushReplacement(MaterialPageRoute(
                            //         builder: (context) => Home(
                            //               value: checkusername,
                            //             ),
                            //         fullscreenDialog: true));
                          },
                          child: Text("Ok"),
                        ),
                        FlatButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                      ],
                    );
                  });
            },
          ),
          title: Text('Booking'),
          centerTitle: true,
        ),
        body: WillPopScope(
          onWillPop: () async => false,
          child: Container(
            width: device_size.size.width,
            height: device_size.size.height,
            child: Column(children: <Widget>[
              complete
                  ? Expanded(
                      child: Center(
                        child: AlertDialog(
                          title: new Text("Booking"),
                          content: Container(
                            child: Column(
                              children: <Widget>[
                                new Text(
                                  "Are this data correct?",
                                ),
                                Table(
                                  children: [
                                    TableRow(children: [
                                      Text(
                                        "Tanggal acara",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        date.toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Jam acara",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        widget.jam,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Text("Nama",
                                          style: TextStyle(fontSize: 18)),
                                      TextFormField(
                                        controller: nameController,
                                        maxLines: null,
                                        readOnly: true,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Nama acara",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      TextFormField(
                                        controller: eventController,
                                        maxLines: null,
                                        readOnly: true,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Tempat",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      TextFormField(
                                        controller: tempatController,
                                        maxLines: null,
                                        readOnly: true,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "Keterangan tempat",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      TextFormField(
                                        controller: keteranganController,
                                        maxLines: null,
                                        readOnly: true,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Text(
                                        "No telepon tempat",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        teleponController.text.toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ]),
                                  ],
                                ),
                                CheckboxListTile(
                                  title: Text("perlu mencetak format order?"),
                                  value: format_order,
                                  onChanged: (newValue) {
                                    setState(() {
                                      format_order = newValue;
                                      print(format_order);
                                    });
                                  },
                                ),
                                if (promo == "Promo")
                                  Text(
                                      "Selamat anda mendapatkan potongan harga\nsebesar Rp.20.000.")
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("Yes"),
                              onPressed: () async {
                                if (widget.tanggal != "" &&
                                    setIdBarang.isNotEmpty &&
                                    widget.jam != "" &&
                                    nameController.text.toString() != "" &&
                                    eventController.text.toString() != "") {
                                  var url = koneksi
                                      .connect('checkDateAndTimeBooking.php');
                                  http.post(url, body: {
                                    "date": widget.tanggal,
                                    "time": widget.jam,
                                  }).then((response) async {
                                    print(
                                        "Response status: ${response.statusCode}");
                                    print("Response body: ${response.body}");
                                    //ini mau kirim
                                    if (response.body == "Isi") {
                                      var urlkirim =
                                          koneksi.connect('postBooking.php');
                                      double hasilgrandtotal = 0.0;
                                      int hasiljumlahorang = 0;
                                      for (var z = 0;
                                          z < kirimCart.length;
                                          z++) {
                                        hasilgrandtotal +=
                                            kirimCart[z].grandtotal;
                                        hasiljumlahorang +=
                                            kirimCart[z].for_many_people;
                                      }
                                      http.post(urlkirim, body: {
                                        "username": cekUsername,
                                        "name": nameController.text.toString(),
                                        "nama_acara":
                                            eventController.text.toString(),
                                        "tanggal_acara":
                                            widget.tanggal.toString() +
                                                " " +
                                                widget.jam.toString(),
                                        "grandtotal":
                                            hasilgrandtotal.toString(),
                                        "jumlah": hasiljumlahorang.toString(),
                                        "tempat":
                                            tempatController.text.toString(),
                                        "keterangan": keteranganController.text
                                            .toString(),
                                        "no_telp":
                                            teleponController.text.toString(),
                                        "format_order": format_order.toString(),
                                        "tanggal": widget.tanggal.toString(),
                                        "promo": promo,
                                      }).then((getresponse) {
                                        print(
                                            "get Response status: ${getresponse.statusCode}");
                                        print(
                                            "get Response body: ${getresponse.body}");

                                        if (getresponse.body != null) {
                                          var urlPostAdd = koneksi
                                              .connect('postDetailBarang.php');
                                          http.post(urlPostAdd, body: {
                                            "noBooking":
                                                getresponse.body.toString(),
                                            "idm_asset": setIdBarang.toString(),
                                            "jumlah":
                                                setJumlahBarang.toString(),
                                            "idpaket":
                                                setPaketIdBarang.toString(),
                                            "tanggal_acara":
                                                widget.tanggal.toString() +
                                                    " " +
                                                    widget.jam.toString(),
                                          }).then((getbarangresponse) {
                                            print(getbarangresponse.body);
                                            var urlPostReq = koneksi.connect(
                                                'postRequestPaket.php');
                                            for (var x = 0;
                                                x < kirimCart.length;
                                                x++) {
                                              http.post(urlPostReq, body: {
                                                "noBooking":
                                                    getresponse.body.toString(),
                                                "tanggal_acara":
                                                    widget.tanggal.toString() +
                                                        " " +
                                                        widget.jam.toString(),
                                                "idpaket":
                                                    kirimCart[x].paket_id,
                                                "idgambar":
                                                    kirimCart[x].id_gambar,
                                                "jenis_warna":
                                                    kirimCart[x].paket_color,
                                                "id_tema":
                                                    kirimCart[x].paket_theme
                                              }).then((response) {
                                                print(
                                                    "req Response status: ${response.statusCode}");
                                                print(
                                                    "req Response body: ${response.body}");
                                                if (response.body == '') {
                                                  var urlPostPembayaran =
                                                      koneksi.connect(
                                                          'postPembayaran.php');
                                                  http.post(urlPostPembayaran,
                                                      body: {
                                                        "noBooking": getresponse
                                                            .body
                                                            .toString(),
                                                        "idpembayaran":
                                                            dropdownValuePembayaran
                                                                .toString(),
                                                        "tanggal": widget
                                                            .tanggal
                                                            .toString(),
                                                      }).then((response) async {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Booking akan diproses:'),
                                                            content: Container(
                                                              height: 300.0,
                                                              width: 400.0,
                                                              child: Text(
                                                                  "Sukses menginput data. Silahkan lakukan pembayaran dan upload bukti transfer di aplikasi ini untuk diproses.\n Thank you and have a nice day"),
                                                            ),
                                                            actions: [
                                                              FlatButton(
                                                                  onPressed:
                                                                      () async {
                                                                    int result =
                                                                        await _helper
                                                                            .deleteBarang();

                                                                    if (result >
                                                                        0) {
                                                                      await _helper
                                                                          .deleteCart();
                                                                    }
                                                                    Navigator.of(
                                                                            context)
                                                                        .pushAndRemoveUntil(
                                                                            MaterialPageRoute(
                                                                              builder: (context) => Home(
                                                                                value: checkusername,
                                                                              ),
                                                                            ),
                                                                            (Route<dynamic> route) =>
                                                                                false);
                                                                    // Navigator.of(
                                                                    //         context,
                                                                    //         rootNavigator:
                                                                    //             true)
                                                                    //     .pushReplacement(MaterialPageRoute(
                                                                    // builder: (context) => Home(
                                                                    //       value: checkusername,
                                                                    //     ),
                                                                    //         fullscreenDialog: true));
                                                                  },
                                                                  child: Text(
                                                                      "Ok"))
                                                            ],
                                                          );
                                                        });
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Gagal menginput data. Silahkan dicoba ulang atau hubungi admin.");
                                                }
                                              });
                                            }
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Gagal menginput data. Silahkan dicoba ulang atau hubungi admin.");
                                        }
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: response.body.toString());
                                    }
                                  });

                                  setState(() => complete = false);
                                } else {
                                  setState(() => complete = false);
                                  Fluttertoast.showToast(
                                      msg:
                                          "Ada data yang masih kosong. Silahkan isi data yang kosong tersebut");
                                }
                              },
                            ),
                            new FlatButton(
                                child: new Text("No"),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                })
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: Stepper(
                        steps: _getSteps(context, device_size.size.height,
                            device_size.size.width),
                        currentStep: currStep,
                        onStepContinue: next,
                        onStepCancel: cancel,
                      ),
                    ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      final locationType = detail.result.geometry.locationType.toString();

      final resl = detail.result.adrAddress.toString();
      final nama = detail.result.name.toString();

      final phone_number = detail.result.formattedPhoneNumber.toString();
      setState(() {
        teleponController.text = phone_number.toString();
        tempatController.text = nama.toString();
      });
      print("resl ini: " + resl);
      print("nama ini: " + nama);
      print("phone number ini: " + phone_number.toString());
      print("locationType ini: " + locationType.toString());
      print("lat ini: " + lat.toString());
      print("lng ini: " + lng.toString());
    }
  }
}
