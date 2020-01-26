import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MyDetailPesanPaketKonsumen());
}

class MyDetailPesanPaketKonsumen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Pesan Paket';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(

        appBar: AppBar(
          title: Text(appTitle),
        ),

        body:Detail_Pesan_Paket() ,

      ),
    );
  }


}

class Detail_Pesan_Paket extends StatefulWidget {
  @override
  _Detail_Pesan_PaketState createState() => _Detail_Pesan_PaketState();
}

class _Detail_Pesan_PaketState extends State<Detail_Pesan_Paket> with SingleTickerProviderStateMixin{
  bool isChecked = false;
  @override
  void initState() {
        super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Package Name:'),
                Text('ini'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Package Type:'),
                Text('ini'),
              ],
            ),
            Row(        
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,top: 0.0),
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (bool value) {
                      setState(() {
                        isChecked = value;
                        if(isChecked==true)
                        {
                          Toast.show('ini true', context);
                          // listViewAdditional();
                        }
                        else
                        {
                          Toast.show('ini false', context);
                          
                        }
                      });
                    },
                  ),
                ) ,       
                Text("Add additional"),
              ],
            ),
            new Container(
              height: 44.0,
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: null,
                    child: new Text("Facebook"),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.00)),
                  new RaisedButton(
                    onPressed: null,
                    child: new Text("Google"),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Package Type:'),
                Text('ini'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Package Type:'),
                Text('ini'),
              ],
            ),
            GestureDetector(
              onTap: (){},
              child: Text('Tidak ada warna?'),
            ),
            grandtotalField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Package Type:'),
                Text('ini'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget listViewAdditional(){
    return Container(
      margin: EdgeInsets.all(10.0), //SET MARGIN DARI CONTAINER
      child: ListView.separated(
        separatorBuilder: (context,index){
          return Divider(
            color: Colors.grey,
            );
          },
        itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('ini'),
            );
        },
        itemCount: 3,
      ),
    );
  }

  Widget grandtotalField() {

    return TextFormField(

      // controller: tanggalController,
      decoration: InputDecoration(
          labelText: 'Grand total' //DENGAN LABEL Nama Lengkap
      ),
      enabled: false,

    );
  }
}