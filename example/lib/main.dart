import 'dart:convert';
import 'dart:io';

import 'package:unsplash_client/unsplash_client.dart';

void main(List<String> args) async {
  // Load app credentials from environment variables or file.
  var appCredentials = loadAppCredentialsFromEnv();

  if (appCredentials == null) {
    if (args.length != 1) {
      throw 'Please provide a credentials file as the first and only argument.';
    }

    appCredentials = await loadAppCredentialsFromFile(args.first);
  }

  // Create a client.
  final client = UnsplashClient(
    settings: ClientSettings(credentials: appCredentials),
  );

  // Fetch 5 random photos.
  final response = await client.photos.random(count: 5).go();

  // Check that the request was successful.
  if (!response.isOk) {
    throw 'Something is wrong: $response';
  }

  // Do something with the photos.
  final photos = response.data;
  print('--- Photos');
  print(photos);
  print('---\n');

  // Create a dynamically resizing url.
  final resizedUrl = photos.first.urls.raw.resizePhoto(
    width: 400,
    height: 400,
    fit: ResizeFitMode.clamp,
    format: ImageFormat.webp,
  );
  print('--- Resized Url');
  print(resizedUrl);
}

/// Loads [AppCredentials] from environment variables
/// (`UNSPLASH_ACCESS_KEY`, `UNSPLASH_SECRET_KEY`).
///
/// Returns `null` if the variables do not exist.
AppCredentials loadAppCredentialsFromEnv() {
  final accessKey = Platform.environment['UNSPLASH_ACCESS_KEY'];
  final secretKey = Platform.environment['UNSPLASH_SECRET_KEY'];

  if (accessKey != null && secretKey != null) {
    return AppCredentials(
      accessKey: accessKey,
      secretKey: secretKey,
    );
  }

  return null;
}

/// Loads [AppCredentials] from a json file with the given [fileName].
Future<AppCredentials> loadAppCredentialsFromFile(String fileName) async {
  final file = File(fileName);
  final content = await file.readAsString();
  final json = jsonDecode(content) as Map<String, dynamic>;
  return AppCredentials.fromJson(json);
}
