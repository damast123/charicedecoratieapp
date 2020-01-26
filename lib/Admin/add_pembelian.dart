import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:dbcrypt/dbcrypt.dart';

import 'package:http/http.dart' as http;
void main() {
  runApp(add_Pembelian());
}

class add_Pembelian extends StatefulWidget {
  @override
  _add_PembelianState createState() => _add_PembelianState();
}

class _add_PembelianState extends State<add_Pembelian> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phonenumberController = new TextEditingController();
  List _statusbarangs = ["Main", "Additional"];

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
    for (String role in _statusbarangs) {
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
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 30),
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
                                    labelText: 'Supplier Name',
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

                                  var url = "http://192.168.43.97:9090/TA/register.php";
                                  http.post(url, body: {"username": usernameController.text.toString(), "nama": nameController.text.toString(), "email": emailController.text.toString(), "notelp": phonenumberController.text.toString(), "role":_currentRole})
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

  void changedDropDownItem(String selectedrole) {
    setState(() {
      _currentRole = selectedrole;
    });
  }

}