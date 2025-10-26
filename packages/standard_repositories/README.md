# Standard Repositories

[![pub package][pub_badge]][pub_link]
[![shorebird ci](https://api.shorebird.dev/api/v1/github/mtwichel/standard_repositories/badge.svg)](https://console.shorebird.dev/ci)
[![codecov](https://codecov.io/gh/mtwichel/standard_repositories/graph/badge.svg?token=9GXPJKY9A8)](https://codecov.io/gh/mtwichel/standard_repositories)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Provides an interface for `Repositories` in your Flutter apps.

If you've never heard of the concept of repositories, you can read about theme [in the bloc documentation](https://bloclibrary.dev/architecture/#repository).

## Usage

Create a repository for a particular type

```dart
import 'package:standard_repositories/standard_repositories.dart';

class MyRepository {
    MyRepository();

    final repository = Repository<String>(repositoryName: 'my_repository');

    void makeUpperCase() {
        repository.value = repository.value.toUpperCase();
    }
}
```

Use the repository in your app

```dart
final repository = MyRepository('Hello, world!');
final subscription = repository.stream.listen((value) {
    print(value);
});

repository.makeUpperCase();

subscription.cancel();
```

Prints

- Hello, world!
- HELLO, WORLD!

## Available Repositories

### `Repository`

A simple repository that allows you to manage a single value.

Setting Values:

- `value = value`: Set the value to a new value.

Reading Values:

- `stream`: A stream of the value.
- `value`: The current value.

### `MultiRepository`

A repository with a collection of handy functions to manage a collection of values.

Setting Values:

- `value = values`: Set the collection to a new value.
- `add(value)`: Add a value to the collection.
- `addAll(values)`: Add multiple values to the collection.
- `remove(value)`: Remove a value from the collection.
- `removeWhere(selector)`: Remove all values that match the selector.
- `replace(existingValue, newValue)`: Replace a value in the collection.
- `replaceWhere(selector, value)`: Replace all values that match the selector.

Reading Values:

- `stream`: A stream of the collection.
- `value`: The current value of the collection.

### `RepositoryGroup`

A group of repositories that allows you to manage a collection of repositories.

```dart
import 'package:standard_repositories/standard_repositories.dart';

final repositoryGroup = RepositoryGroup<String>(
  build: (id) => Repository<String>(repositoryName: 'my_repository_$id'),
  );

  final repository = repositoryGroup.getRepository('id1');
  // Use repository like normal
```

[pub_badge]: https://img.shields.io/pub/v/standard_repositories.svg
[pub_link]: https://pub.dartlang.org/packages/standard_repositories
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
