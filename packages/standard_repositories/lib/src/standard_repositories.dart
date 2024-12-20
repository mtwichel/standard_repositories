// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:standard_repositories/standard_repositories.dart';

typedef TestFunction<T> = bool Function(T object);

typedef UniqueEvent<T> = ({T event, int id, bool fetched});

abstract class Repository<T> {
  Repository({
    required T initialValue,
    bool fakeCache = false,
  })  : _random = Random(),
        _cache = BehaviorSubject.seeded(
          (event: initialValue, id: -1, fetched: false),
        ),
        _fakeCache = fakeCache {
    if (!fakeCache) {
      _readValue();
    }
  }

  final Random _random;
  final bool _fakeCache;

  @protected
  bool get fetched => _cache.value.fetched;

  UniqueEvent<T> _createEvent(T data) => (
        event: data,
        id: _random.nextInt(1000),
        fetched: true,
      );

  T get value => _cache.value.event;
  Stream<T> stream({bool fetchedOnly = true}) async* {
    Stream<UniqueEvent<T>> ans = _cache.stream;
    if (fetchedOnly) {
      ans = ans.where((e) => e.fetched);
    }
    if (!_cache.value.fetched && this is FetcherRepository) {
      await (this as FetcherRepository).fetch();
    }
    yield* ans.map((e) => e.event);
  }

  final BehaviorSubject<UniqueEvent<T>> _cache;

  @protected
  Future<void> setValue(FutureOr<T> Function() create) async {
    try {
      _cache.value = _createEvent(await create());
    } catch (e) {
      _cache.addError(e);
    } finally {
      unawaited(_writeValue(value));
    }
  }

  Future<void> _writeValue(T value) async {
    if (_fakeCache || this is! RepositoryCache<T>) return;
    try {
      final cache = this as RepositoryCache<T>;
      await cache.writeValue(value);
    } catch (_) {}
  }

  Future<void> _readValue() async {
    if (_fakeCache || this is! RepositoryCache<T>) return;
    try {
      final cache = this as RepositoryCache<T>;
      final value = await cache.readValue(runtimeType.toString());
      if (value == null) return;
      _cache.value = _createEvent(value);
    } catch (_) {}
  }
}

abstract class MultiRepository<T> extends Repository<Iterable<T>> {
  MultiRepository({
    super.initialValue = const {},
  });

  @protected
  Future<void> addValue(FutureOr<T> Function() create) async {
    await setValue(() async {
      final newValue = await create();
      return {...value, newValue};
    });
  }

  @protected
  Future<void> addAllValues(FutureOr<Iterable<T>> Function() create) async {
    await setValue(() async {
      final newValues = await create();
      return {...value, ...newValues};
    });
  }

  @protected
  void removeValue(
    bool Function(T datum) selector,
  ) {
    setValue(() {
      final temp = value.where((e) => !selector(e));
      return temp;
    });
  }

  @protected
  Future<void> replaceValue(
    bool Function(T datum) selector,
    FutureOr<T> Function(T current) create,
  ) async {
    await setValue(() async {
      final temp = value.where((e) => !selector(e));
      final current = value.firstWhere(selector);
      final newValue = await create(current);
      return {...temp, newValue};
    });
  }
}
