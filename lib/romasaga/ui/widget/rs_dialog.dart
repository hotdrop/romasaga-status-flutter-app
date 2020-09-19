import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';

class RSDialog {
  const RSDialog._(
    this._type,
    this._title,
    this._description,
    this._successMessage,
    this._errorMessage,
    this._onOkPress,
    this._onCancelPress,
    this._onSuccessOkPress,
  );

  factory RSDialog.createInfo(
      {@required String title,
      @required String description,
      @required String successMessage,
      @required String errorMessage,
      @required Future<bool> Function() onOkPress,
      void Function() onCancelPress,
      void Function() onSuccessOkPress}) {
    return RSDialog._(
      DialogType.INFO,
      title,
      description,
      successMessage,
      errorMessage,
      onOkPress,
      onCancelPress,
      onSuccessOkPress,
    );
  }

  final DialogType _type;
  final String _title;
  final String _description;
  final String _successMessage;
  final String _errorMessage;
  final Future<bool> Function() _onOkPress;
  final void Function() _onCancelPress;
  final void Function() _onSuccessOkPress;

  Future<void> show(BuildContext context) async {
    return AwesomeDialog(
      context: context,
      dialogType: _type,
      title: _title,
      desc: _description,
      btnCancelOnPress: (_onCancelPress != null) ? _onCancelPress : () {},
      btnOkOnPress: () async {
        await _executeWithStateDialog(context);
      },
    ).show();
  }

  Future<void> _executeWithStateDialog(BuildContext context) async {
    final progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    await progressDialog.show();
    final isSuccess = await _onOkPress();
    await progressDialog.hide();
    if (isSuccess) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        title: RSStrings.dialogTitleSuccess,
        desc: _successMessage,
        btnOkOnPress: (_onSuccessOkPress != null) ? () => _onSuccessOkPress() : () {},
      ).show();
    } else {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        title: RSStrings.dialogTitleError,
        desc: _errorMessage,
        btnOkOnPress: () {},
      ).show();
    }
  }
}

class RSSimpleDialog {
  const RSSimpleDialog({
    @required this.message,
    @required this.onOkPress,
    this.onCancelPress,
  });

  final String message;
  final void Function() onOkPress;
  final void Function() onCancelPress;

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text(RSStrings.simpleDialogCancelLabel),
              onPressed: () {
                if (onCancelPress != null) {
                  onCancelPress();
                }
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text(RSStrings.simpleDialogOkLabel),
              onPressed: () {
                onOkPress();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
