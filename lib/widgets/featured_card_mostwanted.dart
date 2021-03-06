import 'package:cached_network_image/cached_network_image.dart';
import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';

import 'package:charicedecoratieapp/Konsumen/detail_paket.dart';

class FeaturedCardMostWanted extends StatelessWidget {
  String name = "";
  String jenisPaket = "";
  String id = "";
  String picture = "";
  String user = "";
  FeaturedCardMostWanted(
      {@required this.name,
      @required this.jenisPaket,
      @required this.id,
      @required this.picture,
      @required this.user});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context, rootNavigator: true)
            .pushReplacement(MaterialPageRoute(
                builder: (context) => new Home(
                      value: user,
                    )));
      },
      child: Padding(
        padding: EdgeInsets.all(4),
        child: InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .pushReplacement(MaterialPageRoute(
                    builder: (context) => MyDetailPaketKonsumen(
                          val: id,
                          getbool: "false",
                          getDate: "2",
                          getJam: "2",
                          user: user,
                        ),
                    fullscreenDialog: true));
          },
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(62, 168, 174, 201),
                  offset: Offset(0, 9),
                  blurRadius: 14,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    height: 220,
                    width: 200,
                    fit: BoxFit.cover,
                    imageUrl: koneksi.getImagePaket(picture),
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          // Box decoration takes a gradient
                          gradient: LinearGradient(
                            // Where the linear gradient begins and ends
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            colors: [
                              // Colors are easy thanks to Flutter's Colors class.
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.025),
                            ],
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container())),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: 'Nama paket: $name \n',
                              style: TextStyle(fontSize: 18)),
                          TextSpan(
                              text: 'Jenis: $jenisPaket \n',
                              style: TextStyle(fontSize: 18)),
                          // TextSpan(text: '\$${price.toString()} \n', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ]))),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
