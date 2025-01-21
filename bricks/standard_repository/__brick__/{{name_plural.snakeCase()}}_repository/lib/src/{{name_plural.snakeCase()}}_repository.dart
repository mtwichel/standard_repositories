import 'package:standard_repositories/standard_repositories.dart';
import 'package:{{name_plural.snakeCase()}}_repository/{{name_plural.snakeCase()}}_repository.dart';

/// {@template {{name_plural.snakeCase()}}_repository}
/// A repository managing the {{name_plural.titleCase()}} domain.
/// {@endtemplate}
class {{name_plural.pascalCase()}}Repository extends Repository<{{name_single.pascalCase()}}> {
  /// {@macro {{name_plural.snakeCase()}}_repository}
  {{name_plural.pascalCase()}}Repository({super.fakeCache})
      : super(initialValue: const {{name_single.pascalCase()}}());
}