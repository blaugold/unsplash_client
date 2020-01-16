import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

// TODO document models

@immutable
/// Base class for all models.
///
/// [==] and [hashCode] are implemented based on the json representation,
/// returned by [toJson].
///
/// [toString] returns a pretty json representation based on [toJson].
abstract class ModelBase {
  /// Equality used to implement json representation of all models.
  static const jsonEquality = DeepCollectionEquality();

  /// Const constructor to allow sub classes to have const constructors.
  const ModelBase();

  /// Returns the json representation of this model in the unsplash api.
  Map<String, dynamic> toJson();

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
