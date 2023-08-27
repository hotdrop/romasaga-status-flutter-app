import 'package:flutter/material.dart';

class RSColors {
  RSColors._();

  // 共通
  static const Color itemBackground = Color(0xFF4C4C4C);

  // スタイルChips
  static final Color chipAvatarBackground = Colors.grey.shade300;
  static const Color chipRankA = Color.fromARGB(255, 239, 201, 191);
  static const Color chipRankS = Color.fromARGB(255, 200, 204, 219);
  static const Color chipRankSS = Color.fromARGB(255, 233, 217, 77);

  // アイコン
  static const Color iconSelectedBackground = Colors.yellowAccent;

  // キャラクター一覧
  static const Color hpOnList = Color(0xFF699BFF);

  // キャラクター詳細
  static const Color totalStatusIndicator = Color(0xFF699BFF);
  static const Color stageNameLine = Color(0xFF87A0E5);
  static const Color stageLimitLine = Color(0xFFFFF987);
  static const Color statusNone = Colors.grey;
  static const Color statusIndicatorBackground = Color.fromARGB(255, 232, 232, 225);
  static const Color statusLack = Color(0xFFFF5E6A);
  static const Color statusNormal = Color(0xFF74FF97);
  static const Color statusSufficient = Color(0xFF26BCFF);

  static const Color favoriteSelected = Colors.amber;
  static const Color statusUpEventSelected = Colors.cyanAccent;

  // ステータス編集
  static const Color statusPlus = Colors.blue;
  static const Color statusMinus = Colors.red;
}
