// ignore_for_file: public_member_api_docs

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);
typedef ToJson<T> = Map<String, dynamic> Function(T object);
typedef TestFunction<T> = bool Function(T object);

abstract class Repository<T> {
  Repository({
    required T initialValue,
  }) : _cache = BehaviorSubject.seeded(initialValue);

  @protected
  set value(T value) => _cache.value = value;
  T get value => _cache.value;
  Stream<T> get stream => _cache.stream;

  final BehaviorSubject<T> _cache;
}

abstract class MultiRepository<T> extends Repository<Iterable<T>> {
  MultiRepository({
    super.initialValue = const {},
  });

  Stream<Iterable<T>> streamWhere(TestFunction<T> filter) => _cache.stream
      .map((all) => all.where((e) => filter(e)))
      .where((e) => e.isNotEmpty);

  T singleWhere(TestFunction<T> test) => value.singleWhere(test);
  Stream<T> streamSingleWhere(TestFunction<T> test) => stream
      .map((e) => e.singleWhereOrNull(test))
      .where((e) => e != null)
      .cast<T>();

  @protected
  void add(T object) => value = {...value, object};
  @protected
  void addAll(Iterable<T> objects) => value = {...value, ...objects};
}
