import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(add_Supplier());
}

class add_Supplier extends StatelessWidget {
  const add_Supplier({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: My_add_Supplier(),
    );
  }
}

class My_add_Supplier extends StatefulWidget {
  @override
  _My_add_SupplierState createState() => _My_add_SupplierState();
}

class _My_add_SupplierState extends State<My_add_Supplier> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController alamatController = new TextEditingController();
  TextEditingController phonenumberController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Form Add Supplier'),
        ),
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/background_image.jpg'),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter)),
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
                            color: Color(0xfff5f5f5), child: alamatField()),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            color: Color(0xfff5f5f5), child: emailField()),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            onPressed: () async {
                              var url = koneksi.connect("addSupplier.php");
                              Response response = await dio.post(url,
                                  data: FormData.fromMap({
                                    "nama": nameController.text.toString(),
                                    "email": emailController.text.toString(),
                                    "notelp":
                                        phonenumberController.text.toString(),
                                    "alamat": alamatController.text.toString()
                                  }));

                              print("Response status: ${response.statusCode}");
                              print("Response body: ${response.data}");
                              Fluttertoast.showToast(msg: response.data);
                            },
                            child: Text(
                              'Add Supplier',
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

  Widget alamatField() {
    return TextFormField(
      controller: alamatController,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Alamat',
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
          labelText: 'Phone Number',
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
