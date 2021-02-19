import 'package:http/http.dart' as http;

import 'client.dart';
import 'model/model.dart';
import 'utils.dart';

/// Provides access to resources related to [Collection].
///
/// See: [Unsplash docs](https://unsplash.com/documentation#collections)
class Collections {
  /// Creates a new instance which belongs to [client].
  Collections(this.client) : baseUrl = client.baseUrl.resolve('collections/');

  /// The parent [UnsplashClient].
  final UnsplashClient client;

  /// The base url for all endpoints for [Collections].
  final Uri baseUrl;

  /// List collections
  ///
  /// Get a single page from the list of all collections.
  ///
  /// ## List featured collections
  /// Get a single page from the list of featured collections, by setting
  /// [featured] to `true`.
  ///
  /// See: [Collections](https://unsplash.com/documentation#list-collections)
  /// [Featured Collections](https://unsplash.com/documentation#list-featured-collections)
  Request<List<Collection>> list({
    int? page,
    int? perPage,
    bool featured = false,
  }) {
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);

    final params = queryParams({
      'page': page,
      'per_page': perPage,
    });

    final url = (featured ? baseUrl.resolve('featured') : baseUrl)
        .replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializeCollections,
    );
  }

  /// Get a collection
  ///
  /// Retrieve a single collection. To view a user’s private collections, the
  /// read_collections scope is required.
  ///
  /// Note: See the note on [hotlinking](https://unsplash.com/documentation#hotlinking).
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-collection)
  Request<Collection> get(String id) {
    final url = baseUrl.resolve(id);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          Collection.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get a collection’s photos
  ///
  /// Retrieve a collection’s photos.
  ///
  /// Note: See the note on [hotlinking](https://unsplash.com/documentation#hotlinking).
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-collections-photos)
  Request<List<Photo>> photos(
    String id, {
    int? page,
    int? perPage,
    PhotoOrientation? orientation,
  }) {
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);

    final params = queryParams({
      'page': page,
      'per_page': perPage,
      'orientation': orientation?.let(enumName),
    });

    final url = baseUrl.resolve('$id/photos').replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializePhotos,
    );
  }

  /// List a collection’s related collections
  ///
  /// Retrieve a list of collections related to this one.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#list-a-collections-related-collections)
  Request<List<Collection>> related(String id) {
    final url = baseUrl.resolve('$id/related');

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializeCollections,
    );
  }
}

List<Collection> _deserializeCollections(dynamic body) {
  return deserializeObjectList(body, (json) => Collection.fromJson(json));
}

List<Photo> _deserializePhotos(dynamic body) {
  return deserializeObjectList(body, (json) => Photo.fromJson(json));
}
