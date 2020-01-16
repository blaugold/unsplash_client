import 'package:meta/meta.dart';

import '../utils.dart';
import 'base_model.dart';

// ignore_for_file: public_member_api_docs

class User extends BaseModel {
  const User({
    @required this.id,
    @required this.updatedAt,
    @required this.username,
    @required this.name,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.uploadsRemaining,
    @required this.portfolioUrl,
    @required this.bio,
    @required this.location,
    @required this.totalLikes,
    @required this.totalPhotos,
    @required this.totalCollections,
    @required this.followedByUser,
    @required this.followerCount,
    @required this.followingCount,
    @required this.downloads,
    @required this.instagramUsername,
    @required this.twitterUsername,
    @required this.profileImage,
    @required this.badge,
    @required this.links,
  });

  final String id;
  final DateTime updatedAt;
  final String username;
  final String name;
  final String firstName;
  final String lastName;
  final String email;
  final int uploadsRemaining;
  final Uri portfolioUrl;
  final String bio;
  final String location;
  final int totalLikes;
  final int totalPhotos;
  final int totalCollections;
  final bool followedByUser;
  final int followerCount;
  final int followingCount;
  final int downloads;
  final String instagramUsername;
  final String twitterUsername;
  final ProfileImage profileImage;
  final UserBadge badge;
  final UserLinks links;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'updated_at': updatedAt?.toIso8601String(),
      'username': username,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'uploads_remaining': uploadsRemaining,
      'portfolio_url': portfolioUrl?.toString(),
      'bio': bio,
      'location': location,
      'total_likes': totalLikes,
      'total_photos': totalPhotos,
      'total_collections': totalCollections,
      'followed_by_user': followedByUser,
      'follower_count': followerCount,
      'following_count': followingCount,
      'downloads': downloads,
      'instagram_username': instagramUsername,
      'twitter_username': twitterUsername,
      'profile_image': profileImage?.toJson(),
      'badge': badge?.toJson(),
      'links': links?.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      username: json['username'] as String,
      name: json['name'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      uploadsRemaining: json['uploads_remaining'] as int,
      portfolioUrl:
          (json['portfolio_url'] as String)?.let(Uri.parse),
      bio: json['bio'] as String,
      location: json['location'] as String,
      totalLikes: json['total_likes'] as int,
      totalPhotos: json['total_photos'] as int,
      totalCollections: json['total_collections'] as int,
      followedByUser: json['followed_by_user'] as bool,
      followerCount: json['follower_count'] as int,
      followingCount: json['following_count'] as int,
      downloads: json['downloads'] as int,
      instagramUsername: json['instagram_username'] as String,
      twitterUsername: json['twitter_username'] as String,
      profileImage: (json['profile_image'] as Map<String, dynamic>)
          ?.let((it) => ProfileImage.fromJson(it)),
      badge: (json['badge'] as Map<String, dynamic>)
          ?.let((it) => UserBadge.fromJson(it)),
      links: (json['links'] as Map<String, dynamic>)
          ?.let((it) => UserLinks.fromJson(it)),
    );
  }
}

class ProfileImage extends BaseModel {
  const ProfileImage({
    @required this.small,
    @required this.medium,
    @required this.large,
  });

  final Uri small;
  final Uri medium;
  final Uri large;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'small': small?.toString(),
      'medium': medium?.toString(),
      'large': large?.toString(),
    };
  }

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      small: (json['small'] as String)?.let(Uri.parse),
      medium: (json['medium'] as String)?.let(Uri.parse),
      large: (json['large'] as String)?.let(Uri.parse),
    );
  }
}

class UserBadge extends BaseModel {
  const UserBadge({
    @required this.title,
    @required this.primary,
    @required this.slug,
    @required this.link,
  });

  final String title;
  final bool primary;
  final String slug;
  final Uri link;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'primary': primary,
      'slug': slug,
      'link': link?.toString(),
    };
  }

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      title: json['title'] as String,
      primary: json['primary'] as bool,
      slug: json['slug'] as String,
      link: (json['link'] as String)?.let(Uri.parse),
    );
  }
}

class UserLinks extends BaseModel {
  const UserLinks({
    @required this.self,
    @required this.html,
    @required this.photos,
    @required this.likes,
    @required this.portfolio,
  });

  final Uri self;
  final Uri html;
  final Uri photos;
  final Uri likes;
  final Uri portfolio;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'self': self?.toString(),
      'html': html?.toString(),
      'photos': photos?.toString(),
      'likes': likes?.toString(),
      'portfolio': portfolio?.toString(),
    };
  }

  factory UserLinks.fromJson(Map<String, dynamic> json) {
    return UserLinks(
      self: (json['self'] as String)?.let(Uri.parse),
      html: (json['html'] as String)?.let(Uri.parse),
      photos: (json['photos'] as String)?.let(Uri.parse),
      likes: (json['likes'] as String)?.let(Uri.parse),
      portfolio: (json['portfolio'] as String)?.let(Uri.parse),
    );
  }
}
