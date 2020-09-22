import 'dart:async';
import 'dart:convert';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(new MyCheckChart());

class MyCheckChart extends StatelessWidget {
  String getVal;
  MyCheckChart({
    Key key,
    this.getVal,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(
        getVal: getVal,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String getVal;
  MyHomePage({
    Key key,
    this.getVal,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data = [];
  List dataLalu = [];
  Timer timer;
  String namaJenis = "";
  @override
  void initState() {
    super.initState();
    final String url =
        koneksi.connect('getStatistikaPaket.php?id=' + widget.getVal);
    Future<String> makeRequest() async {
      try {
        Response response = await dio.get(url);
        print("Ini isi response: " + response.toString());
        setState(() {
          var content = json.decode(response.data);

          data = content['getBarang'];
        });
      } catch (e) {
        print(e.toString());
      }
    }

    makeRequest();

    final String urlDulu =
        koneksi.connect('getStatistikaPaketDulu.php?id=' + widget.getVal);
    Future<String> makeRequestDulu() async {
      try {
        Response response = await dio.get(urlDulu);
        print("Ini isi response: " + response.toString());
        setState(() {
          var content = json.decode(response.data);

          dataLalu = content['getBarangLalu'];
        });
      } catch (e) {
        print(e.toString());
      }
    }

    makeRequestDulu();
    // timer = new Timer.periodic(new Duration(seconds: 2), (t) => makeRequest());
    if (widget.getVal == "4") {
      namaJenis = "Backdrop";
    } else if (widget.getVal == "5") {
      namaJenis = "Room decor";
    } else {
      namaJenis = "Table decor";
    }
  }

  @override
  void dispose() {
    // timer.cancel();
    AutoOrientation.landscapeRightMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AutoOrientation.landscapeRightMode();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Paket Data ' + namaJenis),
      ),
      body: data == null
          ? CircularProgressIndicator()
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Bulan lalu:"),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: createChartDulu(),
                    ),
                    Text("Bulan ini:"),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: createChart(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  charts.Series<LivePaket, String> createSeries(String id, int i) {
    return charts.Series<LivePaket, String>(
      id: id,
      domainFn: (LivePaket wear, _) => wear.namaPaket,
      measureFn: (LivePaket wear, _) => wear.jumlah,
      // data is a List<LivePaket> - extract the information from data
      // could use i as index - there isn't enough information in the question
      // map from 'data' to the series
      // this is a guess
      data: [
        LivePaket(data[i]['nama_paket'], int.parse(data[i]['jumlah'])),
      ],
    );
  }

  Widget createChart() {
    // data is a List of Maps
    // each map contains at least temp1 (tool 1) and temp2 (tool 2)
    // what are the groupings?

    List<charts.Series<LivePaket, String>> seriesList = [];

    for (int i = 0; i < data.length; i++) {
      String id = '${i + 1}';
      seriesList.add(createSeries(id, i));
    }

    return new charts.BarChart(
      seriesList,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }

  charts.Series<LivePaketDulu, String> createSeriesDulu(String id, int i) {
    return charts.Series<LivePaketDulu, String>(
      id: id,
      domainFn: (LivePaketDulu wear, _) => wear.namaPaketDulu,
      measureFn: (LivePaketDulu wear, _) => wear.jumlahDulu,
      // data is a List<LivePaket> - extract the information from data
      // could use i as index - there isn't enough information in the question
      // map from 'data' to the series
      // this is a guess
      data: [
        LivePaketDulu(data[i]['nama_paket'], int.parse(data[i]['jumlah'])),
      ],
    );
  }

  Widget createChartDulu() {
    // data is a List of Maps
    // each map contains at least temp1 (tool 1) and temp2 (tool 2)
    // what are the groupings?

    List<charts.Series<LivePaketDulu, String>> seriesList = [];

    for (int i = 0; i < dataLalu.length; i++) {
      String id = '${i + 1}';
      seriesList.add(createSeriesDulu(id, i));
    }

    return new charts.BarChart(
      seriesList,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }
}

class LivePaket {
  final String namaPaket;
  final int jumlah;

  LivePaket(this.namaPaket, this.jumlah);
}

class LivePaketDulu {
  final String namaPaketDulu;
  final int jumlahDulu;

  LivePaketDulu(this.namaPaketDulu, this.jumlahDulu);
}
