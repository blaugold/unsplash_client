import 'model_base.dart';

// ignore_for_file: public_member_api_docs

/// The frequency of the stats.
enum StatisticsResolution {
  /// Return a value for each day.
  days,
}

/// A statistical metric.
class Statistic extends ModelBase {
  const Statistic({
    Map<String, dynamic>? source,
    required this.total,
    required this.historical,
  }) : super(source: source);

  final int total;
  final HistoricalData historical;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total': total,
      'historical': historical.toJson(),
    };
  }

  factory Statistic.fromMap(Map<String, dynamic> json) {
    return Statistic(
      source: json,
      total: json['total'] as int,
      historical:
          HistoricalData.fromJson(json['historical'] as Map<String, dynamic>),
    );
  }
}

/// Historical data for a statistic.
class HistoricalData extends ModelBase {
  const HistoricalData({
    Map<String, dynamic>? source,
    required this.change,
    required this.average,
    required this.resolution,
    required this.quantity,
    required this.values,
  }) : super(source: source);

  final int change;
  final int? average;
  final String resolution;
  final int quantity;
  final List<HistoricalValue> values;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'change': change,
      'average': average,
      'resolution': resolution,
      'quantity': quantity,
      'values': values.map((it) => it.toJson()).toList(),
    };
  }

  factory HistoricalData.fromJson(Map<String, dynamic> json) {
    return HistoricalData(
      source: json,
      change: json['change'] as int,
      average: json['average'] as int?,
      resolution: json['resolution'] as String,
      quantity: json['quantity'] as int,
      values: (json['values'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((it) => HistoricalValue.fromJson(it))
          .toList(),
    );
  }
}

/// Historical data point in [HistoricalData].
class HistoricalValue extends ModelBase {
  const HistoricalValue({
    Map<String, dynamic>? source,
    required this.date,
    required this.value,
  }) : super(source: source);

  final DateTime date;
  final num value;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date.toIso8601String(),
      'value': value,
    };
  }

  factory HistoricalValue.fromJson(Map<String, dynamic> json) {
    return HistoricalValue(
      source: json,
      date: DateTime.parse(json['date'] as String),
      value: json['value'] as num,
    );
  }
}

/// Total statistics for all of Unsplash.
///
/// See: [Unsplash docs](https://unsplash.com/documentation#stats)
class TotalStats extends ModelBase {
  const TotalStats({
    Map<String, dynamic>? source,
    required this.photos,
    required this.downloads,
    required this.views,
    required this.likes,
    required this.photographers,
    required this.pixels,
    required this.downloadsPerSecond,
    required this.viewsPerSecond,
    required this.developers,
    required this.applications,
    required this.requests,
  }) : super(source: source);

  final int photos;
  final int downloads;
  final int views;
  final int? likes;
  final int photographers;
  final int pixels;
  final int downloadsPerSecond;
  final int viewsPerSecond;
  final int developers;
  final int applications;
  final int requests;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'photos': photos,
      'downloads': downloads,
      'views': views,
      'likes': likes,
      'photographers': photographers,
      'pixels': pixels,
      'downloads_per_second': downloadsPerSecond,
      'views_per_second': viewsPerSecond,
      'developers': developers,
      'applications': applications,
      'requests': requests,
    };
  }

  factory TotalStats.fromJson(Map<String, dynamic> json) {
    return TotalStats(
      source: json,
      photos: json['photos'] as int,
      downloads: json['downloads'] as int,
      views: json['views'] as int,
      likes: json['likes'] as int?,
      photographers: json['photographers'] as int,
      pixels: json['pixels'] as int,
      downloadsPerSecond: json['downloads_per_second'] as int,
      viewsPerSecond: json['views_per_second'] as int,
      developers: json['developers'] as int,
      applications: json['applications'] as int,
      requests: json['requests'] as int,
    );
  }
}

/// Monthly statistics for all of Unsplash.
///
/// See: [Unsplash docs](https://unsplash.com/documentation#stats)
class MonthStats extends ModelBase {
  const MonthStats({
    Map<String, dynamic>? source,
    required this.downloads,
    required this.views,
    required this.likes,
    required this.newPhotos,
    required this.newPhotographers,
    required this.newPixels,
    required this.newDevelopers,
    required this.newApplications,
    required this.newRequests,
  }) : super(source: source);

  final int downloads;
  final int views;
  final int? likes;
  final int newPhotos;
  final int newPhotographers;
  final int newPixels;
  final int newDevelopers;
  final int newApplications;
  final int newRequests;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'downloads': downloads,
      'views': views,
      'likes': likes,
      'new_photos': newPhotos,
      'new_photographers': newPhotographers,
      'new_pixels': newPixels,
      'new_developers': newDevelopers,
      'new_applications': newApplications,
      'new_requests': newRequests,
    };
  }

  factory MonthStats.fromJson(Map<String, dynamic> json) {
    return MonthStats(
      source: json,
      downloads: json['downloads'] as int,
      views: json['views'] as int,
      likes: json['likes'] as int?,
      newPhotos: json['new_photos'] as int,
      newPhotographers: json['new_photographers'] as int,
      newPixels: json['new_pixels'] as int,
      newDevelopers: json['new_developers'] as int,
      newApplications: json['new_applications'] as int,
      newRequests: json['new_requests'] as int,
    );
  }
}
