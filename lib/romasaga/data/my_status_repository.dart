import 'package:shared_preferences/shared_preferences.dart';
import 'package:rsapp/romasaga/data/local/my_status_dao.dart';
import 'package:rsapp/romasaga/data/remote/my_status_api.dart';
import 'package:rsapp/romasaga/model/status.dart' show MyStatus;
import 'package:rsapp/romasaga/common/rs_logger.dart';

class MyStatusRepository {
  const MyStatusRepository._(this._dao, this._api);

  factory MyStatusRepository.create() {
    final dao = MyStatusDao.create();
    final api = MyStatusApi.create();
    return MyStatusRepository._(dao, api);
  }

  final MyStatusDao _dao;
  final MyStatusApi _api;

  static String _backupDateKey = 'backup_date_key';

  Future<List<MyStatus>> findAll() async {
    return await _dao.findAll();
  }

  Future<MyStatus> find(int id) async {
    return await _dao.find(id) ?? MyStatus.empty(id);
  }

  Future<void> save(MyStatus status) async {
    return _dao.save(status);
  }

  Future<void> backup() async {
    final myStatuses = await findAll();
    await _api.save(myStatuses);
    await _saveBackupDate();
  }

  Future<void> restore() async {
    final myStatuses = await _api.findAll();
    RSLogger.d('データを取得しました。size=${myStatuses.length}');

    await _dao.refresh(myStatuses);
  }

  Future<String> getPreviousBackupDateStr() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dateStr = prefs.get(_backupDateKey) as String;
    return dateStr?.substring(0, 10) ?? "-";
  }

  Future<void> _saveBackupDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final nowDate = DateTime.now();
    await prefs.setString(_backupDateKey, nowDate.toString());
  }
}
