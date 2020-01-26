// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:toast/toast.dart';
import 'package:dbcrypt/dbcrypt.dart';


import 'delayed_animation.dart';
import 'Konsumen/home.dart';
import 'regiter.dart';
import 'koneksi.dart';

import 'Admin/home_admin.dart';
import 'Freelance/home_freelance.dart';
import 'lupa_password.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
//ambil ini
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'dart:convert';

import 'package:flutter_launch/flutter_launch.dart';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:url_launcher/url_launcher.dart';


// sudah bisa camera. tak kasi tanda

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
String RandomString(int strlen) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}
_launchURL() async {
  const url = 'https://flutter.io';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


void main(){
  runApp(Login());
  // print(RandomString(10));
  // print(RandomString(20));
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Login';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(

        appBar: AppBar(
          title: Text(appTitle),
        ),

        body:MyCustomForm() ,

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


class MyCustomFormState extends State<MyCustomForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String cekUsername = "";
  String cekPassword = "";
  String cekStatus = "";
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  TextEditingController tanggalController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final String url = koneksi.connect('userLogin.php');
  List data; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> getData() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    var res = await http.get(Uri.encodeFull(url), headers: { 'accept':'application/json' });
    if(mounted)
    {
      setState(() {
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      data = content['cekuserlogin'];
      
    });
    return 'success!';
    }
  }

  List dataGoogleCalendar; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  


  //yang ini juga
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
  //semua sampai sini.

  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    
//    fetchData();
    _loadSessionUser();
    this.getData();
    
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
        
        if(cekUsername.isNotEmpty&&cekPassword.isNotEmpty)
        {
          print("bisa");
          if(cekStatus=='konsumen')
          {
            Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new Home(value: "bisa",apa: "maumu apa",)));
              
          }
          else if(cekStatus=='admin')
          {
            Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new home_admin()));
                
          }
          else if(cekStatus=='freelance')
          {
            Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new home_freelance()));
          }
          
        }
        else
        {
          print("gagal");
        }
    });
  }

  //perlu dipakai
