import 'package:charicedecoratieapp/Admin/DetailHistoryAdmin.dart';
import 'dart:convert';

import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyHistoryAdmin());
}

class MyHistoryAdmin extends StatelessWidget {
  const MyHistoryAdmin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HistoryAdmin(),
    );
  }
}

class HistoryAdmin extends StatefulWidget {
  @override
  _HistoryAdminState createState() => _HistoryAdminState();
}

class _HistoryAdminState extends State<HistoryAdmin> {
  String urlHistory = koneksi.connect('historyBooking.php');
  List dataHistory = [];
  Future<String> fetchHistory() async {
    try {
      Response response = await dio.get(urlHistory);
      print("Ini isi response: " + response.toString());

      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.data);

          dataHistory = content['historyBooking'];
        });
        return 'sukses';
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("History Admin"),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "All history",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: dataHistory.isEmpty
                      ? Container(
                          padding: EdgeInsets.all(100.0),
                          child: Text(
                            'Empty',
                            style: TextStyle(fontSize: 20),
                          ))
                      : ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey,
                            );
                          },
                          itemCount: dataHistory.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {},
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                          dataHistory[index]['no_booking'],
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  'Nama acara : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(dataHistory[index]
                                                    ['nama_acara'])
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  'Tanggal acara : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(dataHistory[index]
                                                    ['tanggal_acara'])
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  'Grandtotal : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(dataHistory[index]
                                                    ['grandtotal'])
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Colors.black,
                                            size: 30.0),
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      new MyDetailHistoryAdmin(
                                                        getBooking:
                                                            dataHistory[index]
                                                                ['no_booking'],
                                                        getIsDone:
                                                            dataHistory[index]
                                                                ['_isdone'],
                                                      )));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
