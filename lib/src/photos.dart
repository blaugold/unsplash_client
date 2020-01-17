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

/// The frequency of the stats.
enum PhotoStatisticsResolution {
  /// Return a value for each day.
  days,
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

  /// List photos
  ///
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
      'order_by': orderBy?.let(enumName),
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

  /// Get a photo
  ///
  /// Retrieve a single photo.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-photo)
  Request<Photo> get(String id) {
    assert(id != null);

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

  /// Get a photo’s statistics
  ///
  /// Retrieve total number of downloads, views and likes of a single photo, as
  /// well as the historical breakdown of these stats in a specific time frame
  /// (default is 30 days).
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#get-a-photos-statistics)
  Request<PhotoStatistics> statistics(
    String id, {
    PhotoStatisticsResolution resolution,
    int quantity,
  }) {
    assert(id != null);
    assert(quantity == null || quantity >= 1 && quantity <= 30);

    final params = <String, dynamic>{
      'resolution': resolution?.let(enumName),
      'quantity': quantity?.toString(),
    };

    params.removeWhereValue(isNull);

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
  /// See: [Unsplash docs](https://unsplash.com/documentation#track-a-photo-download)
  Request<TrackPhotoDownload> download(String id) {
    assert(id != null);

    final url = baseUrl.resolve('$id/download');

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
