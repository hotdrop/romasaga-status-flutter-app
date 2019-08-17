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

  Future<void> save(List<MyStatus> myStatusList) {
//    try {
//      _romancingService.save(myStatusList);
//    } catch (e) {
//      SagaLogger.e('ステータス保存時にエラーが発生しました。', e);
//      throw e;
//    }
  }
}
