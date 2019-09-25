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

    final c1 = Character(1001, 'single style', 'prd', 'weapon', selectedStyleRank: 's');
    c1.addStyle(Style(1001, 's', 't', 'iconName1', 1, 1, 1, 1, 1, 1, 1, 1));

    final c2 = Character(1002, 'multi style', 'prd', 'weapon', selectedStyleRank: 's');
    c2.addStyle(Style(1002, 's', 't', 'iconName2', 1, 1, 1, 1, 1, 1, 1, 1));
    c2.addStyle(Style(1002, 'a', 't', 'iconName3', 1, 1, 1, 1, 1, 1, 1, 1));

    testCharacters.add(c1);
    testCharacters.add(c2);

    return testCharacters;
  }

  List<Character> createCase1ResultData() {
    final testCharacters = <Character>[];

    final c1 = Character(1001, 'single style', 'prd', 'weapon', selectedStyleRank: 's', selectedIconFilePath: dummyNetworkPath);
    c1.addStyle(Style(1001, 's', 't', 'iconName1', 1, 1, 1, 1, 1, 1, 1, 1)..iconFilePath = '$dummyNetworkPath/iconName1');

    final c2 = Character(1002, 'multi style', 'prd', 'weapon', selectedStyleRank: 's', selectedIconFilePath: dummyNetworkPath);
    c2.addStyle(Style(1002, 's', 't', 'iconName2', 1, 1, 1, 1, 1, 1, 1, 1)..iconFilePath = '$dummyNetworkPath/iconName2');
    c2.addStyle(Style(1002, 'a', 't', 'iconName3', 1, 1, 1, 1, 1, 1, 1, 1)..iconFilePath = '$dummyNetworkPath/iconName3');

    testCharacters.add(c1);
    testCharacters.add(c2);

    return testCharacters;
  }

  test('Case1 refresh() リモートから取得したデータを正しく加工してrefreshメソッドを呼んでくれるかテスト', () async {
    // create test data
    final testCharacters = createCase1TestData();

    // create object to target test class
    final db = FakeCharacterSource();
    final api = MockCharacterApi();

    when(api.findAll()).thenAnswer((_) => Future.value(testCharacters));
    when(api.findIconUrl(any)).thenAnswer((s) => Future.value(dummyNetworkPath));

    // execute test
    final repository = CharacterRepository(local: db, remote: api);
    await repository.refresh();

    final resultCharacters = db.results;
    final expectCharacters = createCase1ResultData();

    expect(resultCharacters.length, 2);
    expect(resultCharacters[1].selectedIconFilePath, expectCharacters[1].selectedIconFilePath);
  });
}

class FakeCharacterSource extends Fake implements CharacterSource {
  List<Character> results;

  @override
  Future<void> refresh(List<Character> characters) {
    results = characters;
  }
}

class MockCharacterApi extends Mock implements CharacterApi {}
