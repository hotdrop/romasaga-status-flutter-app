import 'dart:async';

import 'local/local_data_source.dart';
import 'remote/remote_data_source.dart';
import '../model/character.dart';

class RomasagaRepository {
  LocalDataSource localDataSource;
  RemoteDataSource remoteDataSource;

  RomasagaRepository({LocalDataSource local, RemoteDataSource remote}) {
    localDataSource = (local == null) ? LocalDataSource() : local;
    remoteDataSource = (remote == null) ? RemoteDataSource() : remote;
  }

  Future<List<Character>> findAll() async {
    // TODO デバッグログはちゃんとLogger使う。どれがいいかな。。
    print("Repository DBから取得");
    var characters = await localDataSource.findAll();
    if (characters.isEmpty) {
      print("Repository DBが0件なのでリモートから取得");
      characters = await remoteDataSource.findAll();
      print("Repository DBに保存");
      localDataSource.save(characters);
    }

    print("Repository データ取得完了 件数=${characters.length}");
    return characters;
  }
}
