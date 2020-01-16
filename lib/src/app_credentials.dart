import 'package:meta/meta.dart';

/// Credentials for accessing the unsplash api as a registered app.
///
/// You need to [register](https://unsplash.com/developers) as a developer
/// and create an usnplash app to get credentials.
@immutable
class AppCredentials {
  /// Creates [AppCredentials] from the given arguments.
  const AppCredentials({
    @required this.accessKey,
    this.secretKey,
  }) : assert(accessKey != null);

  /// The access key of the app these [AppCredentials] belong to.
  final String accessKey;

  /// The secret key of the app these [AppCredentials] belong to.
  final String secretKey;

  /// Creates a copy of this instance, replacing non `null` fields.
  AppCredentials copyWith({
    String accessKey,
    String secretKey,
  }) {
    return AppCredentials(
      accessKey: accessKey ?? this.accessKey,
      secretKey: secretKey ?? this.secretKey,
    );
  }

  /// Serializes this instance to json.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessKey': accessKey,
      'secretKey': secretKey,
    };
  }

  /// Deserializes [AppCredentials] from [json].
  factory AppCredentials.fromJson(Map<String, dynamic> json) {
    return AppCredentials(
      accessKey: json['accessKey'] as String,
      secretKey: json['secretKey'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCredentials &&
          runtimeType == other.runtimeType &&
          accessKey == other.accessKey &&
          secretKey == other.secretKey;

  @override
  int get hashCode => accessKey.hashCode ^ secretKey.hashCode;

  @override
  String toString() {
    return 'Credentials{accessKey: $accessKey, secretKey: $secretKey}';
  }
}
