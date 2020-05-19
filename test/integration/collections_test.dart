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
    group('Collections', () {
      test('list', () async {
        final response = await client.collections.list(perPage: 10).go();

        expect(response.data, hasLength(10));
      });
    });
  });
}
