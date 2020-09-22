import 'dart:convert';

import 'package:charicedecoratieapp/Konsumen/home.dart';
import 'package:charicedecoratieapp/api/messaging.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

Map<DateTime, List> _holidays = {};
void main() {
  runApp(MyReschedule());
}

class MyReschedule extends StatelessWidget {
  String noBooking = "";
  String user = "";
  MyReschedule({Key key, this.noBooking, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Re Schedule: ' + noBooking;

    return MaterialApp(
      title: appTitle,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: Re_Scedule(
            noBooking: noBooking,
            user: user,
          ),
        ),
      ),
    );
  }
}

class Re_Scedule extends StatefulWidget {
  String noBooking = "";
  String user = "";
  Re_Scedule({Key key, this.noBooking, this.user}) : super(key: key);
  @override
  _Re_SceduleState createState() => _Re_SceduleState();
}

class _Re_SceduleState extends State<Re_Scedule> with TickerProviderStateMixin {
  Map<DateTime, List> _events = {};
  List _getTanggal = [];
  List _selectedEvents;
  List dataBook = [];
  List profileAdmin = [];
  var setReschedule = true;
  String startTime;
  String endTime;
  final startTimes = DateTime(2018, 6, 23, 07, 30);
  final endTimes = DateTime(2018, 6, 23, 22, 01);
  var setConfirm = true;
  var dateNow;
  final format = DateFormat("Hm");
  AnimationController _animationController;
  List dataLiburAdmin = [];
  CalendarController _calendarController;
  TextEditingController timeController = new TextEditingController();
  List dataGoogleCalendar;
  List dataEventCalendar;
  Future<String> fetchPost() async {
    final response = await http.get(
        'https://www.googleapis.com/calendar/v3/calendars/en.indonesian%23holiday%40group.v.calendar.google.com/events?key=AIzaSyDvlHs0BcZVHR_LeME6LLIL-g4HUCqfvrs');

    if (response.statusCode == 200) {
      setState(() {
        var content = json.decode(response.body);

        dataGoogleCalendar = content['items'];
        for (var i = 0; i < dataGoogleCalendar.length; i++) {
          var getdate = DateTime.parse(dataGoogleCalendar[i]['start']['date']);
          _holidays.addAll({
            DateTime.parse(dataGoogleCalendar[i]['start']['date']): [
              dataGoogleCalendar[i]['summary']
            ]
          });

          print('ini Get Data' + getdate.toString());
        }
        print('ini holidays' + _holidays.toString());
      });
      return 'sukses';
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<String> fetchDataAdmin() async {
    final response = await http.get(koneksi
        .connect('getAdminReschedule.php?no_booking=' + widget.noBooking));

    if (response.statusCode == 200) {
      setState(() {
        var content = json.decode(response.body);

        profileAdmin = content['data_admin'];
      });
      return 'sukses';
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<String> fetchLiburAdmin() async {
    final response = await http.get(koneksi.connect('getLiburDate.php'));

    if (response.statusCode == 200) {
      setState(() {
        var content = json.decode(response.body);

        dataLiburAdmin = content['getLibur'];
        for (var i = 0; i < dataLiburAdmin.length; i++) {
          _events.addAll({
            DateTime.parse(dataLiburAdmin[i]): ["Libur"]
          });
        }
      });
      return 'sukses';
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();

    Future<String> fetchDataBooking() async {
      final response = await http.get(
          koneksi.connect('searchBooking.php?no_booking=' + widget.noBooking));

      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.body);

          dataBook = content['searchbooking'];
        });
        return 'sukses';
      } else {
        throw Exception('Failed to load post');
      }
    }

    var isDone = 1;
    final _selectedDay = DateTime.now();
    dateNow = DateFormat('yyyy-MM-dd').format(_selectedDay);

    startTime = DateFormat("Hm").format(startTimes);
    endTime = DateFormat("Hm").format(endTimes);

    this.fetchPost();
    fetchDataBooking();
    this.fetchDataAdmin();
    this.fetchLiburAdmin();
    if (isDone == 1) {
      setReschedule = true;
      setConfirm = false;
      print("isdone 1");
    } else {
      setReschedule = false;
      setConfirm = true;
      print("isdone lain");
    }

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    dateNow = DateFormat('yyyy-MM-dd').format(day);
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          //tabel
          Text("Data Booking", style: TextStyle(fontSize: 20)),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Table(children: [
              TableRow(children: [
                Text(
                  "Nama pemesan: ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  dataBook[0]['nama_pemesan'],
                  style: TextStyle(fontSize: 20),
                )
              ]),
              TableRow(children: [
                Text(
                  "Tanggal acara: ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  dataBook[0]['tanggal_acara'],
                  style: TextStyle(fontSize: 20),
                )
              ]),
              TableRow(children: [
                Text(
                  "Tanggal bayar: ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  dataBook[0]['tanggal_bayar'],
                  style: TextStyle(fontSize: 20),
                )
              ]),
              TableRow(children: [
                Text(
                  "Grandtotal: ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  dataBook[0]['grandtotal'],
                  style: TextStyle(fontSize: 20),
                )
              ]),
              TableRow(children: [
                Text(
                  "Tipe pembayaran: ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  dataBook[0]['nama_pembayaran'],
                  style: TextStyle(fontSize: 20),
                )
              ]),
            ]),
          ),

          _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),

