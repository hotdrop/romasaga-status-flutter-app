class CharaStyle {
  final int _str;
  final int _vit;
  final int _dex;
  final int _agi;
  final int _int;
  final int _spirit;
  final int _love;
  final int _attr;

  const CharaStyle(this._str, this._vit, this._dex, this._agi, this._int, this._spirit, this._love, this._attr);

  String toString() {
    return '$_str, $_vit, $_dex, $_agi, $_int, $_spirit, $_love, $_attr';
  }
}
