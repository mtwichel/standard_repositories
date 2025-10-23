import 'dart:async';
import 'dart:math';

import 'package:rxdart/subjects.dart';
import 'package:standard_repositories/standard_repositories.dart';

/// A unique event with an id
typedef UniqueEvent<T> = ({T event, int id});

/// {@template repository}
/// A repository that manages a single value
/// {@endtemplate}
abstract class Repository<T> {
  /// {@macro repository}
  Repository({
    required T initialValue,
    RepositoryCache<T>? cache,
    String? repositoryName,
  })  : _cache = cache,
        _repositoryName = repositoryName,
        _random = Random(),
        _subject = BehaviorSubject.seeded(
          (event: initialValue, id: -1),
        ) {
    _readValue();
  }

  final Random _random;
  final RepositoryCache<T>? _cache;
  final BehaviorSubject<UniqueEvent<T>> _subject;
  final String? _repositoryName;

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
          repositoryName: _repositoryName ?? runtimeType.toString(),
        ),
      );
    } catch (e) {
      _subject.addError(e);
    }
  }

  Future<void> _readValue() async {
    try {
      final value =
          await _cache?.readValue(_repositoryName ?? runtimeType.toString());
      if (value != null) {
        _subject.add(_createEvent(value));
      }
    } catch (_) {}
  }
}
