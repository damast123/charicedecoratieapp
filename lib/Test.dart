// import 'package:flutter/material.dart';
// import 'package:grouped_list/grouped_list.dart';

// void main() => runApp(MyApp());

void main(List<String> args) {
  DateTime now = DateTime.now();
  int lastday = DateTime(now.year, now.month + 1, 0).day;
  int dayNow = now.day;
  int getWeek = lastday - dayNow;
  print("Ini last day: " + lastday.toString());
  if (getWeek < 7) {
    print("ini get Week: " + getWeek.toString());
  } else {
    print("Belum sampe");
  }
}

// List _elements = [
//   {'name': 'John', 'group': 'Team A'},
//   {'name': 'Will', 'group': 'Team B'},
//   {'name': 'Beth', 'group': 'Team A'},
//   {'name': 'Miranda', 'group': 'Team B'},
//   {'name': 'Mike', 'group': 'Team C'},
//   {'name': 'Danny', 'group': 'Team C'},
// ];

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Grouped List View Example'),
//         ),
//         body: GroupedListView<dynamic, String>(
//           groupBy: (element) => element['group'],
//           elements: _elements,
//           order: GroupedListOrder.DESC,
//           useStickyGroupSeparators: true,
//           groupSeparatorBuilder: (String value) => Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               value,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           itemBuilder: (c, element) {
//             return Card(
//               elevation: 8.0,
//               margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//               child: Container(
//                 child: ListTile(
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                   leading: Icon(Icons.account_circle),
//                   title: Text(element['name']),
//                   trailing: Icon(Icons.arrow_forward),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
