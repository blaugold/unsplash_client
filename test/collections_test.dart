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

  group('Collections', () {
    test('list', () async {
      final req = client.collections.list(
        page: 1,
        perPage: 2,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.collections.baseUrl.path,
          queryParameters: {
            'page': '1',
            'per_page': '2',
          },
        ),
      );
    });

    test('get', () async {
      final req = client.collections.get('a');

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.collections.baseUrl.resolve('a').path,
        ),
      );
    });

    test('photos', () async {
      final req = client.collections.photos(
        'a',
        page: 1,
        perPage: 2,
        orientation: PhotoOrientation.landscape,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.collections.baseUrl.resolve('a/photos').path,
          queryParameters: {
            'page': '1',
            'per_page': '2',
            'orientation': 'landscape',
          },
        ),
      );
    });

    test('related', () async {
      final req = client.collections.related('a');

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.collections.baseUrl.resolve('a/related').path,
        ),
      );
    });
  });
}
