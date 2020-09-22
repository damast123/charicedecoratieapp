import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MySettingUser());
}

class MySettingUser extends StatelessWidget {
  String username = "";
  String nama = "";
  String noTelp = "";
  String email = "";
  MySettingUser({Key key, this.username, this.nama, this.noTelp, this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: settingUser(
      username: username,
      nama: nama,
      noTelp: noTelp,
      email: email,
    ));
  }
}

class settingUser extends StatefulWidget {
  String username = "";
  String nama = "";
  String noTelp = "";
  String email = "";
  settingUser({Key key, this.username, this.nama, this.noTelp, this.email})
      : super(key: key);
  @override
  _settingUserState createState() => _settingUserState();
}

class _settingUserState extends State<settingUser>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phonenumberController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.nama;
    emailController.text = widget.email;
    phonenumberController.text = widget.noTelp;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/background_image.jpg'),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.only(
                      top: 270,
                      bottom: MediaQuery.of(context).viewInsets.bottom / 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(23),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person_outline),
                                labelStyle: TextStyle(fontSize: 15)),
                            initialValue: widget.username,
                            readOnly: true,
                          ),
                        ),
                        Container(color: Color(0xfff5f5f5), child: nameField()),
                        Container(
                            color: Color(0xfff5f5f5),
                            child: phonenumberField()),
                        Container(
                            color: Color(0xfff5f5f5), child: emailField()),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            onPressed: () {
                              var url = koneksi.connect('updateProfil.php');
                              http.post(url, body: {
                                "username": widget.username,
                                "nama": nameController.text.toString(),
                                "email": emailController.text.toString(),
                                "notelp": phonenumberController.text.toString()
                              }).then((response) {
                                print(
                                    "Response status: ${response.statusCode}");
                                print("Response body: ${response.body}");
                                Fluttertoast.showToast(msg: response.body);
                              });
                              Navigator.of(context, rootNavigator: true)
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => Home(
                                          value: widget.username,
                                        ),
                                      ),
                                      (Route<dynamic> route) => false);
                            },
                            child: Text(
                              'Ganti',
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
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    return TextFormField(
      controller: nameController,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nama',
          prefixIcon: Icon(Icons.person),
          labelStyle: TextStyle(fontSize: 15)),
    );
  }

  Widget phonenumberField() {
    return TextFormField(
      controller: phonenumberController,
      keyboardType: TextInputType.phone,
      maxLength: 13,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nomor telp',
          prefixIcon: Icon(Icons.phone),
          labelStyle: TextStyle(fontSize: 15)),
    );
  }

  Widget emailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
          labelStyle: TextStyle(fontSize: 15)),
    );
  }
}
