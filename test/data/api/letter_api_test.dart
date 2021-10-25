import 'dart:convert' as convert;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rsapp/data/remote/letter_api.dart';
import 'package:rsapp/service/rs_service.dart';

import 'letter_api_test.mocks.dart';

@GenerateMocks([RSService])
void main() {
  const String _letterJson =
      '{"letters": [{ "year": 2021, "month": 1, "title": "Test1", "short_title": "short1", "image_name": "image1" },{ "year": 2021, "month": 2, "title": "Test2", "short_title": "short2", "image_name": "image2" },{ "year": 2021, "month": 3, "title": "Test3", "short_title": "short3", "image_name": "image3" }]}';

  test('想定しているキャラ情報レスポンス(json)をパースしてモデルクラスとして取得できることを確認する', () async {
    // rsServiceをmockにする
    final mockRsService = MockRSService();
    when(mockRsService.getLetters()).thenAnswer((_) async {
      return convert.jsonDecode(_letterJson);
    });

    final container = ProviderContainer(overrides: [
      rsServiceProvider.overrideWithValue(mockRsService),
    ]);

    // テスト開始
    final response = await container.read(letterApiProvider).findAll();
    expect(response.letters.length, 3);
  });
}
