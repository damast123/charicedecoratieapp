import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:toast/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(Detail_testimoni());
}

class Detail_testimoni extends StatefulWidget {
  final String value;

  const Detail_testimoni({Key key, this.value}) : super(key:key);
  @override
  _Detail_testimoniState createState() => _Detail_testimoniState();
}

class _Detail_testimoniState extends State<Detail_testimoni> {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Detail_testimoni';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(

        appBar: AppBar(
          title: Text(appTitle),
        ),

        body:Container(
          child:Column(
            children: <Widget>[
              Align(
              alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
              // child: Text("Package Name:"+paket[idget]['nama_paket']),
              child: Text("Package Name:"),
              ),
              Align(
                alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                // child: Text("Type of Packet:"+paket[idget]['nama_jenis']),
                child: Text("Type of Package"),
              ),
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
            Container(
              height: 270.0,
              child: ListView.separated(
                separatorBuilder: (context,index){
                  return Divider(color: Colors.grey,);
                },
                itemCount:6, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
                itemBuilder: (BuildContext context, int index) { 
                  return Container(
                    child: GestureDetector(
                      child:Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Package Type:'),
                              Text('ini'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Komentar:'),
                              Text('ini'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Rating:'),
                              Text('ini'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Oleh siapa:'),
                              Text('ini'),
                            ],
                          ),
                          Text("img"),
                        ],
                      ),
                    ),
                    onTap: (){
                      Alert(
                        context: context,
                        title: "RFLUTTER ALERT",
                        desc: "Flutter is better with RFlutter Alert.",
                        image: Image.asset("assets/success.png"),
                      ).show();
                    },
                  ),
                  );
                }
              ),
            ),
              
            ],
          ),
          
        ) ,

      ),
    );
  }
}