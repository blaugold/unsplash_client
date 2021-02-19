import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'integration_test_utils.dart';

void main() {
  setupIntegrationTests('stats');

  test('total', () async {
    await client.stats.total().goAndGet();
  });

  test('month', () async {
    await client.stats.month().goAndGet();
  });
}
