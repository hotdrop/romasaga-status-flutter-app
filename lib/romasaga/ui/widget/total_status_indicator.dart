import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';

class TotalStatusIndicator {
  static Widget create(int currentTotal, int limit) {
    return _createIndicator(currentTotal, limit);
  }

  static Widget _createIndicator(int currentTotal, int limit) {
    double percent = currentTotal / limit;
    percent = (percent > 1) ? 1 : percent;

    return CircularPercentIndicator(
      radius: 100.0,
      animation: true,
      animationDuration: 1000,
      lineWidth: 10.0,
      percent: percent,
      center: _centerText(currentTotal),
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: RSColors.detailTotalStatusGraph.withOpacity(0.3),
      progressColor: RSColors.detailTotalStatusGraph,
    );
  }

  static Widget _centerText(int currentTotal) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          currentTotal.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 24.0,
            letterSpacing: 0.0,
            color: RSColors.detailTotalStatusGraph,
          ),
        ),
        Text(
          RSStrings.characterDetailTotalStatusCircleLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            letterSpacing: 0.0,
            color: RSColors.subText,
          ),
        ),
      ],
    );
  }
}
