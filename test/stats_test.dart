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

  group('Stats', () {
    test('total', () async {
      final req = client.stats.total();

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.stats.baseUrl.resolve('total').path,
        ),
      );
    });

    test('month', () async {
      final req = client.stats.month();

      expect(
        req.httpRequest,
        matchHttpRequest(
          method: 'GET',
          path: client.stats.baseUrl.resolve('month').path,
        ),
      );
    });
  });
}
