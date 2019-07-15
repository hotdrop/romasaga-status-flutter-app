import 'package:flutter/material.dart';

class Letter {
  Letter._({@required this.letterType, @required this.gifResource, @required this.title, @required this.themeColor});

  factory Letter.fromType(LetterType type) {
    switch (type) {
      case LetterType.january:
        return Letter._(letterType: type, gifResource: "res/letters/201901_hane.gif", title: januaryTitle, themeColor: Colors.orange);
      case LetterType.february:
        return Letter._(letterType: type, gifResource: "res/letters/201902_valentine.gif", title: februaryTitle, themeColor: Colors.redAccent);
      case LetterType.march:
        return Letter._(letterType: type, gifResource: "res/letters/201903_hinamaturi.gif", title: marchTitle, themeColor: Colors.pinkAccent);
      case LetterType.april:
        return Letter._(letterType: type, gifResource: "res/letters/201904_hanami.gif", title: aprilTitle, themeColor: Colors.pinkAccent);
      case LetterType.may:
        return Letter._(letterType: type, gifResource: "res/letters/201905_hiyori.gif", title: mayTitle, themeColor: Colors.green);
      case LetterType.june:
        return Letter._(letterType: type, gifResource: "res/letters/201906_halfAniver.gif", title: juneTitle, themeColor: Colors.green);
      case LetterType.july:
        return Letter._(letterType: type, gifResource: "res/letters/201907_asami.gif", title: julyTitle, themeColor: Colors.blueAccent);
      default:
        return null;
    }
  }

  final LetterType letterType;
  final String title;
  final String gifResource;
  final Color themeColor;

  static final String januaryTitle = "1月 ロックブーケとモニカの羽根つき";
  static final String februaryTitle = "2月 バレンタイン";
  static final String marchTitle = "3月 皆で楽しいひな祭り段";
  static final String aprilTitle = "4月 サガフロ勢で花見";
  static final String mayTitle = "5月 詩人と最終皇帝女の日常";
  static final String juneTitle = "6月 ハーフアニバーサリー";
  static final String julyTitle = "7月 アザミサービス";
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
