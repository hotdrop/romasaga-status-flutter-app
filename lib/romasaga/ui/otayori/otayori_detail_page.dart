import 'package:flutter/material.dart';

class OtayoriDetailPage extends StatelessWidget {
  OtayoriDetailPage({@required this.gifRes, @required this.title, @required this.themeColor});

  final String title;
  final String gifRes;
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("運営からのお便り詳細"),
      ),
      body: Center(
        child: _widgetContents(),
      ),
    );
  }

  Widget _widgetContents() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 16.0),
        _widgetTitle(),
        const SizedBox(height: 16.0),
        _widgetImageGif(),
      ],
    );
  }

  Widget _widgetTitle() {
    return Text(
      title,
      style: TextStyle(fontSize: 24.0, color: themeColor, shadows: [
        Shadow(color: Colors.grey, offset: Offset(1, 2), blurRadius: 2),
      ]),
    );
  }

  Widget _widgetImageGif() {
    return Image.asset(gifRes);
  }
}
