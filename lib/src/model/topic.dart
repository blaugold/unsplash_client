import '../utils.dart';
import 'model_base.dart';
import 'photo.dart';
import 'user.dart';

// ignore_for_file: public_member_api_docs

enum TopicOrder {
  featured,
  latest,
  oldest,
  position,
}

/// A topic on Unsplash.
///
/// See: [Unsplash docs](https://unsplash.com/documentation#topics)
class Topic extends ModelBase {
  Topic({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.updatedAt,
    required this.startsAt,
    required this.endsAt,
    required this.featured,
    required this.totalPhotos,
    required this.links,
    required this.status,
    required this.owners,
    required this.topContributors,
    required this.coverPhoto,
  });

  final String id;
  final String slug;
  final String title;
  final String description;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final DateTime startsAt;
  final DateTime? endsAt;
  final bool featured;
  final int totalPhotos;
  final TopicLinks links;
  final String status;
  final List<User> owners;
  final List<User>? topContributors;
  final Photo coverPhoto;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'slug': slug,
      'title': title,
      'description': description,
      'published_at': publishedAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'starts_at': startsAt.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
      'featured': featured,
      'total_photos': totalPhotos,
      'links': links.toJson(),
      'status': status,
      'owners': owners.map((it) => it.toJson()).toList(),
      'top_contributors': topContributors?.map((it) => it.toJson()).toList(),
      'cover_photo': coverPhoto.toJson(),
    };
  }

  static Topic fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      publishedAt: (json['published_at'] as String).let(DateTime.parse),
      updatedAt: (json['updated_at'] as String).let(DateTime.parse),
      startsAt: (json['starts_at'] as String).let(DateTime.parse),
      endsAt: (json['ends_at'] as String?)?.let(DateTime.parse),
      featured: json['featured'] as bool,
      totalPhotos: json['total_photos'] as int,
      links: TopicLinks.fromJson(json['links'] as Map<String, dynamic>),
      status: json['status'] as String,
      owners: (json['owners'] as List)
          .map((dynamic it) => User.fromJson(it as Map<String, dynamic>))
          .toList(),
      topContributors: (json['top_contributors'] as List?)
          ?.map((dynamic it) => User.fromJson(it as Map<String, dynamic>))
          .toList(),
      coverPhoto: Photo.fromJson(json['cover_photo'] as Map<String, dynamic>),
    );
  }
}

/// Links for a [Photo].
class TopicLinks extends ModelBase {
  const TopicLinks({
    required this.self,
    required this.html,
    required this.photos,
  });

  final Uri self;
  final Uri html;
  final Uri photos;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'self': self.toString(),
      'html': html.toString(),
      'photos': photos.toString(),
    };
  }

  factory TopicLinks.fromJson(Map<String, dynamic> map) {
    return TopicLinks(
      self: (map['self'] as String).let(Uri.parse),
      html: (map['html'] as String).let(Uri.parse),
      photos: (map['photos'] as String).let(Uri.parse),
    );
  }
}
