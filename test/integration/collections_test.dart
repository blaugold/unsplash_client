import 'package:test/test.dart';

import 'integration_test_utils.dart';

void main() {
  setupIntegrationTests('collections');

  group('Integration', () {
    group('Collections', () {
      test('list', () async {
        final response = await client.collections.list(perPage: 10).go();

        expect(response.data, hasLength(10));
      });
    });
  });
}
