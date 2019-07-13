import 'package:flutter/material.dart';

import 'otayori_detail_page.dart';

class OtayoriTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('運営からのお便り一覧'),
      ),
      body: Center(
        child: _widgetContents(context),
      ),
    );
  }

  Widget _widgetContents(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        otayoriButton(context, label: "1月 ロックブーケとモニカの羽根つき", resPath: "res/otayori/201901_hane.gif", color: Colors.orange),
        const SizedBox(height: 16.0),
        otayoriButton(context, label: "2月 バレンタイン", resPath: "res/otayori/201902_barentine.gif", color: Colors.redAccent),
        const SizedBox(height: 16.0),
        otayoriButton(context, label: "3月 皆で楽しいひな祭り段", resPath: "res/otayori/201903_hinamaturi.gif", color: Colors.pinkAccent),
        const SizedBox(height: 16.0),
        otayoriButton(context, label: "4月 サガフロ勢で花見", resPath: "res/otayori/201904_hanami.gif", color: Colors.pinkAccent),
        const SizedBox(height: 16.0),
        otayoriButton(context, label: "5月 詩人と最終皇帝女の日常", resPath: "res/otayori/201905_hiyori.gif", color: Colors.green),
        const SizedBox(height: 16.0),
        otayoriButton(context, label: "6月 ハーフアニバーサリー", resPath: "res/otayori/201906_halfAniver.gif", color: Colors.green),
        const SizedBox(height: 16.0),
        otayoriButton(context, label: "7月 アザミサービス", resPath: "res/otayori/201907_asami.gif", color: Colors.blueAccent),
      ],
    );
  }

  Widget otayoriButton(BuildContext context, {@required String label, @required String resPath, @required Color color}) {
    return OutlineButton(
      textColor: color,
      borderSide: BorderSide(color: color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtayoriDetailPage(
                    title: label,
                    gifRes: resPath,
                    themeColor: color,
                  )),
        );
      },
      child: Text(label),
    );
  }
}
