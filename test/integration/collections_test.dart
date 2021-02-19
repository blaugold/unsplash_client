import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'integration_test_utils.dart';

void main() {
  setupIntegrationTests('collections');

  group('Integration', () {
    group('Collections', () {
      test('list', () async {
        final response = await client.collections.list(perPage: 10).goAndGet();
        expect(response, hasLength(10));
      });
    });
  });
}
