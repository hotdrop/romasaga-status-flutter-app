import '../../model/status.dart' show MyStatus;

import '../../service/rs_service.dart';
import '../../common/rs_logger.dart';

class MyStatusApi {
  final RSService _romancingService;
  MyStatusApi({RSService rsService}) : _romancingService = (rsService == null) ? RSService() : rsService;

  Future<void> save(List<MyStatus> myStatuses) async {
    try {
      RSLogger.d('ステータスを保存します。対象数=${myStatuses.length}');
      await _romancingService.saveMyStatuses(myStatuses);
    } catch (e) {
      RSLogger.e('ステータス保存時にエラーが発生しました。', e);
      throw e;
    }
  }

  Future<List<MyStatus>> findAll() async {
    try {
      RSLogger.d('サーバから保存したステータスを取得します。');
      return await _romancingService.findMyStatues();
    } catch (e) {
      RSLogger.e('保存したステータス取得時にエラーが発生しました。', e);
      throw e;
    }
  }
}
