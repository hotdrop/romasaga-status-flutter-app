class Character {
  final String name;

  final _styleMap = Map<String, Style>();

  Character(this.name);

  addStyle(String rank, int str, int vit, int dex, int agi, int inte, int spi, int love, int attr) {
    _styleMap.putIfAbsent(rank, () => _createStyle(str, vit, dex, agi, inte, spi, love, attr));
  }

  Style _createStyle(int str, int vit, int dex, int agi, int inte, int spi, int love, int attr) {
    return Style(str, vit, dex, agi, inte, spi, love, attr);
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
