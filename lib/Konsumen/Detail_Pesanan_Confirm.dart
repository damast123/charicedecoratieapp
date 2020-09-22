import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/api/messaging.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

void main() {
  runApp(MyDetailPesananConfirm());
}

class MyDetailPesananConfirm extends StatelessWidget {
  String booking = "";
  String user = "";
  MyDetailPesananConfirm({Key key, this.booking, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Detail Confirmation: ' + booking;

    return MaterialApp(
      title: appTitle,
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: DetailPesananConfirm(booking: booking, user: user),
        ),
      ),
    );
  }
}

class DetailPesananConfirm extends StatefulWidget {
  String booking = "";
  String user = "";
  DetailPesananConfirm({Key key, this.booking, this.user}) : super(key: key);
  @override
  _DetailPesananConfirmState createState() => _DetailPesananConfirmState();
}

class _DetailPesananConfirmState extends State<DetailPesananConfirm> {
  var setCaraPembayaran = "BCA";
  var setGmbar = "";
  DateTime tanggal_now = DateTime.now();
  DateTime tanggal_awal = DateTime.now();
  DateTime tanggal_akhir = DateTime.now();
  var setButton = true;
  var dateAfter = false;
  List book = [];
  Future<File> file;
  String status = '';
  DateTime date_akhir;
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
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());

          setGmbar = "ada";
          print("setGmbar: " + setGmbar);
          return Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          setGmbar = "";
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          setGmbar = "";
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          );
        }
      },
    );
  }

  List dataAdmin = [];
  Future<String> fetchAdmin() async {
    final urlGetAdmin = koneksi.connect('getAdmin.php');
    Response response = await dio.get(urlGetAdmin);
    print(response.data.toString());
    if (response.statusCode == 200) {
      setState(() {
        var content = json.decode(response.data);

        dataAdmin = content['data_admin'];
      });
      return 'sukses';
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    final String url =
        koneksi.connect('searchBooking.php?no_booking=' + widget.booking);
    super.initState();
    Future<String> getData() async {
      var setDateAfter = "";
      Response response = await dio.get(url);
      setState(() {
        print(response.data.toString());

        var content = json.decode(response.data);
        book = content['searchbooking'];

        tanggal_awal = DateTime.parse(book[0]['tanggal_booking']);
        tanggal_akhir = tanggal_awal.add(Duration(days: 2));
        var set_time_akhir = DateFormat("yyyy-MM-dd").format(tanggal_akhir);
        var get_time_akhir = set_time_akhir + " 23:59:59";
        date_akhir = DateTime.parse(get_time_akhir);
        dateAfter = DateTime.now().isAfter(date_akhir);
        if (dateAfter == true) {
          setDateAfter = "ada";
          setState(() {
            setButton = false;
          });
        } else {
          setState(() {
            setButton = true;
          });
        }
      });
      if (setDateAfter == "ada") {
        var url = koneksi.connect('UpdatePembayaran.php');
        Response responseUpdatePembayaran = await dio.post(url,
            data: FormData.fromMap(
              {
                "tanggal": tanggal_now.toString(),
                "status": "-1",
                "role": "Konsumen",
                "noBooking": widget.booking,
              },
            ));
        print("Response status: ${responseUpdatePembayaran.statusCode}");
        print("Response body: ${responseUpdatePembayaran.data}");
        if (responseUpdatePembayaran.data == "sukses") {
          Fluttertoast.showToast(
              msg:
                  "Proses booking dibatalkan dikarenakan sudah melewati tanggal akhir.",
              toastLength: Toast.LENGTH_LONG);
          sendNotificationPembayaranBatal();
        } else {
          Fluttertoast.showToast(
              msg: "Ini update pembayaran: " + responseUpdatePembayaran.data);
        }
      } else {}
    }

    getData();
    this.fetchAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: RichText(
                  text: TextSpan(
                      text: 'Silahkan lakukan pembayaran sebelum tanggal: ',
                      style: TextStyle(fontSize: 18, color: Colors.black38),
                      children: <TextSpan>[
                        TextSpan(
                            text: date_akhir.toString(),
                            style: TextStyle(color: Colors.black, fontSize: 18))
                      ]),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            if (book[0]['nama_pembayaran'] == "Transfer")
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 48),
                          child: Text("BCA")),
                    ],
                  ),
                  new TextFormField(
                    maxLines: 2,
                    readOnly: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.multiline,
                    initialValue: "Transfer BCA:\n081741326642",
                    style: TextStyle(color: Colors.blue[800], fontSize: 18),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: RichText(
                        text: TextSpan(
                            text: 'Jumlah yang harus dibayar: \n',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Rp.' + book[0]['grandtotal'],
                                  style: TextStyle(color: Colors.red[500]))
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            if (book[0]['nama_pembayaran'] == "OVO")
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 48),
                          child: Text("OVO")),
                    ],
                  ),
                  new TextFormField(
                    maxLines: 2,
                    readOnly: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.multiline,
                    initialValue: "No telp:\n081741326642",
                    style:
                        TextStyle(color: Colors.deepPurple[500], fontSize: 18),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: RichText(
                        text: TextSpan(
                            text: 'Jumlah yang harus dibayar: \n',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Rp.' + book[0]['grandtotal'],
                                  style: TextStyle(color: Colors.red[500]))
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            if (book[0]['nama_pembayaran'] == "GOPAY")
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 48),
                          child: Text("GOPAY")),
                    ],
                  ),
                  new TextFormField(
                    maxLines: 2,
                    readOnly: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.multiline,
                    initialValue: "No telp:\n081741326642",
                    style: TextStyle(color: Colors.green[500], fontSize: 18),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: RichText(
                        text: TextSpan(
                            text: 'Jumlah yang harus dibayar: \n',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Rp.' + book[0]['grandtotal'],
                                  style: TextStyle(color: Colors.red[500]))
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Text(
              'Upload image',
              style: TextStyle(fontSize: 18),
            ),
            showImage(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: RaisedButton(
                    color: Colors.blue[500],
                    onPressed: setButton
                        ? () {
                            chooseImage();
                          }
                        : null,
                    child: Text(
                      'Upload',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: RaisedButton(
                    color: Colors.deepOrange[400],
                    onPressed: setButton
                        ? () async {
                            if (setGmbar == "") {
                              Fluttertoast.showToast(
                                  msg: "Silahkan masukkan bukti transfer");
                            } else {
                              var now = DateTime.now();
                              String datenow =
                                  DateFormat("yyyy-MM-dd").format(now);
                              var url = koneksi.connect('UpdatePembayaran.php');
                              Response responseUpdatePembayaran =
                                  await dio.post(url,
                                      options: Options(
                                          contentType: 'multipart/form-data'),
                                      data: FormData.fromMap(
                                        {
                                          "tanggal": datenow.toString(),
                                          "status": "1",
                                          "role": "Konsumen",
                                          "noBooking": widget.booking,
                                          "image": base64Image,
                                        },
                                      ));
                              print(
                                  "Response status: ${responseUpdatePembayaran.statusCode}");
                              print(
                                  "Response body: ${responseUpdatePembayaran.data}");
                              if (responseUpdatePembayaran.data == "sukses") {
                                sendNotification();
                                Fluttertoast.showToast(
                                    msg: responseUpdatePembayaran.data +
                                        " mengisi data");
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => Home(
                                              value: widget.user,
                                            ),
                                        fullscreenDialog: true));
                              } else {
                                Fluttertoast.showToast(
                                    msg: responseUpdatePembayaran.data);
                              }
                            }
                          }
                        : null,
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future sendNotification() async {
    for (var i = 0; i < dataAdmin.length; i++) {
      final response = await Messaging.sendTo(
        title: "New booking",
        body: "Ada booking baru yang telah dibayar. Silahkan dicek.",
        fcmToken: dataAdmin[i]['token'],
      );

      if (response.statusCode != 200) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content:
              Text('[${response.statusCode}] Error message: ${response.body}'),
        ));
      }
    }
  }

  Future sendNotificationPembayaranBatal() async {
    for (var i = 0; i < dataAdmin.length; i++) {
      final response = await Messaging.sendTo(
        title: "Booking: " + widget.booking + " batal",
        body:
            "Pada booking tersebut tidak jadi dikarenakan konsumen telah melewati tanggal pembayaran.",
        fcmToken: dataAdmin[i]['token'],
      );

      if (response.statusCode != 200) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content:
              Text('[${response.statusCode}] Error message: ${response.body}'),
        ));
      }
    }
  }
}
