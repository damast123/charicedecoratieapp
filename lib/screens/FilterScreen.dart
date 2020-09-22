import 'dart:convert';

import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/Konsumen/homePaket.dart';
import 'package:charicedecoratieapp/model/popularFilterList.dart';
import 'package:charicedecoratieapp/widgets/hotelAppTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:charicedecoratieapp/widgets/RangeSlider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FiltersScreen extends StatefulWidget {
  String num1 = "";
  String num2 = "";
  String user = "";
  FiltersScreen({Key key, this.num1, this.num2, this.user}) : super(key: key);
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

enum SingingCharacter { jenis, tema }

class _FiltersScreenState extends State<FiltersScreen> {
  RangeValues _values = RangeValues(100,
      600); //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY
  double harga_mahal = 0;
  double harga_murah = 0;
  var _isAbsorbTema = true;
  var _isAbsorbJenis = false;
  SingingCharacter _character = SingingCharacter.jenis;

  final String url = koneksi.connect('getJenisPaket.php');
  final String urlgettema = koneksi.connect('getTema.php');
  List jenis = [];
  List tema = [];
  List<String> _listViewDataTema = [];
  List<String> _listViewDataJenis = [];
  List<PopularFilterListData> popularFilterListData =
      PopularFilterListData.popularFList;
  List<PopularFilterListData> accomodationListData =
      PopularFilterListData.accomodationList;
  Future<String> getData() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON

    var res = await http
        .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});

    setState(() {
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      jenis = content['jenis'];
    });
    if (popularFilterListData.isEmpty) {
      for (int i = 0; i < jenis.length; i++) {
        popularFilterListData.add(PopularFilterListData(
          titleTxt: jenis[i]['nama_jenis'],
          isSelected: false,
          id: jenis[i]['idjenis'],
        ));
      }
    } else {}

    return 'success!';
  }

  Future<String> getDataTema() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON

    var res = await http.get(Uri.encodeFull(urlgettema),
        headers: {'accept': 'application/json'});

    setState(() {
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      tema = content['tema'];
    });
    if (accomodationListData.isEmpty) {
      for (int i = 0; i < tema.length; i++) {
        accomodationListData.add(PopularFilterListData(
          titleTxt: tema[i]['nama_tema'],
          isSelected: false,
          id: tema[i]['idtema'],
        ));
      }
    } else {}

    return 'success!';
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    this.getData();
    this.getDataTema();
    if (_listViewDataTema.isNotEmpty) {
      _listViewDataTema.clear();
    }

    if (_listViewDataJenis.isEmpty) {
      _listViewDataJenis.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    harga_murah = num.tryParse("${widget.num1}").toDouble();
    harga_mahal = num.tryParse("${widget.num2}").toDouble();

    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: WillPopScope(
          onWillPop: () {
            Navigator.of(context, rootNavigator: true)
                .pushReplacement(MaterialPageRoute(
                    builder: (context) => Home(
                          value: widget.user,
                        ),
                    fullscreenDialog: true));
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        getAppBarUI(),
                        Container(
                          height: 800,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                _buildRadioButton(),

                                priceBarFilter(),
                                Divider(
                                  height: 1,
                                ),
                                Text('Jenis Paket'),
                                AbsorbPointer(
                                  absorbing: _isAbsorbJenis,
                                  child: popularFilter(),
                                ),
                                // popularFilter(),
                                Divider(
                                  height: 1,
                                ),
                                Text('Jenis Tema'),
                                AbsorbPointer(
                                  absorbing: _isAbsorbTema,
                                  child: popularFilterTema(),
                                ),
                                // popularFilterTema(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 8),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: HotelAppTheme.buildLightTheme().primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          blurRadius: 8,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        highlightColor: Colors.transparent,
                        onTap: () {
                          // Navigator.pop(context);

                          if (_character == SingingCharacter.jenis) {
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => home_paket(
                                          value: _listViewDataJenis,
                                          murah: _values.start,
                                          mahal: _values.end,
                                          filter: "jenis",
                                          user: widget.user.toString(),
                                        )));
                          } else {
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => home_paket(
                                          value: _listViewDataTema,
                                          murah: _values.start,
                                          mahal: _values.end,
                                          filter: "tema",
                                          user: widget.user.toString(),
                                        ),
                                    fullscreenDialog: true));
                          }
                        },
                        child: Center(
                          child: Text(
                            "Apply",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: const Text('Jenis'),
          leading: Radio(
            value: SingingCharacter.jenis,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                _isAbsorbJenis = false;
                _isAbsorbTema = true;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Tema'),
          leading: Radio(
            value: SingingCharacter.tema,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                _isAbsorbJenis = true;
                _isAbsorbTema = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Price (for 1 night)",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSliderView(
          values: _values = RangeValues(harga_murah, harga_mahal),
          onChnageRangeValues: (values) {
            _values = values;
          },
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Filters",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }

  Widget popularFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            "Popular filters Jenis",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList() {
    List<Widget> noList = List<Widget>();
    var cout = 0;
    final columCount = 2;
    for (var i = 0; i < popularFilterListData.length / columCount; i++) {
      List<Widget> listUI = List<Widget>();
      for (var i = 0; i < columCount; i++) {
        try {
          final date = popularFilterListData[cout];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        date.isSelected = !date.isSelected;
                        if (date.isSelected == true) {
                          _listViewDataJenis.add(date.id);
                          print('_listViewDataJenis yang ditambah');
                          print(_listViewDataJenis);
                        } else {
                          _listViewDataJenis.remove(date.id);
                          print('_listViewDataJenis yang terhapus');
                          print(_listViewDataJenis);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            date.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: date.isSelected
                                ? HotelAppTheme.buildLightTheme().primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            date.titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          cout += 1;
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget popularFilterTema() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            "Popular filters Tema",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPListTema(),
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPListTema() {
    List<Widget> noList = List<Widget>();
    var cout = 0;
    final columCount = 2;
    for (var i = 0; i < accomodationListData.length / columCount; i++) {
      List<Widget> listUI = List<Widget>();
      for (var i = 0; i < columCount; i++) {
        try {
          final date = accomodationListData[cout];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        date.isSelected = !date.isSelected;
                        if (date.isSelected == true) {
                          _listViewDataTema.add(date.id);
                          print('_listViewDataTema yang ditambah');
                          print(_listViewDataTema);
                        } else {
                          _listViewDataTema.remove(date.id);
                          print('_listViewDataTema yang terhapus');
                          print(_listViewDataTema);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            date.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: date.isSelected
                                ? HotelAppTheme.buildLightTheme().primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            date.titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          cout += 1;
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }
}

class RadioGrup {
  final int index;
  final String text;
  RadioGrup({this.index, this.text});
}
