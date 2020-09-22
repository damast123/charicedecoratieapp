import 'package:flutter/material.dart';

void main() {
  runApp(MyAbout());
}

class MyAbout extends StatelessWidget {
  const MyAbout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: About(),
    );
  }
}

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  TextEditingController about = new TextEditingController();
  @override
  void initState() {
    super.initState();
    about.text =
        "Charicedecoratie merupakan sebuah usaha jasa dekorasi milik sendiri yang dimiliki oleh Devi Verina. Perusahaan ini memulai usaha pada tahun 2016. Mayoritas dekorasi yang diterima adalah table decor. Harga dekorasi bervariasi dan fleksibel tergantung dari tingkat kerumitan dari dekorasi sendiri. Jasa dekorasi untuk table décor yang ditawarkan berupa paket couple hingga paket group.";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("About"),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: 300,
                  height: 300,
                  child: Image(image: AssetImage('assets/images/29.jpg')),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  child: TextField(
                    controller: about,
                    maxLines: 8,
                    readOnly: true,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
