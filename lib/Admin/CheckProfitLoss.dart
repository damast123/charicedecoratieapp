// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:charicedecoratieapp/Chart/datum_legend_with_measures.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(CheckProfitLoss());
}

typedef Widget GalleryWidgetBuilder();

/// Helper to build gallery.
class CheckProfitLoss extends StatefulWidget {
  /// The widget used for leading in a [ListTile].
  String year = "";
  String month = "";
  CheckProfitLoss({Key key, this.year, this.month}) : super(key: key);

  @override
  _CheckProfitLossState createState() => new _CheckProfitLossState();
}

class _CheckProfitLossState extends State<CheckProfitLoss> {
  List data = [];
  String dropdownValueYear = "";
  String dropdownValueMonth = "";
  List dataYear = [];
  List dataMonth = [];

  @override
  void initState() {
    super.initState();
    data.clear();
    for (var i = 1; i < 13; i++) {
      dataMonth.add(i);
    }
    for (var i = 2016; i < 2101; i++) {
      dataYear.add(i);
    }
    dropdownValueMonth = widget.month.toString();
    dropdownValueYear = widget.year.toString();
    final String url = koneksi.connect('checkProfitLoss.php?date=' +
        widget.year.toString() +
        "-" +
        widget.month.toString());
    print(url);
    Future<String> makeRequest() async {
      try {
        Response response = await dio.get(url);
        print("Ini isi response: " + response.toString());
        setState(() {
          var content = json.decode(response.data);

          data = content['labarugi'];
        });
      } catch (e) {
        print(e.toString());
      }
    }

    makeRequest();
  }

  @override
  void dispose() {
    AutoOrientation.portraitUpMode();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AutoOrientation.portraitUpMode();
    return new Scaffold(
      appBar: new AppBar(title: new Text("Pendapatan pengeluaran")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Year'),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 5,
              child: DropdownButton(
                value: dropdownValueYear,
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
                    dropdownValueYear = newValue;
                    print("ini onchange year: " + dropdownValueYear);
                  });
                },
                items: dataYear.map((item) {
                  return new DropdownMenuItem(
                    child: new Text(item.toString()),
                    value: item.toString(),
                  );
                }).toList(),
              ),
            ),
            Text('Month'),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 5,
              child: DropdownButton(
                value: dropdownValueMonth,
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
                    dropdownValueMonth = newValue;
                    print("ini onchange month: " + dropdownValueMonth);
                  });
                },
                items: dataMonth.map((item) {
                  return new DropdownMenuItem(
                    child: new Text(item.toString()),
                    value: item.toString(),
                  );
                }).toList(),
              ),
            ),
            RaisedButton(
              onPressed: () {
                print("ini isi dropdownvalueyear: " + dropdownValueYear);
                print("ini isi dropdownvaluemonth: " + dropdownValueMonth);
                Navigator.of(context, rootNavigator: true)
                    .pushReplacement(MaterialPageRoute(
                        builder: (context) => new CheckProfitLoss(
                              year: dropdownValueYear.toString(),
                              month: dropdownValueMonth.toString(),
                            )));
              },
              child: Text('Check'),
            ),
            new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Column(children: <Widget>[
                  new SizedBox(
                      height: 250.0,
                      child: DatumLegendWithMeasures.withSampleData(
                          data[0]['untung'], data[1]['rugi'])),
                ])),
          ],
        ),
      ),
    );
  }
}
