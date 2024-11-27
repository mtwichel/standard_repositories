import 'dart:convert';

import 'package:hive_ce/hive.dart';

/// A function type that converts a JSON map into an object of type [T].
///
/// Example:
/// ```dart
/// FromJson<User> fromJson = (json) => User.fromJson(json);
/// ```
typedef FromJson<T> = T Function(Map<String, dynamic> json);

/// A function type that converts an object of type [T] into a JSON map.
///
/// Example:
/// ```dart
/// ToJson<User> toJson = (user) => user.toJson();
/// ```
typedef ToJson<T> = Map<String, dynamic> Function(T object);

/// {@template repository_cache}
/// An object that can cache repository values for quick retrieval,
/// ideally on device
/// {@endtemplate}
abstract class RepositoryCache<T> {
  /// {@macro repository_cache}
  const RepositoryCache();

  /// Writes the value to the cache
  Future<void> writeValue(T value);

  /// Reads the value from the cache
  Future<T?> readValue(String repositoryName);
}

/// {@template hive_repository_cache}
/// A [RepositoryCache] that stores values on device with [Hive]
/// {@endtemplate}
class HiveRepositoryCache<T> extends RepositoryCache<T> {
  /// {@macro hive_repository_cache}
  const HiveRepositoryCache({
    required String repositoryName,
    required FromJson<T> fromJson,
    required ToJson<T> toJson,
    String boxName = '_standard_repositories_cache',
  })  : _boxName = boxName,
        _repositoryName = repositoryName,
        _fromJson = fromJson,
        _toJson = toJson;

  final String _boxName;
  final String _repositoryName;
  final FromJson<T> _fromJson;
  final ToJson<T> _toJson;

  @override
  Future<void> writeValue(
    T value,
  ) async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      await box.put(_repositoryName, jsonEncode(_toJson(value)));
    } catch (_) {}
  }

  @override
  Future<T?> readValue(String repositoryName) async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      final value = box.get(repositoryName);
      if (value == null) return null;
      final json = Map<String, dynamic>.from(jsonDecode(value) as Map);
      return _fromJson(json);
    } catch (_) {
      return null;
    }
  }
}

/// {@template noop_repository_cache}
/// A repository cacher that does nothing.
/// {@endtemplate}
class NoopRepositoryCacher<T> extends RepositoryCache<T> {
  /// {@macro noop_repository_cache}
  const NoopRepositoryCacher();

  @override
  Future<T?> readValue(String repositoryName) async => null;

  @override
  Future<void> writeValue(
    T value,
  ) async {}
}
