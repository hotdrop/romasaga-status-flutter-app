import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';

///
/// ステータスの合計を示すサークルグラフ
///
class TotalStatusCircleGraph extends StatelessWidget {
  const TotalStatusCircleGraph({super.key, required this.totalStatus, required this.limitStatus});

  final int totalStatus;
  final int limitStatus;

  @override
  Widget build(BuildContext context) {
    double percent = totalStatus / limitStatus;
    percent = (percent > 1) ? 1 : percent;
    CircularStrokeCap strokeCap = (percent < 1) ? CircularStrokeCap.round : CircularStrokeCap.butt;

    return CircularPercentIndicator(
      radius: 70.0,
      lineWidth: 10.0,
      animation: true,
      animationDuration: 500,
      percent: percent,
      center: _CenterText(currentTotal: totalStatus),
      circularStrokeCap: strokeCap,
      backgroundColor: RSColors.totalStatusIndicator.withOpacity(0.3),
      progressColor: RSColors.totalStatusIndicator,
    );
  }
}

class _CenterText extends StatelessWidget {
  const _CenterText({required this.currentTotal});

  final int currentTotal;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          currentTotal.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          RSStrings.detailPageTotalStatusLabel,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

///
/// HPのグラフ
///
class HpGraph extends StatelessWidget {
  const HpGraph({
    super.key,
    required this.status,
    required this.limit,
  });

  final int status;
  final int limit;

  @override
  Widget build(BuildContext context) {
    Color currentStatusColor = _calcCurrentStatusColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
          child: Text(RSStrings.hpName, style: Theme.of(context).textTheme.titleMedium),
        ),
        _ContentLinearPercentIndicator(
          width: MediaQuery.of(context).size.width * 0.8,
          status: status,
          limit: limit,
          color: currentStatusColor,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 8.0),
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
      return RSColors.statusNone;
    } else if (diffLimit < -100) {
      return RSColors.statusLack;
    } else if (diffLimit >= -100 && diffLimit < -10) {
      return RSColors.statusNormal;
    } else {
      return RSColors.statusSufficient;
    }
  }
}

///
/// 各ステータスのグラフ
///
class StatusGraph extends StatelessWidget {
  const StatusGraph({
    super.key,
    required this.title,
    required this.status,
    required this.limit,
  });

  final String title;
  final int status;
  final int limit;

  @override
  Widget build(BuildContext context) {
    Color currentStatusColor = _calcCurrentStatusColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        _ContentLinearPercentIndicator(
          width: MediaQuery.of(context).size.width / 4,
          status: status,
          limit: limit,
          color: _calcCurrentStatusColor(),
        ),
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
      return RSColors.statusNone;
    } else if (diffLimit < -6) {
      return RSColors.statusLack;
    } else if (diffLimit >= -6 && diffLimit < -3) {
      return RSColors.statusNormal;
    } else {
      return RSColors.statusSufficient;
    }
  }
}

class _ContentLinearPercentIndicator extends StatelessWidget {
  const _ContentLinearPercentIndicator({
    required this.width,
    required this.status,
    required this.limit,
    required this.color,
  });

  final double width;
  final int status;
  final int limit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double percent = status / limit;
    percent = (percent > 1) ? 1 : percent;

    List<Color> graphColors = (status > 0) ? [color.withOpacity(0.6), color] : [color, color];

    return LinearPercentIndicator(
      alignment: MainAxisAlignment.center,
      width: width,
      lineHeight: 4.0,
      animation: true,
      animationDuration: 500,
      percent: percent,
      barRadius: const Radius.circular(16),
      linearGradient: LinearGradient(colors: graphColors),
      backgroundColor: RSColors.statusIndicatorBackground,
    );
  }
}
