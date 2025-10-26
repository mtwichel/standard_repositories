import 'dart:async';
import 'dart:math';

import 'package:rxdart/subjects.dart';
import 'package:standard_repositories/standard_repositories.dart';

/// A unique event with an id
typedef UniqueEvent<T> = ({T event, int id});

/// {@template repository}
/// A repository that manages a single value
/// {@endtemplate}
class Repository<T> {
  /// {@macro repository}
  Repository({
    required String repositoryName,
    T? initialValue,
    RepositoryCache<T>? cache,
  })  : _cache = cache,
        _repositoryName = repositoryName,
        _random = Random(),
        _subject = initialValue != null
            ? BehaviorSubject.seeded(
                (event: initialValue, id: -1),
              )
            : BehaviorSubject<UniqueEvent<T>>() {
    _readValue();
  }

  final Random _random;
  final RepositoryCache<T>? _cache;
  final BehaviorSubject<UniqueEvent<T>> _subject;
  final String _repositoryName;

  UniqueEvent<T> _createEvent(T data) => (
        event: data,
        id: _random.nextInt(1000),
      );

  /// The current value of the repository
  T get value => _subject.value.event;

  /// The stream of the repository
  Stream<T> get stream async* {
    final Stream<UniqueEvent<T>> ans = _subject.stream;

    yield* ans.map((e) => e.event);
  }

  set value(T value) {
    try {
      _subject.value = _createEvent(value);
      unawaited(
        _cache?.writeValue(
          value: value,
          repositoryName: _repositoryName,
        ),
      );
    } catch (e) {
      _subject.addError(e);
    }
  }

  Future<void> _readValue() async {
    try {
      final value = await _cache?.readValue(_repositoryName);
      if (value != null) {
        _subject.add(_createEvent(value));
      }
    } catch (_) {}
  }

  /// Closes the repository
  Future<void> close() {
    return _subject.close();
  }
}
