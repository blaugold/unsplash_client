import 'package:http/http.dart' as http;

import '../unsplash_client.dart';

/// Provides access to the [TotalStats] and [MonthStats] resources.
///
/// See: [Unsplash docs](https://unsplash.com/documentation#totals)
class Stats {
  /// Creates a new instance which belongs to [client].
  Stats(this.client)
      : assert(client != null),
        baseUrl = client.baseUrl.resolve('stats/');

  /// The parent [UnsplashClient].
  final UnsplashClient client;

  /// The base url for all endpoints for [Photos].
  final Uri baseUrl;

  /// Get a list of counts for all of Unsplash.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#totals)
  Request<TotalStats> total() {
    final url = baseUrl.resolve('total');

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          TotalStats.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get the overall Unsplash stats for the past 30 days.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#month)
  Request<MonthStats> month() {
    final url = baseUrl.resolve('month');

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          MonthStats.fromJson(json as Map<String, dynamic>),
    );
  }
}
