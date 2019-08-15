import 'local/my_status_source.dart';
import '../model/status.dart' show MyStatus;

class MyStatusRepository {
  final MyStatusSource _localDataSource;

  MyStatusRepository({MyStatusSource local}) : _localDataSource = (local == null) ? MyStatusSource() : local;

  Future<List<MyStatus>> findAll() async {
    return await _localDataSource.findAll();
  }

  Future<MyStatus> find(int id) async {
    return await _localDataSource.find(id) ?? MyStatus.empty(id);
  }

  Future<void> save(MyStatus status) async {
    return _localDataSource.save(status);
  }

  String getPreviousBackupDate() {
    // TODO sharedから取得
    return '2019-08-10';
  }

  Future<void> backup() async {
    // TODO データを全取得してfirestoreへ保存
    // TODO 成功したら日付を保存
  }

  Future<void> restore() async {
    // TODO firestoreからデータ取得してsaveを実行
  }
}
