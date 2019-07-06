import 'local/stage_source.dart';
import 'remote/stage_api.dart';
import '../model/stage.dart';

class BaseStatusRepository {
  final StageSource _localDataSource;
  final StageApi _baseStatusApi;

  BaseStatusRepository({StageSource local, StageApi remote})
      : _localDataSource = (local == null) ? StageSource() : local,
        _baseStatusApi = (remote == null) ? StageApi() : remote;

  Future<List<Stage>> findAll() async {
    var stages = await _localDataSource.findAll();

    if (stages.isEmpty) {
      // TODO ロガーライブラリ使うべき。Timberみたいなのが欲しい
      print("[debung] DBが0件なのでリモートから取得");
      stages = await _baseStatusApi.findAll();
      _localDataSource.save(stages);
      stages.sort((e1, e2) => (e1.itemOrder > e2.itemOrder) ? -1 : 1);
    }

    print("[debung] データ取得完了 件数=${stages.length}");
    return stages;
  }
}
