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

    test('setting value sets the value', () {
      final repository = MyTestingRepository(initialValue: 0);
      repository.value = 1;
      expect(repository.value, equals(1));
    });
    test('setting value emits the value in stream', () {
      final repository = MyTestingRepository(initialValue: 0);
      repository.value = 1;
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
      repository.add(3);
      repository.add(4);
      repository.add(5);
      repository.add(6);
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
      repository.add(4);
      repository.add(6);
    });

    test('add all emits the new value added to the set', () {
      final repository = TestingMultiRepository(initialValue: [0, 1, 2]);
      expect(
        repository.stream,
        emitsInOrder([
          [0, 1, 2],
          [0, 1, 2, 4],
        ]),
      );
      repository.add(4);
      expect(repository.value, equals([0, 1, 2, 4]));
    });
    test('add allAll emits the new value added to the set', () {
      final repository = TestingMultiRepository(initialValue: [0, 1, 2]);
      expect(
        repository.stream,
        emitsInOrder([
          [0, 1, 2],
          [0, 1, 2, 4, 5, 6],
        ]),
      );
      repository.addAll([4, 5, 6]);
      expect(repository.value, equals([0, 1, 2, 4, 5, 6]));
    });
  });
}
