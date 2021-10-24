import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsapp/data/local/dao/character_dao.dart';

import '../hive_test.dart';

void main() {
  setUpAll(() => HiveTest.setUp());
  tearDown(() async => await HiveTest.clear());

  test('全キャラ情報の保存と取得ができるか確認する', () async {
    final container = ProviderContainer();
    final dao = container.read(characterDaoProvider);
    // テスト開始
    // refresh
    // findAll
  });

  test('全キャラクターの概要情報（スタイル以外の情報）を取得', () async {
    final container = ProviderContainer();
    final dao = container.read(characterDaoProvider);
    // テスト開始
    // refresh
    // findAllSummary
  });

  test('引数に指定したキャラクターIDのスタイル一式を取得', () async {
    // findStyles
  });
  test('登録されているキャラデータの件数を取得', () async {
    // count
  });
  test('ダミーデータの取得処理が行えることを確認する', () async {
    // loadDummy
  });
  test('キャラのスタイルアイコンを指定したものに更新する', () async {
    // updateStyleIcon
  });
  test('キャラ情報毎に指定できるデフォルト表示用のスタイルアイコンを、指定したものに変更する', () async {
    // saveSelectedStyle
  });
  test('指定したキャラのstatusUpEventを更新する', () async {
    // saveStatusUpEvent
  });
}
