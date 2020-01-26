import 'package:flutter/material.dart';

void main() {
  runApp(HistoryKonsumen());
}


class HistoryKonsumen extends StatefulWidget {
  HistoryKonsumen({Key key}) : super(key: key);

  @override
  _HistoryKonsumenState createState() => _HistoryKonsumenState();
}

class _HistoryKonsumenState extends State<HistoryKonsumen> {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'History Konsumen';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(

        appBar: AppBar(
          title: Text(appTitle),
        ),

        body:Container(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text('Kode Booking: BKxxxxx'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Package Name:'),
                  Text('Deluxe'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Name that order:'),
                  Text('Dan'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Payment date:'),
                  Text('xxxx-xx-xx'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Grand total:'),
                  Text('Rp.x.xxx.xxx'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Type of payment:'),
                  Text('Transfer'),
                ],
              ),
              AbsorbPointer(
                  absorbing: false,
                  child: RaisedButton(
                    onPressed: (){},
                    child: Text('Re-schedule'),
                    
                  ),
              ),
              AbsorbPointer(
                  absorbing: true,
                  child: RaisedButton(
                    onPressed: (){},
                    child: Text('Done'),
                    
                  ),
              ),
              
            ],
          ),
        ),

      ),
    );
    
  }
}