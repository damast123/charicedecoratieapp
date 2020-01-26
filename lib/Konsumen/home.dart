import 'dart:convert';

import 'package:charicedecoratieapp/Konsumen/ReSchedule.dart';
import 'package:charicedecoratieapp/Konsumen/input_booking.dart';
import 'package:charicedecoratieapp/screens/FilterScreen.dart';
import 'package:charicedecoratieapp/widgets/featured_card.dart';
import 'package:charicedecoratieapp/widgets/featured_card_mostwanted.dart';
import 'package:charicedecoratieapp/widgets/featured_card_testimony.dart';
import 'package:charicedecoratieapp/widgets/hotelAppTheme.dart';
import 'package:flutter/material.dart';

import 'package:charicedecoratieapp/delayed_animation.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:charicedecoratieapp/main.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
void main() => runApp(Home());

List userProfile = [];
String v = "";
String s = "";
class Home extends StatefulWidget {
  final String value;
  final String apa;
  Home({Key key, this.value,this.apa}) : super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();

  }
}


class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 0;
   bool isBottomBarVisible = true;

  final List<Widget> _children = [
    MyHomeKonsumen(),
    PesananKonsumen(),
    ProfileKonsumen()
  ];


  @override
  Widget build(BuildContext context) {
    v = "${widget.value}";
    s = "${widget.apa}";
    return Scaffold(

      body: _children[_currentIndex], // new
      bottomNavigationBar: TitledBottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          TitledNavigationBarItem(title: 'Home', icon: Icons.home),
          TitledNavigationBarItem(title: 'Orders', icon: Icons.shopping_cart),
          TitledNavigationBarItem(title: 'Profile', icon: Icons.person_outline),
        ],

      ),

    );

  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}


class MyHomeKonsumen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Home';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(appTitle),
        ),

        body:HomeKonsumen() ,

      ),
    );
  }


}

class HomeKonsumen extends StatefulWidget {
//  Home({Key key, this.value}) : super(key:key);

  @override
  _HomeKonsumenState createState() => _HomeKonsumenState();
}

class _HomeKonsumenState extends State<HomeKonsumen> with TickerProviderStateMixin{
  AnimationController _controller;
  final String urlHargaMax = koneksi.connect('getHargaMaxMinPaket.php');
  List rangeharga = []; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY
  
  String get_harga_murah = "";
  String get_harga_mahal = "";

  Future<String> getRange() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    
    var res = await http.get(Uri.encodeFull(urlHargaMax), headers: { 'accept':'application/json' });
    if(mounted)
    {
      setState(() {
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      rangeharga = content['paket'];
    });
    get_harga_murah = rangeharga[1]['harga_termurah']; 
    get_harga_mahal = rangeharga[1]['harga_termahal'];
    
    return 'success!';
    }
    
  }
  
  final String url = koneksi.connect('getJenisPaket.php');
  List jenis = []; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> getData() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    
    var res = await http.get(Uri.encodeFull(url), headers: { 'accept':'application/json' });
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

  final String urlgetmostwanted = koneksi.connect('mostwanted.php');
  List mostwanted = []; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> getmostwanted() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    
    var res = await http.get(Uri.encodeFull(urlgetmostwanted), headers: { 'accept':'application/json' });
    if(mounted)
    {
      setState(() {
      
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      mostwanted = content['mostwanted'];
    });
    
    
    return 'success!';
    }
    
    
  }

  final String urlgettestimoni = koneksi.connect('testimonihome.php');
  List testimoni = []; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> gettestimoni() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    
    var res = await http.get(Uri.encodeFull(urlgettestimoni), headers: { 'accept':'application/json' });
    if(mounted)
    {
      setState(() {
      
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      testimoni = content['testimoni'];
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
          userProfile = content['getProfile'];

        });
    });

  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
    
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  
  _afterLayout(_) {
    this.getData();
    this.getRange();
    this.getmostwanted();
    this.gettestimoni();
    this._loadSessionUser();
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child:DelayedAimation(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                getFilterBarUI(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Most wanted package',style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      ),),
                    GestureDetector(
                      onTap: (){
                        Toast.show('View more Detail', context);
                      },
                      child: Text('View more detail',style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue
                      ),),
                    )
                  ],
                ),
                
                Container(
                  height: 230,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: jenis == null ? 0:jenis.length,
                      itemBuilder: (_, index) {
                        return FeaturedCardMostWanted(
                          name: mostwanted[index]['nama_paket'],
                          id: mostwanted[index]['idpaket'],
                          picture: '',
                        );
                  })),
                
                
                
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text('Jenis paket',style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  ),),
                ),
                Container(
                  height: 230,
                  child: jenis.isEmpty ? Container(padding: EdgeInsets.only(left: 30.0), child: Text("Tidak ada jenis",style: TextStyle(fontSize: 20,),),) :ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: jenis.length,
                      itemBuilder: (_, index) {
                        return FeaturedCard(
                          name: jenis[index]['nama_jenis'],
                          id: jenis[index]['idjenis'],
                          picture: '',
                        );
                        
                  })
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text('Testimoni paket',style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  ),),
                ),
                Container(
                  height: 230,
                  child: testimoni.isEmpty ? Container(padding: EdgeInsets.only(left: 30.0), child: Text("Tidak ada testimony",style: TextStyle(fontSize: 20,),),) : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: testimoni.length,
                      itemBuilder: (_, index) {
                        return FeaturedCardTestimoni(
                          name: testimoni[index]['nama_jenis'],
                          id: testimoni[index]['idjenis'],
                          picture: '',
                          rating: testimoni[index]['rating'],
                          no_booking: testimoni[index]['no_booking'],
                        );
                        
                  })
                ),
              ],
            ),
          delay: 100,
        ),
      );
    });
  }


    Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.grey.withOpacity(0.2), offset: Offset(0, -2), blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HotelAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Filter it...",
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => FiltersScreen(num1: get_harga_murah,num2: get_harga_mahal,), fullscreenDialog: true));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Filtter",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }


}


