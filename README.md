# MyRS
Flutterの学習用で作成したロマサガRSのステータス管理用アプリです。  
アイコンなど画像ファイルは一切Git管理していないのでそのままでは動きません。  

# 作成にあたっての方針
  - Flutterのみで完結ネイティブコードには手を入れない
  - ネットワーク通信は最低限

電車などでサッと起動して閲覧したかったので、アカウント画面の各機能と各キャラの画像アイコン初回ロード時のみネットワーク通信をします。
 
# 利用している外部サービス
  - Firebase Authentication
  - Firebase Storage
  - Firebase Firestore
  - Firebase Crashlytics

# 設計
自分はAACでのMVVM構成に慣れてしまったため、このアプリもAACによったMVVMで作成しました。  
BLoCパターンは利用しておらず、状態管理はProvdierのChangeNotifierProviderで行なっています。

# 環境
実際に使っているアプリとデバッグ用アプリが混在するのを避けるためAndroidだけProductFlavorの設定をしています。
AndroidStudioのmain.dart実行時のConfiguration設定で「Build flavor:」に"develop"を指定します。
