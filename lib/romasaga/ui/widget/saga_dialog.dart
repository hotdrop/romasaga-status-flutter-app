import 'package:flutter/material.dart';

class SagaDialog {
  final BuildContext context;
  final String message;
  final Function positiveListener;

  const SagaDialog(
    this.context, {
    @required this.message,
    @required this.positiveListener,
  });

  void show() {
    showDialog(
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
