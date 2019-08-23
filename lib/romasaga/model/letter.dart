import 'package:flutter/material.dart';

import '../common/rs_strings.dart';

class Letter {
  final LetterType letterType;
  final String title;
  final String gifResource;
  final Color themeColor;

  Letter._({@required this.letterType, @required this.gifResource, @required this.title, @required this.themeColor});

  factory Letter.fromType(LetterType type) {
    switch (type) {
      case LetterType.january:
        return Letter._(letterType: type, gifResource: 'res/letters/201901_hane.gif', title: RSStrings.LetterJanuaryTitle, themeColor: Colors.orange);
      case LetterType.february:
        return Letter._(
            letterType: type, gifResource: 'res/letters/201902_valentine.gif', title: RSStrings.LetterFebruaryTitle, themeColor: Colors.redAccent);
      case LetterType.march:
        return Letter._(
            letterType: type, gifResource: 'res/letters/201903_hinamaturi.gif', title: RSStrings.LetterMarchTitle, themeColor: Colors.pinkAccent);
      case LetterType.april:
        return Letter._(
            letterType: type, gifResource: 'res/letters/201904_hanami.gif', title: RSStrings.LetterAprilTitle, themeColor: Colors.pinkAccent);
      case LetterType.may:
        return Letter._(letterType: type, gifResource: 'res/letters/201905_hiyori.gif', title: RSStrings.LetterMayTitle, themeColor: Colors.green);
      case LetterType.june:
        return Letter._(
            letterType: type, gifResource: 'res/letters/201906_halfAniver.gif', title: RSStrings.LetterJuneTitle, themeColor: Colors.green);
      case LetterType.july:
        return Letter._(
            letterType: type, gifResource: 'res/letters/201907_asami.gif', title: RSStrings.LetterJulyTitle, themeColor: Colors.blueAccent);
      case LetterType.august:
        return Letter._(
            letterType: type, gifResource: 'res/letters/201908_summer.gif', title: RSStrings.LetterAugustTitle, themeColor: Colors.blueAccent);
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
}
