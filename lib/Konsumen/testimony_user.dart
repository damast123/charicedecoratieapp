import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(TestimoniUser());
}

class TestimoniUser extends StatefulWidget {
  TestimoniUser({Key key}) : super(key: key);

  @override
  _TestimoniUserState createState() => _TestimoniUserState();
}

class _TestimoniUserState extends State<TestimoniUser> {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Testimoni User';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(

        appBar: AppBar(
          title: Text(appTitle),
        ),

        body:LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Package Name:'),
                Image.asset('assets/images/pic2.jpg'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Grand total'),
                    Text('Rp.x.xxx.xxx')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Date'),
                    Text('xxxx-xx-xx')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Rating'),
                    AbsorbPointer(
                      absorbing: true,
                      child: RatingBar(
                        initialRating: 0.0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ),
                    
                  ],
                ),
                new TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                RaisedButton(
                  onPressed: (){},
                  child: Text('Submit'),
                ), 
              ],
            ),
          );
        }),
      ),
    );
  }
}