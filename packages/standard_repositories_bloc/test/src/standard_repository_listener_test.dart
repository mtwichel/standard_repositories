// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:standard_repositories/standard_repositories.dart';
import 'package:standard_repositories_bloc/standard_repositories_bloc.dart';
import 'package:test/test.dart';

class MyRepository extends Repository<int> {
  MyRepository({required super.initialValue})
      : super(
          repositoryCacher: NoopRepositoryCacher(),
          adapter: RepositoryObjectAdapter(
            fromJson: (json) => 0,
            toJson: (object) => {},
          ),
        );

  // ignore: use_setters_to_change_properties
  void testSet(int testValue) {
    setValue(() => testValue);
  }

  void testError(Error error) {
    setValue(() => throw error);
  }
}

class MyCubit extends Cubit<int> with StandardRepositoryListener {
  MyCubit(MyRepository repository) : super(0) {
    mountRepository(
      repository,
      // ignore: unnecessary_lambdas
      onData: (value) => emit(value),
      where: (value) => value < 1000,
      onError: (error, stackTrace) => emit(-1),
      onSubscribe: () => emit(500),
    );
  }
}

void main() {
  group('StreamListenerBloc', () {
    test('can be instantiated', () async {
      final repository = MyRepository(initialValue: 0);
      final cubit = MyCubit(repository);
      expect(cubit.state, equals(500));
      repository.testSet(1);
      await Future<void>.delayed(Duration(milliseconds: 5));
      expect(cubit.state, equals(1));
      repository.testError(Error());
      await Future<void>.delayed(Duration(milliseconds: 50));
      expect(cubit.state, equals(-1));
      repository.testSet(1000);
      await Future<void>.delayed(Duration(milliseconds: 5));
      expect(cubit.state, equals(-1));
    });
  });
}
