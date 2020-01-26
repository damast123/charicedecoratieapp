import 'dart:convert';

import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(add_Tempat());
}



class add_Tempat extends StatefulWidget {
  @override
  _add_TempatState createState() => _add_TempatState();
}

class _add_TempatState extends State<add_Tempat> {
  final String url = koneksi.connect('selectbooking.php');
  
  List tempat = []; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY
  
  Future<String> getDataTempat() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    var res = await http.get(Uri.encodeFull(url), headers: { 'accept':'application/json' });
    if(mounted)
    {
      setState(() {
      
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      tempat = content['tempat'];
    });
    return 'success!';
    }
    
  }
  @override
  void initState() { 
    this.getDataTempat();
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Add Tempat",
      home: Scaffold(
        appBar: AppBar(title: Text('Add Tempat'),),
        body: Container(
          child: Column(
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }
}