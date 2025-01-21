// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:{{name_plural.snakeCase()}}_repository/{{name_plural.snakeCase()}}_repository.dart';

void main() {
  group('${{name_plural.pascalCase()}}Repository', () {
    test('can be instantiated', () {
      expect({{name_plural.pascalCase()}}Repository(), isNotNull);
    });
  });
}
