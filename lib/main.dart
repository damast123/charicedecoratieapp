import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Admin/home_admin.dart';
import 'Freelance/home_freelance.dart';
import 'Konsumen/home.dart';
import 'delayed_animation.dart';
import 'koneksi.dart';
import 'lupa_password.dart';
import 'regiter.dart';

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
String RandomString(int strlen) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}

String ad1 = "";

void main() {
  runApp(Login());
}

DateTime currentBackPressTime;

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Login';
    return MaterialApp(
      title: appTitle,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: MyCustomForm(),
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String cekUsername = "";
  String cekPassword = "";
  String cekStatus = "";
  var setToken;
  var nomor;
  var statususer;
  List<String> myArray = List<String>();
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  TextEditingController tanggalController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final String url = koneksi.connect('userLogin.php');
  List data = [];

  Future<String> getData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
    if (mounted) {
      setState(() {
        var content = json.decode(res.body);

        data = content['cekuserlogin'];
      });
      return 'success!';
    }
  }

  List dataGoogleCalendar;

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    myArray.add("Ini");
    myArray.add("Itu");
    myArray.add("value");

    _loadSessionUser();
    this.getData();
    _firebaseMessaging.getToken().then((token) {
      print(token);
      setToken = token;
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    this.getData();
    _controller.dispose();
  }

  _loadSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cekUsername = prefs.getString('username') ?? "";
      cekPassword = prefs.getString('password') ?? "";
      cekStatus = prefs.getString('status') ?? "";

      if (cekUsername.isNotEmpty && cekPassword.isNotEmpty) {
        print("bisa");
        if (cekStatus == 'konsumen') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Home(
                    value: cekUsername,
                  )));
        } else if (cekStatus == 'admin') {
          var urlPostDepresiasi = koneksi.connect('cekDepresiasi.php');
          http.post(urlPostDepresiasi, body: {
            "tes": "1",
          }).then((response) async {
            print("Ini isi response body" + response.body);
            if (response.body == "gagal") {
            } else {
              Fluttertoast.showToast(
                  msg: "Ada barang yang didepresiasi. Silahkan dicek",
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 10,
                  toastLength: Toast.LENGTH_LONG);
            }
          });
          ad1 = "ada";
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => home_admin(
                    username: cekUsername,
                  )));
        } else if (cekStatus == 'freelance') {
          ad1 = "ada";
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => home_freelance(
                    username: cekUsername,
                  )));
        }
      } else {
        print("gagal");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _sizeDevice = MediaQuery.of(context);
    _scale = 1 - _controller.value;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Form(
      key: _formKey,
      child: Stack(
        children: <Widget>[
          Container(
            width: _sizeDevice.size.width,
            height: _sizeDevice.size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/charicedecor.jpg'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter)),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 270, bottom: _sizeDevice.viewInsets.bottom / 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: DelayedAimation(
                      child: Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: usernameController,
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person_outline),
                              labelStyle: TextStyle(fontSize: 15)),
                        ),
                      ),
                      delay: delayedAmount + 100,
                    ),
                  ),
                  DelayedAimation(
                    child: Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            labelStyle: TextStyle(fontSize: 15)),
                      ),
                    ),
                    delay: delayedAmount + 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: DelayedAimation(
                      child: MaterialButton(
                        onPressed: () {
                          String username = usernameController.text.toString();
                          String password = passwordController.text.toString();
                          if (_formKey.currentState.validate()) {
                            for (int i = 0; i < data.length; i++) {
                              if (data[i]['username'] == username &&
                                  new DBCrypt()
                                      .checkpw(password, data[i]['password'])) {
                                nomor = i;
                                statususer = "ada";
                                break;
                              } else {
                                statususer = "tidak ada";
                              }
                            }
                            if (statususer == "ada") {
                              _getSessionUser(
                                  usernameController.text.toString(),
                                  passwordController.text.toString(),
                                  data[nomor]['status'],
                                  data[nomor]['nama_user']);

                              var url = koneksi.connect('updateToken.php');
                              http.post(url, body: {
                                "username": usernameController.text.toString(),
                                "token": setToken.toString(),
                              }).then((response) {
                                print(
                                    "Response status: ${response.statusCode}");
                                print("Response body: ${response.body}");
                              });
                              if (data[nomor]['status'] == 'konsumen') {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => Home(
                                              value: usernameController.text
                                                  .toString(),
                                            )));
                                _firebaseMessaging.subscribeToTopic('konsumen');
                              } else if (data[nomor]['status'] == 'admin') {
                                var urlPostDepresiasi =
                                    koneksi.connect('cekDepresiasi.php');
                                http.post(urlPostDepresiasi, body: {
                                  "kirim": "1",
                                }).then((response) async {
                                  print(
                                      "Ini isi response body" + response.body);
                                  if (response.body == "gagal") {
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Ada barang yang didepresiasi. Silahkan dicek",
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 10,
                                        toastLength: Toast.LENGTH_LONG);
                                  }
                                });
                                ad1 = "ada";
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => home_admin(
                                              username: usernameController.text
                                                  .toString(),
                                            )));
                                _firebaseMessaging.subscribeToTopic('admin');
                              } else if (data[nomor]['status'] == 'freelance') {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => home_freelance(
                                              username: usernameController.text
                                                  .toString(),
                                            )));
                                _firebaseMessaging
                                    .subscribeToTopic('freelance');
                              }
                              Fluttertoast.showToast(msg: "Sukses login");
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Username atau Password salah");
                            }
                          }
                        },
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SFUIDisplay',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Color(0xffff2d55),
                        elevation: 0,
                        minWidth: 400,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      delay: delayedAmount + 200,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: DelayedAimation(
                      delay: delayedAmount + 300,
                      child: Center(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Lupa password?",
                                style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                            TextSpan(
                                text: "Lupa",
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new LupaPass())),
                                style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  color: Colors.lightBlue,
                                  fontSize: 15,
                                ))
                          ]),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: DelayedAimation(
                      delay: delayedAmount + 300,
                      child: Center(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Tidak memiliki akun?",
                                style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                            TextSpan(
                                text: "Registrasi",
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => new Regist())),
                                style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  color: Colors.lightBlue,
                                  fontSize: 15,
                                ))
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void whatsAppOpen() async {
    await FlutterLaunch.launchWathsApp(
        phone: "+6281357999781", message: "Hello");
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  _getSessionUser(
      String username, String password, String status, String namauser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('username', username);
      prefs.setString('password', password);
      prefs.setString('status', status);
      prefs.setString('namauser', namauser);
    });
  }
}

Future<bool> onWillPops() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: "Are you sure want to exit app");

    return Future.value(false);
  }
  exit(0);
  return Future.value(true);
}
