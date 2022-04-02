# MyRS
Flutter学習用として定期的にいじっているロマサガRSのステータス管理用アプリです。
アイコンは著作権があるのでGit管理対象にはしていません。

# 設計
自分がAndroidアプリ開発に慣れていることもありAACのMVVMをベースにしています。
状態管理はRiverpodで行っておりhooksは使っていません。

## hooksを使っていない理由
単にHookWidgetをextendsするのが嫌だったのでhook使ってなかったのですが、Riverpodv1.0.0でConsumerWidgetをextendsしないといけなくなったので、私の中でもはやhooksを使わない理由がなくなりました。
ただ、hooksもuseProviderがなくなって書き方が同じようになったので使うかどうかは微妙です。

## Riverpodの使い方
DIとして使っている箇所は全てref.readでProvider同士を参照しています。これは公式のMarvelアプリでも同じようにしていたので問題ないと思います。
ただ、色々と勘違いしていたのでリファクタリングしました。現在の作りだと各Pageの一番上でuiStateをwatchしてしまっているのとViewModelに状態を持ってしまっているので`read`と`watch`の利用区分けは意味をなしていませんでした。そのため、Widgetがwatchする状態は基本StateProviderかStateNotifierProviderに切り出しました。  

## 迷っているところ
前Pageから引き継ぐデータをどうするか迷っており、現在はViewModelにinitメソッドをつけてViewModelのフィールドとして持っています。  
ほとんどの場合、そういった前画面から受け取ったデータをもとにしたものをProviderで状態管理したいのですがその場合の設計で以下の３パターン思いつきました。
1. 引き継いだデータをProviderで持つ
   1. この場合、ページに遷移してきた際に100%データが存在するにもかかわらずProviderの型はnull許容しないといけないので、いちいち!をつけるのが嫌だなと思いました
2. 引き継いだデータはViewModelで持つ
   1. 現在これでコード書いてます。これだと各Providerの値をいちいちViewModelで初期設定しないといけないので嫌だなと思いました。（本当は１のように１つのProviderに値を入れたら他のProviderはwatchして勝手に最適なデータが流れてほしい）
3. 引き継ごうとするデータもProviderにする
   1. Page間やりとりも全部Providerでやればいいのでは？と思ったのですが、ページ遷移する際に「AとBのProviderに結果を入れてく必要がある」といちいち遷移時に考えないといけなくなるのはすごく嫌だなと思いました。これをやるなら全てのデータをProviderでやり取りするのがいいと思いますが（全てのProviderが相互作用すればページ遷移する際にXXのProviderに値が入っていない、というミスは無くなるのかなと）これをそのままやるとView層を巻き込んでProviderが複雑に絡み合ってしまうと思って躊躇しています。もしやるならPageごとにProviderを束ねるProviderを作るのが望ましいと思いましたがその場合はUI層の再検討が必要でした。
この問題は`character_detail_view_model.dart`がわかりやすいと思いますが、できることならViewModelで持っている`_character`や`_stage`はProviderにしたいと思っています。
現在の緩いMVVM設計は私が分かりやすいので基本は1画面1ViewModel（ChangeNotiferProvider）でいきたいと思っていますが、上記のような疑問が出るのはそもそもRiverpodを理解していない可能性も大きいので、どういう作りがベストなのかは模索中です。  

# Firebaseについて
Firebaseで利用しているサービスは次の通りです。
  - Authentication
    - Googleアカウントと連携しています。サインイン状態だと入力したキャラデータのバックアップと復元ができるようになります。
  - Storage
    - キャラ情報やお便りなど定期で更新されるデータをjsonで持っています。
  - Firestore
    - 自身で入力したステータス情報のバックアップと復元に使います。
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
