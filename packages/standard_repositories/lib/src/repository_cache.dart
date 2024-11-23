import 'dart:convert';

import 'package:hive_ce/hive.dart';

/// {@template repository_cache}
/// An object that can cache repository values for quick retrieval,
/// ideally on device
/// {@endtemplate}
abstract class RepositoryCache {
  /// {@macro repository_cache}
  const RepositoryCache();

  /// Writes the value to the cache
  Future<void> writeValue(String repositoryName, Map<String, dynamic> value);

  /// Reads the value from the cache
  Future<Map<String, dynamic>?> readValue(String repositoryName);
}

/// {@template hive_repository_cache}
/// A [RepositoryCache] that stores values on device with [Hive]
/// {@endtemplate}
class HiveRepositoryCache extends RepositoryCache {
  /// {@macro hive_repository_cache}
  const HiveRepositoryCache({
    String boxName = '_standard_repositories_cache',
  }) : _boxName = boxName;

  final String _boxName;

  @override
  Future<void> writeValue(
    String repositoryName,
    Map<String, dynamic> value,
  ) async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      await box.put(repositoryName, jsonEncode(value));
    } catch (_) {}
  }

  @override
  Future<Map<String, dynamic>?> readValue(String repositoryName) async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      final value = box.get(repositoryName);
      if (value == null) return null;
      return Map<String, dynamic>.from(jsonDecode(value) as Map);
    } catch (_) {
      return null;
    }
  }
}

/// {@template noop_repository_cache}
/// A repository cacher that does nothing.
/// {@endtemplate}
class NoopRepositoryCacher extends RepositoryCache {
  /// {@macro noop_repository_cache}
  const NoopRepositoryCacher();

  @override
  Future<Map<String, dynamic>?> readValue(String repositoryName) async => null;

  @override
  Future<void> writeValue(
    String repositoryName,
    Map<String, dynamic> value,
  ) async {}
}
