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

  group('Stats', () {
    test('total', () async {
      final response = await client.stats.total().go();

      print(response.data);

      expect(response.hasData, isTrue);
    });

    test('month', () async {
      final response = await client.stats.month().go();

      print(response.data);

      expect(response.hasData, isTrue);
    });
  });
}
