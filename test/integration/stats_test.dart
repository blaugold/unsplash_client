import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'test_utils.dart';

void main() {
  UnsplashClient client;

  setUpAll(() async {
    final credentials = await getTestAppCredentials();

    client = UnsplashClient(settings: ClientSettings(credentials: credentials));
  });

  group('Integration', () {
    group('Stats', () {
      test('total', () async {
        final response = await client.stats.total().go();

        expect(response.hasData, isTrue);
      });

      test(
        'month',
        () async {
          final response = await client.stats.month().go();
          expect(response.hasData, isTrue);
        },
        // TODO getting 404 from api
        skip: true,
      );
    });
  });
}
