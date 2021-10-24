import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/data/local/stage_dao.dart';
import 'package:rsapp/data/remote/stage_api.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/common/rs_logger.dart';

final stageRepositoryProvider = Provider((ref) => _StageRepository(ref.read));

class _StageRepository {
  const _StageRepository(this._read);

  final Reader _read;

  ///
  /// ステージデータを全て取得します
  ///
  Future<List<Stage>> findAll() async {
    var stages = await _read(stageDaoProvider).findAll();

    if (stages.isEmpty) {
      RSLogger.d('キャッシュにデータがないのでローカルファイルを読み込みます。');
      // final tmp = await _read(stageDaoProvider).loadDummy();
      // RSLogger.d('  ${tmp.length}件のデータを取得しました。キャッシュします。');
      // await _read(stageDaoProvider).refresh(tmp);

      RSLogger.d('再度キャッシュからデータを取得します。');
      stages = await _read(stageDaoProvider).findAll();
    }

    RSLogger.d('データ取得完了 件数=${stages.length}');
    return stages;
  }

  Future<void> refresh() async {
    final stages = await _read(stageApiProvider).findAll();
    RSLogger.d('リモートから${stages.length}件のデータを取得しました。');

    // await _read(stageDaoProvider).refresh(stages);
  }

  Future<String> getLatestStageName() async {
    final stages = await _read(stageDaoProvider).findAll();
    if (stages.isEmpty) {
      return RSStrings.accountStageEmptyLabel;
    } else {
      return stages.first.name;
    }
  }
}
