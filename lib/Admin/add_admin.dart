import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:dbcrypt/dbcrypt.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(add_Admin());
}

class add_Admin extends StatefulWidget {
  @override
  _add_AdminState createState() => _add_AdminState();
}

class _add_AdminState extends State<add_Admin> {
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
      items.add(new DropdownMenuItem(
          value: role,
          child: new Text(role)
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add admin or freelance',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Form Add'),
        ),
        body: Container(
          margin: EdgeInsets.all(20.0), //SET MARGIN DARI CONTAINER 
          child: Form( 
            key: _formKey,
                  child: Stack(
                    children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/pic0.jpg'),
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
                              padding: EdgeInsets.only(top: 20),
                              child: Container(
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
                            ),
                            Container(
                              color: Color(0xfff5f5f5),
                              child: TextFormField(
                                obscureText: true,
                                controller: passwordController,
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
                            Container(
                              color: Color(0xfff5f5f5),
                              child: nameField()
                            ),
                            Container(
                              color: Color(0xfff5f5f5),
                              child: phonenumberField()
                            ),
                            Container(
                              color: Color(0xfff5f5f5),
                              child: emailField()
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Role:'),
                                new DropdownButton(
                                  value: _currentRole,
                                  items: _dropDownMenuItems,
                                  onChanged: changedDropDownItem,
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: MaterialButton(
                                onPressed: (){
                                  var plainpass = passwordController.text.toString();
                                  var hashedPassword = new DBCrypt().hashpw(plainpass, new DBCrypt().gensalt());
                                  var url = "http://192.168.43.97:9090/TA/register.php";
                                  http.post(url, body: {"username": usernameController.text.toString(), "password": hashedPassword, "nama": nameController.text.toString(), "email": emailController.text.toString(), "notelp": phonenumberController.text.toString(), "role":_currentRole})
                                      .then((response) {
                                    print("Response status: ${response.statusCode}");
                                    print("Response body: ${response.body}");
                                    Toast.show(response.body, context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                                  });
                                },//since this is only a UI app
                                child: Text('REGISTER',
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
    //MEMBUAT TEXT INPUT 
    return TextFormField(
      controller: nameController,
      style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nama',
                              prefixIcon: Icon(Icons.person),
                              labelStyle: TextStyle(
                                  fontSize: 15
                                )
                            ),
      //AKAN BERISI VALIDATION
    );
  }

  Widget phonenumberField() {
    return TextFormField(
      controller: phonenumberController,
      keyboardType: TextInputType.phone, 
      maxLength: 13,
      style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                              labelStyle: TextStyle(
                                  fontSize: 15
                                )
                            ),
      //AKAN BERISI VALIDATION
    );
  }

  Widget emailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress, // KEYBOARD TYPENYA ADALAH EMAIL ADDRESS
      //AGAR SYMBOL @ DILETAKKAN DIDEPAN KETIKA KEYBOARD DI TAMPILKAN
      style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              labelStyle: TextStyle(
                                  fontSize: 15
                                )
                            ),
      //AKAN BERISI VALIDATION
    );
  }

  Widget registerButton() {
    //MEMBUAT TOMBOL
    return RaisedButton(
      color: Colors.blueAccent, //MENGATUR WARNA TOMBOL
      onPressed: () {
        //PERINTAH YANG AKAN DIEKSEKUSI KETIKA TOMBOL DITEKAN
        var plainpass = passwordController.text.toString();
        var hashedPassword = new DBCrypt().hashpw(plainpass, new DBCrypt().gensalt());
        var url = "http://192.168.43.97:9090/TA/register.php";
        http.post(url, body: {"username": usernameController.text.toString(), "password": hashedPassword, "nama": nameController.text.toString(), "email": emailController.text.toString(), "notelp": phonenumberController.text.toString()})
            .then((response) {
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.body}");
          Toast.show(response.body, context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
        });
      },
      child: Text('Daftar'), //TEXT YANG AKAN DITAMPILKAN PADA TOMBOL
    );
  }
}