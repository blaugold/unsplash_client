import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'test_utils.dart';

void main() {
  final client = UnsplashClient(
    settings: ClientSettings(
      credentials: AppCredentials(
        secretKey: '',
        accessKey: '',
      ),
    ),
  );

  group('Search', () {
    test('photos', () async {
      final req = client.search.photos(
        'query',
        page: 2,
        perPage: 3,
        collections: ['a', 'b'],
        orientation: PhotoOrientation.squarish,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.search.baseUrl.resolve('photos').path,
          queryParameters: {
            'query': 'query',
            'page': '2',
            'per_page': '3',
            'collections': 'a,b',
            'orientation': 'squarish',
          },
        ),
      );
    });

    test('collections', () async {
      final req = client.search.collections(
        'query',
        page: 2,
        perPage: 3,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.search.baseUrl.resolve('collections').path,
          queryParameters: {
            'query': 'query',
            'page': '2',
            'per_page': '3',
          },
        ),
      );
    });

    test('users', () async {
      final req = client.search.users(
        'query',
        page: 2,
        perPage: 3,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.search.baseUrl.resolve('users').path,
          queryParameters: {
            'query': 'query',
            'page': '2',
            'per_page': '3',
          },
        ),
      );
    });
  });
}
