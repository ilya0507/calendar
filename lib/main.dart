import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Календарь',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void getData() async {
    http.Response response = await http.get(
        'https://raw.githubusercontent.com/d10xa/holidays-calendar/master/json/calendar.json');

    if (response.statusCode == 200) {
      String data = response.body;
      for (var i = 0; i < data.length - 70; i++) {
        String holidays = jsonDecode(data)['holidays'][i];
        //Разбираю каждый String формата 2011-01-01 на 3 int, чтобы вставить в DateTime
        List<String> mylist = holidays.split('-');
        int holidaysInt0 = int.parse(mylist[0]);
        int holidaysInt1 = int.parse(mylist[1]);
        int holidaysInt2 = int.parse(mylist[2]);

        //Замена тире "-" на запятую ",". Пока не применимо.
        //String holidaisWithComa = holidays.replaceAll(new RegExp('-'), ',');

        //Проверяю в консоли, что int действительно получились
        print(holidaysInt0);
        print(holidaysInt1);
        print(holidaysInt2);

        //Пытаюсь добавить в Map<DateTime, List>, но ничего не получается.
        //_events[DateTime.parse(holidaisWithComa)] = ['holy$i'];
        //_events[DateTime.parse(holidaysInt0, holidaysInt1, holidaysInt2)] = ['holy$i'];
      }
    } else {
      print(response.statusCode);
    }
  }

  CalendarController _calendarController;

  //Примеры событий, чтобы проверить, что даты отмечены точкой
  final Map<DateTime, List> _events = {
    DateTime(2020, 1, 1): ['New Year\'s Day'],
    DateTime(2020, 1, 6): ['Epiphany'],
    DateTime(2020, 2, 14): ['Valentine\'s Day'],
    DateTime(2020, 4, 21): ['Easter Sunday'],
    DateTime(2020, 4, 22): ['Easter Monday'],
  };

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ООО "Третий парк"'),
      ), //return TableCalendar(
      body: SingleChildScrollView(
          //scrollDirection: Axis.vertical,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            //initialSelectedDay: DateTime.parse('2020-01-01'), //Выделяет цветом, а не точкой
            events: _events,
            calendarController: _calendarController,
            startingDayOfWeek:
                StartingDayOfWeek.monday, //Начало недели с понедельника
            locale: 'ru_RU', //Русский язык
            //startDay: DateTime.now(),
          ),
        ],
      )),
    );
  }
}
