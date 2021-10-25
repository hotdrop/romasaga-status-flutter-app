import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsapp/data/local/dao/character_dao.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/res/rs_strings.dart';

import '../hive_test.dart';

void main() {
  setUpAll(() => HiveTest.setUp());
  tearDown(() async => await HiveTest.clear());

  test('全キャラ情報の保存と取得ができることを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(characterDaoProvider);

    final characters = [
      Character(1001, 'Test1', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's')
        ..addStyle(Style(1, 1001, 's', 'remote', 'remoteName1', 91, 92, 93, 94, 95, 96, 97, 98)),
      Character(1002, 'Test2', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's')
        ..addStyle(Style(2, 1002, 's', 'remote', 'remoteName2', 100, 101, 102, 103, 104, 105, 106, 107))
        ..addStyle(Style(3, 1002, 'a', 'remote', 'remoteName3', 21, 22, 23, 24, 25, 26, 27, 28)),
      Character(1003, 'Test3', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 'ss')
        ..addStyle(Style(4, 1003, 'ss', 'remote', 'remoteName2', 31, 32, 33, 34, 35, 36, 37, 38))
        ..addStyle(Style(5, 1003, 's', 'remote', 'remoteName3', 41, 42, 43, 44, 45, 46, 47, 48)),
    ];

    // テスト開始
    await dao.refresh(characters);
    final results = await dao.findAll();
    expect(results.length, 3);
    expect(results[0].id, 1001);
    expect(results[0].name, 'Test1');
    expect(results[0].styles.length, 1);

    expect(results[1].id, 1002);
    expect(results[1].name, 'Test2');
    expect(results[1].styles.length, 2);

    expect(results[2].id, 1003);
    expect(results[2].name, 'Test3');
    expect(results[2].styles.length, 2);
  });

  test('全キャラクターの概要情報（スタイル以外の情報）が取得できることを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(characterDaoProvider);

    final characters = [
      Character(1001, 'Test1', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's')
        ..addStyle(Style(1, 1001, 's', 'remote', 'remoteName1', 91, 92, 93, 94, 95, 96, 97, 98)),
      Character(1002, 'Test2', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's')
        ..addStyle(Style(2, 1002, 's', 'remote', 'remoteName2', 100, 101, 102, 103, 104, 105, 106, 107))
        ..addStyle(Style(3, 1002, 'a', 'remote', 'remoteName3', 21, 22, 23, 24, 25, 26, 27, 28)),
      Character(1003, 'Test3', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 'ss')
        ..addStyle(Style(4, 1003, 'ss', 'remote', 'remoteName2', 31, 32, 33, 34, 35, 36, 37, 38))
        ..addStyle(Style(5, 1003, 's', 'remote', 'remoteName3', 41, 42, 43, 44, 45, 46, 47, 48)),
    ];

    // テスト開始
    await dao.refresh(characters);
    final results = await dao.findAllSummary();
    expect(results.length, 3);
    expect(results[0].id, 1001);
    expect(results[0].styles.length, 0);

    expect(results[1].id, 1002);
    expect(results[1].styles.length, 0);

    expect(results[2].id, 1003);
    expect(results[2].styles.length, 0);
  });

  test('指定したキャラクターIDのスタイル情報が全て取得できることを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(characterDaoProvider);

    final characters = [
      Character(1001, 'Test1', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's')
        ..addStyle(Style(1, 1001, 's', 'remote', 'remoteName1', 91, 92, 93, 94, 95, 96, 97, 98)),
      Character(1002, 'Test2', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's')
        ..addStyle(Style(2, 1002, 's', 'remote', 'remoteName2', 100, 101, 102, 103, 104, 105, 106, 107))
        ..addStyle(Style(3, 1002, 'a', 'remote', 'remoteName3', 21, 22, 23, 24, 25, 26, 27, 28)),
      Character(1003, 'Test3', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 'ss')
        ..addStyle(Style(4, 1003, 'ss', '1003Test1', '1003Name1', 31, 32, 33, 34, 35, 36, 37, 38))
        ..addStyle(Style(5, 1003, 's', '1003Test2', '1003Name2', 41, 42, 43, 44, 45, 46, 47, 48)),
    ];
    await dao.refresh(characters);

    // テスト開始
    final result = await dao.findStyles(1003);
    expect(result.length, 2);

    expect(result[0].id, 4);
    expect(result[0].rank, 'ss');
    expect(result[0].title, '1003Test1');
    expect(result[0].iconFileName, '1003Name1');
    expect(result[0].str, 31);
    expect(result[0].vit, 32);
    expect(result[0].dex, 33);
    expect(result[0].agi, 34);
    expect(result[0].intelligence, 35);
    expect(result[0].spirit, 36);
    expect(result[0].love, 37);
    expect(result[0].attr, 38);

    expect(result[1].id, 5);
    expect(result[1].rank, 's');
    expect(result[1].title, '1003Test2');
    expect(result[1].iconFileName, '1003Name2');
    expect(result[1].str, 41);
    expect(result[1].vit, 42);
    expect(result[1].dex, 43);
    expect(result[1].agi, 44);
    expect(result[1].intelligence, 45);
    expect(result[1].spirit, 46);
    expect(result[1].love, 47);
    expect(result[1].attr, 48);
  });

  test('登録されているキャラ情報の総件数が取得できることを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(characterDaoProvider);

    final characters = [
      Character(1001, 'Test1', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's')
        ..addStyle(Style(1, 1001, 's', 'remote', 'remoteName1', 91, 92, 93, 94, 95, 96, 97, 98)),
      Character(1002, 'Test2', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's')
        ..addStyle(Style(2, 1002, 's', 'remote', 'remoteName2', 100, 101, 102, 103, 104, 105, 106, 107)),
      Character(1003, 'Test3', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 'ss')
        ..addStyle(Style(4, 1003, 'ss', '1003Test1', '1003Name1', 31, 32, 33, 34, 35, 36, 37, 38)),
    ];
    await dao.refresh(characters);

    // テスト開始
    final result = await dao.count();
    expect(result, 3);
  });

  test('キャラのスタイルアイコンを指定したものに更新できることを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(characterDaoProvider);

    final characters = [
      Character(1001, 'Test1', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's', selectedIconFilePath: 'oldPath')
        ..addStyle(Style(1, 1001, 's', 'style1', 'iconFile1', 1, 2, 3, 4, 5, 6, 7, 8))
        ..addStyle(Style(2, 1001, 'a', 'style2', 'iconFile2', 91, 92, 93, 94, 95, 96, 97, 98)),
      Character(1002, 'Test2', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's')
        ..addStyle(Style(3, 1002, 's', 'style3', 'iconFile3', 100, 101, 102, 103, 104, 105, 106, 107)),
      Character(1003, 'Test3', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 'ss')
        ..addStyle(Style(4, 1003, 'ss', 'style4', 'iconFile4', 31, 32, 33, 34, 35, 36, 37, 38)),
    ];
    await dao.refresh(characters);

    // テスト開始
    await dao.updateStyleIcon(1001, 'a', 'update/iconpath/2');

    final resultStyles = await dao.findStyles(1001);
    final result = resultStyles.where((c) => c.rank == 'a').first;
    expect(result.iconFilePath, 'update/iconpath/2');
  });

  test('キャラ情報毎に指定できるデフォルト表示用のスタイルアイコンを、指定したものに変更できることを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(characterDaoProvider);

    final characters = [
      Character(1001, 'Test1', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's', selectedIconFilePath: 'oldPath')
        ..addStyle(Style(1, 1001, 's', 'style1', 'icon1', 1, 2, 3, 4, 5, 6, 7, 8))
        ..addStyle(Style(2, 1001, 'a', 'style2', 'icon2', 91, 92, 93, 94, 95, 96, 97, 98)),
      Character(1002, 'Test2', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's')
        ..addStyle(Style(2, 1002, 's', 'remote', 'remoteName2', 100, 101, 102, 103, 104, 105, 106, 107)),
      Character(1003, 'Test3', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 'ss')
        ..addStyle(Style(4, 1003, 'ss', '1003Test1', '1003Name1', 31, 32, 33, 34, 35, 36, 37, 38)),
    ];
    await dao.refresh(characters);

    // テスト開始
    final firstResults = await dao.findAllSummary();
    final beforeChar = firstResults.where((c) => c.id == 1001).first;
    expect(beforeChar.selectedStyleRank, 's');
    expect(beforeChar.selectedIconFilePath, 'oldPath');

    await dao.saveSelectedStyle(1001, 'a', 'updateIcon');

    final results = await dao.findAllSummary();
    final afterChar = results.where((c) => c.id == 1001).first;
    expect(afterChar.selectedStyleRank, 'a');
    expect(afterChar.selectedIconFilePath, 'updateIcon');
  });
  test('指定したキャラのstatusUpEventが更新できることを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(characterDaoProvider);

    final characters = [
      Character(1001, 'Test1', 'prd', Weapon(name: RSStrings.sword), selectedStyleRank: 's'),
      Character(1002, 'Test2', 'prd', Weapon(name: RSStrings.axe), selectedStyleRank: 'ss'),
    ];
    await dao.refresh(characters);

    // テスト開始
    final beforeResults = await dao.findAllSummary();
    final beforeResult = beforeResults.where((e) => e.id == 1001).first;
    expect(beforeResult.statusUpEvent, false);

    await dao.saveStatusUpEvent(1001, true);

    final afterResults = await dao.findAllSummary();
    final afterResult = afterResults.where((e) => e.id == 1001).first;
    expect(afterResult.statusUpEvent, true);
  });
  test('保存されているキャラデータが空であっても各メソッドがエラーにならないことを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(characterDaoProvider);

    // テスト開始
    final characters = <Character>[];
    await dao.refresh(characters);

    final resultFindAll = await dao.findAll();
    expect(resultFindAll.length, 0);

    final resultFindAllSummary = await dao.findAllSummary();
    expect(resultFindAllSummary.length, 0);

    final result = await dao.count();
    expect(result, 0);
  });
}
