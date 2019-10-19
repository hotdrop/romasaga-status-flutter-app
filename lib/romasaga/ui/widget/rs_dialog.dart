import 'package:flutter/material.dart';

class RSDialog {
  const RSDialog(
    this.context, {
    @required this.message,
    @required this.positiveListener,
  });

  final BuildContext context;
  final String message;
  final Function positiveListener;

  void show() {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                positiveListener();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
