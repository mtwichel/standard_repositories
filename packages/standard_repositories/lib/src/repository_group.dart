import 'package:standard_repositories/standard_repositories.dart';

/// A function that builds a repository
typedef RepositoryBuilder<T> = Repository<T> Function(String id);

/// A function that builds a multi repository
typedef MultiRepositoryBuilder<T> = MultiRepository<T> Function(String id);

/// {@template repository_group}
/// A group of repositories
/// {@endtemplate}
class RepositoryGroup<T> {
  /// {@macro repository_group}
  RepositoryGroup({
    required RepositoryBuilder<T> build,
  }) : _build = build;

  final RepositoryBuilder<T> _build;
  final Map<String, Repository<T>> _repositories = {};

  /// Gets a repository by id, or builds it if it doesn't exist
  Repository<T> getRepository(String id) {
    return _repositories.putIfAbsent(
      id,
      () => _build(id),
    );
  }

  /// Closes the repository group
  Future<void> close() async {
    await Future.wait([
      for (final repository in _repositories.values) repository.close(),
    ]);
    _repositories.clear();
  }
}

/// {@template multi_repository_group}
/// A group of multi repositories
/// {@endtemplate}
class MultiRepositoryGroup<T> {
  /// {@macro multi_repository_group}
  MultiRepositoryGroup({required MultiRepositoryBuilder<T> build})
      : _build = build;

  final MultiRepositoryBuilder<T> _build;
  final Map<String, MultiRepository<T>> _repositories = {};

  /// Gets a repository by id, or builds it if it doesn't exist
  MultiRepository<T> getRepository(String id) {
    return _repositories.putIfAbsent(
      id,
      () => _build(id),
    );
  }

  /// Closes the repository group
  Future<void> close() async {
    await Future.wait([
      for (final repository in _repositories.values) repository.close(),
    ]);
    _repositories.clear();
  }
}