//  void fetchData() async {
//    final response = await http.get(
//        'http://192.168.43.97:9090/TA/userLogin.php');
//
//    if (response.statusCode == 200) {
//      setState(() {
//        data = json.decode(response.body);
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    
    // Build a Form widget using the _formKey created above.
    final color = Colors.lightBlue;

    _scale = 1 - _controller.value;

    return Form(
      key: _formKey,
                child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/charicedecor.jpg'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter
                      )
                    ),
                  ),
                  Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 270),
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
                    child:Container(
                    color: Color(0xfff5f5f5),
                    child: TextFormField(
                      controller: usernameController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFUIDisplay'
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline),
                        labelStyle: TextStyle(
                            fontSize: 15
                          )
                        ),
                      ),
                      
                    ),
                    delay: delayedAmount + 100, 
                  ),
                ),
                DelayedAimation(
                  child:Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFUIDisplay'
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      labelStyle: TextStyle(
                          fontSize: 15
                              )
                          ),
                        ),

                    
                      ),
                    delay: delayedAmount + 100,                  
                  ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: DelayedAimation(
                          child: MaterialButton(
                          onPressed: (){
                            String username = usernameController.text.toString();
                            String password = passwordController.text.toString();

                            if(_formKey.currentState.validate())
                            {
                                for(int i=0;i<data.length;i++)
                                {
                                  if(new DBCrypt().checkpw(password, data[i]['password']))
                                  {
                                    if(data[i]['username']==username)
                                    {
                                      _getSessionUser(usernameController.text.toString(), passwordController.text.toString(),data[i]['status']);
                                      if(data[i]['status']=='konsumen')
                                      {
                                        // var route = new MaterialPageRoute(
                                        //       builder: (BuildContext context) => new Home(value: "bisa",apa: "maumu apa",),
                                        //   );
                                        //   Navigator.of(context).pushReplacement(route);
                                          
                                          Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new Home(value: "bisa",apa: "maumu apa",)));
                                      }
                                      else if(data[i]['status']=='admin')
                                      {
                                        Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new home_admin()));
                                      }
                                      else if(data[i]['status']=='freelance')
                                      {
                                        // Navigator.pushReplacement(context, new MaterialPageRoute(
                                        // builder: (context) =>
                                        // new home_freelance())
                                        // );
                                        Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new home_freelance()));
                                      }
                                      
                                    }
                                    else
                                    {
                                      Toast.show("username salah", context,gravity: Toast.CENTER);
                                    }
                                  }
                                  else{
                                    Toast.show("Password salah", context,gravity: Toast.CENTER);
                                  }
                                  
                                }
                                
                            }
                          },//since this is only a UI app
                          child: Text('SIGN IN',
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
                            borderRadius: BorderRadius.circular(10)
                          ),
                          ),
                          delay: delayedAmount + 200,
                        ),
                        
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child:
                        DelayedAimation(
                          delay: delayedAmount + 300, child: Center(
                          child:
                          GestureDetector(
                          onTap: () async {
                            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => new LupaPass()));
                          },
                          child: Text('Forgot your password?',
                          style: TextStyle(
                            fontFamily: 'SFUIDisplay',
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                            ),
                            ),

                        ), 
                          
                          ),
                        ), 
                        
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child:DelayedAimation(
                          delay: delayedAmount + 300, child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account?",
                                  style: TextStyle(
                                    fontFamily: 'SFUIDisplay',
                                    color: Colors.black,
                                    fontSize: 15,
                                  )
                                ),
                                TextSpan(
                                  text: "sign up",
                                  recognizer: new TapGestureRecognizer()..onTap = () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => new Regist())),
                                  style: TextStyle(
                                    fontFamily: 'SFUIDisplay',
                                    color: Colors.lightBlue,
                                    fontSize: 15,
                                  )
                                )
                              ]
                            ),
                          ),
                        ),
                        ), 
                        
                      ),
                      
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () async {
                            _launchURL();
                            Toast.show("Bisa g sih?", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                            //ambil ini juga
                            // final MailOptions mailOptions = MailOptions(
                            //   body: 'a long body for the email <br> with a subset of HTML',
                            //   subject: 'the Email Subject',
                            //   recipients: ['example@example.com'],
                            //   isHTML: true,
                            //   bccRecipients: ['other@example.com'],
                            //   ccRecipients: ['third@example.com'],

                            // );

                            // await FlutterMailer.send(mailOptions);
                            // Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new MyAppSearch()));

                          },
                          child: Text(
                            "Test email?".toUpperCase(),
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: color),
                          ),

                        ),
                      )
                    ],
                  ),
                ),
              ),
                  
                  
                  DateTimeField(

                    format: format,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,

                          firstDate: DateTime(DateTime.now().year),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime:
                          TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                        );
                        enabled: false;
                        return DateTimeField.combine(date, time);

                      } else {
                        return currentValue;
                      }
                    },
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(vertical: 0.0),

                      prefixIcon: new Padding(
                        padding: const EdgeInsets.only( top: 0, left: 5, right: 0, bottom: 0),
                        child: new SizedBox(
                          height: 4,
                          child: Image.asset('assets/images/datetime.png'),
                        ),
                      ),
                    ),

                  ),
                  
                FlatButton(

                    onPressed: () async {
                      final date = await showDatePicker(
                          context: context,

                          firstDate: DateTime(DateTime.now().year),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime:
                          TimeOfDay(hour: 13,minute: 0),
                        );

                        return tanggalController.text = DateTimeField.combine(date, time).toString();

                      }
                    },
                    child: Text(
                      'show date time picker',
                      style: TextStyle(color: Colors.blue),
                    )),
                  SizedBox(height: 50.0,),
                  DelayedAimation(
                    child: tanggalfield(),

                    delay: delayedAmount + 2000,
                  ),  
                ],
              ),
          );
  }

  void whatsAppOpen() async{
    await FlutterLaunch.launchWathsApp(phone: "+6281357999781", message: "Hello");
  }

  //sama ini juga sisa niru di inet
  Widget showImage(){
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
  _getSessionUser(String username,String password,String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      
        prefs.setString('username', username);
        prefs.setString('password', password);
        prefs.setString('status', status);
    });
  }


  Widget nameField() {

    return TextFormField(
      controller: usernameController,
      decoration: InputDecoration(
          labelText: 'Username' //DENGAN LABEL Nama Lengkap
      ),
      validator: (value){
        if(value.isEmpty)
          {
            return 'Please enter some text';
          }
        return null;
      },
    );
  }
  Widget tanggalfield() {

    return TextFormField(

      controller: tanggalController,
      decoration: InputDecoration(
          labelText: 'Tanggal' //DENGAN LABEL Nama Lengkap
      ),
      enabled: false,

    );
  }

  Widget passwordField() {

    return TextFormField(
      controller: passwordController,
      obscureText: true, //KETIKA obsecureText bernilai TRUE
      //MAKA SAMA DENGAN TYPE PASSWORD PADA HTML
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter Password',
      ),
      validator: (value){
        if(value.isEmpty)
        {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}