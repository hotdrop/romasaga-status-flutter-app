import 'package:flutter/material.dart';

import '../common/rs_colors.dart';

class Letter {
  Letter({
    @required this.year,
    @required this.month,
    @required this.title,
    @required this.shortTitle,
    @required this.imagePath,
    @required this.staticImagePath,
  });

  final int year;
  final int month;

  final String title;
  final String shortTitle;

  final String imagePath;
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
}
