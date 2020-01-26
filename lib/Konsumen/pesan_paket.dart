import 'dart:convert';

import 'package:charicedecoratieapp/Konsumen/add_additional.dart';
import 'package:charicedecoratieapp/Konsumen/add_theme.dart';
import 'package:charicedecoratieapp/Konsumen/add_warna.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:image_picker/image_picker.dart';


void main() {
  runApp(MyPesanPaketKonsumen());
}



class MyPesanPaketKonsumen extends StatefulWidget {
  final String value;
  
  
  const MyPesanPaketKonsumen({Key key, this.value}) : super(key:key);
  @override
  _MyPesanPaketKonsumenState createState() => _MyPesanPaketKonsumenState();
}

class _MyPesanPaketKonsumenState extends State<MyPesanPaketKonsumen> with SingleTickerProviderStateMixin{
  bool isChecked = false;
  String dropdownValue = 'Putih';
  Size _deviceSize;
  String dropdownValueTema = '1';

  var items = List<String>();
  var itemsed = List<String>();
  List paket;
  List warna;
  String gambar;
  List tema;
  static final String uploadEndPoint = 'http://localhost/flutter_test/upload_image.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
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

  @override
  void initState() {
    String v = widget.value;
      final String url = koneksi.connect('detailPaket.php?id='+v);
      final String urlgetwarna = koneksi.connect('getwarna.php');
      final String urlgettema = koneksi.connect('getTema.php');
      Future<String> getData() async {
    
      var res = await http.get(Uri.encodeFull(url), headers: { 'accept':'application/json' });
        if(mounted)
        {
          setState(() {
          
          //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
          var content = json.decode(res.body);
          //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
          //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
          paket = content['paket'];
        });
        return 'success!';
        }
        
      }
      Future<String> getWarna() async {
    
      var res = await http.get(Uri.encodeFull(urlgetwarna), headers: { 'accept':'application/json' });
        if(mounted)
        {
          setState(() {
          
          //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
          var content = json.decode(res.body);
          //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
          //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
          warna = content['warna'];
        });
        return 'success!';
        }
        
        
      }
      Future<String> gettema() async {
    
      var res = await http.get(Uri.encodeFull(urlgettema), headers: { 'accept':'application/json' });
        if(mounted)
        {
          setState(() {
          
          //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
          var content = json.decode(res.body);
          //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
          //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
          tema = content['tema'];
        });
        return 'success!';
        }
        
        
      }
      getData();
      gettema();
      getWarna();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return MaterialApp(
      title: "Pesan Paket Konsumen",
      home: Scaffold(

        appBar: AppBar(
          title: Text("Pesan Paket Konsumen"),
        ),

        body: Container(
          padding: EdgeInsets.only(left: 0,top: 30.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Package Name: '+paket[0]['nama_paket'],style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87
                          ),),                          
                        ],
                      ),
                      
                      
                      Padding(
                        padding: EdgeInsets.only(left: 0.0,top: 20.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Choose Color:'),
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
                          items: warna.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['jenis_warna']),
                              value: item['jenis_warna'].toString(),
                            );
                          }).toList(),        
                        ),
                      ),
                      GestureDetector(
                            onTap: (){
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => new ChooseColor()));
                            },
                            child: Text('Tidak ada warna?', style: TextStyle(color: Colors.lightBlue),),
                          ),
                      
                      Padding(
                        padding: EdgeInsets.only(left: 0.0,top: 20.0),
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Choose Theme:'),
                        ],
                      ),
                      Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            width: _deviceSize.width,
                            height: 60,
                            child: DropdownButton<String>(
                              value: dropdownValueTema,
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
                                  dropdownValueTema = newValue;
                                });
                              },
                              items: tema.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(item['nama_tema']),
                                  value: item['idtema'].toString(),
                                );
                              }).toList(),
                              
                            ),
                          ),
                      GestureDetector(
                            onTap: (){
                              Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new MyAddTheme()));
                            },
                            child: Text('Tidak ada tema?', style: TextStyle(color: Colors.lightBlue),),
                          ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0,top: 20.0),
                      ),
                      Text('Reference Image:'),
                      SizedBox(
                        height: 20.0,
                      ),
                      showImage(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                        new RaisedButton(
                          padding: const EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text('Country List'),
                                  content: setupAlertDialoadContainer(),
                              );
                              }
                            );
                          },
                          child: new Text("Choose from database"),
                        ),
                        new RaisedButton(
                          onPressed: chooseImage,
                          textColor: Colors.white,
                          color: Colors.orange,
                          padding: const EdgeInsets.all(8.0),
                          child: new Text(
                            "Choose image from gallery",
                          ),
                        ),
                      ],),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => addAdditional(), fullscreenDialog: true));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.red,
                              size: 36.0,
                            ),
                            Text('add additional')
                          ],
                        ),
                      ),
                      
                      grandtotalField(),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0,top: 20.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            onPressed: (){
                              Toast.show('ini nnti masuk add to cart', context);
                            },
                            color: Colors.blue,
                            child: Text('Add',style: TextStyle(color: Colors.white),),
                          ),
                          FlatButton(
                            onPressed: (){
                              Toast.show('ini nnti masuk contact', context);
                            },
                            color: Colors.blue,
                            child: Text('Contact',style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

      ),
    );
  }
  

  Widget grandtotalField() {

    return TextFormField(

      // controller: tanggalController,
      decoration: InputDecoration(
          labelText: 'Grand total' //DENGAN LABEL Nama Lengkap
      ),
      enabled: false,

    );
  }


  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: GestureDetector(
        child: ListView.builder(
        shrinkWrap: true,
        itemCount: 60,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 64,
                maxHeight: 64,
              ),
              child: Image.asset('assets/images/pic0.jpg', fit: BoxFit.cover),
            ),
            title: Text('Gujarat, India'),
            onTap: (){
              Toast.show('ini bisa coba aja'+index.toString(), context);
            },
          );
        },
      ),
      )
    );
  }
}