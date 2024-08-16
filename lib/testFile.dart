import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Custom Calendar')),
        body: MyCalendar(),
      ),
    );
  }
}

class MyCalendar extends StatefulWidget {
  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  final Map<DateTime, List<dynamic>> _events = {
    DateTime(2024, 7, 31): ['Data1'],
    DateTime(2024, 8, 1): ['Data2'],
    // 날짜에 따른 데이터 추가
  };

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarBuilders: CalendarBuilders(
        // 날짜에 대한 커스텀 빌더
        markerBuilder: (context, date, events) {
          if (_getEventsForDay(date).isNotEmpty) {
            // 데이터가 있는 날짜에 아이콘 추가
            return Positioned(
              right: 0,
              bottom: 0,
              child: Icon(
                Icons.event,
                color: Colors.red,
                size: 16.0,
              ),
            );
          }
          return SizedBox.shrink(); // 아이콘이 필요 없는 경우 빈 위젯 반환
        },
      ),
      focusedDay: DateTime.now(),
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
    );
  }
}