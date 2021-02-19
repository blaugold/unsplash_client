import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'mock_server.dart';

var _hasSetupIntegrationTests = false;

void setupIntegrationTests(String name) {
  if (_hasSetupIntegrationTests) {
    return;
  }
  _hasSetupIntegrationTests = true;

  _recordedExpectations =
      File.fromUri(_recordedExpectationsDir.uri.resolve('$name.json'));

  _setupRecordedExpectationsTestHooks();
  _setupTestClientTestHooks();
}

bool get isCI => Platform.environment['CI'] != null;

// === Recorded Expectations ===================================================

bool get _updateRecordedExpectations =>
    Platform.environment['UPDATE_RECORDED_EXPECTATIONS'] != null;

final _recordedExpectationsDir =
    Directory('test/fixtures/recorded_expectations');
late File _recordedExpectations;

late MockServer mockServer;

void _setupRecordedExpectationsTestHooks() {
  setUpAll(() async {
    mockServer = MockServer(host: 'localhost', port: 1080);

    // Always reset everything on the mock server before all tests.
    await mockServer.reset();

    // Setup MockServer to replay responses.
    if (!_updateRecordedExpectations) {
      assert(
        await _recordedExpectations.exists(),
        'There are no recorded expectations.',
      );

      final recordedExpectations =
          decodeExpectations(await _recordedExpectations.readAsString());

      // If the content of `User-Agent` changes we can still use the recorded
      // expectations, since the header does not change the expected response.
      removeRequestHeaderFromExpectations(recordedExpectations, 'User-Agent');

      // The content length changes because we parse the json and don't format
      // it exactly the same way the actual API server does.
      removeResponseHeaderFromExpectations(
        recordedExpectations,
        'Content-Length',
      );

      final expectations = [
        expectationNotFoundExpectation,
        ...recordedExpectations,
      ];

      await mockServer.createExpectations(expectations);
    }
  });

  tearDownAll(() async {
    // Persist recorded requests
    if (_updateRecordedExpectations) {
      final recordedExpectations = await mockServer.recordedExpectations();

      // Remove the authorization header because it should not be necessary
      // to match request in tests and it contains credentials which should not
      // be checked in to VCS.
      removeRequestHeaderFromExpectations(
        recordedExpectations,
        'Authorization',
      );

      await _recordedExpectations.parent.create(recursive: true);
      final jsonEncoder = const JsonEncoder.withIndent('  ');
      await _recordedExpectations
          .writeAsString(jsonEncoder.convert(recordedExpectations));
    }

    mockServer.close();
  });
}

// === AppCredentials ==========================================================

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

  if (accessKey != null) {
    return AppCredentials(
      accessKey: accessKey,
      secretKey: secretKey,
    );
  }

  return readAppCredentials(File('./test-unsplash-credentials.json'));
}

// === UnsplashClient ==========================================================

late UnsplashClient client;

void _setupTestClientTestHooks() {
  setUpAll(() async {
    // In CI we run tests always against recorded responses and need not
    // credentials.
    final credentials = isCI
        ? AppCredentials(accessKey: '', secretKey: '')
        : await getTestAppCredentials();

    client = UnsplashClient(
      settings: ClientSettings(credentials: credentials),
      httpClient: IOClient(mockServer.createProxiedHttpClient()),
    );
  });

  tearDownAll(() {
    client.close();
  });
}
