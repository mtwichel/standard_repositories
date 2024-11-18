import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:standard_repositories/standard_repositories.dart';

/// {@template standard_repositories_bloc}
/// A mixin that simplifies listening to streams in Blocs and Cubits
/// {@endtemplate}
mixin StandardRepositoryListener<State> on BlocBase<State> {
  final Set<StreamSubscription<dynamic>> _subscriptions = {};

  /// Listens to the [repository] and calls [onData] for every event.
  void mountRepository<T>(
    Repository<T> repository, {
    required void Function(T data) onData,
    void Function(Object error, StackTrace stackTrace)? onError,
    void Function()? onDone,
    bool? cancelOnError,
    Function? onSubscribe,
  }) {
    _subscriptions.add(
      repository.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
    );
    // ignore: avoid_dynamic_calls
    onSubscribe?.call();
  }

  @override
  Future<void> close() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    return super.close();
  }
}
