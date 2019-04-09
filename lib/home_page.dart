import 'package:flutter/material.dart';
import 'package:my_calendar_widget/calendar_widget/calendar_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Calendar'),
      ),
      body: Center(
        child: CalendarWidget(),
      ),      
    );
  }
}