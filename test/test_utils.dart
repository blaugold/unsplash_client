import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

Matcher matchHttpRequest({
  required String method,
  String path = '',
  Map<String, String> queryParameters = const {},
}) {
  return MatchRequest(
    method: method,
    path: path,
    queryParameters: queryParameters,
  );
}

class MatchRequest extends Matcher {
  static final DeepCollectionEquality queryParametersEquality =
      DeepCollectionEquality.unordered();

  const MatchRequest({
    required this.method,
    required this.path,
    required this.queryParameters,
  });

  final String method;
  final String path;
  final Map<String, String> queryParameters;

  @override
  Description describe(Description description) {
    return description
        .add('Method: $method\n')
        .add('Path: $path\n')
        .add('Query Parameters: ')
        .addDescriptionOf(queryParameters);
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    assert(item is http.Request);
    final req = item as http.Request;

    return mismatchDescription
        .add('Method: ${req.method}\n')
        .add('Path: ${req.url.path}\n')
        .add('Query Parameters: ')
        .addDescriptionOf(req.url.queryParameters);
  }

  @override
  bool matches(dynamic item, Map matchState) {
    assert(item is http.Request);
    final req = item as http.Request;

    return req.method == method &&
        req.url.path == path &&
        queryParametersEquality.equals(
          req.url.queryParameters,
          queryParameters,
        );
  }
}
