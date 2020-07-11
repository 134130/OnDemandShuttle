import 'package:flutter/material.dart';
import 'package:on_demand_shuttle2/time_table.dart';
import 'package:on_demand_shuttle2/request_shuttle.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _children = [TimeTablePage(), RequestShuttlePage()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hyupsung Shuttle',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: getMyBottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar getMyBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: _onTap,
      currentIndex: _currentIndex,
      items: [
        new BottomNavigationBarItem(
            icon: Icon(
              Icons.table_chart,
              color: Colors.black54,
            ),
            title: Text(
              '시간표',
              style: TextStyle(color: Colors.black54),
            )),
        new BottomNavigationBarItem(
            icon: Icon(
              Icons.add_to_queue,
              color: Colors.black54,
            ),
            title: Text(
              '배차신청',
              style: TextStyle(color: Colors.black54),
            )),
      ],
    );
  }
}
