import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/romasaga/model/app_settings.dart';
import 'package:rsapp/romasaga/model/ranking_character.dart';

class RSRadarChart extends StatelessWidget {
  const RSRadarChart(this._char);

  final RankingCharacter _char;

  static const _ticks = [1, 2, 3, 4, 5];
  static const _features = [
    RSStrings.strL,
    RSStrings.vitL,
    RSStrings.dexL,
    RSStrings.agiL,
    RSStrings.intL,
    RSStrings.spiL,
    RSStrings.loveL,
    RSStrings.attrL,
  ];

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    final topCharData = _char.toStatuses();
    RSLogger.d('トップキャラのステータス: $topCharData');
    final rankingData = convertRanking(topCharData);
    RSLogger.d('コンバート後: $topCharData');

    return appSettings.isDarkMode
        ? RadarChart.dark(
            ticks: _ticks,
            features: _features,
            data: [rankingData],
            reverseAxis: true,
          )
        : RadarChart.light(
            ticks: _ticks,
            features: _features,
            data: [rankingData],
            reverseAxis: true,
          );
  }

  ///
  /// このライブラリ、なぜか一位のチャートを二位として表示するので全部ー1している
  ///
  List<int> convertRanking(List<int> rankData) {
    return rankData.map((e) => e - 1).toList();
  }
}
