import 'dart:convert';

import 'package:charicedecoratieapp/Konsumen/detail_paket.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';


void main() {
  runApp(home_paket());
}
String v = "";
class home_paket extends StatefulWidget {
  final List value;
  final double murah;
  final double mahal;
  final String filter;
  
  const home_paket({Key key, this.value,this.murah,this.mahal,this.filter}) : super(key:key);
  @override
  _home_paketState createState() => _home_paketState();
}

class _home_paketState extends State<home_paket> {
  
  
  List paket; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  //ini cara gunakan get http://localhost:9090/ta/getPaket.php?id=1
    @override
    void initState() {
      List sa = widget.value;
      final String url = koneksi.connect('getPaket.php?id='+sa.toString()+'&murah='+widget.murah.toString()+'&mahal='+widget.mahal.toString()+'&temp='+widget.filter);
      Future<String> getData() async {
    
      var res = await http.get(Uri.encodeFull(url), headers: { 'accept':'application/json' });
        if(mounted)
        {
          setState(() {
          
          //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
          var content = json.decode(res.body);
          //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
          //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Paket'),
          
        ),
        body: Container(
          margin: EdgeInsets.all(10.0), //SET MARGIN DARI CONTAINER
          child: paket == null ? Center(child: Text('Kosong'),) : ListView.builder( //MEMBUAT LISTVIEW
            itemCount: paket.length, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
            itemBuilder: (BuildContext context, int index) { 
              return Container(
                child:GestureDetector(
                  onTap: (){
                    
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => new MyDetailPaketKonsumen(value: paket[index]['idpaket'],id:index,)));
                  },
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, children: <Widget>[
                      //ListTile MENGELOMPOKKAN WIDGET MENJADI BEBERAPA BAGIAN
                      ListTile(
                        leading: 
                        //title TAMPIL DITENGAH SETELAH leading
                        // VALUENYA ADALAH WIDGET TEXT
                        // YANG BERISI NAMA SURAH
                        Text("Gambar", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                        title: Text(paket[index]['nama_paket'], style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                        //subtitle TAMPIL TEPAT DIBAWAH title
                        subtitle: Column(children: <Widget>[ //MENGGUNAKAN COLUMN
                          //DIMANA MASING-MASING COLUMN TERDAPAT ROW
                          Row(
                            children: <Widget>[
                              //MENAMPILKAN TEXT arti
                              Text('Rating : ', style: TextStyle(fontWeight: FontWeight.bold),),
                              //MENAMPILKAN TEXT DARI VALUE arti
                              Text(paket[index]['rating'].toString(), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),),
                            ],
                          ),
                          //ROW SELANJUTNYA MENAMPILKAN JUMLAH AYAT
                          Row(
                            children: <Widget>[
                              Text('For many people : ', style: TextStyle(fontWeight: FontWeight.bold),),
                              //DARI INDEX ayat
                              Text(paket[index]['untuk_berapa_orang'])
                            ],
                          ),
                          //MENAMPILKAN DIMANA SURAH TERSEBUT DITURUNKAN
                          Row(
                            children: <Widget>[
                              Text('Jenis : ', style: TextStyle(fontWeight: FontWeight.bold),),
                              //DENGAN INDEX type
                              Text(paket[index]['nama_jenis'])
                            ],
                          ),
                        ],),
                        trailing:
                            Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
                        onTap: () {
                        },
                      ),
                      
                    ],),
                  ),
                ),
                
              );
              
            }),
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