import 'local/stage_source.dart';
import 'remote/stage_api.dart';

import '../model/stage.dart';

import '../common/saga_logger.dart';

class StageRepository {
  final StageSource _localDataSource;
  final StageApi _remoteDataSource;

  StageRepository({StageSource local, StageApi remote})
      : _localDataSource = (local == null) ? StageSource() : local,
        _remoteDataSource = (remote == null) ? StageApi() : remote;

  Future<List<Stage>> load() async {
    var stages = await _localDataSource.findAll();

    if (stages.isEmpty) {
      SagaLogger.d('キャッシュにデータがないのでローカルファイルを読み込みます。');
      final tmp = await _localDataSource.load();
      SagaLogger.d('  ${tmp.length}件のデータを取得しました。キャッシュします。');
      await _localDataSource.refresh(tmp);

      SagaLogger.d('再度キャッシュからデータを取得します。');
      stages = await _localDataSource.findAll();
    }

    SagaLogger.d('データ取得完了 件数=${stages.length}');
    return stages;
  }

  Future<void> refresh() async {
    final stages = await _remoteDataSource.findAll();
    SagaLogger.d('リモートから${stages.length}件のデータを取得しました。');

    await _localDataSource.refresh(stages);
  }

  Future<int> count() async {
    return await _localDataSource.count();
  }
}
