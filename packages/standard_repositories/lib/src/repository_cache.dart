import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:standard_repositories/standard_repositories.dart';

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
  Future<void> writeValue(T value);

  /// Reads the value from the cache
  Future<T?> readValue(String repositoryName);
}

/// {@template hive_repository_cache}
/// A [RepositoryCache] that stores values on device with [Hive]
/// {@endtemplate}
mixin HiveRepositoryCache<T> on Repository<T> implements RepositoryCache<T> {
  static const String _boxName = '_standard_repositories_cache';

  /// Converts a json [Map] to a [T]
  T fromJson(Map<String, dynamic> json);

  /// Converts a [T] to a json [Map]
  Map<String, dynamic> toJson(T value);

  @override
  Future<void> writeValue(T value) async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      await box.put(runtimeType.toString(), jsonEncode(toJson(value)));
    } catch (_) {}
  }

  @override
  Future<T?> readValue(String repositoryName) async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      final value = box.get(repositoryName);
      if (value == null) return null;
      final json = Map<String, dynamic>.from(jsonDecode(value) as Map);
      return fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
