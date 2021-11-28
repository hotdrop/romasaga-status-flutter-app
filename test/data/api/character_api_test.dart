import 'dart:convert' as convert;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rsapp/data/remote/character_api.dart';
import 'package:rsapp/service/rs_service.dart';

import 'character_api_test.mocks.dart';

@GenerateMocks([RSService])
void main() {
  const String _characterJson =
      '{  "characters": [    {      "id": 10000,      "name": "ロマンシングテスト",      "weapon_type": ["大剣", "槍"],      "production": "ロマンシング・サガ3",      "attributes": ["光"],      "styles": [        {          "rank": "SS",          "title": "アイウエオ",          "str": 50,          "vit": 48,          "dex": 48,          "agi": 45,          "int": 43,          "spi": 45,          "love": 44,          "attr": 45,          "icon": "test_ss.jpg"        },        {          "rank": "S",          "title": "アワキャラ",          "str": 47,          "vit": 47,          "dex": 47,          "agi": 47,          "int": 44,          "spi": 45,          "love": 45,          "attr": 46,          "icon": "test_ss.jpg"        }      ]    },    {      "id": 10001,      "name": "佐賀スカーレット",      "weapon_type": ["小剣"],      "production": "サガスカーレットグレイス",      "styles": [        {          "rank": "SS",          "title": "アイウエオ",          "str": 50,          "vit": 48,          "dex": 48,          "agi": 45,          "int": 43,          "spi": 45,          "love": 44,          "attr": 45,          "icon": "test_ss.jpg"        }      ]    },    {      "id": 88888,      "name": "テストキャラ1",      "weapon_type": ["大剣", "弓", "杖"],      "production": "ロマンシング・サガ1",      "styles": [        {          "rank": "S",          "title": "Sキャラです",          "str": 47,          "vit": 47,          "dex": 47,          "agi": 47,          "int": 44,          "spi": 45,          "love": 45,          "attr": 46,          "icon": "test_ss.jpg"        }      ]    },    {      "id": 99999,      "name": "テストキャラ2",      "weapon_type": ["小剣"],      "production": "ロマンシング・サガ2",      "styles": [        {          "rank": "SS",          "title": "アイウエオ",          "str": 50,          "vit": 48,          "dex": 48,          "agi": 45,          "int": 43,          "spi": 45,          "love": 44,          "attr": 45,          "icon": "test_ss.jpg"        },        {          "rank": "S",          "title": "アワキャラ",          "str": 47,          "vit": 47,          "dex": 47,          "agi": 47,          "int": 44,          "spi": 45,          "love": 45,          "attr": 46,          "icon": "test_ss.jpg"        },        {          "rank": "A",          "title": "テストその1",          "str": 47,          "vit": 47,          "dex": 47,          "agi": 47,          "int": 44,          "spi": 45,          "love": 45,          "attr": 46,          "icon": "test_ss.jpg"        }      ]    },    {      "id": 99998,      "name": "テストキャラ3",      "weapon_type": ["杖"],      "attributes": ["火", "水"],      "production": "ロマンシング・サガ2",      "styles": [        {          "rank": "SS",          "title": "アイウエオ",          "str": 50,          "vit": 48,          "dex": 48,          "agi": 45,          "int": 43,          "spi": 45,          "love": 44,          "attr": 45,          "icon": "test_ss.jpg"        },        {          "rank": "S",          "title": "アワキャラ",          "str": 47,          "vit": 47,          "dex": 47,          "agi": 47,          "int": 44,          "spi": 45,          "love": 45,          "attr": 46,          "icon": "test_ss.jpg"        }      ]    }  ]}';

  test('想定しているキャラ情報レスポンス(json)をパースしてモデルクラスとして取得できることを確認する', () async {
    // rsServiceをmockにする
    final mockRsService = MockRSService();
    when(mockRsService.getCharacters()).thenAnswer((_) async {
      return convert.jsonDecode(_characterJson);
    });

    final container = ProviderContainer(overrides: [
      rsServiceProvider.overrideWithValue(mockRsService),
    ]);

    // テスト開始
    final response = await container.read(characterApiProvider).findAll();
    expect(response.characters.length, 5);
  });
}