// Pesanan konsumen
class PesananKonsumen extends StatefulWidget {
  // const PesananKonsumen({Key key, this.choice}) : super(key: key);
  // final Choice choice;
  @override
  _PesananKonsumenState createState() => _PesananKonsumenState();
}

class _PesananKonsumenState extends State<PesananKonsumen> with TickerProviderStateMixin {
  AnimationController _controller;
  final String url = koneksi.connect('selectbooking.php');
  bool buttonOn = true;
  List book = []; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY
  
  Future<String> getDataBook() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    var res = await http.get(Uri.encodeFull(url), headers: { 'accept':'application/json' });
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

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
      super.initState();
      this.getDataBook(); //PANGGIL FUNGSI YANG TELAH DIBUAT SEBELUMNYA
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Welcome to Charicedecoratie',
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.shopping_cart)),
                Tab(icon: Icon(Icons.history)),
              ],
            ),
          title: Text('Order'),
        ),
        body: DelayedAimation(child: 
          TabBarView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                Text('Isi cart'),
                SizedBox(height: 20.0,),
                Container(
                  height: 270.0,
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
                                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => MyReschedule(), fullscreenDialog: true));
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
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Status:'),
                    Text('Sukses'),
                  ],
                ),
                SizedBox(height: 50.0,),
                RaisedButton(elevation: 0.0,
                  color: Colors.blue,
                  child: Text('Confirm',style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => new MyInputBooking()));
                  },
                ),
                
              ], 
            ),
            new Column(
              children: <Widget>[
                Text('History'),
                SizedBox(height: 20.0,),
                Container(
                  height: 270.0,
                  child: book.isEmpty ? Container(padding: EdgeInsets.all(100.0),child: Text('Empty',style: TextStyle(fontSize: 20),)) : ListView.separated(
                    separatorBuilder: (context,index){
                      return Divider(color: Colors.grey,);
                    },
                    itemCount: book.length, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
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
                book.isEmpty ? Visibility(
                  child:RaisedButton(elevation: 0.0,
                    color: Colors.blue,
                    child: Text('Confirm',style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      Toast.show('ini bisa ditekan dengan index: ', context);
                    },
                  ),
                  visible: false,
                ):Visibility(
                  child:RaisedButton(elevation: 0.0,
                    color: Colors.blue,
                    child: Text('Confirm',style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      
                    },
                  ),
                  visible: buttonOn,
                ),
                
              ], 
            ),
          ],
        ),
          delay: 100,
        ),
        
      ),
        
        
      ),
    );
  }
}


class ProfileKonsumen extends StatefulWidget {
  @override
  _ProfileKonsumenState createState() => _ProfileKonsumenState();
}

class _ProfileKonsumenState extends State<ProfileKonsumen> with TickerProviderStateMixin{
  AnimationController _controller;
  
  _deleteSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        prefs.remove('username');
        prefs.remove('password');
        prefs.remove('status');
    });
  }
  
  

  @override
  void initState() {
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
      super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Charicedecoratie',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: DelayedAimation
        (
          child:Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text('Nama User'),
                  Text(userProfile[0]['nama_user'].toString()),
                ],),
                
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text('No telepon'),
                  Text(userProfile[0]['no_telp'].toString()),
                ],),
                
                SizedBox(height: 30.0,),
                FlatButton.icon(
                  color: Colors.blue,
                  icon: Icon(Icons.settings,color: Colors.white,), //`Icon` to display
                  label: Text('Setting',style: TextStyle(color: Colors.white),), //`Text` to display
                  onPressed: () {
                    Toast.show('bisa kok', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                  },
                ),
                SizedBox(height: 40.0,),
                Row(
                  children: <Widget>[
                    Text('About')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton.icon(
                      color: Colors.blue,
                      icon: Icon(Icons.info_outline,color: Colors.white,), //`Icon` to display
                      label: Text('Info',style: TextStyle(color: Colors.white),), //`Text` to display
                      onPressed: () {
                        
                      },
                    ),
                    FlatButton.icon(
                      color: Colors.blue,
                      icon: Icon(Icons.android,color: Colors.white,), //`Icon` to display
                      label: Text('About',style: TextStyle(color: Colors.white),), //`Text` to display
                      onPressed: () {
                        
                      },
                    ),
                  ],
                ),
                
                SizedBox(height: 50.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    
                    FlatButton.icon(
                      color: Colors.blue,
                      icon: Icon(Icons.exit_to_app,color: Colors.white,), //`Icon` to display
                      label: Text('Log out',style: TextStyle(color: Colors.white),), //`Text` to display
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
        delay: 100,
        ),
      ),
    );
  }

}
