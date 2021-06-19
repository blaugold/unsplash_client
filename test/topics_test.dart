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

  group('Topics', () {
    test('list', () async {
      final req = client.topics.list(
        idsOrSlugs: ['a', 'b'],
        page: 1,
        perPage: 2,
        orderBy: TopicOrder.position,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.topics.baseUrl.path,
          queryParameters: {
            'ids': 'a,b',
            'page': '1',
            'per_page': '2',
            'order_by': 'position',
          },
        ),
      );
    });

    test('get', () async {
      final req = client.topics.get('a');

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.topics.baseUrl.resolve('a').path,
        ),
      );
    });

    test('photos', () async {
      final req = client.topics.photos(
        'a',
        page: 1,
        perPage: 2,
        orientation: PhotoOrientation.landscape,
        orderBy: PhotoOrder.relevant,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.topics.baseUrl.resolve('a/photos').path,
          queryParameters: {
            'page': '1',
            'per_page': '2',
            'orientation': 'landscape',
            'order_by': 'relevant',
          },
        ),
      );
    });
  });
}
