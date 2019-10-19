import 'local/stage_dao.dart';
import 'remote/stage_api.dart';

import '../model/stage.dart';

import '../common/rs_logger.dart';

class StageRepository {
  StageRepository({StageDao local, StageApi remote})
      : _localDataSource = (local == null) ? StageDao() : local,
        _remoteDataSource = (remote == null) ? StageApi() : remote;

  final StageDao _localDataSource;
  final StageApi _remoteDataSource;

  ///
  /// ステージデータのロード
  ///
  Future<List<Stage>> load() async {
    var stages = await _localDataSource.findAll();

    if (stages.isEmpty) {
      RSLogger.d('キャッシュにデータがないのでローカルファイルを読み込みます。');
      final tmp = await _localDataSource.loadDummy();
      RSLogger.d('  ${tmp.length}件のデータを取得しました。キャッシュします。');
      await _localDataSource.refresh(tmp);

      RSLogger.d('再度キャッシュからデータを取得します。');
      stages = await _localDataSource.findAll();
    }

    RSLogger.d('データ取得完了 件数=${stages.length}');
    return stages;
  }

  Future<void> refresh() async {
    final stages = await _remoteDataSource.findAll();
    RSLogger.d('リモートから${stages.length}件のデータを取得しました。');

    await _localDataSource.refresh(stages);
  }

  Future<int> count() async {
    return await _localDataSource.count();
  }
}
