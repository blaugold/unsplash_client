import 'package:meta/meta.dart';

import '../utils.dart';
import 'collection.dart';
import 'location.dart';
import 'model_base.dart';
import 'user.dart';

// ignore_for_file: public_member_api_docs

/// A photo uploaded to unsplash.
///
/// See: [Unsplash docs](https://unsplash.com/documentation#photos)
class Photo extends ModelBase {
  const Photo({
    @required this.id,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.urls,
    @required this.width,
    @required this.height,
    @required this.color,
    @required this.downloads,
    @required this.likes,
    @required this.likedByUser,
    @required this.description,
    @required this.exif,
    @required this.location,
    @required this.user,
    @required this.currentUserCollections,
    @required this.links,
    @required this.tags,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Urls urls;
  final int width;
  final int height;
  final String color;
  final int downloads;
  final int likes;
  final bool likedByUser;
  final String description;
  final Exif exif;
  final GeoLocation location;
  final User user;
  final List<Collection> currentUserCollections;
  final PhotoLinks links;
  final List<Tag> tags;

  double get ratio => width / height;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'urls': urls?.toJson(),
      'width': width,
      'height': height,
      'color': color,
      'downloads': downloads,
      'likes': likes,
      'liked_by_user': likedByUser,
      'description': description,
      'exif': exif?.toJson(),
      'location': location?.toJson(),
      'user': user?.toJson(),
      'current_user_collections':
          currentUserCollections?.map((it) => it.toJson())?.toList(),
      'links': links?.toJson(),
      'tags': tags?.map((tag) => tag.toJson())?.toList(),
    };
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      urls: (json['urls'] as Map<String, dynamic>)
          ?.let((it) => Urls.fromJson(it)),
      width: json['width'] as int,
      height: json['height'] as int,
      color: json['color'] as String,
      downloads: json['downloads'] as int,
      likes: json['likes'] as int,
      likedByUser: json['liked_by_user'] as bool,
      description: json['description'] as String,
      exif: (json['exif'] as Map<String, dynamic>)
          ?.let((it) => Exif.fromJson(it)),
      location: (json['location'] as Map<String, dynamic>)
          ?.let((it) => GeoLocation.fromJson(it)),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      currentUserCollections:
          (json['current_user_collections'] as List<dynamic>)
              ?.cast<Map<String, dynamic>>()
              ?.map((it) => Collection.fromJson(it))
              ?.toList(),
      links: (json['links'] as Map<String, dynamic>)
          ?.let((it) => PhotoLinks.fromJson(it)),
      tags: (json['tags'] as List<dynamic>)
        ?.cast<Map<String, dynamic>>()
        ?.map((json) => Tag.fromJson(json))
        ?.toList()
    );
  }
}

class Tag extends ModelBase {
  const Tag({
    @required this.title,
  });

  final String title;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
    };
  }

  factory Tag.fromJson(Map<String, dynamic> map) {
    return Tag(
      title: map['title'] as String,
    );
  }
}

class PhotoLinks extends ModelBase {
  const PhotoLinks({
    @required this.self,
    @required this.html,
    @required this.download,
    @required this.downloadLocation,
  });

  final Uri self;
  final Uri html;
  final Uri download;
  final Uri downloadLocation;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'self': self?.toString(),
      'html': html?.toString(),
      'download': download?.toString(),
      'download_location': downloadLocation?.toString(),
    };
  }

  factory PhotoLinks.fromJson(Map<String, dynamic> map) {
    return PhotoLinks(
      self: (map['self'] as String)?.let(Uri.parse),
      html: (map['html'] as String)?.let(Uri.parse),
      download: (map['download'] as String)?.let(Uri.parse),
      downloadLocation: (map['download_location'] as String)?.let(Uri.parse),
    );
  }
}

class Exif extends ModelBase {
  const Exif({
    @required this.make,
    @required this.model,
    @required this.exposureTime,
    @required this.aperture,
    @required this.focalLength,
    @required this.iso,
  });

  final String make;
  final String model;
  final String exposureTime;
  final String aperture;
  final String focalLength;
  final int iso;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'make': make,
      'model': model,
      'exposure_time': exposureTime,
      'aperture': aperture,
      'focal_length': focalLength,
      'iso': iso,
    };
  }

  factory Exif.fromJson(Map<String, dynamic> json) {
    return Exif(
      make: json['make'] as String,
      model: json['model'] as String,
      exposureTime: json['exposure_time'] as String,
      aperture: json['aperture'] as String,
      focalLength: json['focal_length'] as String,
      iso: json['iso'] as int,
    );
  }
}

class Urls extends ModelBase {
  const Urls({
    @required this.raw,
    @required this.full,
    @required this.regular,
    @required this.small,
    @required this.thumb,
  });

  final Uri raw;
  final Uri full;
  final Uri regular;
  final Uri small;
  final Uri thumb;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'raw': raw?.toString(),
      'full': full?.toString(),
      'regular': regular?.toString(),
      'small': small?.toString(),
      'thumb': thumb?.toString(),
    };
  }

  factory Urls.fromJson(Map<String, dynamic> json) {
    return Urls(
      raw: (json['raw'] as String).let(Uri.parse),
      full: (json['full'] as String).let(Uri.parse),
      regular: (json['regular'] as String).let(Uri.parse),
      small: (json['small'] as String).let(Uri.parse),
      thumb: (json['thumb'] as String).let(Uri.parse),
    );
  }
}
