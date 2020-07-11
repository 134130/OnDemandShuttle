import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:on_demand_shuttle2/request_shuttle.dart';

class MyPainter extends CustomPainter {
  List<PaintOver> poList;

  MyPainter(List<PaintOver> poList) {
    this.poList = poList;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1.0;

    for (int i = 0; i < 8; i++) {
      canvas.drawLine(Offset(i * 40.0, 0), Offset(i * 40.0, 40), paint);
      canvas.drawLine(
          Offset(i * 40.0 + 20.0, 15), Offset(i * 40.0 + 20.0, 40), paint);

      TextSpan ts = TextSpan(
          text: sprintf('%2d', [i + 6]),
          style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.bold));
      TextPainter tp = TextPainter(
          text: ts,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left);
      tp.layout();
      tp.paint(canvas, Offset(i * 40.0 - 8, 40));
    }

    for (PaintOver po in poList) {
      Paint poPaint = Paint()
        ..color = Colors.redAccent
        ..strokeWidth = 8.0;
      if (po.hour < 14) {
        canvas.drawLine(Offset((po.hour - 6) * 40.0 + (po.minute/15) * 5.0, 40.0 - po.demand),
            Offset((po.hour - 6) * 40.0 + (po.minute/15) * 5.0, 40), poPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MyPainter2 extends CustomPainter {
  List<PaintOver> poList;

  MyPainter2(List<PaintOver> poList) {
    this.poList = poList;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1.0;

    for (int i = 0; i < 8; i++) {
      canvas.drawLine(Offset(i * 40.0, 0), Offset(i * 40.0, 40), paint);
      canvas.drawLine(
          Offset(i * 40.0 + 20.0, 15), Offset(i * 40.0 + 20.0, 40), paint);

      TextSpan ts = TextSpan(
          text: sprintf('%2d', [i + 14]),
          style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.bold));
      TextPainter tp = TextPainter(
          text: ts,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left);
      tp.layout();
      tp.paint(canvas, Offset(i * 40.0 - 8, 40));
    }

    for (PaintOver po in poList) {
      Paint poPaint = Paint()
        ..color = Colors.redAccent
        ..strokeWidth = 8.0;
      if (po.hour >= 14) {
        canvas.drawLine(Offset((po.hour - 14) * 40.0 + (po.minute/15) * 5.0, 40.0 - po.demand),
            Offset((po.hour - 14) * 40.0 + (po.minute/15) * 5.0, 40), poPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
