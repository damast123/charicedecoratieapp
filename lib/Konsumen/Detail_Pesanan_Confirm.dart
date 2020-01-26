import 'package:flutter/material.dart';


void main() {
  runApp(MyDetailPesananConfirm());
}

class MyDetailPesananConfirm extends StatelessWidget {
  const MyDetailPesananConfirm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Detail Confirmation';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(appTitle),
        ),

        body:DetailPesananConfirm() ,

      ),
    );
  }
}

class DetailPesananConfirm extends StatefulWidget {
  @override
  _DetailPesananConfirmState createState() => _DetailPesananConfirmState();
}

class _DetailPesananConfirmState extends State<DetailPesananConfirm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Text('Bkxxxxxx'),
          ),
          new TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'BCA',
              hintText: 'Silahkan transfer melalui rekening dibawah ini dan upload bukti transaksi:\n BCA\n081741326642',
            ),
          ),
          new TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'OVO',
              hintText: 'Silahkan transfer melalui rekening dibawah ini dan upload bukti transaksi:\n BCA\n081741326642',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Tanggal'),
              Text('Tanggal Sekarang')
            ],
          ),
          Text('Upload image'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: (){},
                child: Text('Upload'),
              ),
              RaisedButton(
                onPressed: (){},
                child: Text('Confirm'),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}