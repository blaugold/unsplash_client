/// Limit results by content safety.
///
/// See: [Unsplash docs](https://changelog.unsplash.com/#content-safety)
enum ContentFilter {
  /// Guarantees that no content violating our submission guidelines
  /// (like images containing nudity or violence) will be returned in results.
  high,

  /// Remove content that may be unsuitable for younger audiences from results.
  low,
}
