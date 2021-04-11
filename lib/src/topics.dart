import 'package:http/http.dart' as http;

import 'client.dart';
import 'model/model.dart';
import 'utils.dart';

/// Provides access to resources related to [Topic].
///
/// See: [Unsplash docs](https://unsplash.com/documentation#topics)
class Topics {
  /// Creates a new instance which belongs to [client].
  Topics(this.client) : baseUrl = client.baseUrl.resolve('topics/');

  /// The parent [UnsplashClient].
  final UnsplashClient client;

  /// The base url for all endpoints for [Topics].
  final Uri baseUrl;

  /// List topics
  ///
  /// Get a single page from the list of all topics.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#list-topics)
  Request<List<Topic>> list({
    List<String>? idsOrSlugs,
    int? page,
    int? perPage,
    TopicOrder? orderBy,
  }) {
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);

    final params = queryParams({
      'ids': idsOrSlugs?.join(','),
      'page': page,
      'per_page': perPage,
      'order_by': orderBy?.let(enumName),
    });

    final url = baseUrl.replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializeTopics,
    );
  }

  /// Get a topic
  ///
  /// Retrieve a single topic.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-topic)
  Request<Topic> get(String idOrSlug) {
    final url = baseUrl.resolve(idOrSlug);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          Topic.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get a topic’s photos
  ///
  /// Retrieve a topic’s photos.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-topics-photos)
  Request<List<Photo>> photos(
    String idOrSlug, {
    int? page,
    int? perPage,
    PhotoOrientation? orientation,
    PhotoOrder? orderBy,
  }) {
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);

    final params = queryParams({
      'page': page,
      'per_page': perPage,
      'orientation': orientation?.let(enumName),
      'order_by': orderBy?.let(enumName),
    });

    final url =
        baseUrl.resolve('$idOrSlug/photos').replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializePhotos,
    );
  }
}

List<Topic> _deserializeTopics(dynamic body) {
  return deserializeObjectList(body, (json) => Topic.fromJson(json));
}

List<Photo> _deserializePhotos(dynamic body) {
  return deserializeObjectList(body, (json) => Photo.fromJson(json));
}
