class Character {
  final String name;
  final WeaponType weaponType;

  final _styleMap = Map<String, Style>();

  Character(this.name, this.weaponType);

  String get toStringRanks => _styleMap.keys.join(", ");
  String get category => weaponType.category;

  addStyle(String rank, int str, int vit, int dex, int agi, int intelligence, int spi, int love, int attr) {
    _styleMap.putIfAbsent(rank, () => _createStyle(str, vit, dex, agi, intelligence, spi, love, attr));
  }

  Style _createStyle(int str, int vit, int dex, int agi, int intelligence, int spi, int love, int attr) {
    return Style(str, vit, dex, agi, intelligence, spi, love, attr);
  }
}

class Style {
  final int _str;
  final int _vit;
  final int _dex;
  final int _agi;
  final int _int;
  final int _spirit;
  final int _love;
  final int _attr;

  const Style(this._str, this._vit, this._dex, this._agi, this._int, this._spirit, this._love, this._attr);
}

class WeaponType {
  final String _type;
  String get category {
    switch (_type) {
      case "剣":
      case "大剣":
      case "斧":
        return "斬";
      case "棍棒":
      case "体術":
      case "銃":
        return "打";
      case "小剣":
      case "槍":
      case "弓":
        return "突";
      case "杖":
        return "術";
      default:
        return "不明";
    }
  }

  WeaponType(this._type);
}
