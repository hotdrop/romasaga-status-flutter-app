import 'local/base_status_source.dart';
import 'remote/base_status_api.dart';
import '../model/base_status.dart';

class BaseStatusRepository {
  BaseStatusSource localDataSource;
  BaseStatusApi baseStatusApi;

  BaseStatusRepository({BaseStatusSource local, BaseStatusApi remote}) {
    localDataSource = (local == null) ? BaseStatusSource() : local;
    baseStatusApi = (remote == null) ? BaseStatusApi() : remote;
  }

  Future<List<BaseStatus>> findAll() async {
    var baseStatusList = await localDataSource.findAll();
    if (baseStatusList.isEmpty) {
      print("BaseStatusRepository DBが0件なのでリモートから取得");
      baseStatusList = await baseStatusApi.findAll();
      localDataSource.save(baseStatusList);
    }

    print("BaseStatusRepository データ取得完了 件数=${baseStatusList.length}");
    return baseStatusList;
  }
}
