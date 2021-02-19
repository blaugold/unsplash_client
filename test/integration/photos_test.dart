import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'integration_test_utils.dart';

void main() {
  setupIntegrationTests('photos');

  final testPhotoId = 'vUGBY_MnSsg';

  test('list', () async {
    await client.photos.list(perPage: 2).goAndGet();
  });

  test('get', () async {
    await client.photos.get(testPhotoId).goAndGet();
  });

  test('random', () async {
    await client.photos.random(count: 2).goAndGet();
  });

  test('statistics', () async {
    await client.photos.statistics(testPhotoId).goAndGet();
  });

  test('download', () async {
    await client.photos.download(testPhotoId).goAndGet();
  });
}
