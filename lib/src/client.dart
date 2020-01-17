import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../unsplash_client.dart';
import 'app_credentials.dart';
import 'photos.dart';
import 'search.dart';
import 'stats.dart';
import 'users.dart';

/// The settings for the [UnsplashClient].
@immutable
class ClientSettings {
  /// Creates new [ClientSettings].
  ///
  /// [credentials] must not be `null`.
  const ClientSettings({
    @required this.credentials,
    this.debug = false,
  })  : assert(credentials != null),
        assert(debug != null);

  /// The credentials used by the [UnsplashClient] to authenticate the app.
  final AppCredentials credentials;

  /// Whether to log debug information.
  final bool debug;

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
  UnsplashClient({
    @required this.settings,
    http.Client httpClient,
  })  : assert(settings != null),
        _http = httpClient ?? http.Client();

  /// The base url of the unsplash api.
  final Uri baseUrl = Uri.parse('https://api.unsplash.com/');

  /// The [ClientSettings] used by this client.
  final ClientSettings settings;

  /// Provides access to resources related to [User].
  Users get users => Users(this);

  /// Provides access to resources related to [Photo].
  Photos get photos => Photos(this);

  /// Search for resources.
  Search get search => Search(this);

  /// Provides access to the [TotalStats] and [MonthStats] resources.
  Stats get stats => Stats(this);

  final http.Client _http;
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
    @required this.client,
    @required this.httpRequest,
    this.jsonBody,
    @required this.isPublicAction,
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
  final BodyDeserializer<T> bodyDeserializer;

  /// Execute this [Request] and return its [Response].
  ///
  /// Might reject with [http.ClientException] during a network failure.
  Future<Response<T>> go() async {
    final httpRequest = _prepareRequest();
    http.StreamedResponse httpResponse;
    String body;
    dynamic json;
    T data;

    if (client.settings.debug) {
      print('Sending request:\n${_printRequest(httpRequest)}\n');
    }

    httpResponse = await client._http.send(httpRequest);

    if (client.settings.debug) {
      print('Received response:\n${_printResponse(httpResponse)}\n');
    }

    body = await httpResponse.stream.bytesToString();

    json = jsonDecode(body);

    if (bodyDeserializer != null) {
      data = bodyDeserializer(json);
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
    headers.addAll(_publicActionAuthHeader(client.settings.credentials));

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
      client.hashCode ^
      httpRequest.hashCode ^
      jsonBody.hashCode ^
      isPublicAction.hashCode ^
      bodyDeserializer.hashCode;

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
    this.request,
    this.httpRequest,
    this.httpResponse,
    this.body,
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
  final T data;

  /// The status code of [httpResponse].
  int get statusCode => httpResponse?.statusCode;

  /// Whether [statusCode] is bellow 400.
  bool get isOk => statusCode < 400;

  /// Whether this response [isOk] and [data] is not `null`.
  bool get hasData => isOk && data != null;

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
      request.hashCode ^
      httpRequest.hashCode ^
      httpResponse.hashCode ^
      body.hashCode ^
      json.hashCode ^
      data.hashCode;

  @override
  String toString() {
    return 'Response{isOk: $isOk, status: $statusCode}';
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
  return headers.entries
      .map((header) => '${header.key}: ${header.value}')
      .join('\n');
}
