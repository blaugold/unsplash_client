import 'package:test/test.dart';

import 'integration_test_utils.dart';

void main() {
  setupIntegrationTests('stats');

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
        // TODO: getting 404 from api
        skip: true,
      );
    });
  });
}
