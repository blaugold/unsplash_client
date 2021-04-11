import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'client.dart';
import 'model/model.dart';
import 'photos.dart';
import 'utils.dart';

/// Search for resources.
///
/// See: [Unsplash docs](https://unsplash.com/documentation#search)
class Search {
  /// Creates a new instance which belongs to [client].
  Search(this.client) : baseUrl = client.baseUrl.resolve('search/');

  /// The parent [UnsplashClient].
  final UnsplashClient client;

  /// The base url for all endpoints in [Search].
  final Uri baseUrl;

  /// Search photos
  ///
  /// Get a single page of photo results for a query.
  ///
  /// The photo objects returned here are abbreviated. For full details use
  /// [Photos.get].
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#search-photos)
  Request<SearchResults<Photo>> photos(
    String query, {
    int? page,
    int? perPage,
    Iterable<String>? collections,
    PhotoColor? color,
    PhotoOrientation? orientation,
    PhotoOrder? orderBy,
    ContentFilter? contentFilter,
    String? lang,
  }) {
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);

    final params = queryParams({
      'query': query,
      'page': page,
      'per_page': perPage,
      'collections': collections?.join(','),
      'orientation': orientation?.let(enumName),
      'order_by': orderBy?.let(enumName),
      'color': color?.let(enumName),
      'content_filter': contentFilter?.let(enumName),
      'lang': lang,
    });

    final url = baseUrl.resolve('photos').replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) => SearchResults.fromJson(
          json as Map<String, dynamic>, (json) => Photo.fromJson(json)),
    );
  }

  /// Search collections
  ///
  /// Get a single page of collection results for a query.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#search-collections)
  Request<SearchResults<Collection>> collections(
    String query, {
    int? page,
    int? perPage,
  }) {
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);

    final params = queryParams({
      'query': query,
      'page': page,
      'per_page': perPage,
    });

    final url = baseUrl.resolve('collections').replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) => SearchResults.fromJson(
          json as Map<String, dynamic>, (json) => Collection.fromJson(json)),
    );
  }

  /// Search users
  ///
  /// Get a single page of user results for a query.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#search-users)
  Request<SearchResults<User>> users(
    String query, {
    int? page,
    int? perPage,
  }) {
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);

    final params = queryParams({
      'query': query,
      'page': page,
      'per_page': perPage,
    });

    final url = baseUrl.resolve('users').replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) => SearchResults.fromJson(
          json as Map<String, dynamic>, (json) => User.fromJson(json)),
    );
  }
}
