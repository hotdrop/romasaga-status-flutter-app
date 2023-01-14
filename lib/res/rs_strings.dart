class RSStrings {
  RSStrings._();

  // 共通
  static const String appTitle = 'ロマサガRSステータス管理';
  static const String nowLoading = 'Now Loading...';

  static const String bottomMenuCharacter = 'キャラ';
  static const String bottomMenuSearch = '検索';
  static const String bottomMenuNote = 'メモ';
  static const String bottomMenuInformation = '情報';
  static const String bottomMenuAccount = 'アカウント';

  static const String charactersPageTitle = 'キャラ一覧';
  static const String charactersPageTabStatusUp = 'ステUP';
  static const String charactersPageTabHighLevel = '高難';
  static const String charactersPageTabAround = '周回用';
  static const String charactersPageTabFavorite = 'お気入';
  static const String charactersPageTabNotFavorite = '未育成';
  static const String charactersOrderStatus = 'ステータス';
  static const String charactersOrderHp = 'HP';
  static const String charactersOrderProduction = '作品';
  static const String nothingCharactersLabel = '該当キャラはいません。';
  static const String characterTotalStatus = '計: ';

  // キャラ詳細
  static const String detailPageTitle = 'キャラ詳細';
  static const String detailPageTotalStatusLabel = 'Total Status';
  static const String detailPageStageLabel = 'ステージ情報';
  static const String detailPageStatusLimitLabel = 'ステータス上限';
  static const String detailPageChangeStyleIconDialogMessage = 'このアイコンを一覧表示用にしますか？';
  static const String detailPageRefreshIconDialogMessage = 'アイコン情報をサーバーから再取得します。よろしいですか？';
  static const String detailPageStatusTableLabel = 'ステータス上限表';

  static const String highLevelLabel = '高';
  static const String aroundLabel = '周';
  static const String statusEditTitle = 'ステータス編集';

  // 検索
  static const String searchPageTitle = '検索';
  static const String searchListQueryHint = 'キャラ名で検索';
  static const String searchBackDropTitle = 'キャラ一覧';
  static const String searchNoDataLabel = '該当キャラはいません。';
  static const String searchFilterClearWeapon = '武器種別をクリア';
  static const String searchFilterClearAttributes = '属性をクリア';
  static const String searchFilterClearProduction = '作品をクリア';

  // ノート
  static const String notePageTitle = '簡易メモ';

  // 情報
  static const String infoPageTitle = '公式情報';
  static const String infoOfficialUrl = 'https://info.rs.aktsk.jp/info/';

  // アカウント画面
  static const String accountPageTitle = 'アカウント';
  static const String accountNotSignInLabel = '未ログイン';
  static const String accountNotSignInNameLabel = 'ー';
  static const String accountChangeThemeLabel = 'テーマの切り替え';
  static const String accountLicenseLabel = 'バージョンとライセンス';
  static const String accountSignInButton = 'Googleアカウントでサインインする';
  static const String accountSignOutButton = 'Googleアカウントからサインアウトする';
  static const String accountSignOutDialogMessage = 'Googleアカウントからサインアウトします。よろしいですか？';
  static const String accountCharacterUpdateLabel = 'キャラ情報更新';
  static const String accountCharacterDetailLabel = '最新のキャラ情報に更新します。';
  static const String accountCharacterUpdateDialogMessage = 'サーバーから最新のキャラ情報を取得し更新します。\nよろしいですか？';
  static const String accountCharacterUpdateDialogSuccessMessage = 'キャラ情報の更新に成功しました。';
  static const String accountStageLabel = 'ステージ情報';
  static const String accountStageDetailLabel = 'ステージ情報を編集します。';
  static const String accountStatusBackupLabel = 'バックアップ';
  static const String accountStatusBackupDateLabel = '前回実行日:';
  static const String accountStatusBackupNotLabel = 'ー';
  static const String accountStatusBackupDialogMessage = '現在のキャラステータスをサーバーへバックアップします。\nよろしいですか？';
  static const String accountStatusBackupDialogSuccessMessage = 'バックアップに成功しました。';
  static const String accountStatusRestoreLabel = '復元';
  static const String accountStatusRestoreDetailLabel = 'アプリ内のデータを上書きします。';
  static const String accountStatusRestoreDialogMessage = 'サーバーにバックアップしたキャラステータスを復元します。\n現在のステータスは全て消えますがよろしいですか？';
  static const String accountStatusRestoreDialogSuccessMessage = '復元に成功しました。';

  // ステージ情報
  static const String stageEditPageTitle = 'ステージ情報編集';
  static const String stageEditPageOverview = '【ステータス上限値の補足】\nステータス上限値はVH6を0で計算しています。\n一般的なサイトの上限値を参考にする場合は-45してください。';
  static const String stageEditPageNameLabel = 'ステージ名';
  static const String stageEditPageHpLimitLabel = 'HP上限';
  static const String stageEditPageStatusLimitLabel = 'ステ上限';
  static const String stageEditPageSaveLabel = 'この内容で更新する';

  // ダイアログ
  static const String dialogTitleSuccess = '成功';
  static const String dialogTitleError = 'エラー';
  static const String dialogOk = 'OK';
  static const String dialogCancel = 'Cancel';

  // ステータス
  static const String hpName = 'HP';
  static const String strName = '腕力';
  static const String vitName = '体力';
  static const String dexName = '器用';
  static const String agiName = '素早';
  static const String intName = '知力';
  static const String spiName = '精神';
  static const String loveName = '愛';
  static const String attrName = '魅力';

  static const String rankSS = 'SS';
  static const String rankS = 'S';
  static const String rankA = 'A';

  static const String sword = '剣';
  static const String largeSword = '大剣';
  static const String axe = '斧';
  static const String hummer = '棍棒';
  static const String knuckle = '体術';
  static const String gun = '銃';
  static const String rapier = '小剣';
  static const String spear = '槍';
  static const String bow = '弓';
  static const String rod = '杖';

  static const String attributeFire = '火';
  static const String attributeCold = '水';
  static const String attributeWind = '風';
  static const String attributeSoil = '土';
  static const String attributeThunder = '雷';
  static const String attributeDark = '闇';
  static const String attributeShine = '光';

  // 作品（キャラjsonに設定されている文字列）
  static const String productRomaSaga1 = 'ロマンシング・サガ1';
  static const String productRomaSaga2 = 'ロマンシング・サガ2';
  static const String productRomaSaga3 = 'ロマンシング・サガ3';
  static const String productSagaFro1 = 'サガ・フロンティア1';
  static const String productSagaFro2 = 'サガ・フロンティア2';
  static const String productSagaSca = 'サガスカーレットグレイス';
  static const String productUnLimited = 'アンリミテッド・サガ';
  static const String productEmperorsSaga = 'エンペラーズサガ';
  static const String productRomaSagaRS = 'ロマンシング・サガRS';
  static const String productSaga = '魔界塔士 Sa・Ga';
  static const String productSaga2 = 'Sa・Ga2 秘宝伝説';
  static const String productSaga3 = 'Sa・Ga3 時空の覇者';
}
