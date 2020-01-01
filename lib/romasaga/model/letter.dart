import 'package:flutter/material.dart';

import '../common/rs_colors.dart';
import '../common/rs_strings.dart';

class Letter {
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
          title: RSStrings.letterJanuaryTitle,
          shortTitle: RSStrings.letterJanuaryShortTitle,
          themeColor: RSColors.winter,
        );
      case LetterType.february:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201902_valentine.gif',
          thumbnail: 'res/letters/201902_valentine_static.jpg',
          title: RSStrings.letterFebruaryTitle,
          shortTitle: RSStrings.letterFebruaryShortTitle,
          themeColor: RSColors.winter,
        );
      case LetterType.march:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201903_hinamaturi.gif',
          thumbnail: 'res/letters/201903_hinamaturi_static.jpg',
          title: RSStrings.letterMarchTitle,
          shortTitle: RSStrings.letterMarchShortTitle,
          themeColor: RSColors.spring,
        );
      case LetterType.april:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201904_hanami.gif',
          thumbnail: 'res/letters/201904_hanami_static.jpg',
          title: RSStrings.letterAprilTitle,
          shortTitle: RSStrings.letterAprilShortTitle,
          themeColor: RSColors.spring,
        );
      case LetterType.may:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201905_hiyori.gif',
          thumbnail: 'res/letters/201905_hiyori_static.jpg',
          title: RSStrings.letterMayTitle,
          shortTitle: RSStrings.letterMayShortTitle,
          themeColor: RSColors.spring,
        );
      case LetterType.june:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201906_halfAniver.gif',
          thumbnail: 'res/letters/201906_halfAniver_static.jpg',
          title: RSStrings.letterJuneTitle,
          shortTitle: RSStrings.letterJuneShortTitle,
          themeColor: RSColors.summer,
        );
      case LetterType.july:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201907_asami.gif',
          thumbnail: 'res/letters/201907_asami_static.jpg',
          title: RSStrings.letterJulyTitle,
          shortTitle: RSStrings.letterJulyShortTitle,
          themeColor: RSColors.summer,
        );
      case LetterType.august:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201908_summer.gif',
          thumbnail: 'res/letters/201908_summer_static.jpg',
          title: RSStrings.letterAugustTitle,
          shortTitle: RSStrings.letterAugustShortTitle,
          themeColor: RSColors.summer,
        );
      case LetterType.september:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201909_award.gif',
          thumbnail: 'res/letters/201909_award_static.jpg',
          title: RSStrings.letterSeptemberTitle,
          shortTitle: RSStrings.letterSeptemberShortTitle,
          themeColor: RSColors.fall,
        );
      case LetterType.october:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201910_halloween.gif',
          thumbnail: 'res/letters/201910_halloween_static.jpg',
          title: RSStrings.letterOctoberTitle,
          shortTitle: RSStrings.letterOctoberShortTitle,
          themeColor: RSColors.fall,
        );
      case LetterType.november:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201911_onsen.gif',
          thumbnail: 'res/letters/201911_onsen_static.jpg',
          title: RSStrings.letterNovemberTitle,
          shortTitle: RSStrings.letterNovemberShortTitle,
          themeColor: RSColors.fall,
        );
      case LetterType.december:
        return Letter._(
          type: type,
          gifResource: 'res/letters/201912_christmas.gif',
          thumbnail: 'res/letters/201912_christmas_static.jpg',
          title: RSStrings.letterDecemberTitle,
          shortTitle: RSStrings.letterDecemberShortTitle,
          themeColor: RSColors.winter,
        );
      case LetterType.january2020:
        return Letter._(
          type: type,
          gifResource: 'res/letters/202001_happyNewYear.gif',
          thumbnail: 'res/letters/202001_happyNewYear_static.jpg',
          title: RSStrings.letter2020JanuaryTitle,
          shortTitle: RSStrings.letter2020JanuaryShortTitle,
          themeColor: RSColors.winter,
        );
      default:
        return null;
    }
  }

  final LetterType type;
  final String gifResource;
  final String thumbnail;
  final String title;
  final String shortTitle;
  final Color themeColor;
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
  october,
  november,
  december,
  january2020,
}
