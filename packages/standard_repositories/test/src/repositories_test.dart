// ignore_for_file: prefer_const_constructors, cascade_invocations,
// ignore_for_file: invalid_use_of_protected_member

import 'package:standard_repositories/standard_repositories.dart';
import 'package:test/test.dart';

void main() {
  group('Repository', () {
    test('can be instantiated', () {
      final repository = Repository<int>(
        repositoryName: 'my_testing_repository',
        initialValue: 0,
      );
      expect(repository.value, equals(0));
    });

    test('setting value sets the value', () async {
      final repository = Repository<int>(
        repositoryName: 'my_testing_repository',
        initialValue: 0,
      );
      repository.value = 1;
      expect(repository.value, equals(1));
    });
  });
}
