import 'package:meta/meta.dart';
import 'client.dart';

/// An exception which is thrown when an error happens in the [UnsplashClient].
class UnsplashClientException implements Exception {
  const UnsplashClientException({
    @required this.message,
    @required this.cause,
    @required this.stackTrace,
  });

  final String message;
  final dynamic cause;
  final StackTrace stackTrace;

  @override
  String toString() {
    return '''
$runtimeType: $message
$cause
$stackTrace
''';
  }
}
