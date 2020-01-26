import 'dart:convert';

import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyInputBooking());
}



class MyInputBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Pesan Paket';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(

        appBar: AppBar(
          title: Text(appTitle),
        ),

        body:Input_Booking() ,

      ),
    );
  }
}

class Input_Booking extends StatefulWidget {
  @override
  _Input_BookingState createState() => _Input_BookingState();
}

class _Input_BookingState extends State<Input_Booking> {
  String dropdownValue = 'transfer';
  Size _deviceSize;
  bool isChecked = false;
  List type = [];
  final String url = koneksi.connect('getTypePayment.php');
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
      type = content['type'];
    });
    return 'success!';
    }
    
  }

  @override
  void initState() { 
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        // Align(
        //   alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
        //   child: 
        // ),
        Padding(
          padding: EdgeInsets.only(top: 20.0)
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Booking number: ",style: TextStyle(fontSize: 16),),
            Text("ni booking e cik",style: TextStyle(fontSize: 16),)
          ],
        ),
        // new Container(
        //   height: 100.0,
        //   child: ListView.separated(
        //     separatorBuilder: (context,index){
        //     return Divider(color: Colors.grey,);
        //   },
        //   itemCount: 5, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
        //   itemBuilder: (BuildContext context, int index) { 
        //   return Container(
        //     child: Card(
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min, children: <Widget>[
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: <Widget>[
        //             Text('Package Type:'),
        //             Text('ini'),
        //             RaisedButton(elevation: 0.0,
        //             color: Colors.blueAccent,
        //             child: Text('Add',),
        //             onPressed: (){
        //             Toast.show('ini bisa ditekan dengan index: '+index.toString(), context);
        //             },
        //           ),
        //           ],
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        //   }
        // ),
        // ),
        NamaField(),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: <Widget>[
        //     DateField(),
        //     FlatButton(     
        //       onPressed: () async {
        //         final date = await showDatePicker(
        //           context: context,
        //           firstDate: DateTime(DateTime.now().year),
        //           initialDate: DateTime.now(),
        //           lastDate: DateTime(2100));
        //           if (date != null) {
        //             final time = await showTimePicker(
        //             context: context,
        //             initialTime:
        //             TimeOfDay(hour: 13,minute: 0),
        //           );
        //                 // return tanggalController.text = DateTimeField.combine(date, time).toString();
        //           }
        //       },
        //       child: Icon(Icons.date_range),   
        //     ),
        //   ],
        // ),
        PlaceField(),
        PhoneNumberField(),
        ForManyPeopleField(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Status: ',style: TextStyle(fontSize: 16),),
            Text('Ok',style: TextStyle(fontSize: 16),)
          ],
        ),
        SizedBox(height: 20.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Harga:',style: TextStyle(fontSize: 16),),
            Text('Rp.20000',style: TextStyle(fontSize: 16),)
          ],
        ),
        SizedBox(height: 20.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Type of Payment',style: TextStyle(fontSize: 16),),
            
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: _deviceSize.width,
          height: 60,
          child: DropdownButton<String>(
            value: dropdownValue,
            isExpanded: true,
            iconEnabledColor: Colors.black,
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: type.map((item) {
              return new DropdownMenuItem(
                child: new Text(item['nama_pembayaran']),
                value: item['nama_pembayaran'].toString(),
              );
            }).toList(),
                              
          ),
        ),
        SizedBox(height: 20.0,),
        Row(        
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 0.0),
              child: Checkbox(
                value: isChecked,
                onChanged: (bool value) {
                  setState(() {
                  isChecked = value;
                  if(isChecked==true)
                  {
                    Toast.show('True', context);
                  }
                  else
                  {
                    Toast.show('False', context);
                  }
                });
                },
                ),
              ) ,       
              Text("Need format order?",style: TextStyle(fontSize: 16),),
            ],
          ),
        SizedBox(height: 20.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: (){
                
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 20)
                ),
              ),
            ),
            RaisedButton(
              onPressed: (){},
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 20)
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget NamaField() {

    return TextFormField(
      // controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Name',
        hintText: 'Enter Your Name',
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

  Widget PlaceField() {

    return TextFormField(
      // controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Place',
        hintText: 'Enter Your Name',
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
  Widget PhoneNumberField() {

    return TextFormField(
      // controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
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

  Widget ForManyPeopleField() {

    return TextFormField(
      // controller: passwordController,
      decoration: InputDecoration(
        labelText: 'For Many People',
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

  Widget DateField() {

    return TextFormField(
      // controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Date',
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