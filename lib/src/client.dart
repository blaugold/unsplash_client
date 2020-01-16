import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../client.dart';
import 'app_credentials.dart';
import 'exception.dart';
import 'photos.dart';

class ClientSettings {
  const ClientSettings({
    @required this.credentials,
  });

  final AppCredentials credentials;
  final int maxPageSize = 30;
}

class UnsplashClient {
  UnsplashClient({@required this.settings}) : _http = http.Client();

  final baseUrl = Uri.parse('https://api.unsplash.com/');

  final http.Client _http;

  final ClientSettings settings;

  Photos get photos => Photos(this);
}

typedef BodyDeserializer<T> = T Function(dynamic body);

class Request<T> {
  const Request({
    @required this.client,
    @required this.request,
    this.json,
    @required this.isPublicAction,
    this.bodyDeserializer,
  });

  final UnsplashClient client;
  final http.Request request;
  final dynamic json;
  final bool isPublicAction;
  final BodyDeserializer<T> bodyDeserializer;

  Future<Response<T>> go() async {
    final request = _prepareRequest();
    http.StreamedResponse response;
    String body;
    dynamic json;
    T data;
    dynamic error;

    try {
      response = await client._http.send(request);

      body = await response.stream.bytesToString();

      json = jsonDecode(body);

      if (bodyDeserializer != null) {
        data = bodyDeserializer(json);
      }
    } catch (e, stackTrace) {
      // ignore: avoid_catches_without_on_clauses
      error = UnsplashClientException(
        message: 'Failure while making request: $e',
        cause: e,
        stackTrace: stackTrace,
      );
    }

    return Response(
      request: this,
      response: response,
      error: error,
      body: body,
      json: json,
      data: data,
    );
  }

  http.Request _prepareRequest() {
    final request = _copyRequest();

    if (json != null) {
      request.body = jsonEncode(json);
    }

    request.headers.addAll(_createHeaders());

    return request;
  }

  http.Request _copyRequest() {
    final request = http.Request(this.request.method, this.request.url);
    request.headers.addAll(this.request.headers);
    request.maxRedirects = this.request.maxRedirects;
    request.followRedirects = this.request.followRedirects;
    request.persistentConnection = this.request.persistentConnection;
    request.encoding = this.request.encoding;
    request.bodyBytes = this.request.bodyBytes;
    return request;
  }

  Map<String, String> _createHeaders() {
    final headers = <String, String>{};

    // API Version
    headers.addAll({'Accept-Version': 'v1'});

    // Auth
    assert(isPublicAction);
    headers.addAll(_publicActionAuthHeader(client.settings.credentials));

    return headers;
  }
}

class Response<T> {
  Response({
    this.request,
    this.response,
    this.error,
    this.body,
    this.json,
    this.data,
  });

  final Request<T> request;

  final dynamic error;

  final http.BaseResponse response;

  final String body;

  final dynamic json;

  final T data;

  bool get isOk => error == null && response.statusCode < 400;

  bool get hasData => isOk && data != null;

  @override
  String toString() {
    return 'Response{isOk: $isOk, error: $error, '
        'status: ${response?.statusCode}';
  }
}

Map<String, String> _publicActionAuthHeader(AppCredentials credentials) {
  return {'Authorization': 'Client-ID ${credentials.accessKey}'};
}

Map<String, String> _publicActionQueryParam(AppCredentials credentials) {
  return {'client_id': credentials.accessKey};
}
