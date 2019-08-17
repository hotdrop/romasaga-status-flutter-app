import '../../model/status.dart' show MyStatus;

import '../../service/romancing_service.dart';
import '../../common/saga_logger.dart';

class MyStatusApi {
  static final MyStatusApi _instance = MyStatusApi._();
  MyStatusApi._();

  factory MyStatusApi() {
    return _instance;
  }

  RomancingService _romancingService = RomancingService();

  Future<void> save(List<MyStatus> myStatuses) async {
    try {
      SagaLogger.d('ステータスを保存します。対象数=${myStatuses.length}');
      await _romancingService.saveMyStatuses(myStatuses);
    } catch (e) {
      SagaLogger.e('ステータス保存時にエラーが発生しました。', e);
      throw e;
    }
  }

  Future<List<MyStatus>> findAll() async {
    try {
      SagaLogger.d('サーバから保存したステータスを取得します。');
      return await _romancingService.findMyStatues();
    } catch (e) {
      SagaLogger.e('保存したステータス取得時にエラーが発生しました。', e);
      throw e;
    }
  }
}
