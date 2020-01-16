
/// Returns the name of the instance of an enum.
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

/// Util extensions on [Map]s.
extension MapUtils<K, V> on Map<K, V> {
  /// Remove all map entries where the predicate [f] returns `false`, given
  /// the value of the entry.
  void removeWhereValue(bool Function(V v) f) => removeWhere((_, v) => f(v));
}

/// Deserialize [json] as a [List], using [f] to deserialize the elements.
///
/// [json] must be a [List<dynamic>] and its elements must be
/// [Map<String, dynamic>].
List<T> deserializeObjectList<T>(
  dynamic json,
  T Function(Map<String, dynamic> json) f,
) {
  return (json as List<dynamic>).cast<Map<String, dynamic>>().map(f).toList();
}
