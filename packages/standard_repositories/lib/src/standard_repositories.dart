// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:standard_repositories/standard_repositories.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);
typedef ToJson<T> = Map<String, dynamic> Function(T object);
typedef TestFunction<T> = bool Function(T object);

typedef UniqueEvent<T> = ({T event, int id});

abstract class Repository<T> {
  Repository({
    required RepositoryCache<T> repositoryCacher,
    required T initialValue,
    required this.fromJson,
    required this.toJson,
  })  : _random = Random(),
        _cache = BehaviorSubject.seeded(
          (event: initialValue, id: 0),
        ),
        _repositoryCacher = repositoryCacher {
    _readValue().then((value) {
      if (value != null) _cache.value = _createEvent(value);
    });
  }

  final Random _random;
  final FromJson<T> fromJson;
  final ToJson<T> toJson;
  final RepositoryCache<T> _repositoryCacher;

  UniqueEvent<T> _createEvent(T data) => (
        event: data,
        id: _random.nextInt(1000),
      );

  T get value => _cache.value.event;
  Stream<T> get stream => _cache.stream.map((e) => e.event);

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
    try {
      await _repositoryCacher.writeValue(runtimeType.toString(), toJson(value));
    } catch (_) {}
  }

  Future<T?> _readValue() async {
    try {
      final value = await _repositoryCacher.readValue(runtimeType.toString());
      if (value == null) return null;
      return fromJson(value);
    } catch (_) {
      return null;
    }
  }
}

abstract class MultiRepository<T> extends Repository<Iterable<T>> {
  MultiRepository({
    required super.repositoryCacher,
    required FromJson<T> fromJson,
    required ToJson<T> toJson,
    super.initialValue = const {},
  }) : super(
          fromJson: (json) =>
              List<Map<String, dynamic>>.from(json['list'] as List<dynamic>)
                  .map(fromJson),
          toJson: (list) => {'list': list.map((e) => toJson(e)).toList()},
        );

  Stream<Iterable<T>> streamWhere(TestFunction<T> filter) => _cache.stream
      .map((e) => e.event)
      .map((all) => all.where((e) => filter(e)))
      .where((e) => e.isNotEmpty);

  T singleWhere(TestFunction<T> test) => value.singleWhere(test);
  Stream<T> streamSingleWhere(TestFunction<T> test) => stream
      .map((e) => e.singleWhereOrNull(test))
      .where((e) => e != null)
      .cast<T>();

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
