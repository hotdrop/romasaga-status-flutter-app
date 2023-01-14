import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_colors.dart';

class Letter {
  const Letter({
    required this.year,
    required this.month,
    required this.title,
    required this.shortTitle,
    this.fileName,
    this.videoFilePath,
    this.staticImagePath,
  }) : assert(fileName != null || (videoFilePath != null && staticImagePath != null));

  final int year;
  final int month;
  final String title;
  final String shortTitle;
  final String? fileName;
  final String? videoFilePath;
  final String? staticImagePath;

  int get id => int.parse('$year${month.toString().padLeft(2, '0')}');

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

  Letter copyWith({
    int? year,
    int? month,
    String? title,
    String? shortTitle,
    String? fileName,
    String? videoFilePath,
    String? staticImagePath,
  }) {
    return Letter(
      year: year ?? this.year,
      month: month ?? this.month,
      title: title ?? this.title,
      shortTitle: shortTitle ?? this.shortTitle,
      fileName: fileName ?? this.fileName,
      videoFilePath: videoFilePath ?? this.videoFilePath,
      staticImagePath: staticImagePath ?? this.staticImagePath,
    );
  }
}
