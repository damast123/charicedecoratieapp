import 'dart:convert';


import 'package:charicedecoratieapp/koneksi.dart';

import 'detail_testimoni.dart';
import 'pesan_paket.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

final List child = map<Widget>(
  imgList,
  (index, i) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(children: <Widget>[
          Image.network(i, fit: BoxFit.cover, width: 1000.0),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                'No. $index image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  },
).toList();

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

void main() {
  runApp(MyDetailPaketKonsumen());
}

class MyDetailPaketKonsumen extends StatefulWidget {

  final String value;
  final int id;
  
  const MyDetailPaketKonsumen({Key key, this.value,this.id}) : super(key:key);
  
  @override
  _MyDetailPaketKonsumenState createState() => _MyDetailPaketKonsumenState();
}

class _MyDetailPaketKonsumenState extends State<MyDetailPaketKonsumen> {
  int _current = 0;
  int idget = 0;
  List paket;
  
  @override
    void initState() {
      String v = widget.value;
      
      final String url = koneksi.connect('detailpaket.php?id='+v);
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
          print('gila ini');
          print(paket.toString());
        });
        return 'success!';
        }
        
      }
      getData();
      super.initState();
            
    }
    
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Detail Paket';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(

        appBar: AppBar(
          title: Text(appTitle),
        ),

        body:Container(
          child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
              child: Text("Package Name:"+paket[idget]['nama_paket']),
            ),
            Align(
              alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
              child: Text("Type of Packet:"+paket[idget]['nama_jenis']),
            ),
            
            // CarouselSlider(
            //   items: child,
            //   autoPlay: true,
            //   enlargeCenterPage: true,
            //   aspectRatio: 2.0,
            //   onPageChanged: (index) {
            //     setState(() {
            //       _current = index;
            //     });
            //   },
            // ),
            SizedBox(
              height: 200.0,
              width: 350.0,
              child: Carousel(
                images: [
                  NetworkImage('https://i.ytimg.com/vi/MGyMUM8UYII/hqdefault.jpg'),
                  NetworkImage('https://yt3.ggpht.com/a/AGF-l78hGnQnWdhRpOceCK4iUxxTuiXoq6FD5cY_3A=s900-c-k-c0xffffffff-no-rj-mo'),
                  
                ],
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: Colors.lightGreenAccent,
                indicatorBgPadding: 5.0,
                dotBgColor: Colors.purple.withOpacity(0.5),
                borderRadius: true,
                moveIndicatorFromBottom: 180.0,
                noRadiusForIndicator: true,
                autoplay: false,
              )
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Text("Rating"),
                  AbsorbPointer(
                    absorbing: true,
                    child: RatingBar(
                      initialRating: double.parse(paket[idget]['rating']),
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                  
                  Text(paket[idget]['rating']+'/5')
                ],
              ),
            ),
            // Container(
            //       height: 270.0,
            //       child: paket.isEmpty ? Container(child: Text('Empty')) : ListView.separated(
            //         separatorBuilder: (context,index){
            //           return Divider(color: Colors.grey,);
            //         },
            //         itemCount: paket.length, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
            //         itemBuilder: (BuildContext context, int index) { 
            //           return Container(
            //             child: Card(
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min, children: <Widget>[
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                     children: <Widget>[
            //                       Text('Package Type:'),
            //                       Text('ini'),
            //                       RaisedButton(elevation: 0.0,
            //                       color: Colors.blueAccent,
            //                       child: Text('Add',),
            //                       onPressed: (){
            //                           Toast.show('ini bisa ditekan dengan index: '+index.toString(), context);
            //                         },
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           );
            //         }
            //       ),
            //     ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new Detail_testimoni(value:paket[idget]['idpaket'],)));
                  },
                  child: new Text("Testimony"),
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new MyPesanPaketKonsumen(value:paket[idget]['idpaket'],)));
                  },
                  child: Text('Pesan'),
                )
              ],
            )
          ],
        ),
        ),

      ),
    );
  }
}