import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  final Map<String, List<String>> markedDates;
  final Function markBuilder;
  final double borderRadius;
  final double dayTileMargin;
  final Function onTap;
  final Map<String, bool> selectedDates;
  final Color dayTileBorderColor;
  final Function dayTileBuilder;
  final Function weekBuilder;
  final bool showBorder;

  CalendarWidget({
    this.markedDates,
    this.markBuilder,
    this.borderRadius,
    this.onTap,
    this.selectedDates,
    this.dayTileMargin,
    this.dayTileBorderColor,
    this.dayTileBuilder,
    this.weekBuilder,
    this.showBorder,
  });

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _visibleMonth;

  int _currentPageIndex = 999;
  PageController _pageController;

  _onPageChanged(pageIndex) {
    if (pageIndex > _currentPageIndex) {
      _visibleMonth = Utils.nextMonth(_visibleMonth);
    } else if (pageIndex < _currentPageIndex) {
      _visibleMonth = Utils.previousMonth(_visibleMonth);
    }

    setState(() {});

    _currentPageIndex = pageIndex;
  }

  void initState() {
    super.initState();
    _visibleMonth = Utils.firstDayOfMonth(DateTime.now());
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _visibleMonth = Utils.previousMonth(_visibleMonth);
                  });
                },
              ),
              Text(
                '${Utils.formatMonth(_visibleMonth)}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _visibleMonth = Utils.nextMonth(_visibleMonth);
                  });
                },
              ),
            ],
          ),
        ),
        widget.weekBuilder != null
        ? widget.weekBuilder(Utils.weekdays)
        : Container(
          padding: EdgeInsets.only(bottom: 12),
          child: Row(            
            children: List.generate(Utils.weekdays.length, (index) {
              return Expanded(
                child: Text(
                  '${Utils.weekdays[index]}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
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
                        DayTileContainer(
                          dateTime: days[index],
                          isDayOfCurrentMonth:
                              days[index].month == _visibleMonth.month,
                          events: widget.markedDates[
                              DateFormat('y-M-d').format(days[index])],
                          markBuilder: widget.markBuilder,
                          borderRadius: widget.borderRadius,
                          dayTileMargin: widget.dayTileMargin,
                          onTap: widget.onTap,
                          isSelected: widget.selectedDates[
                                  DateFormat('y-M-d').format(days[index])] ??
                              false,
                          dayTileBorderColor: widget.dayTileBorderColor,
                          dayTileBuilder: widget.dayTileBuilder,
                          showBorder: widget.showBorder,
                        ),
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

class DayTileContainer extends StatelessWidget {

  final DateTime dateTime;
  final bool isDayOfCurrentMonth;
  final List<String> events;
  final Function markBuilder;
  final double borderRadius;
  final double dayTileMargin;
  final Function onTap;
  final bool isSelected;
  final Color dayTileBorderColor;
  final Function dayTileBuilder;
  final bool showBorder;

  DayTileContainer({
    this.dateTime,
    this.isDayOfCurrentMonth,
    this.events,
    this.markBuilder,
    this.borderRadius,
    this.dayTileMargin,
    this.onTap,
    this.isSelected,
    this.dayTileBorderColor,
    this.dayTileBuilder,
    this.showBorder,
  });

  @override
  Widget build(BuildContext context) {
    DayProps dayProps = DayProps(
      dateTime: dateTime,
      isDayOfCurrentMonth: isDayOfCurrentMonth,
      events: events,
      markBuilder: markBuilder,
      borderRadius: borderRadius,
      dayTileMargin: dayTileMargin,    
      isSelected: isSelected,
      dayTileBorderColor: dayTileBorderColor,
      showBorder: showBorder,
    );
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap(dateTime, !isSelected);
        },
        onLongPress: () {},
        child: Container(
          width: double.infinity,
          child: dayTileBuilder != null
          ? dayTileBuilder(dayProps)
          : DayTile(dayProps),
        )
      ),
    );
  }
}

class DayProps {
  final DateTime dateTime;
  final bool isDayOfCurrentMonth;
  final List<String> events;
  final Function markBuilder;
  final double borderRadius;
  final double dayTileMargin;
  final Function onTap;
  final bool isSelected;
  final Color dayTileBorderColor;
  final bool showBorder;

  DayProps({
    this.dateTime,
    this.isDayOfCurrentMonth,
    this.events,
    this.markBuilder,
    this.borderRadius,
    this.dayTileMargin,
    this.onTap,
    this.isSelected,
    this.dayTileBorderColor,
    this.showBorder,
  });
}


class DayTile extends StatelessWidget {
  final DayProps props;

  DayTile(this.props);

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.all(props.dayTileMargin ?? 3),          
          decoration: BoxDecoration(
            border: props.showBorder == true
              ? Border.all(
              width: 1,
              color: props.dayTileBorderColor ?? Colors.grey,
            )
            : null,
            borderRadius: BorderRadius.circular(props.borderRadius),
            color: props.isSelected ? Colors.green : Colors.transparent,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${props.dateTime.day}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color:
                            props.isDayOfCurrentMonth ? Colors.black87 : Colors.grey),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: EventMarks(props.events, markBuilder: props.markBuilder),
              ),
            ],
          ),
        );
  }
}

class EventMarks extends StatelessWidget {
  final List<String> events;
  final Function markBuilder;

  EventMarks(this.events, {this.markBuilder});

  @override
  Widget build(BuildContext context) {
    if (events == null || events.length == 0) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(events.length, (index) {
        if (this.markBuilder != null) {
          return this.markBuilder(events[index]);
        }
        if (events[index] == 'Hello') {
          return EventMark(Colors.green);
        } else {
          return EventMark(Colors.red);
        }
      }),
    );
  }
}

class EventMark extends StatelessWidget {
  final Color color;

  EventMark(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Container(
        width: 6,
        height: 6,
        margin: EdgeInsets.symmetric(horizontal: 1),
        color: color,
      ),
    );
  }
}
