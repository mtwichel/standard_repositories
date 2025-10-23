import 'dart:async';
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
  /// Writes the value to the cache
  Future<void> writeValue({required T value, required String repositoryName});

  /// Reads the value from the cache
  FutureOr<T?> readValue(String repositoryName);
}

/// {@template hive_repository_cache}
/// A [RepositoryCache] that stores values on device with [Hive]
/// {@endtemplate}
class HiveRepositoryCache<T> implements RepositoryCache<T> {
  /// {@macro hive_repository_cache}
  HiveRepositoryCache({required this.fromJson, required this.toJson}) {
    initialize();
  }
  late final Box<String> _box;
  bool _initialized = false;

  /// Initializes the cache
  Future<void> initialize({
    String boxName = '_standard_repositories_cache',
  }) async {
    _box = await Hive.openBox(boxName);
    _initialized = true;
  }

  /// Converts a json [Map] to a [T]

  final FromJson<T> fromJson;

  /// Converts a [T] to a json [Map]
  final ToJson<T> toJson;

  @override
  Future<void> writeValue({
    required T value,
    required String repositoryName,
  }) async {
    assert(
      _initialized,
      'HiveRepositoryCache must be initialized before writing a value',
    );
    try {
      await _box.put(repositoryName, jsonEncode(toJson(value)));
    } catch (_) {}
  }

  @override
  T? readValue(String repositoryName) {
    assert(
      _initialized,
      'HiveRepositoryCache must be initialized before reading a value',
    );
    try {
      final value = _box.get(repositoryName);
      if (value == null) return null;
      final json = Map<String, dynamic>.from(jsonDecode(value) as Map);
      return fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
