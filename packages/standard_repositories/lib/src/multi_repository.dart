import 'package:standard_repositories/standard_repositories.dart';

/// {@template multi_repository}
/// A repository that manages a collection of values
/// {@endtemplate}
class MultiRepository<T> extends Repository<Iterable<T>> {
  /// {@macro multi_repository}
  MultiRepository({
    required super.repositoryName,
    super.initialValue = const {},
  });

  /// Adds a single value to the collection
  void add(T value) {
    this.value = {...this.value, value};
  }

  /// Adds multiple values to the collection
  void addAll(Iterable<T> values) {
    value = {...value, ...values};
  }

  /// Removes a single value from the collection
  void remove(
    T value,
  ) {
    this.value = this.value.where((e) => e != value);
  }

  /// Removes all values that match the selector
  void removeWhere(
    bool Function(T value) selector,
  ) {
    value = value.where((e) => !selector(e));
  }

  /// Replaces a single value in the collection
  void replace(
    T existingValue,
    T newValue,
  ) {
    value = value.where((e) => e != existingValue).toList()..add(newValue);
  }

  /// Replaces all values that match the selector
  void replaceWhere(
    bool Function(T value) selector,
    T value,
  ) {
    this.value = this.value.where((e) => !selector(e)).toList()..add(value);
  }
}
