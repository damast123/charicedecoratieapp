
import 'package:charicedecoratieapp/Konsumen/detail_paket.dart' as prefix0;
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/model/Booking.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:charicedecoratieapp/main.dart';

import 'package:charicedecoratieapp/koneksi.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(home_admin());

String v = "";
String s = "";
List userProfileAdmin = [];

class home_admin extends StatefulWidget {
  // final String value;
  // final String apa;
  // Home({Key key, this.value,this.apa}) : super(key:key);
  
  @override
  _home_adminState createState() => _home_adminState();
}

class _home_adminState extends State<home_admin> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeAdmin(),
    ReportAdmin(),
    ProfileAdmin()
  ];

  @override
  Widget build(BuildContext context) {
    v = "ye";
    bool isBottomBarVisible = true;
    s = "ok";
    return Scaffold(

      body: _children[_currentIndex], // new
      bottomNavigationBar: isBottomBarVisible ? BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),

          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('Messages'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
        ],

      ) : Container(),

    );

  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}


class HomeAdmin extends StatefulWidget {
//  Home({Key key, this.value}) : super(key:key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}


class _HomeAdminState extends State<HomeAdmin> with TickerProviderStateMixin{
    List Bookings;
    bool isCheckedList = false;
    bool isCheckedWaiting = true;
    int lengthlist = 0;
    final String url = koneksi.connect('getJenisPaket.php');
    final String urlBook = koneksi.connect('selectbooking.php');
  bool buttonOn = true;
  List book = []; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY
  
