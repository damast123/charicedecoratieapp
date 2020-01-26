import 'package:flutter/material.dart';

import 'package:toast/toast.dart';
import 'package:dbcrypt/dbcrypt.dart';

import 'package:http/http.dart' as http;
void main() {
  runApp(NotaKeluar());
}

class NotaKeluar extends StatefulWidget {
  @override
  _NotaKeluarState createState() => _NotaKeluarState();
}

class _NotaKeluarState extends State<NotaKeluar> {
  

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Nota Keluar';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(

        appBar: AppBar(
          title: Text(appTitle),
        ),

        body: Container(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text('BNKxxxxxx'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Tanggal Keluar'),
                  Text('xxxx-xx-xx')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextField(),
                  TextField(),
                ],
              ),
              
            ],
          ),
        ),

      ),
    );
  }
  
}