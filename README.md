# MyRS
Flutter学習用としてロマサガRSのステータス管理用アプリを作成しています。
アイコンなどの画像ファイルは著作権もありますので一切Git管理していません。
また、Firebaseも使用していますのでcloneしたコードそのままではアプリは動きません。

# 作成にあたっての方針
  - Flutterのみで完結させ、極力ネイティブコードには手を入れない
  - ネットワーク通信は最低限とする

電車などで素早く起動し閲覧したかったので、ネットワーク通信はアカウント画面の各機能と一部の画像ロード時のみとしています。  
画像は全部アプリに埋め込む手もあったのですが、スタイル画像やお便りは都度アプリを更新するのが面倒臭かったのでなるべくキャッシュする方針にしてネットワークから取得するようにしました。
 
# 利用しているサービス
Firebaseのみです。AuthenticationでGoogleアカウントと連携可能にしています。
ログインするとデータのバックアップと復元ができるようになっています。
  - Firebase Authentication
  - Firebase Storage
  - Firebase Firestore
  - Firebase Crashlytics

# 設計
自分がAndroidアプリ開発を生業としている関係で`Android Architecture Components`でのMVVM構成に慣れているため本アプリもAACに寄ったMVVMで作成しています。
状態管理はProvdierの`ChangeNotifierProvider`で行なっています。

# 環境
実際に使っているアプリとデバッグ用のアプリはAndroidのみ分割しておりProductFlavorの設定をしています。  
動作確認はAndroid Studioのmain.dart実行時のConfiguration設定で「Build flavor:」に"develop"を指定して行い、実際に個人端末で利用しているアプリは次のコマンドで作っています。
`flutter build apk --split-per-abi -t lib/romasaga/main.dart --release`

# 画面イメージ一部
![01](/images/01_char_list.png)  
![02](/images/02_char_detail_1.png)
![03](images/03_char_input_status.png)  
![04](images/04_search.png)
![0402](images/04_search_filter.png)  
![06](images/06_account.png)
