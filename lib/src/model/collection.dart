import '../utils.dart';
import 'model_base.dart';
import 'photo.dart';
import 'user.dart';

// ignore_for_file: public_member_api_docs

/// A collection of [Photo]s.
///
/// See: [Unsplash docs](https://unsplash.com/documentation#collections)
class Collection extends ModelBase {
  final String id;
  final String title;
  final String? description;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final Photo? coverPhoto;
  final User user;
  final bool featured;
  final int totalPhotos;
  final bool private;
  final String? shareKey;
  final CollectionLinks links;

  const Collection({
    Map<String, dynamic>? source,
    required this.id,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.updatedAt,
    required this.coverPhoto,
    required this.user,
    required this.featured,
    required this.totalPhotos,
    required this.private,
    required this.shareKey,
    required this.links,
  }) : super(source: source);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'published_at': publishedAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'cover_photo': coverPhoto?.toJson(),
      'user': user.toJson(),
      'featured': featured,
      'total_photos': totalPhotos,
      'private': private,
      'share_key': shareKey,
      'links': links.toJson(),
    };
  }

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      source: json,
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      publishedAt: (json['published_at'] as String).let(DateTime.parse),
      updatedAt: (json['updated_at'] as String).let(DateTime.parse),
      coverPhoto: (json['cover_photo'] as Map<String, dynamic>?)
          ?.let((it) => Photo.fromJson(it)),
      user: ((json['user'] as Map<String, dynamic>)
          .let((it) => User.fromJson(it))),
      featured: json['featured'] as bool,
      totalPhotos: json['total_photos'] as int,
      private: json['private'] as bool,
      shareKey: json['shared_key'] as String?,
      links: (json['links'] as Map<String, dynamic>)
          .let((it) => CollectionLinks.fromJson(it)),
    );
  }
}

/// Links for a [Collection].
class CollectionLinks extends ModelBase {
  final Uri self;
  final Uri html;
  final Uri photos;
  final Uri related;

  const CollectionLinks({
    Map<String, dynamic>? source,
    required this.self,
    required this.html,
    required this.photos,
    required this.related,
  }) : super(source: source);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'self': self.toString(),
      'html': html.toString(),
      'photos': photos.toString(),
      'related': related.toString(),
    };
  }

  factory CollectionLinks.fromJson(Map<String, dynamic> json) {
    return CollectionLinks(
      source: json,
      self: (json['self'] as String).let(Uri.parse),
      html: (json['html'] as String).let(Uri.parse),
      photos: (json['photos'] as String).let(Uri.parse),
      related: (json['related'] as String).let(Uri.parse),
    );
  }
}
