import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';

///
/// ステータスの合計を示すサークルグラフ
///
class TotalStatusCircleGraph extends StatelessWidget {
  const TotalStatusCircleGraph({
    Key? key,
    required this.totalStatus,
    required this.limitStatus,
  }) : super(key: key);

  final int totalStatus;
  final int limitStatus;

  @override
  Widget build(BuildContext context) {
    double percent = totalStatus / limitStatus;
    percent = (percent > 1) ? 1 : percent;
    CircularStrokeCap strokeCap = (percent < 1) ? CircularStrokeCap.round : CircularStrokeCap.butt;

    return CircularPercentIndicator(
      radius: 110.0,
      lineWidth: 10.0,
      animation: true,
      animationDuration: 500,
      percent: percent,
      center: _centerText(context, totalStatus),
      circularStrokeCap: strokeCap,
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
          style: Theme.of(context).textTheme.headline5,
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
class StatusGraph extends StatelessWidget {
  const StatusGraph({
    Key? key,
    required this.title,
    required this.status,
    required this.limit,
  }) : super(key: key);

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
          child: Text(title, style: Theme.of(context).textTheme.subtitle1),
        ),
        _ContentLinearPercentIndicator(status: status, limit: limit, color: currentStatusColor),
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

  Color _calcCurrentStatusColor() {
    int diffLimit = status - limit;
    if (status == 0) {
      return RSColors.characterDetailStatusNone;
    } else if (diffLimit < -6) {
      return RSColors.characterDetailStatusLack;
    } else if (diffLimit >= -6 && diffLimit < -3) {
      return RSColors.characterDetailStatusNormal;
    } else {
      return RSColors.statusSufficient;
    }
  }
}

class _ContentLinearPercentIndicator extends StatelessWidget {
  const _ContentLinearPercentIndicator({
    Key? key,
    required this.status,
    required this.limit,
    required this.color,
  }) : super(key: key);

  final int status;
  final int limit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double percent = status / limit;
    percent = (percent > 1) ? 1 : percent;

    List<Color> graphColors = (status > 0) ? [color.withOpacity(0.6), color] : [color, color];

    return LinearPercentIndicator(
      width: 80,
      lineHeight: 4.0,
      animation: true,
      animationDuration: 500,
      percent: percent,
      linearStrokeCap: LinearStrokeCap.roundAll,
      linearGradient: LinearGradient(colors: graphColors),
      backgroundColor: RSColors.characterDetailStatusIndicatorBackground,
    );
  }
}
