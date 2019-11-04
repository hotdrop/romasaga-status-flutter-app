import 'package:flutter/material.dart';

class RSColors {
  static const Color accent = Colors.blueAccent;
  static const Color bottomNavigation = Colors.white;
  static const Color bottomNavigationIcon = Colors.black87;
  static const Color bottomNavigationText = Colors.black87;

  // common
  static const Color background = Color(0xFFFFFFFF);
  static const Color divider = Colors.white70;
  static const Color subText = Colors.grey;
  static const Color staticIcon = Colors.white;
  static const Color textAttention = Colors.yellowAccent;

  // Chip
  static final Color chipBackground = Colors.grey.shade600;
  static final Color chipAvatarBackground = Colors.grey.shade300;
  static const Color chipRankA = Color.fromARGB(255, 239, 201, 191);
  static final Color chipRankS = Color.fromARGB(255, 200, 204, 219);
  static final Color chipRankSS = Color.fromARGB(255, 233, 217, 77);

  // アイコン
  static final Color weaponIconSelectedBackground = Colors.yellowAccent;
  static final Color weaponIconUnSelectedBackground = Colors.grey;

  // キャラクター詳細（検証用。いずれ下のキャラ詳細は全部消す）
  static const Color characterDetailCardShadow = Color(0xFF3A5160);
  static const Color characterDetailTotalStatusIndicator = Color(0xFF699BFF);
  static const Color characterDetailHpLabel = Color(0xFF87A0E5);
  static const Color characterDetailStylesLabel = Color(0xFFFFF987);

  static const Color characterDetailStatusNone = Colors.grey;
  static const Color characterDetailStatusBackground = Colors.white;
  static const Color characterDetailStatusLack = Color(0xFFFF5E6A);
  static const Color characterDetailStatusNormal = Color(0xFF74FF97);
  static const Color characterDetailStatusSufficient = Color(0xFF26BCFF);

  // キャラ詳細画面
  static const Color charDetailIconBackground = Colors.grey;
  static const Color fabBackground = Colors.white30;

  // キャラ詳細画面 - ステータス
  static const Color statusNone = Colors.black;
  static const Color statusNoneGraphStart = Colors.black;
  static const Color statusNoneGraphEnd = Colors.black;

  // 検索
  static const Color filterText = Colors.white;

  // お便り画面
  static const Color thumbnailCardBackground = Color(0xFF4C4C4C);
  static const Color titleShadow = Colors.grey;
  static const Color winter = Colors.orange;
  static const Color spring = Colors.pinkAccent;
  static const Color summer = Colors.blueAccent;
  static const Color fall = Color(0xFFF2E100);

  // アカウント画面
  static const Color dataLoadStatusNone = Colors.grey;
  static const Color dataLoadStatusLoading = Colors.green;
  static const Color dataLoadStatusComplete = Colors.blueAccent;
  static const Color dataLoadStatusError = Colors.redAccent;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
