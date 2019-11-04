import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';

///
/// キャラクター詳細画面で使う合計ステータス表示用のサークルグラフ
///
class TotalStatusCircularIndicator extends StatelessWidget {
  TotalStatusCircularIndicator({this.totalStatus, this.limitStatus});

  final int totalStatus;
  final int limitStatus;

  @override
  Widget build(BuildContext context) {
    double percent = totalStatus / limitStatus;
    percent = (percent > 1) ? 1 : percent;

    return CircularPercentIndicator(
      radius: 110.0,
      lineWidth: 10.0,
      animation: true,
      animationDuration: 500,
      percent: percent,
      center: _centerText(context, totalStatus),
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: RSColors.characterDetailTotalStatusIndicator.withOpacity(0.3),
      progressColor: RSColors.characterDetailTotalStatusIndicator,
    );
  }

  Widget _centerText(BuildContext context, int currentTotal) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          currentTotal.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline,
        ),
        Text(
          RSStrings.characterDetailTotalStatusCircleLabel,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

///
/// 各ステータスのグラフ
///
class RSStatusBar extends StatelessWidget {
  RSStatusBar({@required this.title, @required this.status, @required this.limit});

  final String title;
  final int status;
  final int limit;

  @override
  Widget build(BuildContext context) {
    Color currentStatusColor = _calcCurrentStatusColor();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(title, style: Theme.of(context).textTheme.subtitle),
        ),
        _contentLinearPercentIndicator(context, currentStatusColor),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 8.0),
          child: Text(
            '$status / $limit',
            style: TextStyle(fontWeight: FontWeight.bold, color: currentStatusColor),
          ),
        ),
      ],
    );
  }

  Widget _contentLinearPercentIndicator(BuildContext context, Color currentStatusColor) {
    double percent = status / limit;
    percent = (percent > 1) ? 1 : percent;

    List<Color> graphColors = (status > 0) ? [currentStatusColor.withOpacity(0.6), currentStatusColor] : [currentStatusColor, currentStatusColor];

    return LinearPercentIndicator(
      width: 80,
      lineHeight: 4.0,
      animation: true,
      animationDuration: 500,
      percent: percent,
      linearStrokeCap: LinearStrokeCap.roundAll,
      linearGradient: LinearGradient(colors: graphColors),
      backgroundColor: RSColors.characterDetailStatusBackground,
    );
  }

  Color _calcCurrentStatusColor() {
    int diffLimit = status - limit;
    if (status == 0) {
      return RSColors.characterDetailStatusNone;
    } else if (diffLimit < -6) {
      return RSColors.characterDetailStatusLack;
    } else if (diffLimit >= -6 && diffLimit < -3) {
      return RSColors.characterDetailStatusNormal;
    } else {
      return RSColors.characterDetailStatusSufficient;
    }
  }
}

class VerticalColorBorder extends StatelessWidget {
  VerticalColorBorder({this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
    );
  }
}
