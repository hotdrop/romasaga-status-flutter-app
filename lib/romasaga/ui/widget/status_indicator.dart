import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../model/status.dart';

class StatusIndicator {
  static Widget create(String statusName, int currentStatus, int statusUpperLimit) {
    return _createIndicator(statusName, currentStatus ?? 0, statusUpperLimit);
  }

  static Widget _createIndicator(String name, int currentStatus, int statusUpperLimit) {
    double percent;
    if (currentStatus > statusUpperLimit) {
      percent = 1.0;
    } else {
      percent = (currentStatus / statusUpperLimit);
    }

    int diffLimit;
    // 今はHPはステータス上限の計測外にしているので無条件で0にする。
    if (name == Status.hpName) {
      diffLimit = 0;
    } else {
      diffLimit = currentStatus - statusUpperLimit;
    }

    final Color statusColor = _labelStatusColor(diffLimit, currentStatus);
    final List<Color> graphColors = _linearGradientColors(diffLimit, currentStatus);

    return LinearPercentIndicator(
      width: 250,
      animation: true,
      animationDuration: 500,
      lineHeight: 20.0,
      leading: Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Text(name),
      ),
      trailing: Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text("${diffLimit.toString()}", style: TextStyle(color: statusColor)),
      ),
      percent: percent,
      center: Text(
        currentStatus.toString(),
        style: TextStyle(color: Colors.black),
      ),
      linearStrokeCap: LinearStrokeCap.butt,
      linearGradient: LinearGradient(colors: graphColors),
    );
  }

  static Color _labelStatusColor(int diffLimit, int currentStatus) {
    if (currentStatus == 0) {
      return Colors.black;
    } else if (diffLimit < -6) {
      return Colors.red;
    } else if (diffLimit >= -6 && diffLimit < -3) {
      return Colors.green;
    } else {
      return Colors.blueAccent;
    }
  }

  static List<Color> _linearGradientColors(int diffLimit, int currentStatus) {
    if (currentStatus == 0) {
      return [Colors.black];
    } else if (diffLimit < -6) {
      return [Color.fromARGB(255, 200, 0, 100), Colors.redAccent];
    } else if (diffLimit >= -6 && diffLimit < -3) {
      return [Color.fromARGB(255, 0, 200, 0), Colors.greenAccent];
    } else {
      return [Color.fromARGB(255, 0, 100, 255), Colors.blueAccent];
    }
  }
}
