import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charicedecoratieapp/Konsumen/detail_paket.dart';
import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(home_paket());
}

String v = "";

class home_paket extends StatefulWidget {
  List value = [];
  double murah = 0.0;
  double mahal = 0.0;
  String filter = "";
  String user = "";

  home_paket(
      {Key key, this.value, this.murah, this.mahal, this.filter, this.user})
      : super(key: key);
  @override
  _home_paketState createState() => _home_paketState();
}

class _home_paketState extends State<home_paket> {
  List paket = [];
  String url;
  @override
  void initState() {
    List sa = widget.value;
    if (sa.isEmpty) {
      url = koneksi.connect('get_paket_harga.php?murah=' +
          widget.murah.toString() +
          '&mahal=' +
          widget.mahal.toString());
    } else {
      url = koneksi.connect('getPaket.php?id=' +
          sa.toString() +
          '&murah=' +
          widget.murah.toString() +
          '&mahal=' +
          widget.mahal.toString() +
          '&temp=' +
          widget.filter);
    }
    Future<String> getData() async {
      Response res = await dio.get(url);

      if (mounted) {
        setState(() {
          var content = json.decode(res.data);

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
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          new MyDetailPaketKonsumen(
                                            val: paket[index]['idpaket'],
                                          )));
                            },
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
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
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    new MyDetailPaketKonsumen(
                                                      val: paket[index]
                                                          ['idpaket'],
                                                    )));
                                      },
                                    ),
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
                                              Text("Rating"),
                                              AbsorbPointer(
                                                absorbing: true,
                                                child: RatingBar(
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
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
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
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    new MyDetailPaketKonsumen(
                                                      val: paket[index]
                                                          ['idpaket'],
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
            onWillPop: () {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacement(MaterialPageRoute(
                      builder: (context) => new Home(
                            value: widget.user.toString(),
                          )));
            },
          ),
        ),
      ),
    );
  }
  // Widget slideList(){
  //   new Slidable(
  //     delegate: new SlidableDrawerDelegate(),
  //     actionExtentRatio: 0.25,

  //     actions: <Widget>[
  //       new IconSlideAction(
  //         caption: 'Archive',
  //         color: Colors.blue,
  //         icon: Icons.archive,
  //         onTap: (){},
  //       ),
  //       new IconSlideAction(
  //         caption: 'Share',
  //         color: Colors.indigo,
  //         icon: Icons.share,
  //         onTap: (){},
  //       ),
  //     ],
  //     secondaryActions: <Widget>[
  //       new IconSlideAction(
  //         caption: 'More',
  //         color: Colors.black45,
  //         icon: Icons.more_horiz,
  //         onTap: (){},
  //       ),
  //       new IconSlideAction(
  //         caption: 'Delete',
  //         color: Colors.red,
  //         icon: Icons.delete,
  //         onTap: (){},
  //       ),
  //     ],
  //   );
  // }

}
