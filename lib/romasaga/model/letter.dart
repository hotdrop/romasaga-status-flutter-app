import 'package:flutter/material.dart';

import '../common/strings.dart';

class Letter {
  Letter._({@required this.letterType, @required this.gifResource, @required this.title, @required this.themeColor});

  factory Letter.fromType(LetterType type) {
    switch (type) {
      case LetterType.january:
        return Letter._(
          letterType: type,
          gifResource: 'res/letters/201901_hane.gif',
          title: Strings.LetterJanuaryTitle,
          themeColor: Colors.orange,
        );
      case LetterType.february:
        return Letter._(
            letterType: type, gifResource: 'res/letters/201902_valentine.gif', title: Strings.LetterFebruaryTitle, themeColor: Colors.redAccent);
      case LetterType.march:
        return Letter._(
            letterType: type, gifResource: 'res/letters/201903_hinamaturi.gif', title: Strings.LetterMarchTitle, themeColor: Colors.pinkAccent);
      case LetterType.april:
        return Letter._(
            letterType: type, gifResource: 'res/letters/201904_hanami.gif', title: Strings.LetterAprilTitle, themeColor: Colors.pinkAccent);
      case LetterType.may:
        return Letter._(letterType: type, gifResource: 'res/letters/201905_hiyori.gif', title: Strings.LetterMayTitle, themeColor: Colors.green);
      case LetterType.june:
        return Letter._(letterType: type, gifResource: 'res/letters/201906_halfAniver.gif', title: Strings.LetterJuneTitle, themeColor: Colors.green);
      case LetterType.july:
        return Letter._(letterType: type, gifResource: 'res/letters/201907_asami.gif', title: Strings.LetterJulyTitle, themeColor: Colors.blueAccent);
      default:
        return null;
    }
  }

  final LetterType letterType;
  final String title;
  final String gifResource;
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
}
