import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';

class StatusIndicator {
  static Widget create(String statusName, int currentStatus, int statusUpperLimit) {
    return _createIndicator(statusName, currentStatus, statusUpperLimit);
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
    if (name == RSStrings.hpName) {
      diffLimit = 0;
    } else {
      diffLimit = currentStatus - statusUpperLimit;
    }

    final statusColor = _labelStatusColor(diffLimit, currentStatus);
    final graphColors = _linearGradientColors(diffLimit, currentStatus);

    return LinearPercentIndicator(
      width: 250,
      animation: true,
      animationDuration: 500,
      lineHeight: 20.0,
      leading: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text(name),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text("${diffLimit.toString()}", style: TextStyle(color: statusColor)),
      ),
      percent: percent,
      center: Text(
        currentStatus.toString(),
        style: const TextStyle(color: Colors.black),
      ),
      linearStrokeCap: LinearStrokeCap.butt,
      linearGradient: LinearGradient(colors: graphColors),
    );
  }

  static Color _labelStatusColor(int diffLimit, int currentStatus) {
    if (currentStatus == 0) {
      return RSColors.statusNone;
    } else if (diffLimit < -6) {
      return RSColors.statusLack;
    } else if (diffLimit >= -6 && diffLimit < -3) {
      return RSColors.statusNormal;
    } else {
      return RSColors.statusSufficient;
    }
  }

  static List<Color> _linearGradientColors(int diffLimit, int currentStatus) {
    if (currentStatus == 0) {
      return [RSColors.statusNoneGraphStart, RSColors.statusNoneGraphEnd];
    } else if (diffLimit < -6) {
      return [RSColors.statusLackGraphStart, RSColors.statusLackGraphEnd];
    } else if (diffLimit >= -6 && diffLimit < -3) {
      return [RSColors.statusNormalGraphStart, RSColors.statusNormalGraphEnd];
    } else {
      return [RSColors.statusSufficientGraphStart, RSColors.statusSufficientGraphEnd];
    }
  }
}
