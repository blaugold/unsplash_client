import 'dart:convert';
import 'dart:io';

import 'package:unsplash_client/client.dart';

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
