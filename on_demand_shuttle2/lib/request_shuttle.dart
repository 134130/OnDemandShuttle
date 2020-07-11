import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'my_painter.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestShuttlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestShuttlePageState();
}

class _RequestShuttlePageState extends State<RequestShuttlePage> {
  String _title;
  String _dropdownValue = '사당';
  int _selected = 0;
  String _dropdownDateValue;
  String _dropdownHourValue = '6';
  String _dropdownMinuteValue = '00';

  @override
  void initState() {
    this._dropdownDateValue = sprintf('%s월 %s일 (%s)', _getCurrentDate());
    this._title = _dropdownDateValue + '\n셔틀버스 배차신청';
  }

  List _getCurrentDate() {
    var _now = DateTime.now();
    var daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
    return [_now.month, _now.day, daysOfWeek[_now.weekday % 7]];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            _titleWidget(),
            _divider(),
            _alertWidget(),
            _divider(),
            _dropdownButton(),
            _header(),
            _calendarDatePicker(),
            _graph(),
            _requestButton(),
          ],
        ),
      ),
    );
  }

  Widget _graph() {
    String departure;
    String arrival;
    if (_selected == 0) {
      departure = _dropdownValue;
      arrival = '협성대';
    } else if (_selected == 1) {
      departure = '협성대';
      arrival = _dropdownValue;
    }

    return FutureBuilder<List<PaintOver>>(
      future: getShuttleDemand(departure, arrival,
          DateTime.now().year.toString(), _dropdownDateValue),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              _myPainter(snapshot.data),
              _myPainter2(snapshot.data)
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error');
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _requestButton() {
    String _content;
    String _departure;
    String _arrival;
    String _year = DateTime.now().year.toString();
    String _date = _dropdownDateValue;
    String _hour = _dropdownHourValue;
    String _minute = _dropdownMinuteValue;

    if (_selected == 0) {
      _departure = _dropdownValue;
      _arrival = '협성대';
    } else if (_selected == 1) {
      _departure = '협성대';
      _arrival = _dropdownValue;
    }

    _content = sprintf(
        '%s→%s\n%s %s:%s\n', [_departure, _arrival, _date, _hour, _minute]);

    return RaisedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('신청하기'),
              content: Text(_content + '가 맞습니까?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('확인'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: FutureBuilder(
                          future: requestShuttle(_departure, _arrival, _year,
                              _date, _hour, _minute),
                          builder: (_context, snapshot) {
                            if (snapshot.hasData) {
                              return AlertDialog(
                                title: Text('신청되었습니다.'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('확인'),
                                    onPressed: () {
                                      Navigator.pop(_context);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  )
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return CircularProgressIndicator();
                          },
                        ));
                  },
                ),
                FlatButton(
                  child: Text('취소'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
      child: Text('신청하기'),
    );
  }

  Widget _myPainter(List<PaintOver> poList) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: CustomPaint(
        size: Size(400, 60),
        painter: MyPainter(poList),
      ),
    );
  }

  Widget _myPainter2(List<PaintOver> poList) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: CustomPaint(
        size: Size(400, 60),
        painter: MyPainter2(poList),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      thickness: 1,
      height: 0,
      color: Colors.blueAccent,
    );
  }

  Widget _titleWidget() {
    return Container(
      child: Text(
        _title,
        style: TextStyle(fontSize: 30),
      ),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 14),
    );
  }

  Widget _alertWidget() {
    return Container(
      margin: EdgeInsets.all(6.0),
      child: Flexible(
        child: Text(
          '※ 오늘로부터 2일 후 까지의 셔틀버스만\n신청할 수 있습니다.',
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _dropdownButton() {
    List<List<String>> _data = [
      ['사당', '수원'],
      ['사당', '주안', '수원']
    ];
    List<DropdownMenuItem> _children = List<DropdownMenuItem>();
    for (String _d in _data[_selected]) {
      _children.add(DropdownMenuItem<String>(
        value: _d,
        child: Text(
          _d,
          style: TextStyle(fontSize: 24),
        ),
      ));
    }

    return Container(
      child: DropdownButton(
        items: _children,
        onChanged: (value) {
          setState(() {
            _dropdownValue = value;
          });
        },
        value: _dropdownValue,
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          _myGestureDetector('등교', 0),
          VerticalDivider(
            thickness: 1,
            color: Colors.blueAccent,
            width: 0,
            indent: 4,
            endIndent: 4,
          ),
          _myGestureDetector('하교', 1),
        ],
      ),
    );
  }

  GestureDetector _myGestureDetector(String _text, int _index) {
    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(color: Colors.blueAccent)),
            color: _selected == _index ? Colors.blue : Colors.transparent,
          ),
          width: (MediaQuery.of(context).size.width - 40) / 2,
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              _text,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onTap: () {
          setState(() {
            if (_index != _selected) _selected ^= 1;
          });
        });
  }

  Widget _calendarDatePicker() {
    DateTime _now = DateTime.now();
    DateTime _next = _now.add(Duration(days: 1));
    DateTime _next2 = _now.add(Duration(days: 2));
    List<String> _weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    List<String> _dates = [
      sprintf(
          '%s월 %s일 (%s)', [_now.month, _now.day, _weekdays[_now.weekday % 7]]),
      sprintf('%s월 %s일 (%s)',
          [_next.month, _next.day, _weekdays[_next.weekday % 7]]),
      sprintf('%s월 %s일 (%s)',
          [_next2.month, _next2.day, _weekdays[_next2.weekday % 7]])
    ];
    List<DropdownMenuItem> _items = List<DropdownMenuItem>();
    for (String _date in _dates) {
      _items.add(DropdownMenuItem(
        child: Text(_date),
        value: _date,
      ));
    }

    List<DropdownMenuItem> _itemsHour = List<DropdownMenuItem>();
    for (int i = 6; i < 22; i++) {
      _itemsHour.add(DropdownMenuItem(
        child: Text('$i'),
        value: '$i',
      ));
    }

    List<DropdownMenuItem> _itemsMinute = List<DropdownMenuItem>();
    for (int i = 0; i < 60; i += 15) {
      String _num = sprintf('%02d', [i]);
      _itemsMinute.add(DropdownMenuItem(
        child: Text(_num),
        value: _num,
      ));
    }

    return Container(
      //color: Colors.red,
      child: Row(
        children: <Widget>[
          Container(
            child: DropdownButton(
              items: _items,
              value: _dropdownDateValue,
              onChanged: (value) {
                setState(() {
                  _dropdownDateValue = value;
                  _title = _dropdownDateValue + '\n셔틀버스 배차신청';
                });
              },
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: <Widget>[
                DropdownButton(
                  items: _itemsHour,
                  onChanged: (value) {
                    setState(() {
                      _dropdownHourValue = value;
                    });
                  },
                  value: _dropdownHourValue,
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.black54,
                  ),
                ),
                Container(
                  child: Text(
                    '시',
                    style: TextStyle(fontSize: 20),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                ),
              ],
            ),
          ),
          Container(
            //margin: EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: <Widget>[
                DropdownButton(
                  items: _itemsMinute,
                  onChanged: (value) {
                    setState(() {
                      _dropdownMinuteValue = value;
                    });
                  },
                  value: _dropdownMinuteValue,
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.black54,
                  ),
                ),
                Container(
                  child: Text(
                    '분',
                    style: TextStyle(fontSize: 20),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> requestShuttle(String departure, String arrival, String year,
    String date, String hour, String minute) async {
  final response = await http.get(
      'http://134130.duckdns.org:5780/request?departure=${departure}&arrival=${arrival}&date=${year}년%20${date}&hour=${hour}&minute=${minute}');

  if (response.statusCode == 200) {
    return 'success';
  } else {
    throw Exception('failed');
  }
}

Future<List<PaintOver>> getShuttleDemand(
    String departure, String arrival, String year, String date) async {
  final response = await http.get(
      'http://134130.duckdns.org:5780/demand?departure=${departure}&arrival=${arrival}&date=${year}년%20${date}');

  if (response.statusCode == 200) {
    List<PaintOver> poList = List<PaintOver>();
    for (Map<String, dynamic> r in jsonDecode(response.body)) {
      poList.add(PaintOver.fromJson(r));
    }
    return poList;
  }
  return null;
}

class PaintOver {
  final int hour;
  final int minute;
  final int demand;

  PaintOver({this.hour, this.minute, this.demand});

  factory PaintOver.fromJson(Map<String, dynamic> json) {
    return PaintOver(
        hour: int.parse(json['hour']),
        minute: int.parse(json['minute']),
        demand: json['demand']);
  }
}
