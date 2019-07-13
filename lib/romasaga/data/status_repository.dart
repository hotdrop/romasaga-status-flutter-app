import 'local/status_source.dart';
import '../model/status.dart' show MyStatus;

class StatusRepository {
  final StatusSource _localDataSource;

  StatusRepository({StatusSource local}) : _localDataSource = (local == null) ? StatusSource() : local;

  Future<MyStatus> find(String charName) async {
    var status = await _localDataSource.find(charName);
    return status;
  }

  Future<void> save(MyStatus status) async {
    _localDataSource.save(status);
  }
}
