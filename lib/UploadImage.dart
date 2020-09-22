import 'dart:convert';
import 'dart:io';

import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyUploadImage());
}

class MyUploadImage extends StatelessWidget {
  String value = "";
  MyUploadImage({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload image',
      home: UploadImage(
        idpaket: value,
      ),
    );
  }
}

class UploadImage extends StatefulWidget {
  String idpaket = "";
  UploadImage({Key key, this.idpaket}) : super(key: key);

  String title = "Upload Image";

  @override
  UploadImageState createState() => UploadImageState();
}

class UploadImageState extends State<UploadImage> {
  static final String uploadEndPoint = koneksi.connect('upload_image.php');
  static final String uploadDatabaseGambarPaket =
      koneksi.connect('sendDataGambarPaket.php');
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
      print(status);
    });
  }

  startUpload() {
    setStatus('Uploading');
    print("upload");
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
      print("bisa g ini" + result.toString());
      http.post(uploadDatabaseGambarPaket, body: {
        "nama_gambar": fileName,
        "id": widget.idpaket,
      }).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        Fluttertoast.showToast(msg: response.body);
      });
    }).catchError((error) {
      print("bisa g");
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
          print("Bisa sampe show image ?");
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Tidak ada gambar yang dipilih',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload gambar"),
        ),
        body: WillPopScope(
          child: Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                OutlineButton(
                  onPressed: chooseImage,
                  child: Text('Pilih gambar' + widget.idpaket),
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
                  child: Text('Upload gambar'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
          onWillPop: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
