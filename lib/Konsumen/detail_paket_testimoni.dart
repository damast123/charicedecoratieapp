import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(MyDetail_testimoni());
}

class MyDetail_testimoni extends StatelessWidget {
  String val = "";
  MyDetail_testimoni({
    Key key,
    this.val,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Detail_testimoni(
        value: val,
      ),
    );
  }
}

class Detail_testimoni extends StatefulWidget {
  String value = "";
  Detail_testimoni({Key key, this.value}) : super(key: key);

  @override
  _MyDetail_testimoniState createState() => _MyDetail_testimoniState();
}

class _MyDetail_testimoniState extends State<Detail_testimoni>
    with TickerProviderStateMixin {
  List paket = [];
  List gambar = [];
  List komentar = [];
  List detail_komentar = [];
  TextEditingController isi_komentar = new TextEditingController();

  @override
  void initState() {
    String v = widget.value;
    final String url = koneksi.connect('detailpaket.php?id=' + v);
    isi_komentar.text = "";
    Future<String> getData() async {
      Response response = await dio.get(url);
      print(response.data.toString());
      setState(() {
        var content = json.decode(response.data);

        paket = content['paket'];
      });
    }

    final String urlKomentar = koneksi.connect('komentar.php?id=' + v);
    Future<String> getDataKomentar() async {
      Response response = await dio.get(urlKomentar);
      print(response.data.toString());

      setState(() {
        var content = json.decode(response.data);

        komentar = content['komentar'];
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
    }

    getData();

    getDataGetGambar();
    getDataKomentar();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Detail_testimoni';
    var changesD = double.parse(paket[0]['harga_awal']);
    MoneyFormatterOutput hargaAwal =
        FlutterMoneyFormatter(amount: changesD).output;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: Container(
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
                          imageUrl: koneksi.getImagePaket(item['nama_gambar']),
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
                  height: MediaQuery.of(context).size.height / 25,
                ),
                Text("Testimoni:", style: TextStyle(fontSize: 20.0)),
                Container(
                  height: 270.0,
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey,
                        );
                      },
                      itemCount: komentar.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (komentar.isNotEmpty)
                          return Container(
                            child: GestureDetector(
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      child: Table(
                                        children: [
                                          TableRow(children: [
                                            Text('Komentar:',
                                                style:
                                                    TextStyle(fontSize: 18.0)),
                                            Text(
                                                komentar[index]
                                                    ['isi_testimoni'],
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    TextStyle(fontSize: 18.0)),
                                          ]),
                                          TableRow(children: [
                                            Text('Rating:',
                                                style:
                                                    TextStyle(fontSize: 18.0)),
                                            AbsorbPointer(
                                              absorbing: false,
                                              child: RatingBar(
                                                itemSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    40,
                                                initialRating: double.parse(
                                                    komentar[index]['star']),
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
                                          ]),
                                          TableRow(children: [
                                            Text('Oleh siapa:',
                                                style:
                                                    TextStyle(fontSize: 18.0)),
                                            Text(komentar[index]['nama_user'],
                                                style:
                                                    TextStyle(fontSize: 18.0)),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text("Testimoni"),
                                        content: dialogTestimoni(
                                            komentar[index]['nama_user'],
                                            komentar[index]['isi_testimoni'],
                                            double.parse(
                                                komentar[index]['star'])),
                                        actions: [
                                          FlatButton(
                                            child: Text("Ok"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                            ),
                          );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dialogTestimoni(String nama, String komentar, double rate) {
    isi_komentar.text = komentar;
    return Container(
      width: 300,
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              child: Table(
                children: [
                  TableRow(children: [
                    Text('Oleh siapa:'),
                    Text(nama),
                  ]),
                  TableRow(children: [
                    Text('Rating:'),
                    AbsorbPointer(
                      absorbing: false,
                      child: RatingBar(
                        itemSize: MediaQuery.of(context).size.width / 40,
                        initialRating: rate,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("Komentar:"),
            TextField(
              controller: isi_komentar,
              maxLines: 8,
              readOnly: true,
            )
          ],
        ),
      ),
    );
  }
}
