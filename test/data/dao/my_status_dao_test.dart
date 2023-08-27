import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:rsapp/data/local/dao/my_status_dao.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/data/local/entity/character_entity.dart';
import 'package:rsapp/data/local/entity/my_status_entity.dart';
import 'package:rsapp/data/local/entity/style_entity.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.current.path);
    Hive.registerAdapter(CharacterEntityAdapter());
    Hive.registerAdapter(MyStatusEntityAdapter());
    Hive.registerAdapter(StyleEntityAdapter());
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  test('ステータス情報の全更新と全取得ができるか確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(myStatusDaoProvider);

    final myStatues = [
      MyStatus(1, 10, 1, 2, 3, 4, 5, 6, 7, 8, false),
      MyStatus(2, 20, 2, 4, 6, 8, 10, 12, 14, 16, true),
      MyStatus(3, 30, 3, 6, 9, 12, 15, 18, 21, 24, true),
    ];

    // テスト開始
    await dao.refresh(myStatues);
    final results = await dao.findAll();
    expect(results.length, 3);
    expect(results[0].id, 1);
    expect(results[1].id, 2);
    expect(results[2].id, 3);

    expect(results[0].hp, 10);
    expect(results[1].hp, 20);
    expect(results[2].hp, 30);

    expect(results[0].str, 1);
    expect(results[1].str, 2);
    expect(results[2].str, 3);

    expect(results[0].vit, 2);
    expect(results[1].vit, 4);
    expect(results[2].vit, 6);

    expect(results[0].dex, 3);
    expect(results[1].dex, 6);
    expect(results[2].dex, 9);

    expect(results[0].agi, 4);
    expect(results[1].agi, 8);
    expect(results[2].agi, 12);

    expect(results[0].inte, 5);
    expect(results[1].inte, 10);
    expect(results[2].inte, 15);

    expect(results[0].spi, 6);
    expect(results[1].spi, 12);
    expect(results[2].spi, 18);

    expect(results[0].love, 7);
    expect(results[1].love, 14);
    expect(results[2].love, 21);

    expect(results[0].attr, 8);
    expect(results[1].attr, 16);
    expect(results[2].attr, 24);

    expect(results[0].favorite, isFalse);
    expect(results[1].favorite, isTrue);
    expect(results[2].favorite, isTrue);
  });
  test('ステータス情報が未登録の状態で全取得した場合でもエラーにならないことを確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(myStatusDaoProvider);
    // テスト開始
    final results = await dao.findAll();
    expect(results.isEmpty, isTrue);
  });

  test('指定したIDのステータス情報を保存し取得できるか確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(myStatusDaoProvider);

    final myStatues = [
      MyStatus(1, 10, 1, 2, 3, 4, 5, 6, 7, 8, false),
      MyStatus(2, 20, 2, 4, 6, 8, 10, 12, 14, 16, true),
      MyStatus(3, 30, 3, 6, 9, 12, 15, 18, 21, 24, true),
    ];
    await dao.refresh(myStatues);

    // テスト開始
    final result = await dao.find(2);
    expect(result, isNotNull);
    expect(result!.id, 2);
    expect(result.hp, 20);
    expect(result.str, 2);
    expect(result.vit, 4);
    expect(result.dex, 6);
    expect(result.agi, 8);
    expect(result.inte, 10);
    expect(result.spi, 12);
    expect(result.love, 14);
    expect(result.attr, 16);
    expect(result.favorite, isTrue);
  });

  test('ステータス情報を保存及び更新できるか確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(myStatusDaoProvider);

    final myStatues = [
      MyStatus(1, 10, 1, 2, 3, 4, 5, 6, 7, 8, false),
      MyStatus(2, 20, 2, 4, 6, 8, 10, 12, 14, 16, true),
      MyStatus(3, 30, 3, 6, 9, 12, 15, 18, 21, 24, true),
    ];
    await dao.refresh(myStatues);

    // テスト開始
    // 既存データの更新
    await dao.save(MyStatus(2, 40, 4, 8, 12, 16, 20, 24, 28, 32, false));
    // 新規データ登録
    await dao.save(MyStatus(4, 50, 5, 10, 15, 20, 25, 30, 35, 40, false));

    final result2 = await dao.find(2);
    expect(result2, isNotNull);
    expect(result2!.id, 2);
    expect(result2.hp, 40);
    expect(result2.str, 4);
    expect(result2.vit, 8);
    expect(result2.dex, 12);
    expect(result2.agi, 16);
    expect(result2.inte, 20);
    expect(result2.spi, 24);
    expect(result2.love, 28);
    expect(result2.attr, 32);
    expect(result2.favorite, isFalse);

    final result4 = await dao.find(4);
    expect(result4, isNotNull);
    expect(result4!.id, 4);
    expect(result4.hp, 50);
    expect(result4.str, 5);
    expect(result4.vit, 10);
    expect(result4.dex, 15);
    expect(result4.agi, 20);
    expect(result4.inte, 25);
    expect(result4.spi, 30);
    expect(result4.love, 35);
    expect(result4.attr, 40);
    expect(result4.favorite, isFalse);
  });
}
