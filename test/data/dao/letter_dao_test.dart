import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsapp/data/local/dao/letter_dao.dart';
import 'package:rsapp/models/letter.dart';

import '../hive_test.dart';

void main() {
  setUpAll(() => HiveTest.setUp());
  tearDown(() async => await HiveTest.clear());

  test('お便り情報の保存と取得ができるか確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(letterDaoProvider);

    const letters = [
      Letter(year: 2020, month: 1, title: 'Test1', shortTitle: 'short1', videoFilePath: 'mp4/test1', staticImagePath: 'static/test1'),
      Letter(year: 2021, month: 10, title: 'Test2', shortTitle: 'short2', videoFilePath: 'mp4/test2', staticImagePath: 'static/test2'),
    ];

    // テスト開始
    await dao.saveAll(letters);
    final results = await dao.findAll();

    expect(results.length, 2);
    expect(results[0].id, 202001);
    expect(results[1].id, 202110);
    expect(results[0].year, 2020);
    expect(results[1].year, 2021);
    expect(results[0].month, 1);
    expect(results[1].month, 10);
    expect(results[0].title, 'Test1');
    expect(results[1].title, 'Test2');
    expect(results[0].shortTitle, 'short1');
    expect(results[1].shortTitle, 'short2');
    expect(results[0].videoFilePath, 'mp4/test1');
    expect(results[1].videoFilePath, 'mp4/test2');
    expect(results[0].staticImagePath, 'static/test1');
    expect(results[1].staticImagePath, 'static/test2');
  });

  test('お便り情報が1件も保存されていない場合に取得処理を行なった場合にエラーにならないことを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(letterDaoProvider);
    // テスト開始
    final results = await dao.findAll();
    expect(results.isEmpty, isTrue);
  });
}
