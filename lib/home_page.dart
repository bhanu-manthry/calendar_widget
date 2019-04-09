import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_calendar_widget/calendar_widget/calendar_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, List<String>> _events;

  Map<String, bool> _selectedDates;

  @override
  void initState() {
    super.initState();
    _events = Map();
    _events[DateFormat('y-M-d').format(DateTime.now())] = ['Hello', 'world'];
    _events[DateFormat('y-M-d').format(DateTime(2019, 4, 5))] = [
      'Hello',
      'world'
    ];

    _selectedDates = Map<String, bool>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Calendar'),
      ),
      body: Center(
        child: CalendarWidget(
          markedDates: _events,
          markBuilder: (String event) {
            if (event == 'Hello') {
              return Text('H');
            }

            return Container(
              width: 6,
              height: 6,
              margin: EdgeInsets.symmetric(horizontal: 1),
              color: Colors.indigo,
            );
          },
          borderType: DayTileBorderType.CIRCULAR,
          dayTileMargin: 1,
          selectedDates: _selectedDates,
          onTap: (DateTime date, isSelected) {
            debugPrint(date.toIso8601String());
            if (isSelected) {
              _selectedDates[DateFormat('y-M-d').format(date)] = isSelected;
            } else {
              _selectedDates.remove(DateFormat('y-M-d').format(date));
            }
            print(_selectedDates);
          },
        ),
      ),
    );
  }
}
