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
        orderBy: PhotoOrder.relevant,
        color: PhotoColor.red,
        contentFilter: ContentFilter.high,
        lang: 'es',
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
            'order_by': 'relevant',
            'color': 'red',
            'content_filter': 'high',
            'lang': 'es',
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
