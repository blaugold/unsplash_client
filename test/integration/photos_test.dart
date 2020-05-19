import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'test_utils.dart';

void main() {
  UnsplashClient client;

  setUpAll(() async {
    final credentials = await getTestAppCredentials();

    client = UnsplashClient(settings: ClientSettings(credentials: credentials));
  });

  Future<Photo> getSinglePhoto() async {
    final resp = await client.photos.random().go();

    expect(resp.isOk, isTrue);
    expect(resp.data, hasLength(1));

    return resp.data.first;
  }

  group('Integration', () {
    group('Photos', () {
      test('list', () async {
        final photos = await client.photos.list(perPage: 2).goAndGet();

        expect(photos, hasLength(2));
      });

      test('get', () async {
        final photo = await getSinglePhoto();
        final id = photo.id;

        final data = await client.photos.get(id).goAndGet();

        expect(data.id, equals(id));
      });

      test('random', () async {
        final photos = await client.photos.random(count: 2).goAndGet();

        expect(photos, hasLength(2));
      });

      test('statistics', () async {
        final photo = await getSinglePhoto();
        final id = photo.id;

        final stats = await client.photos.statistics(id).goAndGet();

        expect(stats.id, equals(id));
      });

      test('download', () async {
        final photo = await getSinglePhoto();

        final response = await client.photos.download(photo.id).go();

        expect(response.hasData, isTrue);
      });
    });
  });
}
