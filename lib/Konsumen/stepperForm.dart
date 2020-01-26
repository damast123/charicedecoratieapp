import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:after_layout/after_layout.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:validate/validate.dart';  //for validation

Map<DateTime, List> _holidays={};
void main() {
  runApp(new StepForm());
}

class StepForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppScreenMode();
  }
}

class MyData {
  String name = '';
  String phone = '';
  String email = '';
  String age = '';
}

class MyAppScreenMode extends State<StepForm> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Booking'),
          ),
          body: new StepperBody(),
        ));
  }
}

class StepperBody extends StatefulWidget {
  @override
  _StepperBodyState createState() => new _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> with TickerProviderStateMixin,AfterLayoutMixin<StepperBody> {
  int currStep = 0;
  static var _focusNode = new FocusNode();
  bool complete = false;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static MyData data = new MyData();

  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  List dataGoogleCalendar; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> fetchPost() async {
    final response =
        await http.get('https://www.googleapis.com/calendar/v3/calendars/en.usa%23holiday%40group.v.calendar.google.com/events?key=AIzaSyDvlHs0BcZVHR_LeME6LLIL-g4HUCqfvrs');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      setState(() {
        //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
        var content = json.decode(response.body);
        
        //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
        //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
        dataGoogleCalendar = content['items'];
        for (var i = 0; i < dataGoogleCalendar.length; i++) {
          var getdate = DateTime.parse(dataGoogleCalendar[i]['start']['date']);
          _holidays.addAll({DateTime.parse(dataGoogleCalendar[i]['start']['date']): [dataGoogleCalendar[i]['summary']]}); 
            
          print('ini Get Data'+getdate.toString());
        }
        print('ini holidays'+_holidays.toString());
      });
      return 'sukses';
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    this.fetchPost();
    
    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  StepState _getState(int i) {
    if (currStep >= i)
      return StepState.complete;
    else
      return StepState.indexed;
  }

  List<Step> spr = <Step>[];
  List<Step> _getSteps(BuildContext context) {
    spr = <Step>[
      new Step(
        title: const Text('Choose date'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: _getState(1),
        content: _buildTableCalendarWithBuilders()),
    new Step(
        title: const Text('Choose time'),
        //subtitle: const Text('Subtitle'),
        isActive: true,
        //state: StepState.editing,
        state: _getState(2),
        content: new TextFormField(
          keyboardType: TextInputType.phone,
          autocorrect: false,
          onSaved: (String value) {
            data.phone = value;
          },
          maxLines: 1,
          decoration: new InputDecoration(
              labelText: 'Enter your number',
              hintText: 'Enter a number',
              icon: const Icon(Icons.phone),
              labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    new Step(
        title: const Text('Data'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: _getState(3),
        // state: StepState.disabled,
        content: new Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              
              onSaved: (String value) {
                data.email = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Enter your email',
                  hintText: 'Enter a email address',
                  icon: const Icon(Icons.email),
                  labelStyle:
                      new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              
              onSaved: (String value) {
                data.email = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Enter your email',
                  hintText: 'Enter a email address',
                  icon: const Icon(Icons.email),
                  labelStyle:
                      new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              
              onSaved: (String value) {
                data.email = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Enter your email',
                  hintText: 'Enter a email address',
                  icon: const Icon(Icons.email),
                  labelStyle:
                      new TextStyle(decorationStyle: TextDecorationStyle.solid)),
            ),
          ],
        )),
    new Step(
        title: const Text('Payment'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: _getState(4),
        content: new TextFormField(
          keyboardType: TextInputType.number,
          autocorrect: false,
          
          maxLines: 1,
          onSaved: (String value) {
            data.age = value;
          },
          decoration: new InputDecoration(
              labelText: 'Enter your age',
              hintText: 'Enter age',
              icon: const Icon(Icons.explicit),
              labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    // new Step(
    //     title: const Text('Fifth Step'),
    //     subtitle: const Text('Subtitle'),
    //     isActive: true,
    //     state: StepState.complete,
    //     content: const Text('Enjoy Step Fifth'))
    ];
    return spr;
  }

  next() {
      currStep + 1 != spr.length
          ? goTo(currStep + 1)
          : setState(() => complete = true);
    }

    cancel() {
      if (currStep > 0) {
        goTo(currStep - 1);
      }
    }

    goTo(int step) {
      setState(() => currStep = step);
    }
  
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(top: 10),
      child:Column(
      children: <Widget>[
        complete ? Expanded(
          child: Center(
            child: AlertDialog(
              title: new Text("Profile Created"),
              content: new Text("Tada!",),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Close"),
                    onPressed: () {
                      setState(() => complete = false);
                    },
                ),
              ],
            ),
          ),
        ):
        Expanded(
          child: Stepper(
            steps: _getSteps(context),
            currentStep: currStep,
            onStepContinue: next,
            onStepCancel: cancel,
          ),
        ),
      ]),
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
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
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

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    showHelloWorld();
  }
  void showHelloWorld() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
            content: new Text('Hello World'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Make sure that you have request at the desired restaurant'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
    );
  }

}
