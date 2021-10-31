class RSStrings {
  RSStrings._();

  static const String appTitle = 'ロマサガRSステータス管理';

  static const String bottomMenuCharacter = 'キャラ';
  static const String bottomMenuSearch = '検索';
  static const String bottomMenuLetter = 'お便り';
  static const String bottomMenuAccount = 'アカウント';
  static const String bottomMenuDashboard = 'ボード';

  static const String charactersPageTitle = 'キャラ一覧';
  static const String charactersPageTabStatusUp = '育成対象';
  static const String charactersPageTabFavorite = 'お気に入り';
  static const String charactersPageTabNotFavorite = '全キャラ';
  static const String charactersOrderStatus = 'ステータス';
  static const String charactersOrderHp = 'HP';
  static const String charactersOrderProduction = '作品';
  static const String nothingCharactersLabel = '該当キャラはいません。';

  static const String characterTotalStatus = '計: ';

  static const String characterDetailPageTitle = 'キャラ詳細';
  static const String characterDetailTotalStatusCircleLabel = 'Total Status';
  static const String characterDetailTotalLimitStatusLabel = 'Total Limit Status';
  static const String characterDetailChangeStyleIconDialogMessage = 'このアイコンを一覧表示用にしますか？';
  static const String characterRefreshIconDialogDesc = 'このアイコンをサーバーから再取得します。よろしいですか？';
  static const String characterDetailStageSelectDescLabel = 'カッコの値はステータス上限です。';
  static const String characterDetailStatusTableLabel = 'ステータス上限表';
  static const String characterDetailLoadingErrorMessage = 'キャラ情報のロードに失敗しました。';

  static const String statusEditTitle = 'ステータス編集';

  static const String searchPageTitle = '検索';
  static const String searchListQueryHint = 'キャラ名で検索';
  static const String searchBackDropTitle = 'キャラ一覧';
  static const String searchFilterTitleOwn = 'フィルター';
  static const String searchFilterTitleWeapon = '武器種別';
  static const String searchFilterTitleAttributes = '属性別';
  static const String searchFilterTitleProduction = '作品別';
  static const String searchFilterClear = 'クリア';
  static const String searchFilterLoadingErrorMessage = 'キャラ情報のロードに失敗しました。';

  static const String letterPageTitle = '運営からのお便り';
  static const String letterPageNotData = 'お便り情報がロードされていません。'
      '\nアカウント画面よりお便り情報を取得してください。'
      '\n\n（お便り情報取得時はネットワーク通信を行いますのでご注意ください。）';
  static const String letterDetailPageTitle = '運営からのお便り詳細';
  static const String letterNothingMessage = '運営からのお便りデータが0件でした。';
  static const String letterLoadingErrorMessage = '運営からのお便りデータ取得に失敗しました。';
  static const String letterNowLoading = 'Now Loading...';
  static const String letterLoadingFailure = '画像取得エラー！';
  static const String letterYearLabel = '年';
  static const String letterMonthLabel = '月';

  // ダッシュボード画面
  static const String dashboardPageTitle = 'ダッシュボード';
  static const String dashboardPageFavoriteCharLabel = 'お気に入り数';
  static const String dashboardPageHaveCharLabel = '保持キャラ数';
  static const String dashboardPageAllCharLabel = '全キャラ数';
  static const String dashboardPageTopCharacterLabel = '現在の総合ランキングトップキャラ';
  static const String dashboardPageLoadingErrorMessage = 'キャラ情報のロードに失敗しました。';
  static const String strL = '力';
  static const String vitL = '体';
  static const String dexL = '器';
  static const String agiL = '早';
  static const String intL = '知';
  static const String spiL = '精';
  static const String loveL = '愛';
  static const String attrL = '魅';

  // アカウント画面
  static const String accountPageTitle = 'アカウント';
  static const String accountNotLoginEmailLabel = '未ログイン';
  static const String accountNotLoginNameLabel = 'ー';
  static const String accountChangeApplicationThemeLabel = 'テーマの切り替え';
  static const String accountAppVersionLabel = 'バージョン';
  static const String accountLoginWithGoogle = 'Googleアカウントでログイン';
  static const String accountLogoutTitle = 'Googleアカウントからログアウト';
  static const String accountLogoutDialogMessage = 'ログアウトしてもよろしいですか？';
  static const String accountLogoutSuccessMessage = 'ログアウトが完了しました。';

  static const String accountDataUpdateTitle = 'サーバーからデータ取得';
  static const String accountDataUpdateDetail = 'キャラ情報はタップで新キャラのみ取得、ロングタップで全キャラ取得します。';

  static const String accountCharacterUpdateLabel = 'キャラ';
  static const String accountCharacterRegisterCountLabel = '現在の登録数:';
  static const String accountCharacterOnlyNewUpdateDialogMessage = '新しくサーバーに登録されたキャラ情報を取得します。\nよろしいですか？';
  static const String accountCharacterAllUpdateDialogMessage = '注意！！\n現在アプリ内に保存されているキャラ情報を全て削除し、サーバーから再取得します。\nこの処理は数分時間がかかりますがよろしいですか？\n(自身が入力したステータス等は削除されません。)';
  static const String accountCharacterUpdateDialogSuccessMessage = '最新のキャラ情報を取得しました。';

  static const String accountStageUpdateLabel = 'ステージ';
  static const String accountStageLatestLabel = '最新:';
  static const String accountStageEmptyLabel = 'ー';
  static const String accountStageUpdateDialogMessage = '現在のステージ情報を全て削除してサーバーから再取得します。\nよろしいですか？';
  static const String accountStageUpdateDialogSuccessMessage = '最新のステージ情報を取得しました。';

  static const String accountLetterUpdateLabel = 'お便り';
  static const String accountLetterLatestLabel = '最新:';
  static const String accountLetterEmptyLabel = 'ー';
  static const String accountLetterUpdateDialogMessage = '新しくサーバーに登録されたお便り情報を取得します。\nよろしいですか？';
  static const String accountLetterAllUpdateDialogMessage = '注意！！\n現在アプリ内に保存されているお便り情報を全て削除し、サーバーから再取得します。\nこの処理は数分時間がかかりますがよろしいですか？\n(自身が入力したステータス等は削除されません。)';
  static const String accountLetterUpdateDialogSuccessMessage = '最新のお便り情報を取得しました。';

  static const String accountStatusBackupLabel = 'バックアップ';
  static const String accountStatusBackupDateLabel = '前回実行日:';
  static const String accountStatusBackupDialogMessage = '現在のキャラステータスをサーバーへバックアップします。\nよろしいですか？';
  static const String accountStatusBackupDialogSuccessMessage = 'バックアップに成功しました。';

  static const String accountStatusRestoreLabel = '復元';
  static const String accountStatusRestoreDialogMessage = 'サーバーにバックアップしたキャラステータスを復元します。\n現在のステータスは全て消えますがよろしいですか？';
  static const String accountStatusRestoreDescriptionLabel = 'アプリ内のデータを上書きします。';
  static const String accountStatusRestoreDialogSuccessMessage = '復元に成功しました。';

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
}
