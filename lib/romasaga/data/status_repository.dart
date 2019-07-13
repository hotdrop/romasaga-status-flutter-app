import 'local/status_source.dart';
import '../model/status.dart' show MyStatus;

class StatusRepository {
  final StatusSource _localDataSource;

  StatusRepository({StatusSource local}) : _localDataSource = (local == null) ? StatusSource() : local;

  Future<MyStatus> find(String charName) async {
    print("$charName のmystatusをfindします");
    var status = await _localDataSource.find(charName);
    return status;
  }

  Future<void> save(MyStatus status) async {
    return _localDataSource.save(status);
  }
}
