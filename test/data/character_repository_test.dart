import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rsapp/romasaga/data/character_repository.dart';
import 'package:rsapp/romasaga/data/local/character_source.dart';
import 'package:rsapp/romasaga/data/remote/character_api.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/style.dart';

void main() {
  final String dummyNetworkPath = '/dummy/net/icon.jpg';

  List<Character> createCase1TestData() {
    final testCharacters = <Character>[];

    final c1 = Character(1001, 'single style', 'prd', 'weapon', selectedStyleRank: 's')
      ..addStyle(Style(1001, 's', 't', 'iconName1', 1, 2, 3, 4, 5, 6, 7, 8));

    final c2 = Character(1002, 'multi style', 'prd', 'weapon', selectedStyleRank: 's')
      ..addStyle(Style(1002, 's', 't', 'iconName2', 10, 11, 12, 13, 14, 15, 16, 17))
      ..addStyle(Style(1002, 'a', 't', 'iconName3', 21, 22, 23, 24, 25, 26, 27, 28));

    testCharacters.add(c1);
    testCharacters.add(c2);

    return testCharacters;
  }

  List<Character> createCase1ResultData() {
    final testCharacters = <Character>[];

    final c1 = Character(1001, 'single style', 'prd', 'weapon', selectedStyleRank: 's', selectedIconFilePath: dummyNetworkPath)
      ..addStyle(Style(1001, 's', 't', 'iconName1', 1, 2, 3, 4, 5, 6, 7, 8)..iconFilePath = dummyNetworkPath);

    final c2 = Character(1002, 'multi style', 'prd', 'weapon', selectedStyleRank: 's', selectedIconFilePath: dummyNetworkPath)
      ..addStyle(Style(1002, 's', 't', 'iconName2', 10, 11, 12, 13, 14, 15, 16, 17)..iconFilePath = dummyNetworkPath)
      ..addStyle(Style(1002, 'a', 't', 'iconName3', 21, 22, 23, 24, 25, 26, 27, 28)..iconFilePath = dummyNetworkPath);

    testCharacters.add(c1);
    testCharacters.add(c2);

    return testCharacters;
  }

  test('Case1 refresh() リモートから取得したデータを正しく加工してrefreshメソッドを呼んでくれるかテスト', () async {
    // テストデータ作成
    final testCharacters = createCase1TestData();

    // テスト対象オブジェクトの生成
    final db = FakeCharacterSource();
    final api = MockCharacterApi();

    when(api.findAll()).thenAnswer((_) => Future.value(testCharacters));
    when(api.findIconUrl(any)).thenAnswer((s) => Future.value(dummyNetworkPath));

    // テスト実行
    final repository = CharacterRepository(local: db, remote: api);
    await repository.refresh();

    // 結果確認。単調すぎるので切り出したかったがexpectの仕様とどこに差分があるか一目で知りたかったので全部力技で書く
    final resultCharacters = db.results;
    final expectCharacters = createCase1ResultData();

    expect(resultCharacters.length, 2);
    expect(resultCharacters[0].id, expectCharacters[0].id);
    expect(resultCharacters[0].name, expectCharacters[0].name);
    expect(resultCharacters[0].production, expectCharacters[0].production);
    expect(resultCharacters[0].weaponType, expectCharacters[0].weaponType);
    expect(resultCharacters[0].selectedStyleRank, expectCharacters[0].selectedStyleRank);
    expect(resultCharacters[0].selectedIconFilePath, expectCharacters[0].selectedIconFilePath);

    expect(resultCharacters[0].styles[0].characterId, expectCharacters[0].styles[0].characterId);
    expect(resultCharacters[0].styles[0].rank, expectCharacters[0].styles[0].rank);
    expect(resultCharacters[0].styles[0].title, expectCharacters[0].styles[0].title);
    expect(resultCharacters[0].styles[0].iconFileName, expectCharacters[0].styles[0].iconFileName);
    expect(resultCharacters[0].styles[0].iconFilePath, expectCharacters[0].styles[0].iconFilePath);
    expect(resultCharacters[0].styles[0].str, expectCharacters[0].styles[0].str);
    expect(resultCharacters[0].styles[0].vit, expectCharacters[0].styles[0].vit);
    expect(resultCharacters[0].styles[0].dex, expectCharacters[0].styles[0].dex);
    expect(resultCharacters[0].styles[0].agi, expectCharacters[0].styles[0].agi);
    expect(resultCharacters[0].styles[0].intelligence, expectCharacters[0].styles[0].intelligence);
    expect(resultCharacters[0].styles[0].spirit, expectCharacters[0].styles[0].spirit);
    expect(resultCharacters[0].styles[0].love, expectCharacters[0].styles[0].love);
    expect(resultCharacters[0].styles[0].attr, expectCharacters[0].styles[0].attr);

    expect(resultCharacters[1].id, expectCharacters[1].id);
    expect(resultCharacters[1].name, expectCharacters[1].name);
    expect(resultCharacters[1].production, expectCharacters[1].production);
    expect(resultCharacters[1].weaponType, expectCharacters[1].weaponType);
    expect(resultCharacters[1].selectedStyleRank, expectCharacters[1].selectedStyleRank);
    expect(resultCharacters[1].selectedIconFilePath, expectCharacters[1].selectedIconFilePath);

    expect(resultCharacters[1].styles[0].characterId, expectCharacters[1].styles[0].characterId);
    expect(resultCharacters[1].styles[0].rank, expectCharacters[1].styles[0].rank);
    expect(resultCharacters[1].styles[0].title, expectCharacters[1].styles[0].title);
    expect(resultCharacters[1].styles[0].iconFileName, expectCharacters[1].styles[0].iconFileName);
    expect(resultCharacters[1].styles[0].iconFilePath, expectCharacters[1].styles[0].iconFilePath);
    expect(resultCharacters[1].styles[0].str, expectCharacters[1].styles[0].str);
    expect(resultCharacters[1].styles[0].vit, expectCharacters[1].styles[0].vit);
    expect(resultCharacters[1].styles[0].dex, expectCharacters[1].styles[0].dex);
    expect(resultCharacters[1].styles[0].agi, expectCharacters[1].styles[0].agi);
    expect(resultCharacters[1].styles[0].intelligence, expectCharacters[1].styles[0].intelligence);
    expect(resultCharacters[1].styles[0].spirit, expectCharacters[1].styles[0].spirit);
    expect(resultCharacters[1].styles[0].love, expectCharacters[1].styles[0].love);
    expect(resultCharacters[1].styles[0].attr, expectCharacters[1].styles[0].attr);

    expect(resultCharacters[1].styles[1].characterId, expectCharacters[1].styles[1].characterId);
    expect(resultCharacters[1].styles[1].rank, expectCharacters[1].styles[1].rank);
    expect(resultCharacters[1].styles[1].title, expectCharacters[1].styles[1].title);
    expect(resultCharacters[1].styles[1].iconFileName, expectCharacters[1].styles[1].iconFileName);
    expect(resultCharacters[1].styles[1].iconFilePath, expectCharacters[1].styles[1].iconFilePath);
    expect(resultCharacters[1].styles[1].str, expectCharacters[1].styles[1].str);
    expect(resultCharacters[1].styles[1].vit, expectCharacters[1].styles[1].vit);
    expect(resultCharacters[1].styles[1].dex, expectCharacters[1].styles[1].dex);
    expect(resultCharacters[1].styles[1].agi, expectCharacters[1].styles[1].agi);
    expect(resultCharacters[1].styles[1].intelligence, expectCharacters[1].styles[1].intelligence);
    expect(resultCharacters[1].styles[1].spirit, expectCharacters[1].styles[1].spirit);
    expect(resultCharacters[1].styles[1].love, expectCharacters[1].styles[1].love);
    expect(resultCharacters[1].styles[1].attr, expectCharacters[1].styles[1].attr);
  });

  final String dummyLocalPath = '/dummy/local/test.jpg';

  List<Character> createCase2LocalTestData() {
    final testCharacters = <Character>[];

    final c1 = Character(1001, 'local single', 'prd', 'weapon', selectedStyleRank: 's', selectedIconFilePath: dummyLocalPath)
      ..addStyle(Style(1001, 's', 'local', 'localIconName1', 1, 2, 3, 4, 5, 6, 7, 8)..iconFilePath = dummyLocalPath);

    final c2 = Character(1002, 'local one style', 'prd', 'weapon', selectedStyleRank: 's', selectedIconFilePath: dummyLocalPath)
      ..addStyle(Style(1002, 's', 'local', 'localIconName2', 10, 11, 12, 13, 14, 15, 16, 17)..iconFilePath = dummyLocalPath);

    testCharacters.add(c1);
    testCharacters.add(c2);

    return testCharacters;
  }

  List<Character> createCase2RemoteTestData() {
    final testCharacters = <Character>[];

    final c1 = Character(1001, 'remote style1', 'prd', 'weapon', selectedStyleRank: 's')
      ..addStyle(Style(1001, 's', 'remote', 'remoteName1', 91, 92, 93, 94, 95, 96, 97, 98));

    final c2 = Character(1002, 'remote style2', 'prd', 'weapon', selectedStyleRank: 's')
      ..addStyle(Style(1002, 's', 'remote', 'remoteName2', 100, 101, 102, 103, 104, 105, 106, 107))
      ..addStyle(Style(1002, 'a', 'remote', 'remoteName3', 21, 22, 23, 24, 25, 26, 27, 28));

    final c3 = Character(1003, 'remote style3', 'prd', 'weapon', selectedStyleRank: 'ss')
      ..addStyle(Style(1003, 'ss', 'remote', 'remoteName2', 31, 32, 33, 34, 35, 36, 37, 38))
      ..addStyle(Style(1003, 's', 'remote', 'remoteName3', 41, 42, 43, 44, 45, 46, 47, 48));

    testCharacters.add(c1);
    testCharacters.add(c2);
    testCharacters.add(c3);

    return testCharacters;
  }

  List<Character> createCase2ResultData() {
    final testCharacters = <Character>[];

    final c1 = Character(1001, 'remote style1', 'prd', 'weapon', selectedStyleRank: 's', selectedIconFilePath: dummyLocalPath)
      ..addStyle(Style(1001, 's', 'remote', 'remoteName1', 91, 92, 93, 94, 95, 96, 97, 98)..iconFilePath = dummyLocalPath);

    final c2 = Character(1002, 'remote style2', 'prd', 'weapon', selectedStyleRank: 's', selectedIconFilePath: dummyLocalPath)
      ..addStyle(Style(1002, 's', 'remote', 'remoteName2', 100, 101, 102, 103, 104, 105, 106, 107)..iconFilePath = dummyLocalPath)
      ..addStyle(Style(1002, 'a', 'remote', 'remoteName3', 21, 22, 23, 24, 25, 26, 27, 28)..iconFilePath = dummyNetworkPath);

    final c3 = Character(1003, 'remote style3', 'prd', 'weapon', selectedStyleRank: 'ss', selectedIconFilePath: dummyNetworkPath)
      ..addStyle(Style(1003, 'ss', 'remote', 'remoteName2', 31, 32, 33, 34, 35, 36, 37, 38)..iconFilePath = dummyNetworkPath)
      ..addStyle(Style(1003, 's', 'remote', 'remoteName3', 41, 42, 43, 44, 45, 46, 47, 48)..iconFilePath = dummyNetworkPath);

    testCharacters.add(c1);
    testCharacters.add(c2);
    testCharacters.add(c3);

    return testCharacters;
  }

  test('Case2 update() リモートとローカルのデータを正しくマージしrefreshメソッドを呼んでくれるかテスト', () async {
    // テストデータ作成
    final localCharacters = createCase2LocalTestData();
    final remoteCharacters = createCase2RemoteTestData();

    // テスト対象オブジェクトの生成
    final db = FakeCharacterSource();
    final api = MockCharacterApi();

    db.fakeSummaryData = localCharacters;
    when(api.findAll()).thenAnswer((_) => Future.value(remoteCharacters));
    when(api.findIconUrl(any)).thenAnswer((s) => Future.value(dummyNetworkPath));

    // テスト実行
    final repository = CharacterRepository(local: db, remote: api);
    await repository.update();

    final resultCharacters = db.results;
    final expectCharacters = createCase2ResultData();

    expect(resultCharacters.length, 3);
    expect(resultCharacters[0].id, expectCharacters[0].id);
    expect(resultCharacters[0].name, expectCharacters[0].name);
    expect(resultCharacters[0].production, expectCharacters[0].production);
    expect(resultCharacters[0].weaponType, expectCharacters[0].weaponType);
    expect(resultCharacters[0].selectedStyleRank, expectCharacters[0].selectedStyleRank);
    expect(resultCharacters[0].selectedIconFilePath, expectCharacters[0].selectedIconFilePath);

    expect(resultCharacters[0].styles[0].characterId, expectCharacters[0].styles[0].characterId);
    expect(resultCharacters[0].styles[0].rank, expectCharacters[0].styles[0].rank);
    expect(resultCharacters[0].styles[0].title, expectCharacters[0].styles[0].title);
    expect(resultCharacters[0].styles[0].iconFileName, expectCharacters[0].styles[0].iconFileName);
    expect(resultCharacters[0].styles[0].iconFilePath, expectCharacters[0].styles[0].iconFilePath);
    expect(resultCharacters[0].styles[0].str, expectCharacters[0].styles[0].str);
    expect(resultCharacters[0].styles[0].vit, expectCharacters[0].styles[0].vit);
    expect(resultCharacters[0].styles[0].dex, expectCharacters[0].styles[0].dex);
    expect(resultCharacters[0].styles[0].agi, expectCharacters[0].styles[0].agi);
    expect(resultCharacters[0].styles[0].intelligence, expectCharacters[0].styles[0].intelligence);
    expect(resultCharacters[0].styles[0].spirit, expectCharacters[0].styles[0].spirit);
    expect(resultCharacters[0].styles[0].love, expectCharacters[0].styles[0].love);
    expect(resultCharacters[0].styles[0].attr, expectCharacters[0].styles[0].attr);

    expect(resultCharacters[1].id, expectCharacters[1].id);
    expect(resultCharacters[1].name, expectCharacters[1].name);
    expect(resultCharacters[1].production, expectCharacters[1].production);
    expect(resultCharacters[1].weaponType, expectCharacters[1].weaponType);
    expect(resultCharacters[1].selectedStyleRank, expectCharacters[1].selectedStyleRank);
    expect(resultCharacters[1].selectedIconFilePath, expectCharacters[1].selectedIconFilePath);

    expect(resultCharacters[1].styles[0].characterId, expectCharacters[1].styles[0].characterId);
    expect(resultCharacters[1].styles[0].rank, expectCharacters[1].styles[0].rank);
    expect(resultCharacters[1].styles[0].title, expectCharacters[1].styles[0].title);
    expect(resultCharacters[1].styles[0].iconFileName, expectCharacters[1].styles[0].iconFileName);
    expect(resultCharacters[1].styles[0].iconFilePath, expectCharacters[1].styles[0].iconFilePath);
    expect(resultCharacters[1].styles[0].str, expectCharacters[1].styles[0].str);
    expect(resultCharacters[1].styles[0].vit, expectCharacters[1].styles[0].vit);
    expect(resultCharacters[1].styles[0].dex, expectCharacters[1].styles[0].dex);
    expect(resultCharacters[1].styles[0].agi, expectCharacters[1].styles[0].agi);
    expect(resultCharacters[1].styles[0].intelligence, expectCharacters[1].styles[0].intelligence);
    expect(resultCharacters[1].styles[0].spirit, expectCharacters[1].styles[0].spirit);
    expect(resultCharacters[1].styles[0].love, expectCharacters[1].styles[0].love);
    expect(resultCharacters[1].styles[0].attr, expectCharacters[1].styles[0].attr);

    expect(resultCharacters[1].styles[1].characterId, expectCharacters[1].styles[1].characterId);
    expect(resultCharacters[1].styles[1].rank, expectCharacters[1].styles[1].rank);
    expect(resultCharacters[1].styles[1].title, expectCharacters[1].styles[1].title);
    expect(resultCharacters[1].styles[1].iconFileName, expectCharacters[1].styles[1].iconFileName);
    expect(resultCharacters[1].styles[1].iconFilePath, expectCharacters[1].styles[1].iconFilePath);
    expect(resultCharacters[1].styles[1].str, expectCharacters[1].styles[1].str);
    expect(resultCharacters[1].styles[1].vit, expectCharacters[1].styles[1].vit);
    expect(resultCharacters[1].styles[1].dex, expectCharacters[1].styles[1].dex);
    expect(resultCharacters[1].styles[1].agi, expectCharacters[1].styles[1].agi);
    expect(resultCharacters[1].styles[1].intelligence, expectCharacters[1].styles[1].intelligence);
    expect(resultCharacters[1].styles[1].spirit, expectCharacters[1].styles[1].spirit);
    expect(resultCharacters[1].styles[1].love, expectCharacters[1].styles[1].love);
    expect(resultCharacters[1].styles[1].attr, expectCharacters[1].styles[1].attr);

    expect(resultCharacters[2].id, expectCharacters[2].id);
    expect(resultCharacters[2].name, expectCharacters[2].name);
    expect(resultCharacters[2].production, expectCharacters[2].production);
    expect(resultCharacters[2].weaponType, expectCharacters[2].weaponType);
    expect(resultCharacters[2].selectedStyleRank, expectCharacters[2].selectedStyleRank);
    expect(resultCharacters[2].selectedIconFilePath, expectCharacters[2].selectedIconFilePath);

    expect(resultCharacters[2].styles[0].characterId, expectCharacters[2].styles[0].characterId);
    expect(resultCharacters[2].styles[0].rank, expectCharacters[2].styles[0].rank);
    expect(resultCharacters[2].styles[0].title, expectCharacters[2].styles[0].title);
    expect(resultCharacters[2].styles[0].iconFileName, expectCharacters[2].styles[0].iconFileName);
    expect(resultCharacters[2].styles[0].iconFilePath, expectCharacters[2].styles[0].iconFilePath);
    expect(resultCharacters[2].styles[0].str, expectCharacters[2].styles[0].str);
    expect(resultCharacters[2].styles[0].vit, expectCharacters[2].styles[0].vit);
    expect(resultCharacters[2].styles[0].dex, expectCharacters[2].styles[0].dex);
    expect(resultCharacters[2].styles[0].agi, expectCharacters[2].styles[0].agi);
    expect(resultCharacters[2].styles[0].intelligence, expectCharacters[2].styles[0].intelligence);
    expect(resultCharacters[2].styles[0].spirit, expectCharacters[2].styles[0].spirit);
    expect(resultCharacters[2].styles[0].love, expectCharacters[2].styles[0].love);
    expect(resultCharacters[2].styles[0].attr, expectCharacters[2].styles[0].attr);

    expect(resultCharacters[2].styles[1].characterId, expectCharacters[2].styles[1].characterId);
    expect(resultCharacters[2].styles[1].rank, expectCharacters[2].styles[1].rank);
    expect(resultCharacters[2].styles[1].title, expectCharacters[2].styles[1].title);
    expect(resultCharacters[2].styles[1].iconFileName, expectCharacters[2].styles[1].iconFileName);
    expect(resultCharacters[2].styles[1].iconFilePath, expectCharacters[2].styles[1].iconFilePath);
    expect(resultCharacters[2].styles[1].str, expectCharacters[2].styles[1].str);
    expect(resultCharacters[2].styles[1].vit, expectCharacters[2].styles[1].vit);
    expect(resultCharacters[2].styles[1].dex, expectCharacters[2].styles[1].dex);
    expect(resultCharacters[2].styles[1].agi, expectCharacters[2].styles[1].agi);
    expect(resultCharacters[2].styles[1].intelligence, expectCharacters[2].styles[1].intelligence);
    expect(resultCharacters[2].styles[1].spirit, expectCharacters[2].styles[1].spirit);
    expect(resultCharacters[2].styles[1].love, expectCharacters[2].styles[1].love);
    expect(resultCharacters[2].styles[1].attr, expectCharacters[2].styles[1].attr);
  });
}

class FakeCharacterSource extends Fake implements CharacterSource {
  List<Character> results;
  List<Character> fakeSummaryData;

  @override
  Future<void> refresh(List<Character> characters) {
    results = characters;
  }

  @override
  Future<List<Character>> findAllSummary() {
    return Future.value(fakeSummaryData);
  }
}

class MockCharacterApi extends Mock implements CharacterApi {}
