import 'dart:convert';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:charicedecoratieapp/koneksi.dart';
import 'package:charicedecoratieapp/welcomescreen.dart';
import 'package:charicedecoratieapp/widgets/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

void main() {
  runApp(Add_Holliday());
}

Map<DateTime, List> _holidays = {};

class Add_Holliday extends StatefulWidget {
  String getVal = "";
  Add_Holliday({Key key, this.getVal}) : super(key: key);
  @override
  _Add_HollidayState createState() => _Add_HollidayState();
}

class _Add_HollidayState extends State<Add_Holliday>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  Map<DateTime, List> _events = {};
  List _selectedEvents = [];
  final format = DateFormat("yyyy-MM-dd");
  AnimationController _animationController;
  CalendarController _calendarController;
  List dataGoogleCalendar = [];
  List dataEventCalendar = [];
  TextEditingController startController = new TextEditingController();
  TextEditingController endController = new TextEditingController();
  List dataLiburAdmin = [];
  Future<String> fetchPost() async {
    try {
      final response = await http.get(
          'https://www.googleapis.com/calendar/v3/calendars/en.indonesian%23holiday%40group.v.calendar.google.com/events?key=AIzaSyDvlHs0BcZVHR_LeME6LLIL-g4HUCqfvrs');

      setState(() {
        var content = json.decode(response.body);

        dataGoogleCalendar = content['items'];
      });

      for (var i = 0; i < dataGoogleCalendar.length; i++) {
        _holidays.addAll({
          DateTime.parse(dataGoogleCalendar[i]['start']['date']): [
            dataGoogleCalendar[i]['summary']
          ]
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> fetchEventCalendar() async {
    try {
      Response response = await dio.get(koneksi.connect('selectbooking.php'));
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        dataEventCalendar = content['selectbooking'];
      });

      for (var i = 0; i < dataEventCalendar.length; i++) {
        _events.addAll({
          DateTime.parse(dataEventCalendar[i]['tanggal_acara']): [
            dataEventCalendar[i]['nama_tanggal']
          ]
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> fetchLiburAdmin() async {
    try {
      Response response = await dio.get(koneksi.connect('getLiburDate.php'));
      print("Ini isi response: " + response.toString());
      setState(() {
        var content = json.decode(response.data);

        dataLiburAdmin = content['getLibur'];
      });

      for (var i = 0; i < dataLiburAdmin.length; i++) {
        _events.addAll({
          DateTime.parse(dataLiburAdmin[i]): ["Libur"]
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    this.fetchPost();
    this.fetchEventCalendar();
    this.fetchLiburAdmin();

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
    AutoOrientation.portraitUpMode();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    print('Ini day lho: ' + day.toString());
    print('Ini event: ' + events.toString());

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
    AutoOrientation.portraitUpMode();
    return MaterialApp(
      title: 'addHoliday',
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('addHoliday'),
          ),
          body: Container(
            margin: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/background_image.jpg'),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 270),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(23),
                      child: ListView(
                        children: <Widget>[
                          _buildTableCalendarWithBuilders(),
                          Text('Start date'),
                          DateTimeField(
                            controller: startController,
                            format: format,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2020),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                          ),
                          Text('End Date'),
                          DateTimeField(
                            controller: endController,
                            format: format,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2020),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RaisedButton(
                            color: Colors.blue,
                            onPressed: () {
                              Alert(
                                context: context,
                                type: AlertType.info,
                                title: "Add Holliday",
                                desc:
                                    "Are you sure want to change this to holliday on start" +
                                        startController.text.toString() +
                                        " to: " +
                                        endController.text.toString(),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      var url =
                                          koneksi.connect('addHolliday.php');
                                      Response res = await dio.post(url,
                                          data: FormData.fromMap({
                                            "startDate":
                                                startController.text.toString(),
                                            "endDate":
                                                endController.text.toString(),
                                            "username": widget.getVal,
                                          }));
                                      Fluttertoast.showToast(msg: res.data);
                                    },
                                  ),
                                  DialogButton(
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ).show();
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(color: white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          events.length.toString(),
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
}
