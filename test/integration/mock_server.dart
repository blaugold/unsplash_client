import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

/// Certificate used by MockServer for TLS
final _mockServerCertificate = '''
-----BEGIN CERTIFICATE-----
MIIDqDCCApCgAwIBAgIEPhwe6TANBgkqhkiG9w0BAQsFADBiMRswGQYDVQQDDBJ3
d3cubW9ja3NlcnZlci5jb20xEzARBgNVBAoMCk1vY2tTZXJ2ZXIxDzANBgNVBAcM
BkxvbmRvbjEQMA4GA1UECAwHRW5nbGFuZDELMAkGA1UEBhMCVUswIBcNMTYwNjIw
MTYzNDE0WhgPMjExNzA1MjcxNjM0MTRaMGIxGzAZBgNVBAMMEnd3dy5tb2Nrc2Vy
dmVyLmNvbTETMBEGA1UECgwKTW9ja1NlcnZlcjEPMA0GA1UEBwwGTG9uZG9uMRAw
DgYDVQQIDAdFbmdsYW5kMQswCQYDVQQGEwJVSzCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAPGORrdkwTY1H1dvQPYaA+RpD+pSbsvHTtUSU6H7NQS2qu1p
sE6TEG2fE+Vb0QIXkeH+jjKzcfzHGCpIU/0qQCu4RVycrIW4CCdXjl+T3L4C0I3R
mIMciTig5qcAvY9P5bQAdWDkU36YGrCjGaX3QlndGxD9M974JdpVK4cqFyc6N4gA
Onys3uS8MMmSHTjTFAgR/WFeJiciQnal+Zy4ZF2x66CdjN+hP8ch2yH/CBwrSBc0
ZeH2flbYGgkh3PwKEqATqhVa+mft4dCrvqBwGhBTnzEGWK/qrl9xB4mTs4GQ/Z5E
8rXzlvpKzVJbfDHfqVzgFw4fQFGV0XMLTKyvOX0CAwEAAaNkMGIwHQYDVR0OBBYE
FH3W3sL4XRDM/VnRayaSamVLISndMA8GA1UdEwEB/wQFMAMBAf8wCwYDVR0PBAQD
AgG2MCMGA1UdJQQcMBoGCCsGAQUFBwMBBggrBgEFBQcDAgYEVR0lADANBgkqhkiG
9w0BAQsFAAOCAQEAecfgKuMxCBe/NxVqoc4kzacf9rjgz2houvXdZU2UDBY3hCs4
MBbM7U9Oi/3nAoU1zsA8Rg2nBwc76T8kSsfG1TK3iJkfGIOVjcwOoIjy3Z8zLM2V
YjYbOUyAQdO/s2uShAmzzjh9SV2NKtcNNdoE9e6udvwDV8s3NGMTUpY5d7BHYQqV
sqaPGlsKi8dN+gdLcRbtQo29bY8EYR5QJm7QJFDI1njODEnrUjjMvWw2yjFlje59
j/7LBRe2wfNmjXFYm5GqWft10UJ7Ypb3XYoGwcDac+IUvrgmgTHD+E3klV3SUi8i
Gm5MBedhPkXrLWmwuoMJd7tzARRHHT6PBH/ZGw==
-----END CERTIFICATE-----
''';

/// Expectation to use when no other expectation matches.
///
/// Adding this expectation ensures that no calls to the actual server are
/// passed through.
final expectationNotFoundExpectation = {
  'priority': -10,
  'httpRequest': <String, dynamic>{},
  'httpResponse': {
    'statusCode': 404,
    'body': 'Request has no matching expectation.'
  }
};

void removeRequestHeaderFromExpectations(
  List<Map<String, dynamic>> expectations,
  String header,
) {
  header = header.toLowerCase();

  for (final expectation in expectations) {
    final request = expectation['httpRequest'] as Map<String, dynamic>?;
    if (request != null) {
      final headers = request['headers'] as Map<String, dynamic>?;
      headers?.removeWhere((key, dynamic _) => key.toLowerCase() == header);
    }
  }
}

void removeResponseHeaderFromExpectations(
  List<Map<String, dynamic>> expectations,
  String header,
) {
  header = header.toLowerCase();

  for (final expectation in expectations) {
    final request = expectation['httpResponse'] as Map<String, dynamic>?;
    if (request != null) {
      final headers = request['headers'] as Map<String, dynamic>?;
      headers?.removeWhere((key, dynamic _) => key.toLowerCase() == header);
    }
  }
}

List<Map<String, dynamic>> decodeExpectations(String json) =>
    (jsonDecode(json) as List).cast<Map<String, dynamic>>();

class MockServer {
  MockServer({
    required this.host,
    required this.port,
  });

  final String host;
  final int port;

  String get _serverBaseUrl => 'http://$host:$port/mockserver';

  final _client = Client();

  HttpClient createProxiedHttpClient() {
    final securityContext = SecurityContext(withTrustedRoots: true)
      ..setTrustedCertificatesBytes(_mockServerCertificate.codeUnits);

    return HttpClient(context: securityContext)
      ..findProxy = (_) => 'PROXY $host:$port';
  }

  Future<List<Map<String, dynamic>>> recordedExpectations() async {
    final response = await _client
        .put(Uri.parse(
            '$_serverBaseUrl/retrieve?type=RECORDED_EXPECTATIONS&format=JSON'))
        .assertIsOk();

    return decodeExpectations(response.body);
  }

  Future<void> createExpectations(
    List<Map<String, dynamic>> expectations,
  ) =>
      _client.put(
        Uri.parse('$_serverBaseUrl/expectation'),
        body: jsonEncode(expectations),
        headers: {
          'Content-Type': 'application/json',
        },
      ).assertIsOk();

  Future<void> reset() =>
      _client.put(Uri.parse('$_serverBaseUrl/reset')).assertIsOk();

  void close() {
    _client.close();
  }
}

extension on Future<Response> {
  Future<Response> assertIsOk() => then((response) {
        response.assertIsOk();
        return response;
      });
}

extension on Response {
  void assertIsOk() {
    assert(
      statusCode >= 200 && statusCode <= 300,
      'request was not successful: $statusCode: $body',
    );
  }
}
