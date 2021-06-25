import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Base class for all models.
///
/// [==] and [hashCode] are implemented based on the json representation,
/// returned by [toJson].
///
/// [toString] returns a pretty json representation based on [toJson].
@immutable
abstract class ModelBase {
  /// Equality used to implement json representation of all models.
  static const jsonEquality = DeepCollectionEquality();

  /// Const constructor to allow sub classes to have const constructors.
  const ModelBase({required this.source});

  /// Returns the json representation of this model in the unsplash api.
  Map<String, dynamic> toJson();

  /// The raw JSON response from the API which was used to construct this
  /// object.
  ///
  /// The Unsplash API returns some undocumented fields which are not exposode
  /// by the models of this library. This field enables you to access those
  /// fields at your own risk.
  ///
  /// If this object was not constructed from an API response this property
  /// is `null`.
  ///
  /// This is value is not considered in [==], [hashCode], [toString] and
  /// [toJson].
  final Map<String, dynamic>? source;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelBase &&
            runtimeType == other.runtimeType &&
            jsonEquality.equals(toJson(), other.toJson());
  }

  @override
  int get hashCode => jsonEquality.hash(toJson());

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}
