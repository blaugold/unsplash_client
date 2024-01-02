import 'package:http/http.dart' as http;

import 'client.dart';
import 'model/model.dart';
import 'utils.dart';

/// Provides access to resources related to [Photo].
///
/// See: [Unsplash docs](https://unsplash.com/documentation#photos)
class Photos {
  /// Creates a new instance which belongs to [client].
  Photos(this.client) : baseUrl = client.baseUrl.resolve('photos/');

  /// The parent [UnsplashClient].
  final UnsplashClient client;

  /// The base url for all endpoints for [Photos].
  final Uri baseUrl;

  /// List photos
  ///
  /// Get a single page from the list of all photos.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#list-photos)
  Request<List<Photo>> list({
    int? page,
    int? perPage,
    PhotoOrder? orderBy,
  }) {
    assert(page == null || page >= 0);
    assert(perPage == null ||
        perPage >= 0 && perPage <= client.settings.maxPageSize);

    final params = queryParams({
      'page': page,
      'per_page': perPage,
      'order_by': orderBy?.let(enumName),
    });

    final url = baseUrl.replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializePhotos,
    );
  }

  /// Get a photo
  ///
  /// Retrieve a single photo.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-photo)
  Request<Photo> get(String id) {
    final url = baseUrl.resolve(id);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          Photo.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get a random photo
  ///
  /// Retrieve a one or more random photos, given optional filters.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#list-photos)
  Request<List<Photo>> random({
    String? query,
    String? username,
    bool? featured,
    Iterable<String>? collections,
    PhotoOrientation? orientation,
    int count = 1,
    ContentFilter? contentFilter,
  }) {
    assert(count >= 0 && count <= client.settings.maxPageSize);

    final params = queryParams({
      'query': query,
      'username': username,
      'featured': featured,
      'collections': collections?.join(','),
      'orientation': orientation?.let(enumName),
      'count': count,
      'content_filter': contentFilter?.let(enumName),
    });

    final url = baseUrl.resolve('random').replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: _deserializePhotos,
    );
  }

  /// Get a photo’s statistics
  ///
  /// Retrieve total number of downloads, views and likes of a single photo, as
  /// well as the historical breakdown of these stats in a specific time frame
  /// (default is 30 days).
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-photos-statistics)
  Request<PhotoStatistics> statistics(
    String id, {
    StatisticsResolution? resolution,
    int? quantity,
  }) {
    assert(quantity == null || quantity >= 1 && quantity <= 30);

    final params = queryParams({
      'resolution': resolution?.let(enumName),
      'quantity': quantity,
    });

    final url =
        baseUrl.resolve('$id/statistics').replace(queryParameters: params);

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          PhotoStatistics.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Track a photo download
  ///
  /// To abide by the API guidelines, you need to trigger a GET request to this
  /// endpoint every time your application performs a download of a photo. To
  /// understand what constitutes a download, please refer to the ‘Triggering a
  /// download’ guideline.
  ///
  /// This is purely an event endpoint used to increment the number of downloads
  /// a photo has. You can think of it very similarly to the pageview event in
  /// Google Analytics—where you’re incrementing a counter on the backend. This
  /// endpoint is not to be used to embed the photo (use the photo.urls.*
  /// properties instead) or to direct the user to the downloaded photo (use the
  /// photo.urls.full instead), it is for tracking purposes only.
  ///
  /// To follow the [guidelines](https://help.unsplash.com/en/articles/2511258-guideline-triggering-a-download)
  /// you should pass the [Photo.links.downloadLocation] to [location], to
  /// include all the necessary information.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#track-a-photo-download)
  Request<TrackPhotoDownload> download(String id, {Uri? location}) {
    final url = baseUrl
        .resolve('$id/download')
        .replace(queryParameters: location?.queryParameters ?? const {});

    return Request(
      client: client,
      httpRequest: http.Request('GET', url),
      isPublicAction: true,
      bodyDeserializer: (dynamic json) =>
          TrackPhotoDownload.fromJson(json as Map<String, dynamic>),
    );
  }
}

List<Photo> _deserializePhotos(dynamic body) {
  return deserializeObjectList(body, (json) => Photo.fromJson(json));
}
