import 'package:http/http.dart' as http;

import 'client.dart';
import 'model/model.dart';
import 'utils.dart';

/// How to sort the photos.
enum PhotoOrder {
  /// Sort from new to old.
  latest,

  /// Sort from old to new.
  oldest,

  /// Sort from most to least popular.
  popular,
}

/// Filter search results by photo orientation.
enum PhotoOrientation {
  /// Find photos which are wider than tall.
  landscape,

  /// Find photos which are taller than wide.
  portrait,

  /// Find photos with similar width and height.
  squarish,
}

/// Provides access to the [Photo] resource.
///
/// See: [Unsplash docs](https://unsplash.com/documentation#photos)
class Photos {
  /// Creates a new instance which belongs to [client].
  Photos(this.client)
      : assert(client != null),
        baseUrl = client.baseUrl.resolve('photos/');

  /// The parent [UnsplashClient].
  final UnsplashClient client;

  /// The base url for all endpoints for [Photos].
  final Uri baseUrl;

  /// Get a single page from the list of all photos.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#list-photos)
  Request<List<Photo>> list({
    int page,
    int perPage,
    PhotoOrder orderBy,
  }) {
    if (page != null) {
      assert(page >= 0);
    }
    if (perPage != null) {
      assert(perPage >= 0 && perPage <= client.settings.maxPageSize);
    }

    final params = {
      'page': page?.toString(),
      'per_page': perPage?.toString(),
      'oder_by': orderBy?.let(enumName),
    };

    params.removeWhereValue(isNull);

    final url = baseUrl.replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializePhotos,
    );
  }

  /// Retrieve a one or more random photos, given optional filters.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#list-photos)
  Request<List<Photo>> random({
    String query,
    String username,
    bool featured,
    Iterable<String> collections,
    PhotoOrientation orientation,
    int count = 1,
  }) {
    assert(count != null);
    assert(count >= 0 && count <= client.settings.maxPageSize);

    final params = {
      'query': query,
      'username': username,
      'featured': featured?.toString(),
      'collections': collections?.join(','),
      'orientation': orientation?.let(enumName),
      'count': count.toString(),
    };

    params.removeWhereValue(isNull);

    final url = baseUrl.resolve('random').replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializePhotos,
    );
  }
}

List<Photo> _deserializePhotos(dynamic body) {
  return deserializeObjectList(body, (json) => Photo.fromJson(json));
}
