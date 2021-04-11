import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'integration_test_utils.dart';

void main() {
  setupIntegrationTests('topics');

  final testTopicSlug = 'wallpapers';

  test('list', () async {
    await client.topics.list(perPage: 2).goAndGet();
  });

  test('get', () async {
    await client.topics.get(testTopicSlug).goAndGet();
  });

  test('photos', () async {
    await client.topics.photos(testTopicSlug).goAndGet();
  });
}
