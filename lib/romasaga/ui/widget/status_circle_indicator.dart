import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatusCircleIndicator {
  static Widget normal(String statusName, int currentStatus, int statusUpperLimit) {
    return _createCircularIndicator(statusName, currentStatus, statusUpperLimit, 80.0, 500);
  }

  static Widget large(String statusName, int currentStatus, int statusUpperLimit) {
    return _createCircularIndicator(statusName, currentStatus, statusUpperLimit, 100.0, 500);
  }

  static Widget _createCircularIndicator(String name, int currentStatus, int statusUpperLimit, double radius, int animationDuration) {
    double percent;
    if (currentStatus > statusUpperLimit) {
      percent = 1.0;
    } else {
      percent = (currentStatus / statusUpperLimit);
    }

    final Color statusColor = _getCurrentStatusColor(statusUpperLimit, currentStatus);

    return CircularPercentIndicator(
      radius: radius,
      animation: true,
      animationDuration: animationDuration,
      lineWidth: 5.0,
      percent: percent,
      circularStrokeCap: CircularStrokeCap.round,
      center: _textCenterInCircle(name, currentStatus, statusColor),
      progressColor: statusColor,
    );
  }

  static Widget _textCenterInCircle(String statusName, int status, Color statusColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          statusName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
        Text(
          (status != 0) ? status.toString() : 'ー',
          style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 20.0),
        )
      ],
    );
  }

  static Color _getCurrentStatusColor(int statusUpperLimit, int currentStatus) {
    int diffWithLimit = currentStatus - statusUpperLimit;
    if (currentStatus == 0) {
      return Colors.black;
    } else if (diffWithLimit <= -10) {
      return Colors.redAccent;
    } else if (diffWithLimit >= -6 && diffWithLimit < -3) {
      return Colors.greenAccent;
    } else {
      return Colors.lightBlueAccent;
    }
  }
}
