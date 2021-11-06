import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rsapp/data/remote/response/character_response.dart';
import 'package:rsapp/data/remote/response/style_response.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/remote/character_api.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';

import 'character_repository_test.mocks.dart';

@GenerateMocks([CharacterApi])
void main() {
  test('新規データが正しくマージされるか確認する', () async {
    final mockApi = MockCharacterApi();
    when(mockApi.findIconUrl('file1')).thenAnswer((_) async => 'test/path/icon.png');
    final container = ProviderContainer(overrides: [
      characterApiProvider.overrideWithValue(mockApi),
    ]);
    final repository = container.read(characterRepositoryProvider);

    final response = [
      CharacterResponse(id: 1001, name: 'Test1', weaponTypeName: RSStrings.sword, production: 'Prod1', styles: [
        StyleResponse(rank: 's', title: 'Title1', str: 1, vit: 2, dex: 3, agi: 4, intelligence: 5, spi: 6, love: 7, attr: 8, iconFileName: 'file1'),
      ]),
      CharacterResponse(id: 1002, name: 'Test2', weaponTypeName: RSStrings.rod, production: 'Prod2', styles: [
        StyleResponse(rank: 'a', title: 'Title2', str: 1, vit: 2, dex: 3, agi: 4, intelligence: 5, spi: 6, love: 7, attr: 8, iconFileName: 'file1'),
        StyleResponse(rank: 'ss', title: 'Title3', str: 1, vit: 2, dex: 3, agi: 4, intelligence: 5, spi: 6, love: 7, attr: 8, iconFileName: 'file1'),
      ]),
      CharacterResponse(id: 1003, name: 'Test3', weaponTypeName: RSStrings.bow, production: 'Prod3', styles: [
        StyleResponse(rank: 'ss', title: 'Title4', str: 1, vit: 2, dex: 3, agi: 4, intelligence: 5, spi: 6, love: 7, attr: 8, iconFileName: 'file1'),
        StyleResponse(rank: 's', title: 'Title5', str: 1, vit: 2, dex: 3, agi: 4, intelligence: 5, spi: 6, love: 7, attr: 8, iconFileName: 'file1'),
      ]),
    ];

    // テスト開始
    final results = await repository.merge(response, []);

    expect(results.length, 3);
    expect(results[0].id, 1001);
    expect(results[0].styles.length, 1);
    expect(results[0].styles[0].id, 1001001);
    expect(results[0].styles[0].iconFileName, 'file1');
    expect(results[0].styles[0].iconFilePath, 'test/path/icon.png');
    expect(results[1].id, 1002);
    expect(results[1].styles.length, 2);
    expect(results[1].styles[1].title, 'Title3');
    expect(results[2].id, 1003);
    expect(results[2].styles.length, 2);
    expect(results[2].styles[1].id, 1003002);
    expect(results[2].styles[1].iconFileName, 'file1');
    expect(results[2].styles[1].iconFilePath, 'test/path/icon.png');
  });

  test('既に保存されているデータが存在する場合、正しくマージできるか確認する', () async {
    final mockApi = MockCharacterApi();
    when(mockApi.findIconUrl('file1')).thenAnswer((_) async => 'test/path/icon.png');
    final container = ProviderContainer(overrides: [
      characterApiProvider.overrideWithValue(mockApi),
    ]);
    final repository = container.read(characterRepositoryProvider);

    final response = [
      CharacterResponse(id: 1001, name: 'Test1', weaponTypeName: RSStrings.sword, production: 'Prod1', styles: [
        StyleResponse(rank: 's', title: 'Title1', str: 1, vit: 2, dex: 3, agi: 4, intelligence: 5, spi: 6, love: 7, attr: 8, iconFileName: 'file1'),
      ]),
      CharacterResponse(id: 1002, name: 'Test2', weaponTypeName: RSStrings.rod, production: 'Prod2', styles: [
        StyleResponse(rank: 'a', title: 'Title2', str: 1, vit: 2, dex: 3, agi: 4, intelligence: 5, spi: 6, love: 7, attr: 8, iconFileName: 'file1'),
        StyleResponse(rank: 'ss', title: 'Title3', str: 1, vit: 2, dex: 3, agi: 4, intelligence: 5, spi: 6, love: 7, attr: 8, iconFileName: 'file1'),
      ]),
      CharacterResponse(id: 1003, name: 'Test3', weaponTypeName: RSStrings.bow, production: 'Prod3', styles: [
        StyleResponse(rank: 'ss', title: 'Title4', str: 1, vit: 2, dex: 3, agi: 4, intelligence: 5, spi: 6, love: 7, attr: 8, iconFileName: 'file1'),
        StyleResponse(rank: 's', title: 'Title5', str: 1, vit: 2, dex: 3, agi: 4, intelligence: 5, spi: 6, love: 7, attr: 8, iconFileName: 'file1'),
      ]),
    ];

    final localCharacters = [
      Character(1001, 'Test1', 'prd', Weapon(name: RSStrings.sword), null, selectedStyleRank: 's')
        ..addStyle(Style(1001001, 1001, 's', 'local', 'file1', 'image/path1.png', 91, 92, 93, 94, 95, 96, 97, 98)),
      Character(1002, 'Test2', 'prd', Weapon(name: RSStrings.sword), null, selectedStyleRank: 'a')
        ..addStyle(Style(1002001, 1002, 'a', 'local', 'file1', 'image/path2.png', 100, 101, 102, 103, 104, 105, 106, 107))
    ];

    // テスト開始
    final results = await repository.merge(response, localCharacters);
    expect(results.length, 3);
    expect(results[0].id, 1001);
    expect(results[0].selectedStyleRank, 's');
    expect(results[0].styles.length, 1);
    expect(results[0].styles[0].id, 1001001);
    expect(results[0].styles[0].iconFileName, 'file1');
    expect(results[0].styles[0].iconFilePath, 'image/path1.png');
    expect(results[1].id, 1002);
    expect(results[1].selectedStyleRank, 'a');
    expect(results[1].styles.length, 2);
    expect(results[1].styles[0].title, 'Title2');
    expect(results[1].styles[1].title, 'Title3');
    expect(results[2].id, 1003);
    expect(results[2].selectedStyleRank, isNull);
    expect(results[2].styles.length, 2);
    expect(results[2].styles[1].id, 1003002);
    expect(results[2].styles[1].iconFileName, 'file1');
    expect(results[2].styles[1].iconFilePath, 'test/path/icon.png');
  });
}
