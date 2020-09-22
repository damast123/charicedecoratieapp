import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:charicedecoratieapp/Konsumen/pesan_paket.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:after_layout/after_layout.dart';

void main() {
  runApp(ChooseColor());
}

class ChooseColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Choose New Color',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyChooseColor(),
    );
  }
}

class MyChooseColor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyChooseColorState();
}

class _MyChooseColorState extends State<MyChooseColor> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: add_Warna(),
    );
  }
}

class add_Warna extends StatefulWidget {
  @override
  _add_WarnaState createState() => _add_WarnaState();
}

class _add_WarnaState extends State<add_Warna>
    with AfterLayoutMixin<add_Warna> {
  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  @override
  void afterFirstLayout(BuildContext context) {
    showGoToChat();
  }

  void showGoToChat() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        content: new Text('Silahkan chat terlebih dahulu kepada admin.'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('DISMISS'),
              onPressed: () {
                Navigator.of(context).pop();
                whatsAppOpen();
              })
        ],
      ),
    );
  }

  List<String> suggestions = [];

  final String url = koneksi.connect('getcolorname.php');
  List colorslah = [];

  Future<String> getData() async {
    Response response = await dio.get(url);
    print(response.data.toString());
    setState(() {
      var content = json.decode(response.data);

      colorslah = content['color'];
    });

    for (var i = 0; i < colorslah.length; i++) {
      suggestions.add(colorslah[i]['name']);
    }
  }

  @override
  void initState() {
    this.getData();

    super.initState();
  }

  _add_WarnaState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: new InputDecoration(errorText: "Choose Color"),
      controller: TextEditingController(text: ""),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) => setState(() async {
        if (text != "") {
          added.add(text);
          print("ini isi item " + text);
          var url = koneksi.connect('insertcolor.php');
          Response res = await dio.post(url,
              data: FormData.fromMap({"namawarna": text.toString()}));
          if (res.data == "sukses") {
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => new MyPesanPaketKonsumen()));
          } else {
            Fluttertoast.showToast(msg: res.data);
          }
        }
      }),
    );
  }

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  Widget build(BuildContext context) {
    Column body = new Column(children: [
      new ListTile(
          title: textField,
          trailing: new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                textField.triggerSubmitted();
                showWhichErrorText = !showWhichErrorText;
                textField.updateDecoration(
                    decoration: new InputDecoration(
                        errorText: showWhichErrorText ? "Beans" : "Tomatoes"));
              })),
    ]);

    body.children.addAll(added.map((item) {
      return new ListTile(title: new Text(item));
    }));

    return SafeArea(
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Text('Choose New Color'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(15.0),
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background_image.jpg'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter)),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(
                    top: 270, bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(23),
                  child: body,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void whatsAppOpen() async {
    await FlutterLaunch.launchWathsApp(phone: "+6281357999781", message: "");
  }
}
