import 'package:flutter/material.dart';

class TimeTableHorizon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TimeTableHorizonState();
}

class _TimeTableHorizonState extends State<TimeTableHorizon> {
  int _selected = 0;
  List _list = [
    [
      {
        'departure': '사당',
        'arrival': '협성대',
        'fee': '1740',
        'times': ['8:00', '8:30', '9:00']
      },
      {
        'departure': '주안',
        'arrival': '협성대',
        'fee': '2440',
        'times': ['7:00', '7:30', '8:00']
      },
      {
        'departure': '수원',
        'arrival': '협성대',
        'fee': '740',
        'times': [
          '8:00',
          '8:30',
          '8:45',
          '8:50',
          '8:55',
          '9:00',
          '9:10',
          '9:30',
          '10:00',
          '10:10',
          '11:00',
          '12:00',
          '13:00'
        ]
      }
    ],
    [
      {
        'departure': '협성대',
        'arrival': '사당',
        'fee': '1740',
        'times': ['8:00', '8:30', '9:00']
      },
    ]
  ];

  Widget _header() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
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

  Widget _table() {
    var _times = _buildTimes();
    return Container(
      height: MediaQuery.of(context).size.height - 220,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _list[_selected].length * 2,
          itemBuilder: (context, i) {
            if (i % 2 == 0) {
              final index = i ~/ 2;
              final _item = _list[_selected][index];
              return Container(
                width: MediaQuery.of(context).size.width - 36,
                margin: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Container( // 사당 -> 협성대
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _item['departure'] + ' → ' + _item['arrival'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Column(children: _times[_selected][index])
                  ],
                ),
              );
            }
            return Divider(
              thickness: 1,
              height: 0,
              color: Colors.blueAccent,
            );
          },
        ),
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            // swiping in right direction
            if (_selected != 0) {
              setState(() {
                _selected = 0;
              });
            }
          } else if (details.delta.dx < 0) {
            if (_selected != 1) {
              setState(() {
                _selected = 1;
              });
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _header(),
        _table(),
      ],
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
          width: (MediaQuery.of(context).size.width - 40.0) / 2,
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

  List _buildTimes() {
    List _times = [List(), List()];
    for (int i = 0; i < _list.length; i++) {
      for (int j = 0; j < _list[i].length; j++) {
        _times[i].add(List<Widget>());
        List<Widget> tmpRow;
        for (int k = 0; k < _list[i][j]['times'].length; k++) {
          if (k % 6 == 0) {
            if (k != 0) {
              _times[i][j].add(Row(children: []..addAll(tmpRow)));
            }
            tmpRow = List<Widget>();
          }
          tmpRow.add(Container(
              width: 48,
              child: Text(
                _list[i][j]['times'][k],
                style: TextStyle(fontSize: 16),
              )));
          if (k == _list[i][j]['times'].length - 1) {
            _times[i][j].add(Row(children: []..addAll(tmpRow)));
          }
        }
      }
    }
    return _times;
  }
}
