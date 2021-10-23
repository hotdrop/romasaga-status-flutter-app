import 'package:rsapp/models/character.dart';

///
/// TODO キャラのランキング。この機能いらない
///
class Ranking {
  Ranking(
    List<Character> strTop5,
    List<Character> vitTop5,
    List<Character> dexTop5,
    List<Character> agiTop5,
    List<Character> intTop5,
    List<Character> spiritTop5,
    List<Character> loveTop5,
    List<Character> attrTop5,
  ) {
    Map<int, RankingCharacter> resultMap = {};

    for (var idx = 0; idx < strTop5.length; idx++) {
      var id = strTop5[idx].id;
      if (resultMap.containsKey(id)) {
        resultMap[id]!.strRanking = idx + 1;
      } else {
        resultMap[id] = RankingCharacter(strTop5[idx], strRanking: idx + 1);
      }
    }

    for (var idx = 0; idx < vitTop5.length; idx++) {
      var id = vitTop5[idx].id;
      if (resultMap.containsKey(id)) {
        resultMap[id]!.vitRanking = idx + 1;
      } else {
        resultMap[id] = RankingCharacter(vitTop5[idx], vitRanking: idx + 1);
      }
    }

    for (var idx = 0; idx < dexTop5.length; idx++) {
      var id = dexTop5[idx].id;
      if (resultMap.containsKey(id)) {
        resultMap[id]!.dexRanking = idx + 1;
      } else {
        resultMap[id] = RankingCharacter(dexTop5[idx], dexRanking: idx + 1);
      }
    }

    for (var idx = 0; idx < agiTop5.length; idx++) {
      var id = agiTop5[idx].id;
      if (resultMap.containsKey(id)) {
        resultMap[id]!.agiRanking = idx + 1;
      } else {
        resultMap[id] = RankingCharacter(agiTop5[idx], agiRanking: idx + 1);
      }
    }

    for (var idx = 0; idx < intTop5.length; idx++) {
      var id = intTop5[idx].id;
      if (resultMap.containsKey(id)) {
        resultMap[id]!.intRanking = idx + 1;
      } else {
        resultMap[id] = RankingCharacter(intTop5[idx], intRanking: idx + 1);
      }
    }

    for (var idx = 0; idx < spiritTop5.length; idx++) {
      var id = spiritTop5[idx].id;
      if (resultMap.containsKey(id)) {
        resultMap[id]!.spiritRanking = idx + 1;
      } else {
        resultMap[id] = RankingCharacter(spiritTop5[idx], spiritRanking: idx + 1);
      }
    }

    for (var idx = 0; idx < loveTop5.length; idx++) {
      var id = loveTop5[idx].id;
      if (resultMap.containsKey(id)) {
        resultMap[id]!.loveRanking = idx + 1;
      } else {
        resultMap[id] = RankingCharacter(loveTop5[idx], loveRanking: idx + 1);
      }
    }

    for (var idx = 0; idx < attrTop5.length; idx++) {
      var id = attrTop5[idx].id;
      if (resultMap.containsKey(id)) {
        resultMap[id]!.attrRanking = idx + 1;
      } else {
        resultMap[id] = RankingCharacter(attrTop5[idx], attrRanking: idx + 1);
      }
    }

    _rankingCharacters = resultMap.values.toList();
  }

  late List<RankingCharacter> _rankingCharacters;

  RankingCharacter? getTop() {
    RankingCharacter? result;
    for (var value in _rankingCharacters) {
      if (result == null) {
        result = value;
      } else if (result.rankingPoint() > value.rankingPoint()) {
        result = value;
      }
    }
    return result;
  }
}

class RankingCharacter {
  RankingCharacter(
    this.character, {
    int? strRanking,
    int? vitRanking,
    int? dexRanking,
    int? agiRanking,
    int? intRanking,
    int? spiritRanking,
    int? loveRanking,
    int? attrRanking,
  }) {
    this.strRanking = (strRanking != null) ? strRanking : _defaultRanking;
    this.vitRanking = (vitRanking != null) ? vitRanking : _defaultRanking;
    this.dexRanking = (dexRanking != null) ? dexRanking : _defaultRanking;
    this.agiRanking = (agiRanking != null) ? agiRanking : _defaultRanking;
    this.intRanking = (intRanking != null) ? intRanking : _defaultRanking;
    this.spiritRanking = (spiritRanking != null) ? spiritRanking : _defaultRanking;
    this.loveRanking = (loveRanking != null) ? loveRanking : _defaultRanking;
    this.attrRanking = (attrRanking != null) ? attrRanking : _defaultRanking;
  }

  final Character character;

  // ランク外は6位とする
  static const int _defaultRanking = 6;

  late int strRanking;
  late int vitRanking;
  late int dexRanking;
  late int agiRanking;
  late int intRanking;
  late int spiritRanking;
  late int loveRanking;
  late int attrRanking;

  ///
  /// これかなり適当
  ///
  int rankingPoint() {
    return strRanking + vitRanking + dexRanking + agiRanking + intRanking + spiritRanking + loveRanking + attrRanking;
  }

  List<int> toStatuses() {
    return [strRanking, vitRanking, dexRanking, agiRanking, intRanking, spiritRanking, loveRanking, attrRanking];
  }
}
