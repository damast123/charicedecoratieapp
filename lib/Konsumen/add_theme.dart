import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyAddTheme());
}

class MyAddTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Choose New Color',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new AddTheme(),
    );
  }
}

class AddTheme extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddThemeState();
}

class _AddThemeState extends State<AddTheme> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Add_Theme(),
    );
  }
}

class Add_Theme extends StatefulWidget {
  @override
  _Add_ThemeState createState() => _Add_ThemeState();
}

class _Add_ThemeState extends State<Add_Theme> {
  List<String> added = [];
  String currentText = "";
  TextEditingController temaController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Container(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: temaController,
                          decoration: InputDecoration(labelText: "Tambah Tema"),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: RaisedButton(
                            child: Text(
                              "Tambah Tema",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blueAccent,
                            onPressed: () async {
                              Response response = await dio.post(
                                koneksi.connect('add_tema.php'),
                                data: FormData.fromMap({
                                  "nama": temaController.text.toString(),
                                }),
                              );

                              Fluttertoast.showToast(
                                  msg: response.data.toString());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
