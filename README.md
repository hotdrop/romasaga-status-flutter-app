![platform](https://img.shields.io/badge/platform-flutter-blue.svg)
![test workflow](https://github.com/hotdrop/romasaga-status-flutter-app/actions/workflows/main.yml/badge.svg)
![GitHub Release](https://img.shields.io/github/release/hotdrop/romasaga-status-flutter-app.svg?style=flat)

# RSApp
ロマサガRSの所持キャラステータス管理用アプリです。Flutter学習用として作成しました。  
assetsを管理対象外にすると吹っ飛んだ時に辛すぎたのでもうアイコンくらいなら管理対象にしていいかと思った。

# 設計について
私がAndroidアプリ開発に慣れていることもありAACのMVVMをベースに設計しています。  
データ取得層は`Repository`パターンを採用しています。  

`ViewModel`は、基本以下の3つで構成しています。  
1. 画面起動時の`Provider`(riverpodアノテーションで生成）
2. ロジックを集約したProvider
3. UiStateを保持する`StateProvider`

2は画面起動時にキャラIDなどの引数をもらうProviderを生成している場合に作っていています。引数がない場合は1と2はまとめています。
また、note_pageなどUiStateを作ると煩雑になる場合は1のみ実装しています。   

`UiState`を保持する`StateProvider`はそのまま画面の状態を保持します。  
ただし、キャラ詳細画面やステータス編集画面など前の画面の詳細情報を扱う場合、キャラデータを`UiState`で持ってしまうより直接参照・更新した方がSSOTに沿えるため`UiState`では管理していません。  
また、`UiState`は`private`にしていて`View`から`watch`する`Provider`は別に定義しています。  
`UiState`の値はそれぞれ`select`で`watch`することで「`UiState`は必ず`ViewModel`を経由して更新する」という設計にしました。

今のところこのような設計で落ち着きました。  

# Firebaseについて
Firebaseで利用しているサービスは次の通りです。
  - Authentication
    - Googleアカウントと連携しています。サインイン状態だと入力したキャラデータのバックアップと復元ができるようになります。
  - Storage
    - キャラデータをjsonで持っています。
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
