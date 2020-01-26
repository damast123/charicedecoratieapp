import 'dart:convert';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
void main(){
  runApp(LupaPass());

}

class LupaPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  List data; 
  final _formKey = GlobalKey<FormState>();
  var gethashpass = "";
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          nameField(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  var url = "http://192.168.43.97:9090/TA/lupapass.php";
                  http.post(url, body: {"username": emailController.text.toString()})
                      .then((response) {
                    print("Response status: ${response.statusCode}");
                    print("Response body: ${response.body}");
                    var content = json.decode(response.body);
                    data = content['getpassword'];
                    print("dibawah ini data");
                    gethashpass = data[0]['password'];
                    print(data[0]['password']);
                    var plainpass = emailController.text.toString();
                    print("dibawah ini data");
                    print(plainpass);
                    if(new DBCrypt().checkpw(plainpass, data[0]['password'])) 
                    {
                      print("It matches");
                    } 
                    else
                    {
                      print("It does not match");
                    } 
                  });
                  
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
  Widget nameField() {

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

