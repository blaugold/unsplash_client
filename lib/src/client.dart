import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'app_credentials.dart';
import 'collections.dart';
import 'model/model.dart';
import 'photos.dart';
import 'search.dart';
import 'stats.dart';
import 'topics.dart';
import 'users.dart';

/// The settings for the [UnsplashClient].
@immutable
class ClientSettings {
  /// Creates new [ClientSettings].
  ///
  /// [credentials] must not be `null`.
  const ClientSettings({
    this.credentials,
    this.debug = false,
    this.loggerName = 'unsplash_client',
  });

  /// The credentials used by the [UnsplashClient] to authenticate the app.
  final AppCredentials? credentials;

  /// Whether to log debug information.
  @Deprecated(
    'Set [UnsplashClient.logger.level] to Level.FINE for debug logging',
  )
  final bool debug;

  /// The name of the [Logger] used by the [UnsplashClient].
  final String loggerName;

  /// The maximum number of items a list request can return.
  ///
  /// Used by the [UnsplashClient] to check request parameters.
  final int maxPageSize = 30;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientSettings &&
          runtimeType == other.runtimeType &&
          credentials == other.credentials &&
          maxPageSize == other.maxPageSize;

  @override
  int get hashCode => credentials.hashCode ^ maxPageSize.hashCode;

  @override
  String toString() {
    return 'ClientSettings{credentials: $credentials, '
        'maxPageSize: $maxPageSize}';
  }
}

/// A client for accessing the unsplash api.
///
/// Http calls are made through the [http](https://pub.dev/packages/http)
/// package, which provides a platform independent client, making the
/// [UnsplashClient] platform independent as well.
class UnsplashClient {
  /// Creates a new instance of the [UnsplashClient].
  ///
  /// [settings] must not be `null`.
  ///
  /// If no [httpClient] is provided, one is created.
  ///
  /// If no [proxyBaseUrl] is provided the Unsplash standard base URL
  /// https://api.unsplash.com/ is used
  UnsplashClient({required this.settings, http.Client? httpClient, Uri? proxyBaseUrl})
      : _http = httpClient ?? http.Client(),
        logger = Logger(settings.loggerName),
        baseUrl = proxyBaseUrl ?? Uri.parse('https://api.unsplash.com/');

  /// The [Logger] used by this instance.
  final Logger logger;

  /// The base url of the unsplash api or its proxy.
  final Uri baseUrl;

  /// The [ClientSettings] used by this client.
  final ClientSettings settings;

  /// Provides access to resources related to [User].
  Users get users => Users(this);

  /// Provides access to resources related to [Photo].
  Photos get photos => Photos(this);

  /// Provides access to resources related to [Collection].
  Collections get collections => Collections(this);

  /// Search for resources.
  Search get search => Search(this);

  /// Provides access to resources related to [Topic].
  Topics get topics => Topics(this);

  /// Provides access to the [TotalStats] and [MonthStats] resources.
  Stats get stats => Stats(this);

  final http.Client _http;

  var _closed = false;

  /// Closes this client and frees allocated resources.
  ///
  /// Failure to close this a client might cause the dart process to hang.
  ///
  /// After this method has been called this instance must not be used any more.
  void close() {
    _closed = true;
    _http.close();
  }
}

typedef BodyDeserializer<T> = T Function(dynamic body);

/// A request holds all the information necessary to make a request to the api.
///
/// [T] is the type of the deserialized body.
///
/// A request is immutable and can be executed multiple times, each time
/// returning a new [Response]. To execute it and receive a [Response], call
/// [go].
///
/// The internal state of [httpRequest] and [jsonBody] should not be mutated.
@immutable
class Request<T> {
  /// Creates a new request.
  const Request({
    required this.client,
    required this.httpRequest,
    this.jsonBody,
    required this.isPublicAction,
    this.bodyDeserializer,
  });

  /// The [UnsplashClient] this request was created with.
  final UnsplashClient client;

  /// The [http.Request], as built by the endpoint, which created this request.
  ///
  /// The [http.Request] actually sent, might be different and is available
  /// through [Response.httpRequest].
  final http.Request httpRequest;

  /// The common dart json representation of the request body.
  ///
  /// This value will be encoded with [JsonEncoder].
  final dynamic jsonBody;

  /// Whether this is a [public action](https://unsplash.com/documentation#public-actions).
  final bool isPublicAction;

  /// The function used to transform the json response into [T].
  final BodyDeserializer<T>? bodyDeserializer;

  /// Execute this [Request] and return its [Response].
  ///
  /// Might reject with [http.ClientException] during a network failure.
  Future<Response<T>> go() async {
    if (client._closed) {
      throw StateError(
        'Cannot execute request because UnsplashClient has already been '
        'closed.',
      );
    }

    final httpRequest = _prepareRequest();
    http.StreamedResponse httpResponse;
    String body;
    dynamic json;
    T? data;

    // ignore: deprecated_member_use_from_same_package
    if (client.settings.debug) {
      print('Sending request:\n${_printRequest(httpRequest)}\n');
    }

    if (client.logger.isLoggable(Level.FINE)) {
      client.logger.fine('Sending request:\n${_printRequest(httpRequest)}');
    }

    httpResponse = await client._http.send(httpRequest);

    // ignore: deprecated_member_use_from_same_package
    if (client.settings.debug) {
      print('Received response:\n${_printResponse(httpResponse)}\n');
    }

    if (client.logger.isLoggable(Level.FINE)) {
      client.logger.fine('Received response:\n${_printResponse(httpResponse)}');
    }

    body = await httpResponse.stream.bytesToString();

    try {
      json = jsonDecode(body);
    } catch (e) {
      // ignore: avoid_catches_without_on_clauses
    }

    if (httpResponse.statusCode < 400 && json != null && bodyDeserializer != null) {
      data = bodyDeserializer!(json);
    }

    return Response(
      request: this,
      httpRequest: httpRequest,
      httpResponse: httpResponse,
      body: body,
      json: json,
      data: data,
    );
  }

