import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/status.dart' show MyStatus;
import 'package:rsapp/service/rs_service.dart';

final myStatusApiProvider = Provider((ref) => _MyStatusApi(ref.read));

class _MyStatusApi {
  const _MyStatusApi(this._read);

  final Reader _read;

  Future<void> save(List<MyStatus> myStatuses) async {
    RSLogger.d('ステータスを保存します。対象数=${myStatuses.length}');
    await _read(rsServiceProvider).saveMyStatuses(myStatuses);
  }

  Future<List<MyStatus>> findAll() async {
    RSLogger.d('サーバから保存したステータスを取得します。');
    return await _read(rsServiceProvider).findMyStatues();
  }
}
