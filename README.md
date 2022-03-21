# MyRS
Flutter学習用として定期的にいじっているロマサガRSのステータス管理用アプリです。
アイコンは著作権があるのでGit管理対象にはしていません。

# 設計
自分がAndroidアプリ開発に慣れていることもありAACのMVVMをベースにしています。
状態管理はRiverpodで行っておりhooksは使っていません。

<hooksを使っていない理由>  
単にHookWidgetをextendsするのが嫌だったのでhook使ってなかったのですが、Riverpodv1.0.0でConsumerWidgetをextendsしないといけなくなったので、私の中でもはやhooksを使わない理由がなくなりました。
ただ、hooksもuseProviderがなくなって書き方が同じようになったので使うかどうかは微妙です。

<Riverpodの使い方>  
DIとして使っている箇所は、全てref.readでProvider同士を参照しています。これは公式のMarvelアプリでも同じようにしていたので問題ないと思います。
ただ、色々とおかしい勘違いしていたので現在リファクタリング中です。今の作りだと各Pageの一番上でuiStateをwatchしてしまっているのとProviderで値を持っていないので`read`と`watch`の利用区分けは意味をなしていないと思われます。  
現在の設計（緩いMVVM）は私が分かりやすいので全値をProviderにするようなリファクタは考えていませんが、どういう作りがベストなのかは模索中です。

# Firebaseについて
Firebaseで利用しているサービスは次の通りです。
  - Authentication
    - Googleアカウントと連携しています。サインイン状態だと入力したキャラデータのバックアップと復元ができるようになります。
  - Storage
    - キャラ情報やお便りなど定期で更新されるデータをjsonで持っています。
  - Firestore
    - 自身で入力したステータス情報のバックアップと復元に使います。
  - Crashlytics
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
