import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(WhiteSpace());
}

class WhiteSpace extends StatelessWidget {
  String nama = "";
  WhiteSpace({Key key, this.nama}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWhiteSpace(usernama: nama),
    );
  }
}

class MyWhiteSpace extends StatefulWidget {
  String usernama = "";
  MyWhiteSpace({Key key, this.usernama}) : super(key: key);

  @override
  _MyWhiteSpaceState createState() => _MyWhiteSpaceState();
}

class _MyWhiteSpaceState extends State<MyWhiteSpace> {
  TextEditingController thank = new TextEditingController();

  @override
  void initState() {
    super.initState();
    thank.text =
        "Terima kasih telah menyelesaikan pemesanan di charicedecoratie. Kami harap anda puas dan silahkan tulis testimoni anda. Terima kasih";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: WillPopScope(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 80,
              padding: EdgeInsets.all(20),
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white10,
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // dialog top
                  new Expanded(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          // padding: new EdgeInsets.all(10.0),
                          decoration: new BoxDecoration(
                            color: Colors.white,
                          ),
                          child: new Text(
                            'Thank you',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'helvetica_neue_light',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // dialog centre
                  new Expanded(
                    child: new Container(
                        child: new TextFormField(
                      maxLines: 3,
                      controller: thank,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: new EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                        hintStyle: new TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                      ),
                    )),
                    flex: 2,
                  ),

                  // dialog bottom
                  new Expanded(
                    child: new Container(
                        child: FlatButton(
                            onPressed: () async {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => Home(
                                      value: widget.usernama,
                                    ),
                                  ),
                                  (Route<dynamic> route) => false);
                              // Navigator.of(
                              //         context,
                              //         rootNavigator:
                              //             true)
                              //     .pushReplacement(MaterialPageRoute(
                              // builder: (context) => Home(
                              //       value: checkusername,
                              //     ),
                              //         fullscreenDialog: true));
                            },
                            child: Text("Ok"))),
                  ),
                ],
              ),
            ),
          ),
          onWillPop: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Home(
                    value: widget.usernama,
                  ),
                ),
                (Route<dynamic> route) => false);
          },
        ),
      ),
    );
  }
}
