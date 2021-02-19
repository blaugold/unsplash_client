import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'integration_test_utils.dart';

void main() {
  setupIntegrationTests('collections');

  final testCollectionId = '3773378';

  test('list', () async {
    await client.collections.list().goAndGet();
  });

  test('get', () async {
    await client.collections.get(testCollectionId).goAndGet();
  });

  test('photos', () async {
    await client.collections.photos(testCollectionId).goAndGet();
  });

  test('related', () async {
    await client.collections.related(testCollectionId).goAndGet();
  });
}
