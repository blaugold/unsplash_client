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

  group('Photos', () {
    test('list', () async {
      final req = client.photos.list(
        page: 1,
        perPage: 2,
        orderBy: PhotoOrder.relevant,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.photos.baseUrl.path,
          queryParameters: {
            'page': '1',
            'per_page': '2',
            'order_by': 'relevant',
          },
        ),
      );
    });

    test('get', () async {
      final req = client.photos.get('a');

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.photos.baseUrl.resolve('a').path,
        ),
      );
    });

    test('random', () async {
      final req = client.photos.random(
        count: 2,
        username: 'username',
        query: 'query',
        collections: ['a', 'b'],
        featured: true,
        orientation: PhotoOrientation.portrait,
        contentFilter: ContentFilter.high,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.photos.baseUrl.resolve('random').path,
          queryParameters: {
            'count': '2',
            'username': 'username',
            'query': 'query',
            'collections': 'a,b',
            'featured': 'true',
            'orientation': 'portrait',
            'content_filter': 'high',
          },
        ),
      );
    });

    test('statistics', () async {
      final req = client.photos.statistics(
        'id',
        quantity: 5,
        resolution: StatisticsResolution.days,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.photos.baseUrl.resolve('id/statistics').path,
          queryParameters: {
            'quantity': '5',
            'resolution': 'days',
          },
        ),
      );
    });

    test('download', () async {
      final req = client.photos.download('id');

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.photos.baseUrl.resolve('id/download').path,
        ),
      );
    });

    test('download with location', () async {
      final req = client.photos
          .download('id', location: Uri(queryParameters: {'a': 'b'}));

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.photos.baseUrl.resolve('id/download').path,
          queryParameters: {'a': 'b'},
        ),
      );
    });
  });
}
