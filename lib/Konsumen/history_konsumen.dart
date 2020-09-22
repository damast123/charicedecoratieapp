import 'dart:convert';

import 'package:charicedecoratieapp/Konsumen/DetailBookingIsDone.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(HistoryKonsumen());
}

class HistoryKonsumen extends StatefulWidget {
  String username = "";
  HistoryKonsumen({Key key, this.username}) : super(key: key);

  @override
  _HistoryKonsumenState createState() => _HistoryKonsumenState();
}

class _HistoryKonsumenState extends State<HistoryKonsumen> {
  List dataHistory = [];

  @override
  void initState() {
    super.initState();
    final String urlHistory = koneksi
        .connect('getHistoryBookingKonsumen.php?username=' + widget.username);
    Future<String> fetchHistory() async {
      final response = await http.get(urlHistory);

      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.body);

          dataHistory = content['getAllHistoryBooking'];
        });
        return 'sukses';
      } else {
        throw Exception('Failed to load post');
      }
    }

    fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'History Konsumen';

    return MaterialApp(
      title: appTitle,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: Container(
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
                                                      new MyDetailBookDone(
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
