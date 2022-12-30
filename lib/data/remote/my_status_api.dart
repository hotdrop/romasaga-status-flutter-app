import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/status.dart' show MyStatus;
import 'package:rsapp/service/rs_service.dart';

final myStatusApiProvider = Provider((ref) => _MyStatusApi(ref));

class _MyStatusApi {
  const _MyStatusApi(this._ref);

  final Ref _ref;

  Future<void> save(List<MyStatus> myStatuses) async {
    RSLogger.d('ステータスを保存します。対象数=${myStatuses.length}');
    await _ref.read(rsServiceProvider).saveMyStatuses(myStatuses);
  }

  Future<List<MyStatus>> findAll() async {
    RSLogger.d('サーバから保存したステータスを取得します。');
    return await _ref.read(rsServiceProvider).findMyStatues();
  }
}
