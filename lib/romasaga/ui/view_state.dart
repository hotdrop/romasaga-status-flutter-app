///
/// 画面でのロード中 or ロード完了を表すため作成したクラス
/// クラスにしてViewModelで持たせるのは嫌だったのでmixinで逃げている。
/// ステータスだけ持っているのがすごく微妙。
/// Resultクラスのように結果も持てばもう少し気にならなくなるのかもしれないが・・・
///
mixin ViewState {
  _State _state = _State.none;

  bool get isLoading => _state == _State.loading;
  bool get isSuccess => _state == _State.success;
  bool get isError => _state == _State.error;

  void onLoading() {
    _state = _State.loading;
  }

  void onSuccess() {
    _state = _State.success;
  }

  void onError() {
    _state = _State.error;
  }
}

enum _State { none, loading, success, error }
