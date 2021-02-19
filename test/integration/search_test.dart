import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'integration_test_utils.dart';

void main() {
  setupIntegrationTests('search');

  test('photos', () async {
    await client.search.photos('test').goAndGet();
  });

  test('collections', () async {
    await client.search.collections('test').goAndGet();
  });

  test('users', () async {
    await client.search.photos('users').goAndGet();
  });
}
