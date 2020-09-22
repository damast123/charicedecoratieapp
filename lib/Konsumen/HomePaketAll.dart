import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import 'detail_paket.dart';

void main() {
  runApp(MYHome_paket());
}

class MYHome_paket extends StatelessWidget {
  String getVal = "";
  String user = "";
  MYHome_paket({Key key, this.getVal, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home_paket(
        getVal: getVal,
        user: user,
      ),
    );
  }
}

String v = "";

class Home_paket extends StatefulWidget {
  String getVal = "";
  String user = "";
  Home_paket({Key key, this.getVal, this.user}) : super(key: key);
  @override
  _Home_paketState createState() => _Home_paketState();
}

class _Home_paketState extends State<Home_paket> {
  List paket = [];
  @override
  void initState() {
    final String url = koneksi.connect('getpaketall.php');
    Future<String> getData() async {
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      if (mounted) {
        setState(() {
          var content = json.decode(res.body);

          paket = content['paket'];
        });
        return 'success!';
      }
    }

    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Charicedecoratie',
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Home Paket'),
          ),
          body: WillPopScope(
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: paket == null
                  ? Center(
                      child: Text('Kosong'),
                    )
                  : ListView.builder(
                      itemCount: paket.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (paket[index]['nama_gambar'] == null)
                                    ListTile(
                                      leading: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Text("Tidak ada gambar"),
                                      ),
                                      title: Text(
                                        paket[index]['nama_paket'],
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text("Rating:"),
                                              AbsorbPointer(
                                                absorbing: false,
                                                child: RatingBar(
                                                  itemSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          40,
                                                  initialRating: double.parse(
                                                      paket[index]['rating']),
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 4.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                              Text(paket[index]['rating'] +
                                                  '/5'),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'For many people : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(paket[index]
                                                  ['untuk_berapa_orang'])
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Jenis : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(paket[index]['nama_jenis'])
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(Icons.keyboard_arrow_right,
                                          color: Colors.black, size: 30.0),
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushReplacement(MaterialPageRoute(
                                                builder: (context) =>
                                                    new MyDetailPaketKonsumen(
                                                      val: paket[index]
                                                          ['idpaket'],
                                                      user: widget.user
                                                          .toString(),
                                                    )));
                                      },
                                    ),
                                  if (paket[index]['nama_gambar'] != null)
                                    ListTile(
                                      leading: CachedNetworkImage(
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        imageUrl: koneksi.getImagePaket(
                                            paket[index]['nama_gambar']),
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      ),
                                      title: Text(
                                        paket[index]['nama_paket'],
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text("Rating:"),
                                              AbsorbPointer(
                                                absorbing: false,
                                                child: RatingBar(
                                                  itemSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          40,
                                                  initialRating: double.parse(
                                                      paket[index]['rating']),
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 4.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                              Text(paket[index]['rating'] +
                                                  '/5'),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'For many people : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(paket[index]
                                                  ['untuk_berapa_orang'])
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Jenis : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(paket[index]['nama_jenis'])
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(Icons.keyboard_arrow_right,
                                          color: Colors.black, size: 30.0),
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushReplacement(MaterialPageRoute(
                                                builder: (context) =>
                                                    new MyDetailPaketKonsumen(
                                                      val: paket[index]
                                                          ['idpaket'],
                                                      getbool: widget.getVal,
                                                      user: widget.user
                                                          .toString(),
                                                    ),
                                                fullscreenDialog: true));
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
            ),
            onWillPop: () {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacement(MaterialPageRoute(
                builder: (context) => Home(
                  value: widget.user,
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
