class Character {
  final String name;
  WeaponType _weaponType;

  final styleMap = Map<String, Style>();

  Character(this.name, weaponType) {
    _weaponType = WeaponType(weaponType);
  }

  String get toStringRanks => styleMap.keys.join(", ");

  String get mainWeaponType => _weaponType.name;
  String get weaponCategory => _weaponType.category;

  void addStyle(String rank, int str, int vit, int dex, int agi, int intelligence, int spi, int love, int attr) {
    styleMap.putIfAbsent(rank, () => _createStyle(str, vit, dex, agi, intelligence, spi, love, attr));
  }

  Style _createStyle(int str, int vit, int dex, int agi, int intelligence, int spi, int love, int attr) {
    return Style(str, vit, dex, agi, intelligence, spi, love, attr);
  }
}

class Style {
  final int str;
  final int vit;
  final int dex;
  final int agi;
  final int intelligence;
  final int spirit;
  final int love;
  final int attr;

  const Style(this.str, this.vit, this.dex, this.agi, this.intelligence, this.spirit, this.love, this.attr);
}

class WeaponType {
  final String name;
  String get category {
    switch (name) {
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

  WeaponType(this.name);
}
