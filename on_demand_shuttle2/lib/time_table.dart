import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:on_demand_shuttle2/time_table_horizon.dart';

class TimeTablePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  String _title;

  _TimeTablePageState() {
    this._title = sprintf('%d월 %d일 (%s)\n셔틀버스 배차표', _getCurrentDate());
  }

  List _getCurrentDate() {
    var _now = DateTime.now();
    var daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
    return [_now.month, _now.day, daysOfWeek[_now.weekday%7]];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40, bottom: 10),
            child: Container(child: Text(_title, style: TextStyle(fontSize: 30),), alignment: Alignment.centerLeft , margin: EdgeInsets.symmetric(horizontal: 28),),
          ),
          TimeTableHorizon(),
        ],
      );
  }
}
