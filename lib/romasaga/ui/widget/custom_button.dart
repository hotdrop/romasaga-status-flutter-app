import 'package:flutter/material.dart';

class CustomWidget {
  static Widget outlineButtonWithIcon({@required Icon icon, @required String text, @required Function onPressedListener}) {
    return Container(
      width: 100,
      child: OutlineButton(
        textColor: Colors.blue,
        borderSide: BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
        onPressed: () {
          onPressedListener();
        },
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[icon, Text(text, textAlign: TextAlign.center)],
            ),
          ],
        ),
      ),
    );
  }
}
