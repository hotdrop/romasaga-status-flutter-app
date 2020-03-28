import 'package:rsapp/romasaga/common/rs_strings.dart';

import 'local/stage_dao.dart';
import 'remote/stage_api.dart';

import '../model/stage.dart';

import '../common/rs_logger.dart';

class StageRepository {
  const StageRepository._(this._dao, this._api);

  factory StageRepository.create() {
    final dao = StageDao.create();
    final api = StageApi.create();
    return StageRepository._(dao, api);
  }

  final StageDao _dao;
  final StageApi _api;

  ///
  /// ステージデータを全て取得します
  ///
  Future<List<Stage>> findAll() async {
    var stages = await _dao.findAll();

    if (stages.isEmpty) {
      RSLogger.d('キャッシュにデータがないのでローカルファイルを読み込みます。');
      final tmp = await _dao.loadDummy();
      RSLogger.d('  ${tmp.length}件のデータを取得しました。キャッシュします。');
      await _dao.refresh(tmp);

      RSLogger.d('再度キャッシュからデータを取得します。');
      stages = await _dao.findAll();
    }

    RSLogger.d('データ取得完了 件数=${stages.length}');
    return stages;
  }

  Future<void> refresh() async {
    final stages = await _api.findAll();
    RSLogger.d('リモートから${stages.length}件のデータを取得しました。');

    await _dao.refresh(stages);
  }

  Future<String> getLatestStageName() async {
    final stages = await _dao.findAll();
    if (stages.isEmpty) {
      return RSStrings.accountStageEmptyLabel;
    } else {
      return stages?.first?.name;
    }
  }
}
