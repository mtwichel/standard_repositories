// ignore_for_file: prefer_const_constructors, cascade_invocations,
// ignore_for_file: invalid_use_of_protected_member

import 'package:standard_repositories/standard_repositories.dart';
import 'package:test/test.dart';

class MyTestingRepository extends Repository<int> {
  MyTestingRepository({required super.initialValue});
}

class TestingMultiRepository extends MultiRepository<int> {
  TestingMultiRepository({required super.initialValue});
}

void main() {
  group('Repository', () {
    test('can be instantiated', () {
      expect(MyTestingRepository(initialValue: 0), isA<Repository<int>>());
    });

    test('setting value sets the value', () async {
      final repository = MyTestingRepository(initialValue: 0);
      repository.value = 1;
      await Future<void>.delayed(Duration(milliseconds: 5));
      expect(repository.value, equals(1));
    });
    test('setting value emits the value in stream', () async {
      final repository = MyTestingRepository(initialValue: 0);
      repository.value = 1;
      await Future<void>.delayed(Duration(milliseconds: 5));
      expect(repository.stream, emits(1));
    });
  });

  group('MultiRepository', () {
    test('addValue emits the new value added to the set', () async {
      final repository = TestingMultiRepository(initialValue: [0, 1, 2]);
      expect(
        repository.stream,
        emitsInOrder([
          [0, 1, 2],
        ]),
      );
      await repository.addValue(() => 4);
      await Future<void>.delayed(Duration(milliseconds: 5));
      expect(repository.value, equals([0, 1, 2, 4]));
    });
    test('addAllValues emits the new value added to the set', () async {
      final repository = TestingMultiRepository(initialValue: [0, 1, 2]);
      expect(
        repository.stream,
        emitsInOrder([
          [0, 1, 2],
        ]),
      );
      await repository.addAllValues(() => [4, 5, 6]);
      await Future<void>.delayed(Duration(milliseconds: 5));
      expect(repository.value, equals([0, 1, 2, 4, 5, 6]));
    });
  });
}
