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

  group('Users', () {
    test('get', () async {
      final req = client.users.get('username');

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.users.baseUrl.resolve('username').path,
        ),
      );
    });

    test('portfolio', () async {
      final req = client.users.portfolio('username');

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.users.baseUrl.resolve('username/portfolio').path,
        ),
      );
    });

    test('photos', () async {
      final req = client.users.photos(
        'username',
        page: 2,
        perPage: 3,
        orderBy: PhotoOrder.relevant,
        stats: true,
        resolution: StatisticsResolution.days,
        orientation: PhotoOrientation.landscape,
        quantity: 5,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.users.baseUrl.resolve('username/photos').path,
          queryParameters: {
            'page': '2',
            'per_page': '3',
            'order_by': 'relevant',
            'stats': 'true',
            'resolution': 'days',
            'orientation': 'landscape',
            'quantity': '5',
          },
        ),
      );
    });

    test('likedPhotos', () async {
      final req = client.users.likedPhotos(
        'username',
        page: 2,
        perPage: 3,
        orderBy: PhotoOrder.relevant,
        orientation: PhotoOrientation.landscape,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.users.baseUrl.resolve('username/likes').path,
          queryParameters: {
            'page': '2',
            'per_page': '3',
            'order_by': 'relevant',
            'orientation': 'landscape',
          },
        ),
      );
    });

    test('collections', () async {
      final req = client.users.collections(
        'username',
        page: 2,
        perPage: 3,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.users.baseUrl.resolve('username/collections').path,
          queryParameters: {
            'page': '2',
            'per_page': '3',
          },
        ),
      );
    });

    test('statistics', () async {
      final req = client.users.statistics(
        'username',
        resolution: StatisticsResolution.days,
        quantity: 5,
      );

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.users.baseUrl.resolve('username/statistics').path,
          queryParameters: {
            'resolution': 'days',
            'quantity': '5',
          },
        ),
      );
    });
  });
}
