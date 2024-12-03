import 'package:standard_repositories/standard_repositories.dart';

/// A repository that fetches it's data when listened to
mixin FetcherRepository<T> on Repository<T> {
  /// Fetches an initial payload
  Future<T> fetch();
}
