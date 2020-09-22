import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/main.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(EnterNewPassword());
}

class EnterNewPassword extends StatelessWidget {
  String email = "";
  EnterNewPassword({Key key, this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ganti password',
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Form ganti password'),
          ),
          body: EnterNewPasswordScreen(
            emails: email,
          ),
        ),
      ),
    );
  }
}

class EnterNewPasswordScreen extends StatefulWidget {
  String emails = "";
  EnterNewPasswordScreen({Key key, this.emails}) : super(key: key);
  @override
  EnterNewPasswordScreenState createState() {
    return EnterNewPasswordScreenState();
  }
}

class EnterNewPasswordScreenState extends State<EnterNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/charicedecor.jpg'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(
                  top: 270,
                  bottom: MediaQuery.of(context).viewInsets.bottom / 4),
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
                        obscureText: true,
                        controller: passwordController,
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            labelStyle: TextStyle(fontSize: 15)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: MaterialButton(
                        onPressed: () {
                          var plainpass = passwordController.text.toString();
                          var hashedPassword = new DBCrypt()
                              .hashpw(plainpass, new DBCrypt().gensalt());
                          var url = koneksi.connect('forgotPassword.php');
                          http.post(url, body: {
                            "password": hashedPassword,
                            "email": widget.emails
                          }).then((response) {
                            print("Response status: ${response.statusCode}");
                            print("Response body: ${response.body}");
                            Fluttertoast.showToast(msg: response.body);
                            if (response.body == "sukses") {
                              Fluttertoast.showToast(msg: response.body);
                              Navigator.of(context, rootNavigator: true)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => new Login()));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Gagal ganti password");
                            }
                          });
                        },
                        child: Text(
                          'Simpan',
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
    );
  }
}
