import 'dart:io';

import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'test_utils.dart';

void main() {
  UnsplashClient client;

  setUpAll(() async {
    final credentialsFile = File('./test-unsplash-credentials.json');
    final credentials = await readAppCredentials(credentialsFile);

    client = UnsplashClient(settings: ClientSettings(credentials: credentials));
  });

  group('Photos', () {
    test('list', () async {
      final photos = await client.photos.list(perPage: 2).go();

      expect(photos.data, hasLength(2));
    });

    test('get', () async {
      final listResponse = await client.photos.list(perPage: 1).go();

      final id = listResponse.data.first.id;
      final getResponse = await client.photos.get(id).go();

      expect(getResponse.data.id, equals(id));
    });

    test('random', () async {
      final photos = await client.photos.random(count: 2).go();

      expect(photos.data, hasLength(2));
    });

    test('statistics', () async {
      final listResponse = await client.photos.list(perPage: 1).go();

      final id = listResponse.data.first.id;
      final statisticsResponse = await client.photos.statistics(id).go();

      expect(statisticsResponse.data.id, equals(id));
    });

    test('download', () async {
      final listResponse = await client.photos.list(perPage: 1).go();

      final id = listResponse.data.first.id;
      final downloadResponse = await client.photos.download(id).go();

      expect(downloadResponse.hasData, isTrue);
    });
  });
}
