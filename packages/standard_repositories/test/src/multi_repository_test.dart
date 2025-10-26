import 'package:standard_repositories/standard_repositories.dart';
import 'package:test/test.dart';

void main() {
  group('MultiRepository', () {
    test('can be instantiated', () {
      final repository = MultiRepository<int>(
        repositoryName: 'testing_multi_repository',
        initialValue: [0, 1, 2],
      );
      expect(repository.value, equals([0, 1, 2]));
    });

    group('MultiRepository', () {
      test('addValue emits the new value added to the set', () async {
        final repository = MultiRepository<int>(
          repositoryName: 'testing_multi_repository',
          initialValue: [0, 1, 2],
        );
        expect(
          repository.value,
          equals([0, 1, 2]),
        );
        repository.add(4);
        expect(repository.value, equals([0, 1, 2, 4]));
        expect(repository.stream, emits(equals([0, 1, 2, 4])));
      });

      test('addAllValues emits the new value added to the set', () async {
        final repository = MultiRepository<int>(
          repositoryName: 'testing_multi_repository',
          initialValue: [0, 1, 2],
        );
        expect(
          repository.value,
          equals([0, 1, 2]),
        );
        repository.addAll([4, 5, 6]);
        expect(repository.value, equals([0, 1, 2, 4, 5, 6]));
        expect(repository.stream, emits(equals([0, 1, 2, 4, 5, 6])));
      });
    });
  });
}
