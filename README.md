# MyRS
Flutter学習用として定期的にいじっているロマサガRSのステータス管理用アプリです。
アイコンは著作権があるのでGit管理対象にはしていません。

# 設計
自分がAndroidアプリ開発に慣れていることもありAACのMVVMをベースにしていて、データ取得層は`Repository`パターンを採用しています。  
基本、クラスは`Riverpod`でDIをしており`ref.read`で`Provider`同士を参照しています。  
`View`レイヤーは、以前の作りだと各Pageの一番上で`uiState`を`watch`してしまっているのと`ViewModel`に状態を持ってしまっているので`read`と`watch`の利用区分けは意味をなしていませんでした。そのためWidgetが`watch`するデータは基本`StateProvider`か`StateNotifierProvider`に切り出しました。  
また、前Pageから引き継ぐデータをどう持つか悩んでいて３パターン思いついていました。
1. 引き継いだデータを`Provider`で持つ
   1. この場合、ページに遷移してきた際に100%データが存在するにもかかわらず定義する`Provider`の型はnull許容しないといけないのでいちいち!をつけるのが嫌だなと思いました。
2. 引き継いだデータを`ViewModel`で持つ
   1. 現在これでコード書いてます。ただ、この方法だと各`Provider`の値をいちいち`ViewModel`で初期設定しないといけないので嫌だなと思いました。本当は1のように1つの`Provider`に値を入れたら他の`Provider`は`watch`して勝手に最適なデータが流れてほしいです。
3. 引き継ごうとするデータ自体を`Provider`にする
   1. Page間やりとりも全部`Provider`でやればいいのでは？と思ったのですが、ページ遷移する際に「AとBの`Provider`に結果を入れてく必要がある」といちいち遷移時に考えないといけなくなるのはすごく嫌だなと思いました。
   2. これをやるなら全てのデータを`Provider`でやり取りするのがいいと思いますが（全ての`Provider`が相互作用すればページ遷移する際にXXの`Provider`に値が入っていない、というミスは無くなるのかなと）これをそのままやるとView層を巻き込んで`Provider`が複雑に絡み合ってしまうと思って躊躇しています。もしやるならPageごとに`Provider`を束ねる`Provider`を作るのが望ましいと思いましたがその場合はUI層の再検討が必要でした。

現在は上記1でnull許容せずに`overrideWithProvider`を使って初期値を入れる方法をとっています。  
`ViewModel`は不変な値とビジネスロジックのみとし、可変の値は`UiState`として`StateNotiferProvider`で定義しています。  
UiStateのそれぞれの値をwatchしたProviderを用意しView側はそれをwatchするのみという設計で今のところ落ち着きました。  

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
