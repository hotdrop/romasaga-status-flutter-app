import 'package:rsapp/romasaga/model/status.dart' show MyStatus;
import 'package:rsapp/romasaga/service/rs_service.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';

class MyStatusApi {
  const MyStatusApi._(this._rsService);

  factory MyStatusApi.create() {
    return MyStatusApi._(RSService.getInstance());
  }

  final RSService _rsService;

  Future<void> save(List<MyStatus> myStatuses) async {
    try {
      RSLogger.d('ステータスを保存します。対象数=${myStatuses.length}');
      await _rsService.saveMyStatuses(myStatuses);
    } catch (e) {
      RSLogger.e('ステータス保存時にエラーが発生しました。', e);
      rethrow;
    }
  }

  Future<List<MyStatus>> findAll() async {
    try {
      RSLogger.d('サーバから保存したステータスを取得します。');
      return await _rsService.findMyStatues();
    } catch (e) {
      RSLogger.e('保存したステータス取得時にエラーが発生しました。', e);
      rethrow;
    }
  }
}
