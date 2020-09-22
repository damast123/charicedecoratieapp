import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import 'detail_paket.dart';

void main() {
  runApp(home_paket_jenis());
}

class home_paket_jenis extends StatelessWidget {
  String val = "";
  String usern = "";
  home_paket_jenis({Key key, this.val, this.usern}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Myhome_paket_jenis(
        value: val,
        usern: usern,
      ),
    );
  }
}

String v = "";

class Myhome_paket_jenis extends StatefulWidget {
  String value = "";
  String usern = "";
  Myhome_paket_jenis({Key key, this.value, this.usern}) : super(key: key);
  @override
  _home_paket_jenisState createState() => _home_paket_jenisState();
}

class _home_paket_jenisState extends State<Myhome_paket_jenis> {
  List paket = [];
  @override
  void initState() {
    String sa = widget.value;
    final String url = koneksi.connect('getpaketjenis.php?id=' + sa.toString());
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
    print("ini isi usern di home paket jenis: " + widget.usern);
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
            onWillPop: () {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacement(MaterialPageRoute(
                builder: (context) => Home(
                  value: widget.usern,
                ),
              ));
            },
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
                                                      getbool: "false",
                                                      getDate: "2",
                                                      getJam: "2",
                                                      user: widget.usern,
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
                                                      getbool: "false",
                                                      getDate: "2",
                                                      getJam: "2",
                                                      user: widget.usern,
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
          ),
        ),
      ),
    );
  }
}
