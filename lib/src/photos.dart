import 'package:http/http.dart' as http;
import 'package:unsplash_client/client.dart';

import 'client.dart';
import 'model/photo.dart';
import 'utils.dart';

enum PhotoOrder { latest, oldest, popular }
enum PhotoOrientation { landscape, portrait, squarish }

class Photos {
  Photos(this.client)
      : assert(client != null),
        baseUrl = client.baseUrl.resolve('photos/');

  final UnsplashClient client;

  final Uri baseUrl;

  /// Get a single page from the list of all photos.
  ///
  /// See:
  ///
  ///   - [Unsplash docs](https://unsplash.com/documentation#list-photos)
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
      request: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializePhotos,
    );
  }

  /// Retrieve a one or more random photos, given optional filters.
  ///
  /// See:
  ///
  ///  - [Unsplash docs](https://unsplash.com/documentation#list-photos)
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
      request: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializePhotos,
    );
  }
}

List<Photo> _deserializePhotos(dynamic body) {
  return deserializeList(body, (json) => Photo.fromJson(json));
}
