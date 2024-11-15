# Standard Repositories

[![secret_manager][ci_badge]][ci_link]
[![coverage][coverage_badge]][ci_link]
[![pub package][pub_badge]][pub_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Provides an interface for `Repositories` in your Flutter apps.

If you've never heard of the concept of repositories, you can read about theme [in the bloc documentation](https://bloclibrary.dev/architecture/#repository).

## Usage

Create a repository for a particular type
```dart
class StringRepository extends Repository<String> {
    StringRepository(super.initialValue);

    void makeUpperCase() {
        value = value.toUpperCase();
    }
}
```

Use the repository in your app
```dart
final repository = StringRepository('Hello, world!');
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
A repository that allows you to manage a collection of values.

Setting Values:
- `value = values`: Set the collection to a new value.
- `add(value)`: Add a value to the collection.
- `addAll(values)`: Add multiple values to the collection.

Reading Values:
- `stream`: A stream of the collection.
- `value`: The current value of the collection.
- `streamWhere(test)`: A stream of the values that match the test.
- `singleWhere(test)`: The first value that matches the test.
- `streamSingleWhere(test)`: A stream of the first value that matches the test.


[ci_badge]: https://github.com/mtwichel/standard_repositories/actions/workflows/standard_repositories_verify_and_test.yaml/badge.svg?branch=main&event=push
[ci_link]: https://github.com/mtwichel/standard_repositories/actions/workflows/standard_repositories_verify_and_test.yaml
[coverage_badge]: https://img.shields.io/badge/coverage-100%25-green
[pub_badge]: https://img.shields.io/pub/v/standard_repositories.svg
[pub_link]: https://pub.dartlang.org/packages/standard_repositories
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
