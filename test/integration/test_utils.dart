import 'dart:convert';
import 'dart:io';

import 'package:unsplash_client/unsplash_client.dart';

// ignore_for_file: avoid_catches_without_on_clauses

/// Reads a [File] as [AppCredentials].
Future<AppCredentials> readAppCredentials(File file) async {
  try {
    final json = await _readJsonFile(file) as Map<String, dynamic>;
    return AppCredentials.fromJson(json);
  } catch (e) {
    throw Exception('Could not read $file as AppCredentials: $e');
  }
}

Future<dynamic> _readJsonFile(File file) async {
  try {
    final fileContents = await file.readAsString();
    return jsonDecode(fileContents);
  } catch (e) {
    throw Exception('Could not read $file as json: $e');
  }
}

/// Loads [AppCredentials] for tests, either from env variables
/// (UNSPLASH_ACCESS_KEY, UNSPLASH_SECRET_KEY)
/// or a file ('./test-unsplash-credentials.json').
Future<AppCredentials> getTestAppCredentials() async {
  final accessKey = Platform.environment['UNSPLASH_ACCESS_KEY'];
  final secretKey = Platform.environment['UNSPLASH_SECRET_KEY'];

  if (accessKey != null && secretKey != null) {
    return AppCredentials(
      accessKey: accessKey,
      secretKey: secretKey,
    );
  }

  return readAppCredentials(File('./test-unsplash-credentials.json'));
}
