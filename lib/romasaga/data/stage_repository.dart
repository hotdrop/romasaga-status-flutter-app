import 'local/stage_source.dart';
import 'remote/stage_api.dart';
import '../model/stage.dart';
import '../common/saga_logger.dart';

class StageRepository {
  final StageSource _localDataSource;
  final StageApi _baseStatusApi;

  StageRepository({StageSource local, StageApi remote})
      : _localDataSource = (local == null) ? StageSource() : local,
        _baseStatusApi = (remote == null) ? StageApi() : remote;

  Future<List<Stage>> findAll() async {
    var stages = await _localDataSource.findAll();

    if (stages.isEmpty) {
      SagaLogger.d('DBが0件なのでリモートから取得');
      stages = await _baseStatusApi.findAll();
      _localDataSource.save(stages);
      stages.sort((e1, e2) => (e1.order > e2.order) ? -1 : 1);
    }

    SagaLogger.d('データ取得完了 件数=${stages.length}');
    return stages;
  }
}