  Future<String> getDataBook() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    var res = await http.get(Uri.encodeFull(urlBook), headers: { 'accept':'application/json' });
    if(mounted)
    {
      setState(() {
      
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      book = content['selectbooking'];
    });
    return 'success!';
    }
    
  }
    List jenis = [];
    Future<String> getData() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    
      var res = await http.get(Uri.encodeFull(url), headers: { 'accept':'application/json', "content-type": "application/json" });
      if(mounted)
      {
        
        setState(() {
        
        //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
        var content = json.decode(res.body);
        //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
        //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
        jenis = content['jenis'];
        
      });
      
      
      return 'success!';
      }
      
    }
  _loadSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        String cekUsername = prefs.getString('username') ?? "";
        var url = koneksi.connect('getProfile.php');
        http.post(url, body: {"username": cekUsername})
        .then((response) {
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.body}");
          var content = json.decode(response.body);
          userProfileAdmin = content['getProfile'];

        });
    });

  }
  @override
  void initState() {
    this.getData();
    Bookings = getBookings();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }
  _afterLayout(_) {
    this.getData();
    this.getDataBook();
    this._loadSessionUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Waiting list: '+jenis.length.toString(),),
                Tab(text: 'In Proggress: '+book.length.toString(),),
              ],
            ),
          title: Text('Home'),
        ),
        body:
          TabBarView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                
                Expanded(
                  child:ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: jenis.length,
                    itemBuilder: (BuildContext context, int index) {
                      
                      return Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: Slidable(
                          delegate: new SlidableDrawerDelegate(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[100]),
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              
                              title: Text(
                                jenis[index]['nama_jenis'],
                                style: TextStyle(color: Colors.black38 , fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              // subtitle: Row(
                              //   children: <Widget>[
                              //     Expanded(
                              //       flex: 4,
                              //       child: Padding(
                              //           padding: EdgeInsets.only(left: 10.0),
                              //           child: Text(listBook.level,
                              //               style: TextStyle(color: Colors.white))),
                              //     )
                              //   ],
                              // ),
                              trailing:
                                  Icon(Icons.keyboard_arrow_right, color: Colors.black38, size: 30.0),
                              onTap: () {
                              },
                            ),
                          ),
                          actions: <Widget>[
                            new IconSlideAction(
                              caption: 'Accept',
                              color: Colors.green,
                              icon: Icons.check,
                              onTap: () => Toast.show('AcceptLah', context),
                            ),
                          ],
                          secondaryActions: <Widget>[
                            
                            new IconSlideAction(
                              caption: 'Decline',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => Toast.show('DeclineLah', context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ], 
            ),
            new Column(
              children: <Widget>[
                Text('History'),
                Expanded(
                  child:ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: jenis.length,
                    itemBuilder: (BuildContext context, int index) {
                      
                      return Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: Slidable(
                          delegate: new SlidableDrawerDelegate(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[100]),
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              title: Text(
                                jenis[index]['nama_jenis'],
                                style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              // subtitle: Row(
                              //   children: <Widget>[
                              //     Expanded(
                              //       flex: 4,
                              //       child: Padding(
                              //           padding: EdgeInsets.only(left: 10.0),
                              //           child: Text(listBook.level,
                              //               style: TextStyle(color: Colors.white))),
                              //     )
                              //   ],
                              // ),
                              trailing:
                                  Icon(Icons.keyboard_arrow_right, color: Colors.black38, size: 30.0),
                              onTap: () {
                              },
                            ),
                          ),
                          actions: <Widget>[
                            new IconSlideAction(
                              caption: 'Accept',
                              color: Colors.green,
                              icon: Icons.check,
                              onTap: () => Toast.show('AcceptLah', context),
                            ),
                          ],
                          secondaryActions: <Widget>[
                            
                            new IconSlideAction(
                              caption: 'Decline',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => Toast.show('DeclineLah', context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ], 
            ),
          ],
        ),
        ),
        
      ),
    );
  }
}
List getBookings() {
  return [
    Booking(
        title: "Introduction to Driving",
        level: "Beginner",
        indicatorValue: 0.33,
        price: 20,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Booking(
        title: "Observation at Junctions",
        level: "Beginner",
        indicatorValue: 0.33,
        price: 50,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Booking(
        title: "Reverse parallel Parking",
        level: "Intermidiate",
        indicatorValue: 0.66,
        price: 30,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Booking(
        title: "Reversing around the corner",
        level: "Intermidiate",
        indicatorValue: 0.66,
        price: 30,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Booking(
        title: "Incorrect Use of Signal",
        level: "Advanced",
        indicatorValue: 1.0,
        price: 50,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Booking(
        title: "Engine Challenges",
        level: "Advanced",
        indicatorValue: 1.0,
        price: 50,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Booking(
        title: "Self Driving Car",
        level: "Advanced",
        indicatorValue: 1.0,
        price: 50,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.  ")
  ];
}
//disini untuk home



//pisah
class ReportAdmin extends StatefulWidget {
  // const PesananKonsumen({Key key, this.choice}) : super(key: key);
  // final Choice choice;
  @override
  _ReportAdminState createState() => _ReportAdminState();
}

class _ReportAdminState extends State<ReportAdmin> {
  final String urlfavtable = koneksi.connect('Favpaket.php');
  List favTable=[]; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> getDataTable() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    
    var res = await http.get(Uri.encodeFull(urlfavtable), headers: { 'accept':'application/json' });
    
    setState(() {
      
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      favTable = content['paketfav'];
    });
    return 'success!';
  }

  final String urlfavroom = koneksi.connect('FavRoomDecor.php');
  List favRoom=[]; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> getDataRoom() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    
    var res = await http.get(Uri.encodeFull(urlfavroom), headers: { 'accept':'application/json' });
    
    setState(() {
      
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      favRoom = content['favroom'];
    });
    return 'success!';
  }

  final String urlfavbackdrop = koneksi.connect('Favbackdrop.php');
  List favBackDrop=[]; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> getDataBackdrop() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    
    var res = await http.get(Uri.encodeFull(urlfavbackdrop), headers: { 'accept':'application/json' });
    
    setState(() {
      
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      favBackDrop = content['favbackdrop'];
    });
    return 'success!';
  }

  @override
  void initState() {
      super.initState();
      this.getDataRoom();
      this.getDataBackdrop();
      this.getDataTable();
     //PANGGIL FUNGSI YANG TELAH DIBUAT SEBELUMNYA
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Charicedecoratie',
      home: Scaffold(
        appBar: AppBar(
            
          title: Text('Order'),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
          child: Column(
          children: <Widget>[
            Text('Favorite in table decor:'),
            new Container(
              height: 150.0,
              child: favTable.isEmpty ? Container(child: Text('Kosong'),) : ListView.separated(
                separatorBuilder: (context,index){
                  return Divider(color: Colors.grey,);
                },
                itemCount: favTable.length, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
                itemBuilder: (BuildContext context, int index) { 
                  return Container(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Package Type:'),
                              Text('ini'),
                              RaisedButton(elevation: 0.0,
                              color: Colors.blueAccent,
                              child: Text('Add',),
                              onPressed: (){
                                  Toast.show('ini bisa ditekan dengan index: '+index.toString(), context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
            SizedBox(height: 50.0,),
            Text('Favorite in backdrop decor'),
            new Container(
              height: 150.0,
              child: favBackDrop.isEmpty ? Container(child: Text('Kosong'),) : ListView.separated(
                separatorBuilder: (context,index){
                  return Divider(color: Colors.grey,);
                },
                itemCount: favBackDrop.length, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
                itemBuilder: (BuildContext context, int index) { 
                  return Container(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Package Type:'),
                              Text('ini'),
                              RaisedButton(elevation: 0.0,
                              color: Colors.blueAccent,
                              child: Text('Add',),
                              onPressed: (){
                                  Toast.show('ini bisa ditekan dengan index: '+index.toString(), context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
            SizedBox(height: 50.0,),
            Text('Favorite in room decor:'),
            new Container(
              height: 150.0,
              child: favRoom.isEmpty ? Container(child: Text('Kosong'),) : ListView.separated(
                separatorBuilder: (context,index){
                  return Divider(color: Colors.grey,);
                },
                itemCount: favRoom.length, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
                itemBuilder: (BuildContext context, int index) { 
                  return Container(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Package Type:'),
                              Text('ini'),
                              RaisedButton(elevation: 0.0,
                              color: Colors.blueAccent,
                              child: Text('Add',),
                              onPressed: (){
                                  Toast.show('ini bisa ditekan dengan index: '+index.toString(), context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
            SizedBox(height: 50.0,),
            Text('Profit and loss in this month'),
            new Container(
              height: 150.0,
              child: ListView.separated(
                separatorBuilder: (context,index){
                  return Divider(color: Colors.grey,);
                },
                itemCount: 5, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
                itemBuilder: (BuildContext context, int index) { 
                  return Container(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Package Type:'),
                              Text('ini'),
                              RaisedButton(elevation: 0.0,
                              color: Colors.blueAccent,
                              child: Text('Add',),
                              onPressed: (){
                                  Toast.show('ini bisa ditekan dengan index: '+index.toString(), context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
            SizedBox(height: 50.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){},
                  child: Text('check the exit note'),
                ),
                RaisedButton(
                  onPressed: (){},
                  child: Text('Check inventory taking'),
                )
              ],
            ),
          ],
        ),
        );
      }),
      
      ),
    );
  }
}


class ProfileAdmin extends StatefulWidget {
  @override
  _ProfileAdminState createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {

  _deleteSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        prefs.remove('username');
        prefs.remove('password');
        prefs.remove('status');
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
                Text('Nama user: '+userProfileAdmin[0]['nama_user']),
                Text('No telepon: '+userProfileAdmin[0]['no_telp']),
                FlatButton.icon(
                  color: Colors.red,
                  icon: Icon(Icons.settings), //`Icon` to display
                  label: Text('Setting'), //`Text` to display
                  onPressed: () {
                    Toast.show('bisa kok', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                  },
                ),
                AddSupplier(),
                AddPurchase(),
                Text('Packet'),
                FlatButton.icon(
                  color: Colors.red,
                  icon: Icon(Icons.create), //`Icon` to display
                  label: Text('Create'), //`Text` to display
                  onPressed: () {
                    Toast.show('bisa kok', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                  },
                ),
                FlatButton.icon(
                  color: Colors.red,
                  icon: Icon(Icons.delete), //`Icon` to display
                  label: Text('Delete'), //`Text` to display
                  onPressed: () {
                    Toast.show('bisa kok', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                  },
                ),
                SizedBox(height: 50.0,),
                
                FlatButton.icon(
                  color: Colors.red,
                  icon: Icon(Icons.exit_to_app), //`Icon` to display
                  label: Text('Log out'), //`Text` to display
                  onPressed: () {
                    _deleteSessionUser();
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                    builder: (context) =>
                    new Login())
                    );
                  },
                ),
                Row(
                  children: [
                    FlatButton.icon(
                      color: Colors.red,
                      icon: Icon(Icons.create), //`Icon` to display
                      label: Text('Create'), //`Text` to display
                      onPressed: () {
                        _deleteSessionUser();
                        Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context) =>
                        new Login())
                        );
                      },
                    ),
                    FlatButton.icon(
                      color: Colors.red,
                      icon: Icon(Icons.delete), //`Icon` to display
                      label: Text('Delete'), //`Text` to display
                      onPressed: () {
                        _deleteSessionUser();
                        Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context) =>
                        new Login())
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
        }),
      ),
    );
  }

  Widget AddSupplier() {
    //MEMBUAT TOMBOL
    return RaisedButton(
      color: Colors.blueAccent, //MENGATUR WARNA TOMBOL
      onPressed: () {
        
      },
      child: Text('Add Supplier'), //TEXT YANG AKAN DITAMPILKAN PADA TOMBOL
    );
  }  
  Widget AddPurchase() {
    //MEMBUAT TOMBOL
    return RaisedButton(
      color: Colors.blueAccent, //MENGATUR WARNA TOMBOL
      onPressed: () {
        
      },
      child: Text('Add Purchase'), //TEXT YANG AKAN DITAMPILKAN PADA TOMBOL
    );
  }  
}