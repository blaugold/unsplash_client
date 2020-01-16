import 'package:meta/meta.dart';

import '../utils.dart';
import 'model_base.dart';

// ignore_for_file: public_member_api_docs

/// A geographical location.
class GeoLocation extends ModelBase {
  const GeoLocation({
    @required this.name,
    @required this.city,
    @required this.country,
    @required this.position,
  });

  final String name;
  final String city;
  final String country;
  final GeoPosition position;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'city': city,
      'country': country,
      'position': position,
    };
  }

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      name: json['name'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      position: (json['position'] as Map<String, dynamic>)
          ?.let((it) => GeoPosition.fromJson(it)),
    );
  }
}

/// A precise geographical position on earth, in [latitude] and [longitude].
class GeoPosition extends ModelBase {
  const GeoPosition({
    @required this.latitude,
    @required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory GeoPosition.fromJson(Map<String, dynamic> json) {
    return GeoPosition(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}
