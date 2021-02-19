import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'integration_test_utils.dart';

void main() {
  setupIntegrationTests('users');

  final testUsername = 'lucreative';

  test('get', () async {
    await client.users.get(testUsername).goAndGet();
  });

  test('portfolio', () async {
    await client.users.portfolio(testUsername).goAndGet();
  });

  test('photos', () async {
    await client.users.photos(testUsername).goAndGet();
  });

  test('likedPhotos', () async {
    await client.users.likedPhotos(testUsername).goAndGet();
  });

  test('collections', () async {
    await client.users.collections(testUsername).goAndGet();
  });

  test('statistics', () async {
    await client.users.statistics(testUsername).goAndGet();
  });
}
