import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

void main() {
  const portfolio = 'https://api.unsplash.com/users/example/portfolio';
  const linksJson = <String, dynamic>{
    'self': 'https://api.unsplash.com/users/example',
    'html': 'https://unsplash.com/@example',
    'photos': 'https://api.unsplash.com/users/example/photos',
    'likes': 'https://api.unsplash.com/users/example/likes',
    'followers': 'https://api.unsplash.com/users/example/followers',
    'following': 'https://api.unsplash.com/users/example/following',
  };

  group('UserLinks.portfolio', () {
    for (final absent in [true, false]) {
      test('${absent ? 'omitted' : 'null'} value survives a JSON roundtrip',
          () {
        final json = <String, dynamic>{
          ...linksJson,
          if (!absent) 'portfolio': null,
        };
        final links = UserLinks.fromJson(json);

        expect(links.portfolio, isNull);
        expect(links.source, same(json));
        expect(links.toJson(), containsPair('portfolio', null));

        final decoded = jsonDecode(jsonEncode(links)) as Map<String, dynamic>;
        final restored = UserLinks.fromJson(decoded);
        expect(restored.portfolio, isNull);
        expect(restored, links);
        expect(restored.hashCode, links.hashCode);
      });
    }

    test('URL is parsed and preserved through a JSON roundtrip', () {
      final json = <String, dynamic>{...linksJson, 'portfolio': portfolio};
      final links = UserLinks.fromJson(json);

      expect(links.portfolio, Uri.parse(portfolio));
      expect(links.toJson(), json);
      final decoded = jsonDecode(jsonEncode(links)) as Map<String, dynamic>;
      expect(UserLinks.fromJson(decoded), links);
    });

    test('constructor accepts null and serializes JSON null', () {
      final links = UserLinks(
        self: Uri.parse(linksJson['self'] as String),
        html: Uri.parse(linksJson['html'] as String),
        photos: Uri.parse(linksJson['photos'] as String),
        likes: null,
        portfolio: null,
        followers: null,
        following: null,
      );

      final json = jsonDecode(jsonEncode(links)) as Map<String, dynamic>;
      expect(json, containsPair('portfolio', null));
      expect(UserLinks.fromJson(json).portfolio, isNull);
    });
  });

  group('Photo responses with a nested user portfolio', () {
    // Reuse a recorded API photo; vary only the field covered by this fix.
    final expectations = jsonDecode(File(
      'test/fixtures/recorded_expectations/photos.json',
    ).readAsStringSync()) as List<dynamic>;
    final expectation = expectations.cast<Map<String, dynamic>>().firstWhere(
          (entry) =>
              (entry['httpRequest'] as Map<String, dynamic>)['path'] ==
              '/photos/vUGBY_MnSsg',
        );
    final response = expectation['httpResponse'] as Map<String, dynamic>;
    final recordedPhoto = (response['body'] as Map<String, dynamic>)['json']
        as Map<String, dynamic>;

    for (final endpoint in ['list', 'random', 'search']) {
      for (final value in ['omitted', 'null', 'URL']) {
        test('$endpoint accepts $value and roundtrips the nested portfolio',
            () async {
          final photo =
              jsonDecode(jsonEncode(recordedPhoto)) as Map<String, dynamic>;
          final user = photo['user'] as Map<String, dynamic>;
          final links = user['links'] as Map<String, dynamic>;
          if (value == 'omitted') {
            links.remove('portfolio');
          } else {
            links['portfolio'] = value == 'null' ? null : portfolio;
          }

          final client = UnsplashClient(
            settings: ClientSettings(
              credentials: AppCredentials(accessKey: '', secretKey: ''),
            ),
            httpClient: MockClient((request) async {
              final body = endpoint == 'search'
                  ? <String, dynamic>{
                      'total': 1,
                      'total_pages': 1,
                      'results': [photo],
                    }
                  : [photo];
              return http.Response(jsonEncode(body), 200, headers: {
                'content-type': 'application/json',
              });
            }),
          );
          addTearDown(client.close);

          final List<Photo> photos;
          if (endpoint == 'list') {
            photos = await client.photos.list().goAndGet();
          } else if (endpoint == 'random') {
            photos = await client.photos.random(count: 1).goAndGet();
          } else {
            photos = (await client.search.photos('example').goAndGet()).results;
          }

          final expected = value == 'URL' ? Uri.parse(portfolio) : null;
          expect(photos, hasLength(1));
          expect(photos.single.user.links.portfolio, expected);
          final decoded =
              jsonDecode(jsonEncode(photos.single)) as Map<String, dynamic>;
          expect(Photo.fromJson(decoded).user.links.portfolio, expected);
        });
      }
    }
  });
}
