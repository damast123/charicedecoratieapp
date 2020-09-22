import 'package:auto_orientation/auto_orientation.dart';
import 'package:charicedecoratieapp/Admin/home_admin.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(add_Admin());
}

class add_Admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registrasi',
      home: myadd_Admin(),
    );
  }
}

class myadd_Admin extends StatefulWidget {
  @override
  _add_AdminState createState() => _add_AdminState();
}

class _add_AdminState extends State<myadd_Admin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phonenumberController = new TextEditingController();
  List _roles = ["admin", "freelance"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentRole;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentRole = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String role in _roles) {
      items.add(new DropdownMenuItem(value: role, child: new Text(role)));
    }
    return items;
  }

  @override
  void dispose() {
    AutoOrientation.portraitUpMode();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AutoOrientation.portraitUpMode();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Form Registrasi Admin'),
        ),
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
                      top: 200,
                      bottom: MediaQuery.of(context).viewInsets.bottom / 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(23),
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Container(
                            color: Color(0xfff5f5f5),
                            child: TextFormField(
                              controller: usernameController,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFUIDisplay'),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person_outline),
                                  labelStyle: TextStyle(fontSize: 15)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(color: Color(0xfff5f5f5), child: nameField()),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            color: Color(0xfff5f5f5),
                            child: phonenumberField()),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            color: Color(0xfff5f5f5), child: emailField()),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('Role:'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 10,
                            ),
                            Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width / 1.64,
                              child: DropdownButton(
                                value: _currentRole,
                                isExpanded: true,
                                iconEnabledColor: Colors.black,
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    setState(() {
                                      _currentRole = newValue;
                                    });
                                  });
                                },
                                items: _dropDownMenuItems,
                              ),
                            ),
                            // new DropdownButton(
                            //   value: _currentRole,
                            //   items: _dropDownMenuItems,
                            //   onChanged: changedDropDownItem,
                            // )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            onPressed: () async {
                              var plainpass =
                                  passwordController.text.toString();
                              var hashedPassword = new DBCrypt()
                                  .hashpw(plainpass, new DBCrypt().gensalt());
                              var url = koneksi.connect('addAdmin.php');
                              Response respons = await dio.post(url,
                                  data: FormData.fromMap({
                                    "username":
                                        usernameController.text.toString(),
                                    "password": hashedPassword,
                                    "nama": nameController.text.toString(),
                                    "email": emailController.text.toString(),
                                    "notelp":
                                        phonenumberController.text.toString(),
                                    "role": _currentRole.toString()
                                  }));
                              Fluttertoast.showToast(msg: respons.data);
                            },
                            child: Text(
                              'REGISTER',
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

  void changedDropDownItem(String selectedrole) {
    setState(() {
      _currentRole = selectedrole;
    });
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
