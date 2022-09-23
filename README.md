# MyRS
Flutter学習用として定期的にいじっているロマサガRSのステータス管理用アプリです。
アイコンは著作権があるのでGit管理対象にはしていません。

# 設計について
私がAndroidアプリ開発に慣れていることもありAACのMVVMをベースに実装しています。  
データ取得層は`Repository`パターンを採用しています。  

`ViewModel`は、画面起動時の`StateNotifierProvider`とUiStateを保持する`StateNotifierProvider`の2つで構成しています。  
(この構成が過剰になる簡素な画面では1つにまとめています。)

画面起動時の`StateNotifierProvider`は`ViewModel`本体としてビジネスロジックとスコープ内の一部の不変値を持つようにしています。  
スコープ内の一部の不変値というのは`family`で取得したデータのうち「Providerに切り出す必要はないがUiStateの更新に必要な不変な値（例えばキャラのIDや作品情報）」を指しています。  

これらの値は`ViewModel`で持っていた方が楽だったので持っていますが、ここで持つべきかは疑問に思っています。  
また、`ViewModel`はViewのライフサイクルと同様にするため`autoDispose`を必ずつけています。  

UiStateを保持する`StateNotifierProvider`はそのまま画面の状態を保持します。  
この`StateNotifierProvider`は外部に公開せずViewでwatchするProviderは別に定義してUiStateの値をそれぞれ`select`し「UiStateは必ず`ViewModel`を経由して更新する」という設計にしました。

ビジネスロジックについては`UiState`の方の`StateNotifierProvider`で書いた方が自然な場合もあって迷っています。  
一応集約した方が保守性が上がるかなと思って現在はなるべく`ViewModel`に書くようにしています。  

今のところこのような設計で落ち着きました。  

# Firebaseについて
Firebaseで利用しているサービスは次の通りです。
  - Authentication
    - Googleアカウントと連携しています。サインイン状態だと入力したキャラデータのバックアップと復元ができるようになります。
  - Storage
    - キャラ情報やお便りなど定期で更新されるデータをjsonで持っています。
  - Firestore
    - 自身で入力したステータス情報のバックアップと復元に使います。
  - Crashlytics
    - クラッシュレポート

# 環境
実際に使っているアプリとデバッグ用のアプリはBuildTypeで分割しています。  
キャラデータが全て入ったjsonをいちいち読み込んで動作確認するのが辛かったため、動作確認は`main_dev.dart`で開発用のjsonを読み込むようにしています。  
開発はvscodeでやっているので`launch.json`のprogramにこのdartファイルを指定してデバッグしています。  
`launch.json`例です。  
```launch.json
{
  "configurations": [
    {
      "name": "romansing_saga_app",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart",
    }
  ]
}
```

# 画面イメージ一部
![01](/images/01_char_list.png)
![0201](/images/02_char_detail_01.png)
![0202](/images/02_char_detail_02.png)
![03](/images/03_search.png)
![04](/images/04_info.png)
![05](/images/05_account.png)
