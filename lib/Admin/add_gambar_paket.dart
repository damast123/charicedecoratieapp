import 'dart:convert';
import 'dart:io';

import 'package:charicedecoratieapp/Admin/home_admin.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyGambarPaket());
}

class MyGambarPaket extends StatelessWidget {
  final value;
  const MyGambarPaket({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Add Image package'),
          ),
          body: GambarPaket(
            username: value,
          ),
        ),
      ),
    );
  }
}

class GambarPaket extends StatefulWidget {
  String username = "";
  GambarPaket({this.username}) : super();

  @override
  _GambarPaket createState() => _GambarPaket();
}

class _GambarPaket extends State<GambarPaket> {
  static final String uploadEndPoint = koneksi.connect('upload_image.php');
  static final String url = koneksi.connect("addGambarPaket.php");
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String namaGambar = "";
  String errMessage = 'Error Uploading Image';
  var dropdownValuePaket;
  List getPaket = [];
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
    namaGambar = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) async {
    Response respons = await dio.post(uploadEndPoint,
        options: Options(contentType: 'multipart/form-data'),
        data: FormData.fromMap({
          "image": base64Image,
          "name": fileName,
        }));
    Response responsPhpMyAdmin = await dio.post(url,
        data: FormData.fromMap({
          "namagambar": namaGambar,
          "jenispaket": dropdownValuePaket.toString(),
        }));
    Fluttertoast.showToast(msg: responsPhpMyAdmin.data);
    if (responsPhpMyAdmin == "sukses") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => home_admin(
              username: widget.username,
            ),
          ),
          (Route<dynamic> route) => false);
    }
  }

  Future<String> fetchPaket() async {
    try {
      Response response = await dio.get(koneksi.connect('getAllPaket.php'));
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        getPaket = content['paket'];
      });
    } catch (e) {
      print(e.toString());
    }
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
    super.initState();
    this.fetchPaket();
  }

  @override
  Widget build(BuildContext context) {
    var _sizeDevice = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: _sizeDevice.size.width,
            height: _sizeDevice.size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/charicedecor.jpg'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter)),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 270, bottom: _sizeDevice.viewInsets.bottom),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Add packet pict",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 20,
                      child: DropdownButton(
                        value: dropdownValuePaket,
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
                            dropdownValuePaket = newValue;
                          });
                        },
                        items: getPaket.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(
                                item['nama_paket'] + ", " + item['nama_jenis']),
                            value: item['idpaket'].toString(),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    OutlineButton(
                      onPressed: chooseImage,
                      child: Text('Choose Image'),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    showImage(),
                    SizedBox(
                      height: 20.0,
                    ),
                    OutlineButton(
                      onPressed: startUpload,
                      child: Text('Upload image'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
