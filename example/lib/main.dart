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
    settings: ClientSettings(credentials: appCredentials, debug: true),
  );

  // Fetch 5 random photos by calling `goAndGet` to execute the [Request]
  // returned from `random` and throw an exception if the [Response] is not ok.
  final photos = await client.photos.random(count: 5).goAndGet();

  // Do something with the photos.
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

  // Close the client when it is done being used to clean up allocated
  // resources.
  client.close();
}

/// Loads [AppCredentials] from environment variables
/// (`UNSPLASH_ACCESS_KEY`, `UNSPLASH_SECRET_KEY`).
///
/// Returns `null` if the variables do not exist.
AppCredentials? loadAppCredentialsFromEnv() {
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
