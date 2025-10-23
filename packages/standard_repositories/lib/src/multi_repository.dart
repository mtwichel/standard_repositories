import 'dart:async';

import 'package:standard_repositories/standard_repositories.dart';

/// {@template multi_repository}
/// A repository that manages a collection of values
/// {@endtemplate}
abstract class MultiRepository<T> extends Repository<Iterable<T>> {
  /// {@macro multi_repository}
  MultiRepository({
    super.initialValue = const {},
  });

  /// Adds a single value to the collection
  Future<void> addValue(FutureOr<T> Function() create) async {
    final newValue = await create();
    value = {...value, newValue};
  }

  /// Adds multiple values to the collection
  Future<void> addAllValues(FutureOr<Iterable<T>> Function() create) async {
    final newValues = await create();
    value = {...value, ...newValues};
  }

  /// Removes a single value from the collection
  void removeValue(
    T datum,
  ) {
    final temp = value.where((e) => e != datum);
    value = temp;
  }

  /// Removes all values that match the selector
  void removeWhere(
    bool Function(T datum) selector,
  ) {
    final temp = value.where((e) => !selector(e));
    value = temp;
  }

  /// Replaces a single value in the collection
  Future<void> replaceValue(
    T existingDatum,
    T newDatum,
  ) async {
    final current = value.where((e) => e != existingDatum);
    value = {...current, newDatum};
  }

  /// Replaces all values that match the selector
  Future<void> replaceWhere(
    bool Function(T datum) selector,
    T newDatum,
  ) async {
    final current = value.where((e) => !selector(e));
    value = {...current, newDatum};
  }
}
