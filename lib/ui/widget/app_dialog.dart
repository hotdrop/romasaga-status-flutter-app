import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/services.dart';
import 'package:rsapp/res/rs_strings.dart';

///
/// シンプルダイアログ
/// OKボタンは必須。キャンセルボタンは不要な場合、コンストラクで表示するダイアログの種類を切り替える。
///
/// ボタンを押すまで結果を待ちたい場合はshowを実行する際にawaitする。
/// iOSでAndroidのダイアログを表示すると違和感があるのでcupertinoデザインで表示している。
///
class AppDialog {
  const AppDialog._(
    this._title,
    this._message,
    this._okButtonLabel,
    this._onOk,
    this._cancelButtonLabel,
    this._onCancel,
    this._isShowCancelButton,
  );

  factory AppDialog.onlyOk({
    String? title,
    required String message,
    String? okLabel,
    Function? onOk,
  }) {
    return AppDialog._(
      title,
      message,
      okLabel ?? RSStrings.dialogOk,
      onOk,
      RSStrings.dialogCancel,
      null,
      false,
    );
  }

  factory AppDialog.okAndCancel({
    String? title,
    required String message,
    String? okLabel,
    required Function onOk,
    String? cancelLabel,
    Function? onCancel,
  }) {
    return AppDialog._(
      title,
      message,
      okLabel ?? RSStrings.dialogOk,
      onOk,
      cancelLabel ?? RSStrings.dialogCancel,
      onCancel,
      true,
    );
  }

  final String? _title;
  final String _message;
  final String _okButtonLabel;
  final Function? _onOk;
  final String _cancelButtonLabel;
  final Function? _onCancel;
  final bool _isShowCancelButton;

  Future<void> show(BuildContext context) async {
    if (Platform.isAndroid) {
      await _showMaterialDialog(context);
    } else {
      await _showCupertinoDialog(context);
    }
  }

  Future<void> _showMaterialDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: (_title != null) ? Text(_title!) : null,
          content: Text(_message),
          actions: <Widget>[
            if (_isShowCancelButton)
              TextButton(
                onPressed: () => _onActionCancel(context),
                child: Text(_cancelButtonLabel),
              ),
            TextButton(
              onPressed: () => _onActionOk(context),
              child: Text(_okButtonLabel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCupertinoDialog(BuildContext context) async {
    await cupertino.showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return cupertino.CupertinoAlertDialog(
          title: (_title != null) ? Text(_title!) : null,
          content: Text(_message),
          actions: <Widget>[
            if (_isShowCancelButton)
              cupertino.CupertinoDialogAction(
                onPressed: () => _onActionCancel(context),
                child: Text(_cancelButtonLabel),
              ),
            cupertino.CupertinoDialogAction(
              onPressed: () => _onActionOk(context),
              child: Text(_okButtonLabel),
            ),
          ],
        );
      },
    );
  }

  void _onActionOk(BuildContext context) {
    Navigator.pop(context);
    _onOk?.call();
  }

  void _onActionCancel(BuildContext context) {
    Navigator.pop(context);
    _onCancel?.call();
  }
}

///
/// ダイアログ表示するとともに現在のページを閉じたい場合に使用する
///
class AppDialogWithClosePage {
  const AppDialogWithClosePage(this._message);

  final String _message;

  Future<void> show(BuildContext context) async {
    await AppDialog.onlyOk(message: _message, onOk: () => _closePage(context)).show(context);
  }

  void _closePage(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      // iOSはアプリ側が勝手にアプリを終了してはならないのでelse文は実装しない
    }
  }
}
