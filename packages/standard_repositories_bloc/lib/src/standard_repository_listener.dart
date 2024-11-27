import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:standard_repositories/standard_repositories.dart';

/// {@template standard_repositories_bloc}
/// A mixin that simplifies listening to streams in Blocs and Cubits
/// {@endtemplate}
mixin StandardRepositoryListener<State> on BlocBase<State> {
  final Map<String, StreamSubscription<dynamic>> _subscriptions = {};

  /// Listens to the [repository] and calls [onData] for every event.
  void mountRepository<T>(
    Repository<T> repository, {
    required void Function(T data) onData,
    void Function(Object error, StackTrace stackTrace)? onError,
    void Function()? onDone,
    bool? cancelOnError,
    Function? onSubscribe,
    bool Function(T data)? where,
  }) {
    final key = repository.runtimeType.toString();
    if (!_subscriptions.containsKey(key)) {
      var stream = repository.stream;
      if (where != null) {
        stream = stream.where(where);
      }
      _subscriptions[key] = stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
      // ignore: avoid_dynamic_calls
      onSubscribe?.call();
    }
  }

  /// Listens to the [repository] and calls [onData] for every event after
  /// transforming it with [selector].
  ///
  /// The [selector] function allows you to extract or transform specific data
  /// from the repository's model before it is passed to [onData].
  void mountRepositoryWithSelector<Model, Data>(
    Repository<Model> repository, {
    required Data Function(Model data) selector,
    required void Function(Data data) onData,
    void Function(Object error, StackTrace stackTrace)? onError,
    void Function()? onDone,
    bool? cancelOnError,
    Function? onSubscribe,
    bool Function(Model data)? where,
  }) {
    final key = repository.runtimeType.toString();
    if (!_subscriptions.containsKey(key)) {
      var stream = repository.stream;
      if (where != null) {
        stream = stream.where(where);
      }
      _subscriptions[key] = stream.map(selector).listen(
            onData,
            onError: onError,
            onDone: onDone,
            cancelOnError: cancelOnError,
          );
      try {
        // ignore: avoid_dynamic_calls
        onSubscribe?.call();
      } catch (error, stackTrace) {
        onError?.call(error, stackTrace);
      }
    }
  }

  /// Cancels any subscriptions to the repository
  Future<void> unmountRepository(Repository<dynamic> repository) async {
    final key = repository.runtimeType.toString();
    if (_subscriptions.containsKey(key)) {
      await _subscriptions[key]!.cancel();
      _subscriptions.remove(key);
    }
  }

  @override
  Future<void> close() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    return super.close();
  }
}
