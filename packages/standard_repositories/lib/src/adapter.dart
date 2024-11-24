/// A function type that converts a JSON map into an object of type [T].
///
/// Example:
/// ```dart
/// FromJson<User> fromJson = (json) => User.fromJson(json);
/// ```
typedef FromJson<T> = T Function(Map<String, dynamic> json);

/// A function type that converts an object of type [T] into a JSON map.
///
/// Example:
/// ```dart
/// ToJson<User> toJson = (user) => user.toJson();
/// ```
typedef ToJson<T> = Map<String, dynamic> Function(T object);

/// {@template repository_object_adapter}
/// An adapter that helps convert objects to and from JSON for repository storage.
///
/// The [fromJson] function converts a JSON map back into the object type [T].
/// The [toJson] function converts an object of type [T] into a JSON map.
///
/// Example:
/// ```dart
/// final adapter = RepositoryObjectAdapter<User>(
///   fromJson: (json) => User.fromJson(json),
///   toJson: (user) => user.toJson(),
/// );
/// ```
/// {@endtemplate}

class RepositoryObjectAdapter<T> {
  /// {@macro repository_object_adapter}
  const RepositoryObjectAdapter({required this.fromJson, required this.toJson});

  /// The function that converts a JSON map into an object of type [T].
  final FromJson<T> fromJson;

  /// The function that converts an object of type [T] into a JSON map.
  final ToJson<T> toJson;
}
