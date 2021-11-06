import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_images.dart';

class Letter {
  const Letter({
    required this.year,
    required this.month,
    required this.title,
    required this.shortTitle,
    this.fileName,
    this.gifFilePath,
    this.staticImagePath,
  }) : assert(fileName != null || (gifFilePath != null && staticImagePath != null));

  final int year;
  final int month;
  final String title;
  final String shortTitle;
  final String? fileName;
  final String? gifFilePath;
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

  String get loadingIcon {
    if (3 <= month && month <= 5) {
      return RSImages.gifLoadingSpring;
    } else if (6 <= month && month <= 8) {
      return RSImages.gifLoadingSummer;
    } else if (9 <= month && month <= 11) {
      return RSImages.gifLoadingFall;
    } else {
      return RSImages.gifLoadingWinter;
    }
  }

  Letter copyWith({
    int? year,
    int? month,
    String? title,
    String? shortTitle,
    String? fileName,
    String? gifFilePath,
    String? staticImagePath,
  }) {
    return Letter(
      year: year ?? this.year,
      month: month ?? this.month,
      title: title ?? this.title,
      shortTitle: shortTitle ?? this.shortTitle,
      fileName: fileName ?? this.fileName,
      gifFilePath: gifFilePath ?? this.gifFilePath,
      staticImagePath: staticImagePath ?? this.staticImagePath,
    );
  }
}
