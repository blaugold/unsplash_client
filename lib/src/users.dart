import 'package:http/http.dart' as http;

import 'client.dart';
import 'model/model.dart';
import 'photos.dart';
import 'utils.dart';

/// Provides access to resources related to [User].
///
/// See: [Unsplash docs](https://unsplash.com/documentation#users)
class Users {
  /// Creates a new instance which belongs to [client].
  Users(this.client)
      : assert(client != null),
        baseUrl = client.baseUrl.resolve('users/');

  /// The parent [UnsplashClient].
  final UnsplashClient client;

  /// The base url for all endpoints for [User].
  final Uri baseUrl;

  /// Get a user’s public profile
  ///
  /// Retrieve public details on a given user.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-users-public-profile)
  Request<User> get(String username) {
    assert(username != null);

    final url = baseUrl.resolve(username);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          User.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get a user’s portfolio link
  ///
  /// Retrieve a single user’s portfolio link.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-users-portfolio-link)
  Request<UserPortfolioLink> portfolio(String username) {
    assert(username != null);

    final url = baseUrl.resolve('$username/portfolio');

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          UserPortfolioLink.fromJson(json as Map<String, dynamic>),
    );
  }

  /// List a user’s photos
  ///
  /// Get a list of photos uploaded by a user.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#list-a-users-photos)
  Request<List<Photo>> photos(
    String username, {
    int page,
    int perPage,
    PhotoOrder orderBy,
    bool stats,
    StatisticsResolution resolution,
    PhotoOrientation orientation,
    int quantity,
  }) {
    assert(username != null);
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);
    assert(quantity == null || quantity >= 0);

    final params = queryParams({
      'page': page,
      'per_page': perPage,
      'order_by': orderBy?.let(enumName),
      'stats': stats,
      'resolution': resolution?.let(enumName),
      'orientation': orientation?.let(enumName),
      'quantity': quantity,
    });

    final url =
        baseUrl.resolve('$username/photos').replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          deserializeObjectList(json, (json) => Photo.fromJson(json)),
    );
  }

  /// List a user’s liked photos
  ///
  /// Get a list of photos liked by a user.
  ///
  /// The photo objects returned here are abbreviated. For full details use
  /// [Photos.get].
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#list-a-users-liked-photos)
  Request<List<Photo>> likedPhotos(
    String username, {
    int page,
    int perPage,
    PhotoOrder orderBy,
    PhotoOrientation orientation,
  }) {
    assert(username != null);
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);

    final params = queryParams({
      'page': page,
      'per_page': perPage,
      'order_by': orderBy?.let(enumName),
      'orientation': orientation?.let(enumName),
    });

    final url =
        baseUrl.resolve('$username/likes').replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          deserializeObjectList(json, (json) => Photo.fromJson(json)),
    );
  }

  /// List a user’s collections
  ///
  /// Get a list of collections created by the user.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#list-a-users-collections)
  Request<List<Collection>> collections(
    String username, {
    int page,
    int perPage,
  }) {
    assert(username != null);
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);

    final params = queryParams({
      'page': page,
      'per_page': perPage,
    });

    final url = baseUrl
        .resolve('$username/collections')
        .replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          deserializeObjectList(json, (json) => Collection.fromJson(json)),
    );
  }

  /// Get a user’s statistics
  ///
  /// Retrieve the consolidated number of downloads, views and likes of all
  /// user’s photos, as well as the historical breakdown and average of these
  /// stats in a specific timeframe (default is 30 days).
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-users-statistics)
  Request<UserStatistics> statistics(
    String username, {
    StatisticsResolution resolution,
    int quantity,
  }) {
    assert(username != null);
    assert(quantity == null || quantity >= 0);

    final params = queryParams({
      'resolution': resolution?.let(enumName),
      'quantity': quantity,
    });

    final url = baseUrl
        .resolve('$username/statistics')
        .replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          UserStatistics.fromJson(json as Map<String, dynamic>),
    );
  }
}