  http.Request _prepareRequest() {
    final request = _copyRequest();

    if (jsonBody != null) {
      request.body = jsonEncode(jsonBody);
    }

    request.headers.addAll(_createHeaders());

    return request;
  }

  http.Request _copyRequest() {
    final request = http.Request(httpRequest.method, httpRequest.url);
    request.headers.addAll(httpRequest.headers);
    request.maxRedirects = httpRequest.maxRedirects;
    request.followRedirects = httpRequest.followRedirects;
    request.persistentConnection = httpRequest.persistentConnection;
    request.encoding = httpRequest.encoding;
    request.bodyBytes = httpRequest.bodyBytes;
    return request;
  }

  Map<String, String> _createHeaders() {
    final headers = <String, String>{
      // Api Version https://unsplash.com/documentation#version
      'Accept-Version': 'v1',
      'Accept': 'application/json',
    };

    if (jsonBody != null) {
      headers.addAll({'Content-Type': 'application/json; charset=utf-8'});
    }

    // Auth
    // TODO implement oauth
    assert(isPublicAction);
    if (client.settings.credentials != null) {
      headers.addAll(_publicActionAuthHeader(client.settings.credentials!));
    }

    return headers;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Request &&
          runtimeType == other.runtimeType &&
          client == other.client &&
          httpRequest == other.httpRequest &&
          jsonBody == other.jsonBody &&
          isPublicAction == other.isPublicAction &&
          bodyDeserializer == other.bodyDeserializer;

  @override
  int get hashCode =>
      client.hashCode ^ httpRequest.hashCode ^ jsonBody.hashCode ^ isPublicAction.hashCode ^ bodyDeserializer.hashCode;

  @override
  String toString() {
    return 'Request{method: ${httpRequest.method}, url: ${httpRequest.url}}';
  }
}

/// The response to a [Request].
///
/// [T] is the type of the deserialized body.
///
/// Before using [data] check that the response [hasData].
@immutable
class Response<T> {
  /// Creates a new response.
  const Response({
    required this.request,
    required this.httpRequest,
    required this.httpResponse,
    required this.body,
    this.json,
    this.data,
  });

  /// The [Request] which created this response.
  final Request<T> request;

  /// The [http.Request] send to the server.
  final http.Request httpRequest;

  /// The [http.BaseResponse] received from the server.
  final http.BaseResponse httpResponse;

  /// The as utf8 decoded body of the response.
  final String body;

  /// The as json decoded body of the response.
  final dynamic json;

  /// The deserialized body of the response.
  final T? data;

  /// The status code of [httpResponse].
  int get statusCode => httpResponse.statusCode;

  /// Whether [statusCode] is below 400.
  bool get isOk => statusCode < 400;

  /// Whether this response [isOk] and [data] is not `null`.
  bool get hasData => isOk && data != null;

  /// Returns [data] if this request [hasData]. If the request has no data a
  /// [StateError] is thrown.
  T get() {
    if (!isOk) {
      throw StateError('Request is not OK: $statusCode\n$body');
    }

    if (!hasData) {
      throw StateError('Request has no data: $statusCode\n$body');
    }

    return data!;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Response &&
          runtimeType == other.runtimeType &&
          request == other.request &&
          httpRequest == other.httpRequest &&
          httpResponse == other.httpResponse &&
          body == other.body &&
          json == other.json &&
          data == other.data;

  @override
  int get hashCode =>
      request.hashCode ^ httpRequest.hashCode ^ httpResponse.hashCode ^ body.hashCode ^ json.hashCode ^ data.hashCode;

  @override
  String toString() {
    return 'Response{isOk: $isOk, status: $statusCode}';
  }
}

/// Extension on [Request].
extension RequestExtension<T> on Request<T> {
  /// Executes this request and returns the response's data, in one call.
  ///
  /// See: [Request.go], [Response.get]
  Future<T> goAndGet() async {
    return (await go()).get();
  }
}

Map<String, String> _publicActionAuthHeader(AppCredentials credentials) {
  return {'Authorization': 'Client-ID ${credentials.accessKey}'};
}

Map<String, String> _sanitizeHeaders(Map<String, String> headers) {
  return headers.map((key, value) {
    final isAuthorization = key.toLowerCase() == 'authorization';
    return MapEntry(key, isAuthorization ? 'HIDDEN' : value);
  });
}

String _printRequest(http.Request request) {
  return '''
${request.method} ${request.url}
${_printHeaders(_sanitizeHeaders(request.headers))}
''';
}

String _printResponse(http.BaseResponse response) {
  return '''
${response.statusCode} ${response.reasonPhrase}
${_printHeaders(response.headers)}
''';
}

String _printHeaders(Map<String, String> headers) {
  return headers.entries.map((header) => '${header.key}: ${header.value}').join('\n');
}
