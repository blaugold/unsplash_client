
String enumName(dynamic e) => e.toString().split('.')[1];

/// Whether [t] is `null`.
bool isNull<T>(T t) => t == null;

/// Util extensions on all objects.
extension ObjectUtils<T> on T {
  /// Transforms this, through the [Function] [f], to [E].
  E let<E>(E Function(T t) f) => f(this);

  /// Whether this is `null`.
  bool get isNull => this == null;

  /// Whether this is not `null`.
  bool get isNotNull => this != null;
}

extension MapUtils<K, V> on Map<K, V> {
  void removeWhereValue(bool Function(V v) f) => removeWhere((_, v) => f(v));
}

List<T> deserializeList<T>(
    dynamic json,
    T Function(Map<String, dynamic> json) f,
    ) {
  return (json as List<dynamic>).cast<Map<String, dynamic>>().map(f).toList();
}
