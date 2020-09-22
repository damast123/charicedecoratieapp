import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(TestimoniPaket());
}

// class Ratings {
//   double rate;

//   Ratings(this.rate);
// }

// class IsiTesti {
//   String isi;

//   IsiTesti(this.isi);
// }

class TestimoniPaket extends StatelessWidget {
  String no_booking = "";
  String tanggal = "";
  String grandtotal = "";
  TestimoniPaket({Key key, this.no_booking, this.tanggal, this.grandtotal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "testimoni paket",
      home: MyTestimoniPaket(
        no_booking: no_booking,
        tanggal: tanggal,
        grandtotal: grandtotal,
      ),
    );
  }
}

class MyTestimoniPaket extends StatefulWidget {
  String no_booking = "";
  String tanggal = "";
  String grandtotal = "";
  MyTestimoniPaket({Key key, this.no_booking, this.tanggal, this.grandtotal})
      : super(key: key);

  @override
  _MyTestimoniPaketState createState() => _MyTestimoniPaketState();
}

class _MyTestimoniPaketState extends State<MyTestimoniPaket> {
  TextEditingController isiController = new TextEditingController();
  // List<Ratings> rate = new List<Ratings>();
  // List<IsiTesti> _value = new List<IsiTesti>();
  List rate = [];
  List _value = [];
  var checkusername = "";
  List setIdPaket = [];
  List reqPaket = [];
  List gambar = [];
  var dropdownValueId;
  FocusNode myFocusNode;
  _loadSessionUserBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkusername = prefs.getString('username') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSessionUserBook();

    final String url = koneksi
        .connect('getRequestPaketAdmin.php?no_booking=' + widget.no_booking);
    Future<String> getData() async {
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      if (mounted) {
        setState(() {
          var content = json.decode(res.body);

          reqPaket = content['getreqbooking'];

          for (var i = 0; i < reqPaket.length; i++) {
            _value.add("");
            rate.add(0.0);
            setIdPaket.add(reqPaket[i]['idpaket']);
          }
          _value.add("s");
          rate.add(0.0);
          setIdPaket.add("0");
          final String urlGetGambar = koneksi
              .connect('getGambarDetailPaket.php?id=' + reqPaket[0]['idpaket']);

          Future<String> getDataGetGambar() async {
            gambar.clear();
            var res = await http.get(Uri.encodeFull(urlGetGambar),
                headers: {'accept': 'application/json'});
            if (mounted) {
              setState(() {
                var content = json.decode(res.body);

                gambar = content['namaGambar'];
                print("ini isi gambar: " + gambar.toString());
              });
              return 'success!';
            }
          }

          getDataGetGambar();
        });
        return 'success!';
      }
    }

    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.addListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Testimoni Paket: ' + widget.no_booking;
    var device_size = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 350.0,
                    width: 350.0,
                    child: CachedNetworkImage(
                      height: 350.0,
                      width: 350.0,
                      fit: BoxFit.cover,
                      imageUrl: koneksi.getImagePaket(gambar[0]['nama_gambar']),
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                  Container(
                      height: device_size.size.height / 3,
                      child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey,
                            );
                          },
                          itemCount: reqPaket.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Table(
                                      children: [
                                        TableRow(children: [
                                          Text(
                                            "Harga",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            ": " + reqPaket[index]['harga'],
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ]),
                                        TableRow(children: [
                                          Text(
                                            "Tanggal",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            ": " + widget.tanggal,
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ]),
                                        TableRow(children: [
                                          Text(
                                            "Nama paket",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            ": " +
                                                reqPaket[index]['nama_paket'],
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ]),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Rating: ' + index.toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        AbsorbPointer(
                                          absorbing: false,
                                          child: RatingBar(
                                            initialRating: 0.0,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              rate[index] = rating;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: device_size.size.height / 15,
                                    ),
                                    new TextFormField(
                                      onChanged: (String newValue) {
                                        setState(() {
                                          print("ini isi index lah: " +
                                              index.toString());
                                          if (newValue == '') {
                                            _value[index] = newValue;
                                          } else {
                                            _value[index] = newValue;
                                          }
                                        });
                                      },
                                      maxLines: 3,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                          hintText: "Isi testimoni"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        print("isi_testimoni: " + _value.toString());
                        print("star: " + rate.toString());
                        print("idpaket: " + setIdPaket.toString());
                        print("checkusername: " + checkusername.toString());
                        var urlPostTesti = koneksi.connect('postTestimoni.php');
                        http.post(urlPostTesti, body: {
                          "no_booking": widget.no_booking,
                          "isi_testimoni": _value.toString(),
                          "star": rate.toString(),
                          "username": checkusername.toString(),
                          "idpaket": setIdPaket.toString()
                        }).then((response) {
                          print("Response status: ${response.statusCode}");
                          print("Response body: ${response.body}");
                          if (response.body == "sukses") {
                            Fluttertoast.showToast(msg: "sukses");
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => Home(
                                    value: checkusername.toString(),
                                  ),
                                ),
                                (Route<dynamic> route) => false);
                          } else {
                            Fluttertoast.showToast(msg: response.body);
                          }
                        });
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
