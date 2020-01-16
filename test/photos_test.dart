import 'dart:io';

import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'test_utils.dart';

void main() {
  AppCredentials credentials;
  UnsplashClient client;

  setUpAll(() async {
    final credentialsFile = File('./test-unsplash-credentials.json');
    credentials = await readAppCredentials(credentialsFile);

    client = UnsplashClient(settings: ClientSettings(credentials: credentials));
  });

  group('Photos', () {
    test('list', () async {
      final photos = await client.photos.list(perPage: 2).go();

      print(photos.data);

      expect(photos.data, hasLength(2));
    });

    test('random', () async {
      final photos = await client.photos.random(count: 2).go();

      print(photos.data);

      expect(photos.data, hasLength(2));
    });
  });
}
