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
      await repository.setValue(() => 1);
      await Future<void>.delayed(Duration(milliseconds: 5));
      expect(repository.value, equals(1));
    });
    test('setting value emits the value in stream', () async {
      final repository = MyTestingRepository(initialValue: 0);
      await repository.setValue(() => 1);
      await Future<void>.delayed(Duration(milliseconds: 5));
      expect(repository.stream, emits(1));
    });
  });

  group('MultiRepository', () {
    test('streamWhere streams only filtered properties', () {
      final repository = TestingMultiRepository(initialValue: [0, 1, 2]);
      expect(
        repository.streamWhere((e) => e.isOdd),
        emitsInOrder([
          [1],
          [1, 3],
          [1, 3],
          [1, 3, 5],
          [1, 3, 5],
        ]),
      );
      repository.addValue(() => 3);
      repository.addValue(() => 4);
      repository.addValue(() => 5);
      repository.addValue(() => 6);
    });

    test('singleWhere returns single element matching test', () {
      final repository = TestingMultiRepository(initialValue: [0, 1, 2]);
      expect(repository.singleWhere((e) => e.isOdd), equals(1));
    });

    test('streamSingleWhere streams only filtered properties', () {
      final repository = TestingMultiRepository(initialValue: [0, 1, 2]);
      expect(
        repository.streamSingleWhere((e) => e.isOdd),
        emitsInOrder([1, 1, 1]),
      );
      repository.addValue(() => 4);
      repository.addValue(() => 6);
    });

    test('addValue emits the new value added to the set', () async {
      final repository = TestingMultiRepository(initialValue: [0, 1, 2]);
      expect(
        repository.stream,
        emitsInOrder([
          [0, 1, 2],
          [0, 1, 2, 4],
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
          [0, 1, 2, 4, 5, 6],
        ]),
      );
      await repository.addAllValues(() => [4, 5, 6]);
      await Future<void>.delayed(Duration(milliseconds: 5));
      expect(repository.value, equals([0, 1, 2, 4, 5, 6]));
    });
  });
}
