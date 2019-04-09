import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _visibleMonth;
  // DateTime _nextMonth;
  // DateTime _prevMonth;

  int _currentPageIndex = 999;

  List<DateTime> months;
  Queue<Widget> q;

  _onPageChanged(pageIndex) {
    if (pageIndex > _currentPageIndex) {
      _visibleMonth = Utils.nextMonth(_visibleMonth);
    }

    else if (pageIndex < _currentPageIndex) {
      _visibleMonth = Utils.previousMonth(_visibleMonth);
    }

    setState(() {});

    _currentPageIndex = pageIndex;

    debugPrint(_visibleMonth.toIso8601String());
  }

  void initState() {
    super.initState();    
    _visibleMonth = Utils.firstDayOfMonth(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {    
    return Column(
      children: <Widget>[
        Container(
          child: Text('${Utils.formatMonth(_visibleMonth)}'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(Utils.weekdays.length, (index) {
            return Expanded(
              child:
                  Text('${Utils.weekdays[index]}', textAlign: TextAlign.center),
            );
          }),
        ),
        Expanded(
          child: PageView.builder(
            // itemCount: months.length,
            controller: PageController(initialPage: _currentPageIndex),
            onPageChanged: _onPageChanged,
            itemBuilder: (context, pageIndex) {
              List<DateTime> days = Utils.daysInMonth(_visibleMonth);
              return GridView.builder(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DayTile(
                            dateTime: days[index],
                            isDayOfCurrentMonth:
                                days[index].month == _visibleMonth.month),
                      ],
                    );
                  });
            },
          ),
        ),
      ],
    );
  }
}

class DayTile extends StatelessWidget {
  final DateTime dateTime;
  final bool isDayOfCurrentMonth;

  DayTile({this.dateTime, this.isDayOfCurrentMonth});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
          child: Text(
        '${dateTime.day}',
        textAlign: TextAlign.center,
        style:
            TextStyle(color: isDayOfCurrentMonth ? Colors.black87 : Colors.grey),
      ),
    );
  }
}
