import 'dart:convert';

import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(addAdditional());
}

class addAdditional extends StatefulWidget {
  @override
  _addAdditionalState createState() => _addAdditionalState();
}

class _addAdditionalState extends State<addAdditional> {
  final _formKey = GlobalKey<FormState>();
  final String url = koneksi.connect('getAdditional.php');
  Map<String, dynamic> formData;
  Map<String, dynamic> formId;
  List barang = [];
      Future<String> getData() async {
    
      var res = await http.get(Uri.encodeFull(url), headers: { 'accept':'application/json' });
        if(mounted)
        {
          setState(() {
          
          //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
          var content = json.decode(res.body);
          //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
          //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
          barang = content['additional'];

        });
        return 'success!';
        }
        
      }
      
    @override
    void initState() {
      this.getData(); 
      super.initState();
      
    }
    _addAdditionalState() {
      formData = {
        'Barang': 'Fresh Flower',
      };
      formId = {
        'id' : '1'
      };
    }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pesan Paket Konsumen",
      home: Scaffold(

        appBar: AppBar(
          title: Text("Pesan Paket Konsumen"),
        ),

        body: LayoutBuilder( 
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    height: 250.0,
                      child:ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.black,
                          ),
                      itemCount: 20,
                      itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Nama barang'),
                                new Container(              
                                  width: 100.0,
                                  child: new TextField()
                                ),
                                RaisedButton(onPressed: (){},child: Text('+'),)
                              ],
                            ),
                          ),
                    ),
                
                ),
                SizedBox(height: 40,),
                Container(
                    height: 250.0,
                      child:ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.black,
                          ),
                      itemCount: 20,
                      itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: Text("Index $index")),
                          ),
                    ),
                
                ),
                RaisedButton(
                  onPressed: (){},
                  child: Text('Confirm'),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}