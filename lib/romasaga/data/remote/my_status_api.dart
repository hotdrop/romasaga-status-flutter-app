import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/models/status.dart' show MyStatus;
import 'package:rsapp/romasaga/service/rs_service.dart';

class MyStatusApi {
  const MyStatusApi._(this._rsService);

  factory MyStatusApi.create() {
    return MyStatusApi._(RSService.getInstance());
  }

  final RSService _rsService;

  Future<void> save(List<MyStatus> myStatuses) async {
    RSLogger.d('ステータスを保存します。対象数=${myStatuses.length}');
    await _rsService.saveMyStatuses(myStatuses);
  }

  Future<List<MyStatus>> findAll() async {
    RSLogger.d('サーバから保存したステータスを取得します。');
    return await _rsService.findMyStatues();
  }
}
