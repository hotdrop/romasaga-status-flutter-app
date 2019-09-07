import 'package:flutter/material.dart';

import '../common/rs_colors.dart';
import '../common/rs_strings.dart';

class Letter {
  final LetterType type;
  final String gifResource;
  final String thumbnail;
  final String title;
  final String shortTitle;
  final Color themeColor;

  Letter._({
    @required this.type,
    @required this.gifResource,
    @required this.thumbnail,
    @required this.title,
    @required this.shortTitle,
    @required this.themeColor,
  });

  factory Letter.fromType(LetterType type) {
    switch (type) {
      case LetterType.january:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201901_hane.gif',
          thumbnail: 'res/letters/201901_hane_static.jpg',
          title: RSStrings.LetterJanuaryTitle,
          shortTitle: RSStrings.LetterJanuaryShortTitle,
          themeColor: RSColors.winter,
        );
      case LetterType.february:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201902_valentine.gif',
          thumbnail: 'res/letters/201902_valentine_static.jpg',
          title: RSStrings.LetterFebruaryTitle,
          shortTitle: RSStrings.LetterFebruaryShortTitle,
          themeColor: RSColors.winter,
        );
      case LetterType.march:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201903_hinamaturi.gif',
          thumbnail: 'res/letters/201903_hinamaturi_static.jpg',
          title: RSStrings.LetterMarchTitle,
          shortTitle: RSStrings.LetterMarchShortTitle,
          themeColor: RSColors.winter,
        );
      case LetterType.april:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201904_hanami.gif',
          thumbnail: 'res/letters/201904_hanami_static.jpg',
          title: RSStrings.LetterAprilTitle,
          shortTitle: RSStrings.LetterAprilShortTitle,
          themeColor: RSColors.spring,
        );
      case LetterType.may:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201905_hiyori.gif',
          thumbnail: 'res/letters/201905_hiyori_static.jpg',
          title: RSStrings.LetterMayTitle,
          shortTitle: RSStrings.LetterMayShortTitle,
          themeColor: RSColors.spring,
        );
      case LetterType.june:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201906_halfAniver.gif',
          thumbnail: 'res/letters/201906_halfAniver_static.jpg',
          title: RSStrings.LetterJuneTitle,
          shortTitle: RSStrings.LetterJuneShortTitle,
          themeColor: RSColors.spring,
        );
      case LetterType.july:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201907_asami.gif',
          thumbnail: 'res/letters/201907_asami_static.jpg',
          title: RSStrings.LetterJulyTitle,
          shortTitle: RSStrings.LetterJulyShortTitle,
          themeColor: RSColors.summer,
        );
      case LetterType.august:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201908_summer.gif',
          thumbnail: 'res/letters/201908_summer_static.jpg',
          title: RSStrings.LetterAugustTitle,
          shortTitle: RSStrings.LetterAugustShortTitle,
          themeColor: RSColors.summer,
        );
      case LetterType.september:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201909_award.gif',
          thumbnail: 'res/letters/201909_award_static.jpg',
          title: RSStrings.LetterSeptemberTitle,
          shortTitle: RSStrings.LetterSeptemberShortTitle,
          themeColor: RSColors.fall,
        );
      default:
        return null;
    }
  }
}

enum LetterType {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
}
