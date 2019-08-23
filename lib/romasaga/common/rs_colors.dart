import 'package:flutter/material.dart';

class RSColors {
  static const Color bottomNavigationIcon = Colors.black12;
  static const Color divider = Colors.white70;
  static const Color subText = Colors.grey;
  static const Color staticIcon = Colors.white;

  // Chip
  static final Color chipBackground = Colors.grey.shade600;
  static final Color chipAvatarBackground = Colors.grey.shade300;
  static const Color chipRankA = Color.fromARGB(255, 239, 201, 191);
  static final Color chipRankS = Color.fromARGB(255, 200, 204, 219);
  static final Color chipRankSS = Color.fromARGB(255, 233, 217, 77);

  // アイコン
  static final Color weaponIconSelectedBackground = Colors.yellowAccent;
  static final Color weaponIconUnSelectedBackground = Colors.grey;

  // キャラ詳細画面
  static const Color charDetailBackground = Colors.grey;
  static const Color fabBackground = Colors.white30;

  // キャラ詳細画面 - ステータス
  static const Color statusNone = Colors.black;

  static const Color statusLack = Colors.red;
  static const Color statusLackGraphStart = Color.fromARGB(255, 167, 167, 100);
  static const Color statusLackGraphEnd = Colors.redAccent;

  static const Color statusNormal = Colors.green;
  static const Color statusNormalGraphStart = Color.fromARGB(255, 0, 200, 0);
  static const Color statusNormalGraphEnd = Colors.greenAccent;

  static const Color statusSufficient = Colors.blue;
  static const Color statusSufficientGraphStart = Color.fromARGB(255, 0, 100, 255);
  static const Color statusSufficientGraphEnd = Colors.blueAccent;

  // お便り画面
  static const Color titleShadow = Colors.grey;
  static const Color winter = Colors.orange;
  static const Color spring = Colors.pinkAccent;
  static const Color summer = Colors.blueAccent;

  // アカウント画面
  static const Color dataLoadStatusNone = Colors.grey;
  static const Color dataLoadStatusLoading = Colors.green;
  static const Color dataLoadStatusComplete = Colors.blueAccent;
  static const Color dataLoadStatusError = Colors.redAccent;
}
