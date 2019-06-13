import 'character_style.dart';

class Character {
  final String name;

  final _styles = Map<String, CharaStyle>();
  CharaStyle _currentStatus;

  Character(this.name);

  addStyle(String rank, int str, int vit, int dex, int agi, int inte, int spi, int love, int attr) {
    _styles.putIfAbsent(rank, () => _createStyle(str, vit, dex, agi, inte, spi, love, attr));
  }

  currentStatus(int str, int vit, int dex, int agi, int inte, int spi, int love, int attr) {
    _currentStatus = _createStyle(str, vit, dex, agi, inte, spi, love, attr);
  }

  CharaStyle _createStyle(int str, int vit, int dex, int agi, int inte, int spi, int love, int attr) {
    return CharaStyle(str, vit, dex, agi, inte, spi, love, attr);
  }

  static String toHeader() {
    return '        腕, 体,  器, 速, 知, 精,  愛, 魅';
  }

  String toStyleString() {
    var ret = "";
    _styles.forEach((rank, value) {
      var rankStr = rank.padRight(7, ' ');
      ret += "$rankStr ${value.toString()}\n";
    });
    return ret;
  }
}
