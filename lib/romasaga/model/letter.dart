import 'package:flutter/material.dart';

import '../common/rs_colors.dart';

class Letter {
  const Letter({
    @required this.year,
    @required this.month,
    @required this.title,
    @required this.shortTitle,
    @required this.gifFilePath,
    @required this.staticImagePath,
  })  : assert(year != null),
        assert(month != null),
        assert(title != null),
        assert(shortTitle != null),
        assert(gifFilePath != null, 'A non-null gifFilePath'),
        assert(staticImagePath != null, 'A non-null staticImagePath');

  final int year;
  final int month;

  final String title;
  final String shortTitle;

  final String gifFilePath;
  final String staticImagePath;

  Color get themeColor {
    if (3 <= month && month <= 5) {
      return RSColors.spring;
    } else if (6 <= month && month <= 8) {
      return RSColors.summer;
    } else if (9 <= month && month <= 11) {
      return RSColors.fall;
    } else {
      return RSColors.winter;
    }
  }

  String get loadingIcon {
    if (3 <= month && month <= 5) {
      return 'res/icons/loading_spring.gif';
    } else if (6 <= month && month <= 8) {
      return 'res/icons/loading_summer.gif';
    } else if (9 <= month && month <= 11) {
      return 'res/icons/loading_fall.gif';
    } else {
      return 'res/icons/loading_winter.gif';
    }
  }
}
