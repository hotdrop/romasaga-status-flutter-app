# MyRS
Flutter学習用として定期的にいじっているロマサガRSのステータス管理用アプリです。
アイコンは著作権があるのでGit管理対象にはしていません。

# 設計について
私がAndroidアプリ開発に慣れていることもありAACのMVVMをベースにしています。データ取得層は`Repository`パターンを採用しています。  
`ViewModel`は画面起動時の`StateNotifierProvider`、UiStateを保持する`StateNotifierProvider`の2つを持っています。分けている理由はいくつかありますが、一番は`ViewModel`をViewのライフサイクルに合わせたいためです。ただ、2つ持つと明らかに過剰になるケース（簡素な画面など）は1つにまとめています。  
詳細画面など前ページから渡されたデータを元にさらにデータを取得するようなケースでは、`family`と`overrideWithProvider`を組み合わせてnull許容しないようにしました。  
UiStateは画面データを保持しており、その`StateNotifierProvider`は外部に公開しないようにします。ViewでwatchするProviderは別に定義しUiStateの値をそれぞれ`select`しています。  
ViewはUiStateをwatchしている別のProvderをwatchし、UiStateは必ず`ViewModel`を経由して更新する、という設計にしました。
`ViewModel`はビジネスロジックと`family`で取得したデータのうち「Providerに切り出す必要はないがUiStateの更新に必要な不変な値（例えばキャラのIDや作品情報）」は持ってもいいかなと思ったので持っています。
ただ、ビジネスロジックについては`UiState`の方の`StateNotifierProvider`で書いた方が自然な場合もあって迷っています。一応集約した方が保守性が上がるかなと思って現在はなるべく`ViewModel`に書くようにしています。  
今のところこのような設計で落ち着きましたがまだ試行錯誤中です。  

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

# 画面イメージ一部
![01](/images/01_char_list.png)
![02](/images/02_char_detail.png)
![03](images/03_search.png)
![04](images/04_info.png)
![05](images/05_account.png)
