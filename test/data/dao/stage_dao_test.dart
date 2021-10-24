import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsapp/data/local/dao/stage_dao.dart';
import 'package:rsapp/models/stage.dart';

import '../hive_test.dart';

void main() {
  setUpAll(() => HiveTest.setUp());
  tearDown(() async => await HiveTest.clear());

  test('ステージ情報が0件の場合、デフォルトステージが取得できることを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(stageDaoProvider);

    // テスト開始
    final results = await dao.findAll();
    expect(results.length, 2);
    expect(results[0].name, 'VH6');
    expect(results[0].limit, 0);
    expect(results[0].order, 1);

    expect(results[1].name, 'VH7');
    expect(results[1].limit, 2);
    expect(results[1].order, 2);
  });

  test('ステージ情報が登録できることを確認する。', () async {
    final container = ProviderContainer();
    final dao = container.read(stageDaoProvider);

    // テスト開始
    await dao.save(const Stage('Test1', 10, 1));
    await dao.save(const Stage('Test2', 20, 2));
    await dao.save(const Stage('Test3', 30, 3));

    final results = await dao.findAll();
    expect(results.length, 3);
    expect(results[0].id, 1);
    expect(results[1].id, 2);
    expect(results[2].id, 3);

    expect(results[0].name, 'Test1');
    expect(results[1].name, 'Test2');
    expect(results[2].name, 'Test3');

    expect(results[0].limit, 10);
    expect(results[1].limit, 20);
    expect(results[2].limit, 30);

    expect(results[0].order, 1);
    expect(results[1].order, 2);
    expect(results[2].order, 3);
  });

  test('ステージ情報が更新できることを確認する。', () async {
    final container = ProviderContainer();
    final dao = container.read(stageDaoProvider);

    await dao.save(const Stage('Test1', 10, 1));
    await dao.save(const Stage('Test2', 20, 2));
    await dao.save(const Stage('Test3', 30, 3));

    // テスト開始
    final data = await dao.findAll();
    final updateData = Stage('Update1', 100, 4, id: data[1].id);
    await dao.save(updateData);

    final results = await dao.findAll();
    expect(results.length, 3);
    expect(results[0].id, 1);
    expect(results[1].id, 2);
    expect(results[2].id, 3);

    expect(results[0].name, 'Test1');
    expect(results[1].name, 'Update1');
    expect(results[2].name, 'Test3');

    expect(results[0].limit, 10);
    expect(results[1].limit, 100);
    expect(results[2].limit, 30);

    expect(results[0].order, 1);
    expect(results[1].order, 4);
    expect(results[2].order, 3);
  });

  test('ステージ情報が削除できることを確認する。', () async {
    final container = ProviderContainer();
    final dao = container.read(stageDaoProvider);

    await dao.save(const Stage('Test1', 10, 1));
    await dao.save(const Stage('Test2', 20, 2));
    await dao.save(const Stage('Test3', 30, 3));

    // テスト開始
    const targetData = Stage('Test2', 20, 2, id: 2);
    await dao.delete(targetData);

    final results = await dao.findAll();
    expect(results.length, 2);

    expect(results[0].id, 1);
    expect(results[0].name, 'Test1');
    expect(results[0].limit, 10);
    expect(results[0].order, 1);

    expect(results[1].id, 3);
    expect(results[1].name, 'Test3');
    expect(results[1].limit, 30);
    expect(results[1].order, 3);
  });
}