          Text("Jam acara:"),
          DateTimeField(
            controller: timeController,
            format: format,
            onShowPicker: (context, currentValue) async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(currentValue ?? startTimes),
              );
              DateTime today = DateTime(2019, 9, 7, time.hour, time.minute);
              String todays = DateFormat("Hm").format(today);
              DateTime getStart = DateFormat("hh:mm").parse(startTime);
              DateTime getEnd = DateFormat("hh:mm").parse(endTime);
              DateTime getToday = DateFormat("hh:mm").parse(todays);
              if (getToday.isAfter(getStart) && getToday.isBefore(getEnd)) {
                return DateTimeField.convert(time);
              } else {
                Fluttertoast.showToast(
                    msg: "Hanya menerima dari jam 7:30 sampai 22:00",
                    timeInSecForIosWeb: 10,
                    toastLength: Toast.LENGTH_LONG);
              }
            },
          ),
          RaisedButton(
              elevation: 0.0,
              color: Colors.blueAccent,
              child: Text(
                'Re Schedule',
              ),
              onPressed: setReschedule
                  ? () {
                      DateTime date1 = DateTime.parse(dateNow);
                      DateTime date2 = DateTime.parse(formattedDate);
                      final differences = date1.difference(date2).inDays;
                      if (differences <= 1) {
                        Fluttertoast.showToast(
                            msg: "Minimal 2 hari dari hari ini");
                      } else {
                        if (timeController.text.toString().isEmpty) {
                          Fluttertoast.showToast(msg: "Silahkan isi jam acara");
                        } else {
                          var url = koneksi.connect('CheckBarangReScedule.php');
                          http.post(url, body: {
                            "date": dateNow.toString(),
                            "time": timeController.text.toString(),
                            "noBooking": widget.noBooking,
                          }).then((response) async {
                            print("Response status: ${response.statusCode}");
                            print("Response body: ${response.body}");
                            if (response.body != "sukses") {
                              Fluttertoast.showToast(msg: response.body);
                            } else {
                              Fluttertoast.showToast(msg: "Sukses");
                              sendNotificationReschedule(dateNow.toString());
                              Navigator.of(context, rootNavigator: true)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => new Home(
                                            value: widget.user.toString(),
                                          )));
                            }
                          });
                        }
                      }
                    }
                  : null),
        ],
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_US',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.red[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.red[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.red[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.red[300]
            : _calendarController.isToday(date)
                ? Colors.red[500]
                : Colors.red[500],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '#',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8),
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                title: Text(event.toString()),
                onTap: () => print(_selectedEvents.toString() +
                    ' disebelah adalah isi _event $event tapped!'),
              )))
          .toList(),
    );
  }

  Future sendNotificationReschedule(String dates1) async {
    final response = await Messaging.sendTo(
      title: "Booking: " + widget.noBooking,
      body: "Booking ini telah diganti jadwal acaranya menjadi " +
          dates1 +
          ". Silahkan diliat booking tersebut.",
      fcmToken: profileAdmin[0]['token'],
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }
}
