import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'dart:async';
import 'dart:convert';
import 'package:charicedecoratieapp/main.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(home_freelance());
String v = "";
String s = "";
List userProfileFreelance = [];
class home_freelance extends StatefulWidget {
  // final String value;
  // final String apa;
  // Home({Key key, this.value,this.apa}) : super(key:key);
  @override
  _home_freelanceState createState() => _home_freelanceState();
}

class _home_freelanceState extends State<home_freelance> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeFreelance(),
    ProfileFreelance()
  ];

  @override
  Widget build(BuildContext context) {
    v = "yosha";
    s = "siap";
    return Scaffold(

      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),

          ),
          
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
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

class HomeFreelance extends StatefulWidget {

//  Home({Key key, this.value}) : super(key:key);
  @override
  _HomeFreelanceState createState() => _HomeFreelanceState();
}

class _HomeFreelanceState extends State<HomeFreelance> with TickerProviderStateMixin {

  TextEditingController editingController = TextEditingController();
  
  Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }
  List Bookings;
    bool isCheckedList = false;
    bool isCheckedWaiting = true;
    int lengthlist = 0;
    final String url = koneksi.connect('getJenisPaket.php');
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
          userProfileFreelance = content['getProfile'];

        });
    });

  }

  @override
  void initState() {
    this.getData();
    
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }
  _afterLayout(_) {
    this.getData();
    this._loadSessionUser();
  }


  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
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
                Tab(text: 'In Proggress: '+jenis.length.toString(),),
              ],
            ),
          title: Text('Home'),
        ),
        body: TabBarView(
          children: <Widget>[
          new Column(
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[

            //     GestureDetector(
            //       onTap: (){
            //         setState(() {
            //           isCheckedList = false;
            //           isCheckedWaiting = true;
            //           print("isCheckedList");
            //           print(isCheckedList);
            //           print("isCheckedWaiting");
            //           print(isCheckedWaiting);
            //         });
                    
            //       },
            //       child: Text('Waiting List:',style: isCheckedWaiting ? TextStyle(fontSize: 20,color: Colors.blue) : TextStyle(fontSize: 20,color: Colors.black),),
            //     ),
            //     GestureDetector(
            //       onTap: (){
            //         setState(() {
            //           isCheckedList = true;
            //           isCheckedWaiting = false;
            //           print("isCheckedList");
            //           print(isCheckedList);
            //           print("isCheckedWaiting");
            //           print(isCheckedWaiting);
            //         });
                    
            //       },
            //       child: Text('In Progress:'+jenis.length.toString(),style: isCheckedList ? TextStyle(fontSize: 20,color: Colors.blue) : TextStyle(fontSize: 20,color: Colors.black),),
                  
            //     ),
                
            //   ],
            // ),
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
                            caption: 'More',
                            color: Colors.black45,
                            icon: Icons.more_horiz,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text('More'),
                                    content: setupAlertDialoadContainer(),
                                );
                                }
                              );
                            },
                          ),
                          
                        ],
                        secondaryActions: <Widget>[
                          new IconSlideAction(
                            caption: 'Accept',
                            color: Colors.green,
                            icon: Icons.check,
                            onTap: () => Toast.show('AcceptLah', context),
                          ),
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
            ]),
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
                              caption: 'More',
                              color: Colors.black45,
                              icon: Icons.more_horiz,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text('More'),
                                      content: setupAlertDialoadContainer(),
                                  );
                                  }
                                );
                              },
                            ),
                            
                          ],
                          secondaryActions: <Widget>[
                            new IconSlideAction(
                              caption: 'Accept',
                              color: Colors.green,
                              icon: Icons.check,
                              onTap: () => Toast.show('AcceptLah', context),
                            ),
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
  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: GestureDetector(
        child: ListView.builder(
        shrinkWrap: true,
        itemCount: 60,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 64,
                maxHeight: 64,
              ),
              child: Image.asset('assets/images/pic0.jpg', fit: BoxFit.cover),
            ),
            title: Text('Gujarat, India'),
            onTap: (){
              Toast.show('ini bisa coba aja'+index.toString(), context);
            },
          );
        },
      ),
      )
    );
  }
}


List<UserDetails> _searchResult = [];

List<UserDetails> _userDetails = [];

final String url = 'https://jsonplaceholder.typicode.com/users';
class UserDetails {
  final int id;
  final String firstName, lastName, profileUrl;

  UserDetails({this.id, this.firstName, this.lastName, this.profileUrl = 'https://i.amz.mshcdn.com/3NbrfEiECotKyhcUhgPJHbrL7zM=/950x534/filters:quality(90)/2014%2F06%2F02%2Fc0%2Fzuckheadsho.a33d0.jpg'});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      id: json['id'],
      firstName: json['name'],
      lastName: json['username'],
    );
  }
}


class ProfileFreelance extends StatefulWidget {
  @override
  _ProfileFreelanceState createState() => _ProfileFreelanceState();
}

class _ProfileFreelanceState extends State<ProfileFreelance> {

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
        body: Container
        (
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Text('Nama user: '+userProfileFreelance[0]['nama_user']),
              SizedBox(height: 50.0,),
                Text('No telepon: '+userProfileFreelance[0]['no_telp']),
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
            ],
          ),
        ),
      ),
    );
  }
}


